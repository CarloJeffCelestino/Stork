import 'package:flutter/material.dart';
import 'package:nopcart_flutter/bloc/auth_bloc.dart';
import 'package:nopcart_flutter/customWidget/CustomAppBar.dart';
import 'package:nopcart_flutter/customWidget/CustomButton.dart';
import 'package:nopcart_flutter/customWidget/loading_dialog.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/AppConstants.dart';
import 'package:nopcart_flutter/utils/ButtonShape.dart';
import 'package:nopcart_flutter/utils/Const.dart';
import 'package:nopcart_flutter/utils/ValidationMixin.dart';
import 'package:nopcart_flutter/utils/styles.dart';
import 'package:nopcart_flutter/utils/utility.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = '/forgot_password';

  const ForgotPasswordScreen({Key key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
  with ValidationMixin {
  GlobalService _globalService = GlobalService();
  AuthBloc _bloc;
  final _formKey = GlobalKey<FormState>();
  String email = '';
  TextEditingController _emailEditingCtrl;

  @override
  void initState() {
    super.initState();
    _emailEditingCtrl = TextEditingController();
    _bloc = AuthBloc();

    _bloc.passRecoverStream.listen((event) {
      if (event.status == Status.COMPLETED) {
        DialogBuilder(context).hideLoader();
        _emailEditingCtrl.clear();
        showSnackBar(context, event.data, false);
      } else if (event.status == Status.ERROR) {
        DialogBuilder(context).hideLoader();
        showSnackBar(context, event.message, true);
      } else if (event.status == Status.LOADING) {
        DialogBuilder(context).showLoader();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _bloc?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
        title: Text(_globalService.getString(Const.TITLE_FORGOT_PASS)),
      ),
      body: rootLayout(),
    );
  }

  Widget rootLayout() {

    final tfEmail = TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: _emailEditingCtrl,
      autofocus: false,
      validator: (value) {
        if ((value == null || value.isEmpty || !isValidEmailAddress(value))) {
          return _globalService.getString(Const.FORGOT_PASS_EMAIL_REQ);
        }
        return null;
      },
      style: Theme.of(context).textTheme.bodyText2.copyWith(
        color: Styles.textColor(context),
        fontSize: 16,
      ),
      onChanged: (value) => email = value,
      decoration: InputDecoration(
          hintText: _globalService.getString(Const.FORGOT_PASS_EMAIL),
          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, -5.0),
          suffixIcon: Icon(Icons.email_outlined)
      ),
      textInputAction: TextInputAction.next,
    );

    final btnRecover = CustomButton(
      label: _globalService.getString(Const.FORGOT_PASS_BTN).toUpperCase(),
      shape: ButtonShape.Rounded,
      onClick: () {
        if (_formKey.currentState.validate()) {
          removeFocusFromInputField(context);
          _bloc.postPasswordRecoverRequest(email);
        }
      },
    );


    return Form(
        key: _formKey,
        child: Container(
          decoration: BoxDecoration(
            // image: DecorationImage(
            //   image: AssetImage(AppConstants.loginBackground),
            //   fit: BoxFit.cover,
            // ),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: Colors.grey.shade400,
                      )),
                  elevation: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 48.0),
                        tfEmail,
                        SizedBox(height: 24.0),
                        btnRecover,
                        SizedBox(height: 48.0),
                      ],
                    ),
                  ),
              ),
            ),
          ),
        ));
  }
}
