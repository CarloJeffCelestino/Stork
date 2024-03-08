import 'package:flutter/material.dart';
import 'package:nopcart_flutter/bloc/contact_us_bloc.dart';
import 'package:nopcart_flutter/customWidget/CustomAppBar.dart';
import 'package:nopcart_flutter/customWidget/CustomButton.dart';
import 'package:nopcart_flutter/customWidget/error.dart';
import 'package:nopcart_flutter/customWidget/loading.dart';
import 'package:nopcart_flutter/customWidget/loading_dialog.dart';
import 'package:nopcart_flutter/model/ContactUsResponse.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/ButtonShape.dart';
import 'package:nopcart_flutter/utils/Const.dart';
import 'package:nopcart_flutter/utils/ValidationMixin.dart';
import 'package:nopcart_flutter/utils/utility.dart';

class ContactUsScreen extends StatefulWidget {
  static const routeName = '/contactUs';

  const ContactUsScreen({Key key}) : super(key: key);

  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> with ValidationMixin {
  ContactUsBloc _bloc;
  GlobalService _globalService = GlobalService();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _bloc = ContactUsBloc();
    _bloc.fetchFormData();

    _bloc.loaderStream.listen((event) {
      if(event.status == Status.LOADING) {
        DialogBuilder(context).showLoader();
      } else if(event.status == Status.COMPLETED) {
        DialogBuilder(context).hideLoader();

        if(event.data?.isNotEmpty == true) {
          showSnackBar(context, event.data, false);
        }
      } else {
        DialogBuilder(context).hideLoader();
        if(event.message?.isNotEmpty == true)
          showSnackBar(context, event.message, true);
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
        title: Text(_globalService.getString(Const.MORE_CONTACT_US)),
      ),
      body: StreamBuilder<ApiResponse<ContactUsData>>(
        stream: _bloc.contactStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Loading(loadingMessage: snapshot.data.message);
                break;
              case Status.COMPLETED:
                return snapshot.hasData
                    ? rootWidget(snapshot.data.data)
                    : SizedBox.shrink();
                break;
              case Status.ERROR:
                return Error(
                  errorMessage: snapshot.data.message,
                  onRetryPressed: () => _bloc.fetchFormData(),
                );
                break;
            }
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget rootWidget(ContactUsData formData) {
    var btnRegister = CustomButton(
        label: _globalService.getString(Const.CONTACT_US_BUTTON).toUpperCase(),
        shape: ButtonShape.RoundedTop,
        onClick: () {
          removeFocusFromInputField(context);

          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            _bloc.postEnquiry(formData);
          }
        }
    );

    return Form(
      key: _formKey,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.name,
                  autofocus: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return _globalService.getString(Const.CONTACT_US_REQUIRED_FULLNAME);
                    }
                    return null;
                  },
                  onChanged: (value) => formData.fullName = value,
                  initialValue: formData.fullName ?? '',
                  textInputAction: TextInputAction.next,
                  decoration: inputDecor(Const.CONTACT_US_FULLNAME, true),
                ),

                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  autofocus: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return _globalService.getString(Const.CONTACT_US_REQUIRED_EMAIL);
                    }
                    return null;
                  },
                  onChanged: (value) => formData.email = value,
                  initialValue: formData.email ?? '',
                  textInputAction: TextInputAction.next,
                  decoration: inputDecor(Const.CONTACT_US_EMAIL, true),
                ),

                if(formData.subjectEnabled)
                  TextFormField(
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    validator: (value) {
                      if (formData.subjectEnabled && (value == null || value.isEmpty)) {
                        return _globalService.getString(Const.CONTACT_US_SUBJECT);
                      }
                      return null;
                    },
                    onChanged: (value) => formData.subject = value,
                    initialValue: formData.subject ?? '',
                    textInputAction: TextInputAction.next,
                    decoration: inputDecor(Const.CONTACT_US_SUBJECT, true),
                  ),

                TextFormField(
                  keyboardType: TextInputType.multiline,
                  autofocus: false,
                  minLines: 3,
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return _globalService.getString(Const.CONTACT_US_REQUIRED_ENQUIRY);
                    }
                    return null;
                  },
                  onChanged: (value) => formData.enquiry = value,
                  initialValue: formData.enquiry ?? '',
                  textInputAction: TextInputAction.next,
                  decoration: inputDecor(Const.CONTACT_US_ENQUIRY, true),
                ),

                SizedBox(height: 60),
              ],
            ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(child: btnRegister)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
