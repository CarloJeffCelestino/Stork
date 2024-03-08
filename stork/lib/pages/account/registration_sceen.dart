import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nopcart_flutter/bloc/register_bloc.dart';
import 'package:nopcart_flutter/customWidget/CustomAppBar.dart';
import 'package:nopcart_flutter/customWidget/CustomButton.dart';
import 'package:nopcart_flutter/customWidget/CustomCheckBox.dart';
import 'package:nopcart_flutter/customWidget/CustomDropdown.dart';
import 'package:nopcart_flutter/customWidget/error.dart';
import 'package:nopcart_flutter/customWidget/loading.dart';
import 'package:nopcart_flutter/customWidget/loading_dialog.dart';
import 'package:nopcart_flutter/model/AvailableOption.dart';
import 'package:nopcart_flutter/model/GetAvatarResponse.dart';
import 'package:nopcart_flutter/model/RegisterFormResponse.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/pages/account/change_password_screen.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/ButtonShape.dart';
import 'package:nopcart_flutter/utils/Const.dart';
import 'package:nopcart_flutter/utils/CustomAttributeManager.dart';
import 'package:nopcart_flutter/utils/ValidationMixin.dart';
import 'package:nopcart_flutter/utils/extensions.dart';
import 'package:nopcart_flutter/utils/shared_pref.dart';
import 'package:nopcart_flutter/utils/utility.dart';

import '../../model/GetOtpResponse.dart';
import '../../utils/styles.dart';

class RegistrationScreen extends StatefulWidget {
  static const routeName = '/registration';
  final RegistrationScreenArguments screenArgument;

  const RegistrationScreen({Key key, this.screenArgument}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState(screenArgument);
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with ValidationMixin, TickerProviderStateMixin {
  final RegistrationScreenArguments screenArgument;
  bool isRegistrationMode;
  GlobalService _globalService = GlobalService();
  RegisterBloc _bloc;
  CustomAttributeManager attributeManager;
  final _formKey = GlobalKey<FormState>();
  List<bool> _isTabDisabled = [false, true, true];
  List<FocusNode> _otpFocusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];
  List<TextEditingController> _otpControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  TabController _tabController;
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController(text: '+63');
  FocusNode mobileNumberFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  String referenceCode = '';

  _RegistrationScreenState(this.screenArgument) {
    isRegistrationMode = !screenArgument.getCustomerInfo;
  }

  changeTabView() {
    if (_isTabDisabled[_tabController.index]) {
      int index = _tabController.previousIndex;
      setState(() {
        _tabController.index = index;
      });
    }
  }

  Future<bool> getOtp() async {
    DialogBuilder(context).showLoader();
    var response = await _bloc.getOtp(countryCodeController.text + mobileNumberController.text.substring(0,1) == '0'
        ? mobileNumberController.text.substring(1)
        : mobileNumberController.text);
    DialogBuilder(context).hideLoader();

    if(response.status == Status.COMPLETED) {
      referenceCode = response.data.data.referenceCode;

      return true;

    } else if(response.status == Status.ERROR) {
      if(response.message.isNotEmpty)
        showSnackBar(context, response.message, true);

      return false;
    } else {
      showSnackBar(context, "Error", true);
      return false;
    }
  }

  verify() {
    setState(() async {
      // Change to validation

      var validate = GetOtpData(
        phoneNumber: mobileNumberController.text,
        otpCode: _otpControllers.map((e) => e.text).join(""),
        referenceCode: referenceCode,
      );


      DialogBuilder(context).showLoader();
      var response =  await _bloc.validateOtp(validate);
      DialogBuilder(context).hideLoader();

      if(response.status == Status.COMPLETED) {
        FocusScope.of(context).requestFocus(passwordFocusNode);
        _isTabDisabled[2] = false;
        _tabController.index = 2;

      } else if(response.status == Status.ERROR) {
        if(response.message.isNotEmpty)
          showSnackBar(context, "Invalid OTP", true);
      } else {
        showSnackBar(context, "Error", true);
      }
    });
  }


  @override
  void initState() {
    super.initState();
    _bloc = RegisterBloc();



    _otpControllers.forEach((element) {
      element.addListener(() {

      });
    });
    _otpFocusNodes.forEach((element) {
      element.addListener(() {
        if (element.hasFocus) {
          var index = _otpFocusNodes.indexOf(element);
          _otpControllers[index].selection = TextSelection(baseOffset: 0, extentOffset: _otpControllers[index].value.text.length);
        }
      });
    });

    if(isRegistrationMode) {
      _bloc.fetchRegisterFormData();
    } else {
      _bloc.fetchCustomerInfo();

      if(_globalService.getAppLandingData().allowCustomersToUploadAvatars == true)
        _bloc.fetchCustomerAvatar();
    }

    _bloc.registerResponseStream.listen((event) async {
      if (event.status == Status.COMPLETED) {
        DialogBuilder(context).hideLoader();
        
        if(isRegistrationMode) {
          showSnackBar(context, event?.data?.message ?? '', false);
          // close the screen
          await Future.delayed(Duration(microseconds: 250));
          Navigator.of(context).pop();
        } else {
          showSnackBar(context, _globalService.getString(Const.UPDATED_SUCCESSFULLY), false);
          // Save updated info to disk
          var info = await SessionData().getCustomerInfo();

          info
            ..firstName = event?.data?.data?.firstName ?? ''
            ..lastName = event?.data?.data?.lastName ?? ''
            ..email = event?.data?.data?.email ?? ''
            ..username = event?.data?.data?.username ?? '';

          SessionData().setCustomerInfo(info);
        }
        
      } else if (event.status == Status.ERROR) {
        DialogBuilder(context).hideLoader();
        showSnackBar(context, event.message, true);
      } else if (event.status == Status.LOADING) {
        DialogBuilder(context).showLoader();
      }
    });

    _bloc.statesListStream.listen((event) {
      if (event.status == Status.LOADING) {
        DialogBuilder(context).showLoader();
      } else {
        DialogBuilder(context).hideLoader();
      }
    });

    attributeManager = CustomAttributeManager(
      context: context,
      onClick: (priceAdjNeeded) {
        setState(() {
          // updating UI to show selected attribute values
        });
      },
    );

    _tabController = new TabController(length: 3, vsync: this);
    _tabController.addListener(changeTabView);

  }

  @override
  void dispose() {
    _bloc.dispose();
    _otpFocusNodes.forEach((element) {element.dispose();});
    mobileNumberFocusNode.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: isRegistrationMode
              ? Text(_globalService.getString(Const.TITLE_REGISTER))
              : Text(_globalService.getString(Const.ACCOUNT_INFO)),
        ),
        body: StreamBuilder<ApiResponse<RegisterFormData>>(
          stream: _bloc.registerFormStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return Loading(loadingMessage: snapshot.data.message);
                  break;
                case Status.COMPLETED:
                  return populateRegisterForm(snapshot.data.data);
                  break;
                case Status.ERROR:
                  return Error(
                    errorMessage: snapshot.data.message,
                    onRetryPressed: () => isRegistrationMode
                        ? _bloc.fetchRegisterFormData()
                        : _bloc.fetchCustomerInfo(),
                  );
                  break;
              }
            }
            return SizedBox.shrink();
          },
        ),
      );
  }

  Widget populateRegisterForm(RegisterFormData formData) {

    final tfFirstName = TextFormField(
      keyboardType: TextInputType.name,
      autofocus: false,
      validator: (value) {
        if (formData.firstNameEnabled &&
            formData.firstNameRequired &&
            (value == null || value.isEmpty)) {
          return _globalService.getString(Const.FIRST_NAME);
        }
        return null;
      },
      onChanged: (value) => formData.firstName = value,
      initialValue: formData.firstName,
      textInputAction: TextInputAction.next,
      decoration: inputDecor(Const.FIRST_NAME,
          formData.firstNameEnabled && formData.firstNameRequired),
    );

    final tfLastName = TextFormField(
      keyboardType: TextInputType.name,
      autofocus: false,
      validator: (value) {
        if (formData.lastNameEnabled &&
            formData.lastNameRequired &&
            (value == null || value.isEmpty)) {
          return _globalService.getString(Const.LAST_NAME);
        }
        return null;
      },
      onChanged: (value) => formData.lastName = value,
      initialValue: formData.lastName,
      textInputAction: TextInputAction.next,
      decoration: inputDecor(Const.LAST_NAME,
          formData.lastNameEnabled && formData.lastNameRequired),
    );

    final tfEmail = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      validator: (value) {
        if (value == null || value.isEmpty || !isValidEmailAddress(value)) {
          return _globalService.getString(Const.EMAIL);
        }
        return null;
      },
      onChanged: (value) => formData.email = value,
      initialValue: formData.email != null && formData.email.contains('dummy.') && formData.email.contains('@stork.ph') ? '' : formData.email,
      textInputAction: TextInputAction.next,
      decoration: inputDecor(Const.EMAIL, true),
    );

    final tfConfirmEmail = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      validator: (value) {
        if ((formData.enteringEmailTwice ?? false) &&
            (value == null || value.isEmpty || !isValidEmailAddress(value))) {
          return _globalService.getString(Const.CONFIRM_EMAIL);
        }
        return null;
      },
      onChanged: (value) => formData.confirmEmail = value,
      initialValue: formData.confirmEmail,
      textInputAction: TextInputAction.next,
      decoration: inputDecor(Const.CONFIRM_EMAIL, true),
    );

    final tfUsername = TextFormField(
      keyboardType: TextInputType.name,
      autofocus: false,
      validator: (value) {
        if (formData.usernamesEnabled && (value == null || value.isEmpty)) {
          return _globalService.getString(Const.USERNAME);
        }
        return null;
      },
      onChanged: (value) => formData.username = value,
      initialValue: formData.username,
      textInputAction: TextInputAction.next,
      decoration: inputDecor(Const.USERNAME, formData.usernamesEnabled),
    );

    final tfCompany = TextFormField(
      keyboardType: TextInputType.name,
      autofocus: false,
      validator: (value) {
        if (formData.companyEnabled &&
            formData.companyRequired &&
            (value == null || value.isEmpty)) {
          return _globalService.getString(Const.COMPANY);
        }
        return null;
      },
      onChanged: (value) => formData.company = value,
      initialValue: formData.company,
      textInputAction: TextInputAction.next,
      decoration: inputDecor(
          Const.COMPANY, formData.companyEnabled && formData.companyRequired),
    );

    final tfStreet1 = TextFormField(
      keyboardType: TextInputType.name,
      autofocus: false,
      validator: (value) {
        if (formData.streetAddressEnabled &&
            formData.streetAddressRequired &&
            (value == null || value.isEmpty)) {
          return _globalService.getString(Const.STREET_ADDRESS);
        }
        return null;
      },
      onChanged: (value) => formData.streetAddress = value,
      initialValue: formData.streetAddress,
      textInputAction: TextInputAction.next,
      decoration: inputDecor(Const.STREET_ADDRESS,
          formData.streetAddressEnabled && formData.streetAddressRequired),
    );

    final tfStreet2 = TextFormField(
      keyboardType: TextInputType.name,
      autofocus: false,
      validator: (value) {
        if (formData.streetAddress2Enabled &&
            formData.streetAddress2Required &&
            (value == null || value.isEmpty)) {
          return _globalService.getString(Const.STREET_ADDRESS_2);
        }
        return null;
      },
      onChanged: (value) => formData.streetAddress2 = value,
      initialValue: formData.streetAddress2,
      textInputAction: TextInputAction.next,
      decoration: inputDecor(Const.STREET_ADDRESS_2,
          formData.streetAddress2Enabled && formData.streetAddress2Required),
    );

    final tfZip = TextFormField(
      keyboardType: TextInputType.number,
      autofocus: false,
      validator: (value) {
        if (formData.zipPostalCodeEnabled &&
            formData.zipPostalCodeRequired &&
            (value == null || value.isEmpty)) {
          return _globalService.getString(Const.ZIP_CODE);
        }
        return null;
      },
      onChanged: (value) => formData.zipPostalCode = value,
      initialValue: formData.zipPostalCode,
      textInputAction: TextInputAction.next,
      decoration: inputDecor(Const.ZIP_CODE,
          formData.zipPostalCodeEnabled && formData.zipPostalCodeRequired),
    );

    final tfCounty = TextFormField(
      keyboardType: TextInputType.name,
      autofocus: false,
      validator: (value) {
        if (formData.countyEnabled &&
            formData.countyRequired &&
            (value == null || value.isEmpty)) {
          return _globalService.getString(Const.ADDRESS_COUNTY);
        }
        return null;
      },
      onChanged: (value) => formData.county = value,
      initialValue: formData.county,
      textInputAction: TextInputAction.next,
      decoration: inputDecor(Const.ADDRESS_COUNTY,
          formData.countyEnabled && formData.countyRequired),
    );

    final tfCity = TextFormField(
      keyboardType: TextInputType.name,
      autofocus: false,
      validator: (value) {
        if (formData.cityEnabled &&
            formData.cityRequired &&
            (value == null || value.isEmpty)) {
          return _globalService.getString(Const.CITY);
        }
        return null;
      },
      onChanged: (value) => formData.city = value,
      initialValue: formData.city,
      textInputAction: TextInputAction.next,
      decoration:
          inputDecor(Const.CITY, formData.cityEnabled && formData.cityRequired),
    );

    final tfPhone = TextFormField(
      keyboardType: TextInputType.phone,
      autofocus: false,
      validator: (value) {
        if (formData.phoneEnabled &&
            formData.phoneRequired &&
            (value == null || value.isEmpty)) {
          return _globalService.getString(Const.PHONE);
        }
        return null;
      },
      onChanged: (value) => formData.phone = value,
      initialValue: formData.phone,
      textInputAction: TextInputAction.next,
      decoration: inputDecor(
          Const.PHONE, formData.phoneEnabled && formData.phoneRequired),
    );

    final tfFax = TextFormField(
      keyboardType: TextInputType.phone,
      autofocus: false,
      validator: (value) {
        if (formData.faxEnabled &&
            formData.faxRequired &&
            (value == null || value.isEmpty)) {
          return _globalService.getString(Const.FAX);
        }
        return null;
      },
      onChanged: (value) => formData.fax = value,
      initialValue: formData.fax,
      textInputAction: TextInputAction.next,
      decoration:
          inputDecor(Const.FAX, formData.faxEnabled && formData.faxRequired),
    );

    final tfDOB = TextFormField(
      key: UniqueKey(),
      keyboardType: TextInputType.text,
      autofocus: false,
      readOnly: true,
      initialValue: getFormattedDate(_bloc.userDob),
      validator: (value) {
        if (formData.dateOfBirthEnabled &&
            formData.dateOfBirthRequired &&
            (value == null || value.isEmpty)) {
          return _globalService.getString(Const.DATE_OF_BIRTH);
        }
        return null;
      },
      onSaved: (newValue) {
        if (_bloc.userDob != null) {
          formData.dateOfBirthDay = _bloc.userDob.day;
          formData.dateOfBirthMonth = _bloc.userDob.month;
          formData.dateOfBirthYear = _bloc.userDob.year;
        }
      },
      onTap: () => _selectDate(),
      textInputAction: TextInputAction.next,
      decoration: inputDecor(Const.DATE_OF_BIRTH,
          formData.dateOfBirthEnabled && formData.dateOfBirthRequired),
    );

    var countryDropDown =  formData.countryEnabled
      ? CustomDropdown<AvailableOption>(
      onChanged: (value) {
        setState(() {
          _bloc.selectedCountry = value;
          formData.countryId = int.tryParse(value.value);
          _bloc.fetchStatesByCountryId(formData.countryId);
        });
      },
      onSaved: (newValue) {
        _bloc.selectedCountry = newValue;
        formData.countryId = int.tryParse(newValue.value);
      },
      validator: (value) {
        if(formData.countryEnabled && formData.countryRequired && (value == null || value.value == '0'))
          return _globalService.getString(Const.COUNTRY_REQUIRED);
        return null;
      },
      preSelectedItem: _bloc.selectedCountry,
      items: formData.availableCountries
          ?.map<DropdownMenuItem<AvailableOption>>((e) =>
          DropdownMenuItem<AvailableOption>(
              value: e, child: Text(e.text)))
          ?.toList() ??
          List.empty(),
    ) : SizedBox.shrink();

    var stateDropDown = formData.stateProvinceEnabled ?
    CustomDropdown<AvailableOption>(
      onChanged: (value) {
        setState(() {
          _bloc.selectedState = value;
          formData.stateProvinceId = int.tryParse(value.value);
        });
      },
      onSaved: (newValue) {
        _bloc.selectedState = newValue;
        formData.stateProvinceId = int.tryParse(newValue.value);
      },
      validator: (value) {
        if(formData.stateProvinceEnabled && formData.stateProvinceRequired && value == null)
          return _globalService.getString(Const.STATE_REQUIRED);
        return null;
      },
      preSelectedItem: _bloc.cachedData.availableStates?.safeFirstWhere(
        (element) => element.selected ?? false,
        orElse: () => formData.availableStates?.safeFirst(),
      ),
      items: _bloc.cachedData.availableStates
          ?.map<DropdownMenuItem<AvailableOption>>((e) =>
          DropdownMenuItem<AvailableOption>(
              value: e, child: Text(e.text)))
          ?.toList() ??
          List.empty(),
    ) : SizedBox.shrink();

    var tzDropDown = formData.allowCustomersToSetTimeZone ?
    CustomDropdown<AvailableOption>(
      onChanged: (value) {
        setState(() {
          _bloc.selectedTimeZone = value;
          formData.timeZoneId = int.tryParse(value.value);
        });
      },
      onSaved: (newValue) {
        _bloc.selectedTimeZone = newValue;
        formData.timeZoneId = int.tryParse(newValue.value);
      },
      preSelectedItem: _bloc.selectedTimeZone,
      items: formData.availableTimeZones
          ?.map<DropdownMenuItem<AvailableOption>>((e) =>
          DropdownMenuItem<AvailableOption>(
              value: e, child: Text(e.text)))
          ?.toList() ??
          List.empty(),
    ) : SizedBox.shrink();

    var radioGender = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 48,
          child: Center(
            child: Text(_globalService.getString(Const.GENDER),
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),),
          ),
        ),
        SizedBox(
          child: Row(
            children: [
              Radio<String>(
                value: "M",
                groupValue: formData.gender,
                onChanged: (value) {
                  setState(() {
                    formData.gender = value;
                  });
                },
              ),
              Text(_globalService.getString(Const.GENDER_MALE)),
            ],
          ),
        ),
        SizedBox(
          child: Row(
            children: [
              Radio<String>(
                value: "F",
                groupValue: formData.gender,
                onChanged: (value) {
                  setState(() {
                    formData.gender = value;
                  });
                },
              ),
              Text(_globalService.getString(Const.GENDER_FEMALE)),
            ],
          ),
        ),
      ],
    );

    var btnRegister = CustomButton(
        label: isRegistrationMode
            ? _globalService.getString(Const.REGISTER_BUTTON).toUpperCase()
            : _globalService.getString(Const.SAVE_BUTTON).toUpperCase(),
        shape: ButtonShape.RoundedTop,
        onClick: () {
          removeFocusFromInputField(context);

          String attrErrorMsg = attributeManager.checkRequiredAttributes(formData.customerAttributes);

          String gdprErrorMsg = '';
          formData.gdprConsents?.forEach((element) {
            if(element.isRequired == true && element.accepted == false)
              gdprErrorMsg = '$gdprErrorMsg${element.requiredMessage ?? ''}\n';
          });
          gdprErrorMsg.trimRight();

          if(attrErrorMsg.isNotEmpty) {
            showSnackBar(context, attrErrorMsg, true);
          } else if((formData.acceptPrivacyPolicyEnabled ?? false) && !_bloc.privacyAccepted) {
            showSnackBar(context, _globalService.getString(Const.REGISTER_ACCEPT_PRIVACY), true);
          } else if (gdprErrorMsg.isNotEmpty) {
            showSnackBar(context, gdprErrorMsg, true);
          } else {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();

              if (isRegistrationMode) {
                _bloc.postRegisterFormData(formData, attributeManager.getSelectedAttributes('customer_attribute'));
              } else {
                _bloc.posCustomerInfo(formData, attributeManager.getSelectedAttributes('customer_attribute'));
              }
            }
          }
        }
    );

    var avatarSection = [
      SizedBox(height: 10),
      StreamBuilder<ApiResponse<GetAvatarData>>(
        stream: _bloc.avatarStream,
        builder: (context, snapshot) {
          if(snapshot.hasData && snapshot.data.status == Status.COMPLETED)
            return CircleAvatar(
            backgroundImage: snapshot.data?.data?.avatarUrl?.isNotEmpty == true
              ? NetworkImage(snapshot.data?.data?.avatarUrl ?? '')
              : AssetImage('assets/user.png'),
            backgroundColor: Colors.grey[200],
            child: Align(
              alignment: Alignment.bottomCenter,
              child: PopupMenuButton(
                icon: Icon(Icons.edit_outlined),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value: 1,
                      child: Text(_globalService.getString(Const.COMMON_UPLOAD)),
                    ),
                    if(snapshot.data?.data?.avatarUrl?.isNotEmpty == true)
                      PopupMenuItem(
                        value: 2,
                        child: Text(_globalService.getString(Const.ACCOUNT_REMOVE_AVATAR)),
                      )
                  ];
                },
                onSelected: (int index) async {
                  if(index == 1) { // upload
                    FilePickerResult result = await FilePicker.platform.pickFiles(
                      // type: FileType.image,
                      allowMultiple: false,
                    );

                    var maxSize = _globalService.getAppLandingData().avatarMaximumSizeBytes;

                    if(result != null && result.files.single.size > maxSize) {
                      var msg = _globalService.getStringWithNumber(
                          Const.ACCOUNT_AVATAR_SIZE, _globalService.getAppLandingData().avatarMaximumSizeBytes ?? 50);
                      showSnackBar(context, msg, true);
                    } else if(result != null && result.files.single.size < maxSize) {
                      _bloc.uploadAvatar(result.files.single.path);
                    }
                  } else if(index == 2) { // remove
                    _bloc.removeAvatar();
                  }
                },
              ),
            ),
            radius: 50,
          );
          else
            return SizedBox.shrink();
        }
      ),
    ];

    if (!isRegistrationMode)
      return Form(
        key: _formKey,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isRegistrationMode && _globalService.getAppLandingData().allowCustomersToUploadAvatars == true)
                      ...avatarSection,
                    sectionTitle(_globalService.getString(Const.REGISTRATION_PERSONAL_DETAILS)),
                    if (formData.firstNameEnabled) tfFirstName,
                    if (formData.lastNameEnabled) tfLastName,
                    if (formData.usernamesEnabled) tfUsername,
                    if (formData.dateOfBirthEnabled) tfDOB,
                    tfEmail,
                    if (formData.enteringEmailTwice ?? false) tfConfirmEmail,
                    if(formData.genderEnabled) radioGender,
                    if (formData.countryEnabled) countryDropDown,
                    if (formData.stateProvinceEnabled) stateDropDown,
                    if (formData.allowCustomersToSetTimeZone) tzDropDown,
                    if (formData.phoneEnabled) tfPhone,
                    if (formData.faxEnabled) tfFax,
                    if (formData.streetAddressEnabled) tfStreet1,
                    if (formData.streetAddress2Enabled) tfStreet2,
                    if (formData.zipPostalCodeEnabled) tfZip,
                    if (formData.countyEnabled) tfCounty,
                    if (formData.cityEnabled) tfCity,
                    if (formData.companyEnabled) tfCompany,
                    checkboxAndGdprConsent(formData),
                    attributeManager.populateCustomAttributes(formData.customerAttributes),
                    SizedBox(height: 10),
                    if(isRegistrationMode)
                      passwordSection(formData),
                    if(!isRegistrationMode)
                      changePasswordSection(),
                    SizedBox(height: 60), // margin for button
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(children: [
                Expanded(child: btnRegister)
              ],),
            )
          ],
        ),
      );


    return TabBarView(
      controller: _tabController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Center(
          child: Container(
            width: 300,
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(),
                ),
                Container(
                  child: Column(
                    children: [
                      Image.asset('assets/app_logo.png',scale: 0.8,),
                      Container(height: 10,),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: countryCodeController,
                              style: Theme.of(context).textTheme.bodyText2.copyWith(
                                color: Styles.textColor(context),
                                fontSize: 16,
                              ),
                              enabled: false,
                              decoration: InputDecoration(
                                hintText: "Country Code",
                                contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, -5.0),
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                setState(() {

                                });
                              },
                            ),
                          ),
                          Expanded(
                            flex: 10,
                            child: TextField(
                              controller: mobileNumberController,
                              focusNode: mobileNumberFocusNode,
                              autofocus: _tabController.index == 0 ? true : false,
                              style: Theme.of(context).textTheme.bodyText2.copyWith(
                                color: Styles.textColor(context),
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                  hintText: "Enter Mobile Number",
                                  contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, -5.0),
                              ),
                              onChanged: (value) {
                                setState(() {

                                });
                              },
                            ),
                          )
                        ],
                      ),

                      Container(height: 16,),
                      CustomButton(
                        label: "Next",
                        enabled: mobileNumberController.text.isNotEmpty,
                        shape: ButtonShape.Rounded,
                        onClick: () {
                          setState(() async {
                            // Change to validation
                            mobileNumberFocusNode.unfocus();
                            if(await getOtp()) {
                              FocusScope.of(context).requestFocus(_otpFocusNodes[0]);
                              _isTabDisabled[1] = false;
                              _tabController.index = 1;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(),
                ),
                Text(
                    '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                    fontSize: 12
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
              ],
            )
          )
        ),
        Center(
            child: Container(
                width: 300,
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Image.asset('assets/app_logo.png',scale: 0.8,),
                          Container(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: ((){
                              List<int> count =  [0,1,2,3,4,5];

                              return [
                                for(var i in count) Container(
                                  width: 24,
                                  margin: EdgeInsets.symmetric(horizontal: 12),
                                  child: TextField(
                                    controller: _otpControllers[i],
                                    focusNode: _otpFocusNodes[i],
                                    textAlign: TextAlign.center,
                                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                    maxLength: 1,
                                    autofocus: i == 0 && _tabController.index == 1 ? true : false,
                                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                                      color: Styles.textColor(context),
                                      fontSize: 16,
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        _otpFocusNodes[i].unfocus();
                                        if (i < _otpFocusNodes.length)
                                          FocusScope.of(context).requestFocus(_otpFocusNodes[i + 1]);
                                        else
                                          verify();

                                      });
                                    },
                                    decoration: InputDecoration(
                                      counterText: '',
                                    ),
                                  ),
                                ),
                              ];

                            }()),
                          ),
                          Container(height: 16,),
                          CustomButton(
                            label: "Verify",
                            shape: ButtonShape.Rounded,
                            enabled: _otpControllers.every((element) => element.text.isNotEmpty),
                            onClick: () {
                              verify();
                            },
                          ),
                          TextButton(
                            child: Padding(
                              padding: EdgeInsets.all(4),
                              child: Text(
                                'Resend',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            onPressed: () {
                              setState(() async {
                                // Change to validation
                                await getOtp();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Container(),
                    ),
                    Text(
                      '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                          fontSize: 12
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                  ],
                )
            )
        ),
        Form(
          key: _formKey,
          child: Center(
              child: Container(
                  width: 300,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Image.asset('assets/app_logo.png',scale: 0.8,),
                            Container(height: 10,),
                            if(isRegistrationMode)
                              passwordSection(formData),
                            if(!isRegistrationMode)
                              changePasswordSection(),
                            Container(height: 16,),
                            CustomButton(
                              label: "Signup",
                              shape: ButtonShape.Rounded,
                              onClick: () {
                                setState(() {
                                  formData.username = countryCodeController.text + (mobileNumberController.text.substring(0,1) == '0'
                                      ? mobileNumberController.text.substring(1)
                                      : mobileNumberController.text);
                                  formData.email = 'dummy.${(mobileNumberController.text.substring(0,1) == '0'
                                      ? mobileNumberController.text.substring(1)
                                      : mobileNumberController.text).replaceAll(RegExp('[^A-Za-z0-9]'), '')}@stork.ph';
                                  removeFocusFromInputField(context);

                                  String attrErrorMsg = attributeManager.checkRequiredAttributes(formData.customerAttributes);

                                  String gdprErrorMsg = '';
                                  formData.gdprConsents?.forEach((element) {
                                    if(element.isRequired == true && element.accepted == false)
                                      gdprErrorMsg = '$gdprErrorMsg${element.requiredMessage ?? ''}\n';
                                  });
                                  gdprErrorMsg.trimRight();

                                  if(attrErrorMsg.isNotEmpty) {
                                    showSnackBar(context, attrErrorMsg, true);
                                  } else if((formData.acceptPrivacyPolicyEnabled ?? false) && !_bloc.privacyAccepted) {
                                    showSnackBar(context, _globalService.getString(Const.REGISTER_ACCEPT_PRIVACY), true);
                                  } else if (gdprErrorMsg.isNotEmpty) {
                                    showSnackBar(context, gdprErrorMsg, true);
                                  } else {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();

                                      if (isRegistrationMode) {
                                        _bloc.postRegisterFormData(formData, attributeManager.getSelectedAttributes('customer_attribute'));
                                      } else {
                                        _bloc.posCustomerInfo(formData, attributeManager.getSelectedAttributes('customer_attribute'));
                                      }
                                    }
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Container(),
                      ),
                      Text(
                        'By signing up, you agree to Stork\'s Terms of Service & Privacy Policy',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                            fontSize: 12
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                    ],
                  )
              )
          )


          //child: Stack(
          //   children: [
          //     SingleChildScrollView(
          //       child: Padding(
          //         padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          //         child: Column(
          //           mainAxisSize: MainAxisSize.min,
          //           children: [
          //             if(isRegistrationMode)
          //               passwordSection(formData),
          //             if(!isRegistrationMode)
          //               changePasswordSection(),
          //             SizedBox(height: 60), // margin for button
          //           ],
          //         ),
          //       ),
          //     ),
          //     Align(
          //       alignment: Alignment.bottomCenter,
          //       child: Row(children: [
          //         Expanded(child: btnRegister)
          //       ],),
          //     )
          //   ],
          // ),
        ),
      ],
    );


    // return Form(
    //     key: _formKey,
    //     child: Stack(
    //       children: [
    //         SingleChildScrollView(
    //           child: Padding(
    //             padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
    //             child: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               children: [
    //                 if (!isRegistrationMode && _globalService.getAppLandingData().allowCustomersToUploadAvatars == true)
    //                   ...avatarSection,
    //                 sectionTitle(_globalService.getString(Const.REGISTRATION_PERSONAL_DETAILS)),
    //                 if (formData.firstNameEnabled) tfFirstName,
    //                 if (formData.lastNameEnabled) tfLastName,
    //                 if (formData.usernamesEnabled) tfUsername,
    //                 if (formData.dateOfBirthEnabled) tfDOB,
    //                 tfEmail,
    //                 if (formData.enteringEmailTwice ?? false) tfConfirmEmail,
    //                 if(formData.genderEnabled) radioGender,
    //                 if (formData.countryEnabled) countryDropDown,
    //                 if (formData.stateProvinceEnabled) stateDropDown,
    //                 if (formData.allowCustomersToSetTimeZone) tzDropDown,
    //                 if (formData.phoneEnabled) tfPhone,
    //                 if (formData.faxEnabled) tfFax,
    //                 if (formData.streetAddressEnabled) tfStreet1,
    //                 if (formData.streetAddress2Enabled) tfStreet2,
    //                 if (formData.zipPostalCodeEnabled) tfZip,
    //                 if (formData.countyEnabled) tfCounty,
    //                 if (formData.cityEnabled) tfCity,
    //                 if (formData.companyEnabled) tfCompany,
    //                 checkboxAndGdprConsent(formData),
    //                 attributeManager.populateCustomAttributes(formData.customerAttributes),
    //                 SizedBox(height: 10),
    //                 if(isRegistrationMode)
    //                   passwordSection(formData),
    //                 if(!isRegistrationMode)
    //                   changePasswordSection(),
    //                 SizedBox(height: 60), // margin for button
    //               ],
    //             ),
    //           ),
    //         ),
    //         Align(
    //           alignment: Alignment.bottomCenter,
    //           child: Row(children: [
    //             Expanded(child: btnRegister)
    //           ],),
    //         )
    //       ],
    //     ),
    // );
  }

  Widget checkboxAndGdprConsent(RegisterFormData formData) {

    final List<Widget> gdprView = [];

    formData.gdprConsents?.forEach((item) {
      gdprView.add(
          CustomCheckBox(
            onTap: () {
              setState(() {
                item.accepted = !item.accepted;
              });
            },
            isChecked: item.accepted ?? false,
            label: item.message,
          )
      );
    });


    return Column(
      children: [
        if (formData.newsletterEnabled ?? false)
          CustomCheckBox(
            onTap: () {
              setState(() {
                formData.newsletter = !formData.newsletter;
              });
            },
            isChecked: formData.newsletter ?? false,
            label: _globalService.getString(Const.NEWSLETTER),
          ),

        if(formData.acceptPrivacyPolicyEnabled ?? false)
          CustomCheckBox(
            onTap: () {
              setState(() {
                _bloc.privacyAccepted = !_bloc.privacyAccepted;
                formData.acceptPrivacyPolicyPopup = _bloc.privacyAccepted;
              });
            },
            isChecked: _bloc.privacyAccepted,
            label: _globalService.getString(Const.ACCEPT_PRIVACY_POLICY),
          ),
        ...gdprView,
      ],

      // TODO GDPR consent
    );
  }

  Widget passwordSection(RegisterFormData formData) {
    return Column(
      children: [
        TextFormField(
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
          autofocus: false,
          focusNode: passwordFocusNode,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return _globalService.getString(Const.ENTER_PASSWORD);
            }
            return null;
          },
          onChanged: (value) => formData.password = value,
          initialValue: formData.password,
          textInputAction: TextInputAction.next,
          style: Theme.of(context).textTheme.bodyText2.copyWith(
            color: Styles.textColor(context),
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: GlobalService().getString(Const.ENTER_PASSWORD),
            contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, -5.0),
          ),
        ),
        TextFormField(
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
          autofocus: false,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return _globalService.getString(Const.CONFIRM_PASSWORD);
            }
            return null;
          },
          onChanged: (value) => formData.confirmPassword = value,
          initialValue: formData.confirmPassword,
          textInputAction: TextInputAction.done,
          style: Theme.of(context).textTheme.bodyText2.copyWith(
            color: Styles.textColor(context),
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: GlobalService().getString(Const.CONFIRM_PASSWORD),
            contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, -5.0),
          ),
        ),
      ],
    );
  }

  Widget changePasswordSection() =>
    Align(
      alignment: Alignment.topRight,
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(ChangePasswordScreen.routeName),
        child: Text(
          _globalService.getString(Const.CHANGE_PASSWORD),
          style: Theme.of(context).textTheme.bodyText2.copyWith(
            color: Colors.blue[800],
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
            fontSize: 17,
          ),
        ),
      ),
    );

  Widget sectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold
          ),
        ),
        getDivider()
      ],
    );
  }

  Future<void> _selectDate() async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: _bloc.userDob == null ? DateTime.now() : _bloc.userDob,
        firstDate: DateTime(1950),
        lastDate: DateTime.now());

    if (pickedDate != null)
      setState(() {
        _bloc.userDob = pickedDate;
      });
  }
}

class RegistrationScreenArguments {
  bool getCustomerInfo;

  RegistrationScreenArguments({@required this.getCustomerInfo});
}
