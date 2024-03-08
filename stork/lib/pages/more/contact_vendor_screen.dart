import 'package:flutter/material.dart';
import 'package:nopcart_flutter/bloc/vendor_bloc.dart';
import 'package:nopcart_flutter/customWidget/CustomAppBar.dart';
import 'package:nopcart_flutter/customWidget/CustomButton.dart';
import 'package:nopcart_flutter/customWidget/error.dart';
import 'package:nopcart_flutter/customWidget/loading.dart';
import 'package:nopcart_flutter/customWidget/loading_dialog.dart';
import 'package:nopcart_flutter/model/ContactVendorResponse.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/ButtonShape.dart';
import 'package:nopcart_flutter/utils/Const.dart';
import 'package:nopcart_flutter/utils/ValidationMixin.dart';
import 'package:nopcart_flutter/utils/utility.dart';

class ContactVendorScreen extends StatefulWidget {
  static const routeName = '/contact-vendor';
  final ContactVendorScreenArgs args;

  const ContactVendorScreen({Key key, @required this.args}) : super(key: key);

  @override
  _ContactVendorScreenState createState() => _ContactVendorScreenState();
}

class _ContactVendorScreenState extends State<ContactVendorScreen>
    with ValidationMixin{
  GlobalService _globalService = GlobalService();
  VendorBloc _bloc;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _enquiryTextController;

  @override
  void initState() {
    super.initState();
    _bloc = VendorBloc();
    _enquiryTextController = TextEditingController();

    _bloc.fetchFormData(widget.args.vendorId);

    _bloc.loaderStream.listen((event) {
      if(event.status == Status.LOADING) {
        DialogBuilder(context).showLoader();
      } else if(event.status == Status.COMPLETED) {
        DialogBuilder(context).hideLoader();
        _enquiryTextController.clear();

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
        title: Text(_globalService.getString(Const.VENDOR_CONTACT_VENDOR)),
      ),
      body: StreamBuilder<ApiResponse<ContactVendorData>>(
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
                  onRetryPressed: () => _bloc.fetchFormData(widget.args.vendorId),
                );
                break;
            }
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  rootWidget(ContactVendorData formData) {
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

    _enquiryTextController.text = (formData.enquiry);

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
                        return _globalService.getString(Const.VENDOR_REQUIRED_FULLNAME);
                      }
                      return null;
                    },
                    onChanged: (value) => formData.fullName = value,
                    initialValue: formData.fullName ?? '',
                    textInputAction: TextInputAction.next,
                    decoration: inputDecor(Const.VENDOR_FULLNAME, true),
                  ),

                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    autofocus: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return _globalService.getString(Const.VENDOR_REQUIRED_EMAIL);
                      }
                      return null;
                    },
                    onChanged: (value) => formData.email = value,
                    initialValue: formData.email ?? '',
                    textInputAction: TextInputAction.next,
                    decoration: inputDecor(Const.VENDOR_EMAIL, true),
                  ),

                  if(formData.subjectEnabled)
                    TextFormField(
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      validator: (value) {
                        if (formData.subjectEnabled && (value == null || value.isEmpty)) {
                          return _globalService.getString(Const.VENDOR_REQUIRED_SUBJECT);
                        }
                        return null;
                      },
                      onChanged: (value) => formData.subject = value,
                      initialValue: formData.subject ?? '',
                      textInputAction: TextInputAction.next,
                      decoration: inputDecor(Const.VENDOR_SUBJECT, true),
                    ),

                  TextFormField(
                    controller: _enquiryTextController,
                    keyboardType: TextInputType.multiline,
                    autofocus: false,
                    minLines: 3,
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return _globalService.getString(Const.VENDOR_REQUIRED_ENQUIRY);
                      }
                      return null;
                    },
                    onChanged: (value) => formData.enquiry = value,
                    textInputAction: TextInputAction.next,
                    decoration: inputDecor(Const.VENDOR_ENQUIRY, true),
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

class ContactVendorScreenArgs{
  final int vendorId;

  ContactVendorScreenArgs(this.vendorId);
}
