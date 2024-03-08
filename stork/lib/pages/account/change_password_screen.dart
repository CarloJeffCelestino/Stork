import 'package:flutter/material.dart';
import 'package:nopcart_flutter/bloc/auth_bloc.dart';
import 'package:nopcart_flutter/customWidget/CustomAppBar.dart';
import 'package:nopcart_flutter/customWidget/CustomButton.dart';
import 'package:nopcart_flutter/customWidget/error.dart';
import 'package:nopcart_flutter/customWidget/loading.dart';
import 'package:nopcart_flutter/customWidget/loading_dialog.dart';
import 'package:nopcart_flutter/model/ChangePasswordResponse.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/AppConstants.dart';
import 'package:nopcart_flutter/utils/ButtonShape.dart';
import 'package:nopcart_flutter/utils/Const.dart';
import 'package:nopcart_flutter/utils/styles.dart';
import 'package:nopcart_flutter/utils/utility.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const routeName = '/change_password';

  const ChangePasswordScreen({Key key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  GlobalService _globalService = GlobalService();
  AuthBloc _bloc;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _pass, _oldPass, _confirmPass;
  List<bool> _obscurePassword = [true, true, true];

  @override
  void initState() {
    super.initState();
    _bloc = AuthBloc();
    _bloc.fetchChangePasswordFormData();

    _pass = TextEditingController();
    _oldPass = TextEditingController();
    _confirmPass = TextEditingController();

    _bloc.postPasswordChangeStream.listen((event) {
      if (event.status == Status.COMPLETED) {
        DialogBuilder(context).hideLoader();

        _pass.clear();
        _oldPass.clear();
        _confirmPass.clear();

        showSnackBar(context, event.data, false);
      } else if (event.status == Status.ERROR) {
        DialogBuilder(context).hideLoader();
        showSnackBar(context, stripHtmlTags(event.message), true);
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
        title: Text(_globalService.getString(Const.CHANGE_PASSWORD)),
      ),
      body: StreamBuilder<ApiResponse<ChangePasswordData>>(
        stream: _bloc.passChangeStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Loading(loadingMessage: snapshot.data.message);
                break;
              case Status.COMPLETED:
                return rootLayout(snapshot.data.data);
                break;
              case Status.ERROR:
                return Error(
                  errorMessage: snapshot.data.message,
                  onRetryPressed: () => _bloc.fetchLoginFormData(),
                );
                break;
            }
          }
          return Container();
        },
      ),
    );
  }

  Widget rootLayout(ChangePasswordData data) {

    final tfOldPassword = TextFormField(
      keyboardType: TextInputType.text,
      controller: _oldPass,
      obscureText: _obscurePassword[0],
      autofocus: false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return _globalService.getString(Const.CHANGE_PASS_OLD_REQ);
        }
        return null;
      },
      style: Theme.of(context).textTheme.bodyText2.copyWith(
        color: Styles.textColor(context),
        fontSize: 16,
      ),
      onChanged: (value) => data.oldPassword = value,
      decoration: InputDecoration(
          hintText: _globalService.getString(Const.CHANGE_PASS_OLD),
          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, -5.0),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword[0] ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          ),
          onPressed: () => _toggle(0),
        ),
      ),
      textInputAction: TextInputAction.next,
    );

    final tfNewPassword = TextFormField(
      keyboardType: TextInputType.text,
      controller: _pass,
      obscureText: _obscurePassword[1],
      autofocus: false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return _globalService.getString(Const.CHANGE_PASS_NEW_REQ);
        }
        return null;
      },
      style: Theme.of(context).textTheme.bodyText2.copyWith(
        color: Styles.textColor(context),
        fontSize: 16,
      ),
      onChanged: (value) => data.newPassword = value,
      decoration: InputDecoration(
          hintText: _globalService.getString(Const.CHANGE_PASS_NEW),
          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, -5.0),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword[1] ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          ),
          onPressed: () => _toggle(1),
        ),
      ),
      textInputAction: TextInputAction.next,
    );

    final tfConfirmPassword = TextFormField(
      keyboardType: TextInputType.text,
      controller: _confirmPass,
      obscureText: _obscurePassword[2],
      autofocus: false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return _globalService.getString(Const.CHANGE_PASS_CONFIRM_REQ);
        }
        return null;
      },
      style: Theme.of(context).textTheme.bodyText2.copyWith(
        color: Styles.textColor(context),
        fontSize: 16,
      ),
      onChanged: (value) => data.confirmNewPassword = value,
      decoration: InputDecoration(
          hintText: _globalService.getString(Const.CHANGE_PASS_CONFIRM),
          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, -5.0),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword[2] ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          ),
          onPressed: () => _toggle(2),
        ),
      ),
      textInputAction: TextInputAction.next,
    );

    final btnRecover = CustomButton(
      label: _globalService.getString(Const.CHANGE_PASS_BTN).toUpperCase(),
      shape: ButtonShape.Rounded,
      onClick: () {
        if (_formKey.currentState.validate()) {
          if(data.newPassword != data.confirmNewPassword) {
            showSnackBar(context, _globalService.getString(Const.CHANGE_PASS_MISMATCH), true);
          } else {
            removeFocusFromInputField(context);
            _bloc.postChangePasswordFormData(data);
          }
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
                      tfOldPassword,
                      tfNewPassword,
                      tfConfirmPassword,
                      SizedBox(height: 24.0),
                      btnRecover,
                      SizedBox(height: 40.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  _toggle(int index) {
    setState(() {
      _obscurePassword[index] = !_obscurePassword[index];
    });
    removeFocusFromInputField(context);
  }
}
