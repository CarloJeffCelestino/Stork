import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nopcart_flutter/bloc/auth_bloc.dart';
import 'package:nopcart_flutter/bloc/register_bloc.dart';
import 'package:nopcart_flutter/customWidget/CustomAppBar.dart';
import 'package:nopcart_flutter/customWidget/CustomButton.dart';
import 'package:nopcart_flutter/customWidget/loading_dialog.dart';
import 'package:nopcart_flutter/customWidget/error.dart';
import 'package:nopcart_flutter/customWidget/loading.dart';
import 'package:nopcart_flutter/model/LoginFormResponse.dart';
import 'package:nopcart_flutter/model/RegisterFormResponse.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/pages/account/forgot_password_screen.dart';
import 'package:nopcart_flutter/pages/account/registration_sceen.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/AppConstants.dart';
import 'package:nopcart_flutter/utils/ButtonShape.dart';
import 'package:nopcart_flutter/utils/Const.dart';
import 'package:nopcart_flutter/utils/CustomAttributeManager.dart';
import 'package:nopcart_flutter/utils/ValidationMixin.dart';
import 'package:nopcart_flutter/utils/shared_pref.dart';
import 'package:nopcart_flutter/utils/styles.dart';
import 'package:nopcart_flutter/utils/utility.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'dart:io' show Platform;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with ValidationMixin {
  GlobalService _globalService = GlobalService();
  AuthBloc _bloc;
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  bool _isLoggedin = false;
  Map _userObj = {};

  RegisterBloc _bloc2;
  CustomAttributeManager attributeManager;

  void _toggle() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
    removeFocusFromInputField(context);
  }

  @override
  void initState() {
    super.initState();
    _bloc2 =RegisterBloc();
    _bloc = AuthBloc();
    _bloc.fetchLoginFormData();

    _bloc.loginResponseStream.listen((event) {
      if (event.status == Status.COMPLETED) {
        // save user session & goto home
        var session = SessionData();
        session.setUserSession(event.data.token, event.data.customerInfo).then((value) {
          DialogBuilder(context).hideLoader();
          Navigator.of(context).pushNamedAndRemoveUntil('/', (r) => false);
        });

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
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    var content = StreamBuilder<ApiResponse<LoginFormData>>(
      stream: _bloc.loginFormStream,
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
    );
    
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
        title: Text(_globalService.getString(Const.ACCOUNT_LOGIN)),
      ),

      body: _globalService.centerWidgets(content),
    );
  }

  Widget rootLayout(LoginFormData formData) {
    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      validator: (value) {
        if (!formData.usernamesEnabled &&
            (value == null || value.isEmpty || !isValidEmailAddress(value))) {
          return _globalService.getString(Const.LOGIN_EMAIL_REQ);
        }
        return null;
      },
      style: Theme.of(context).textTheme.bodyText2.copyWith(
        color: Styles.textColor(context),
        fontSize: 16,
      ),
      onChanged: (value) => formData.email = value,
      decoration: InputDecoration(
        hintText: _globalService.getString(Const.LOGIN_EMAIL),
        contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, -5.0),
        suffixIcon: Icon(Icons.email_outlined)
      ),
      textInputAction: TextInputAction.next,
    );

    final username = TextFormField(
      keyboardType: TextInputType.name,
      autofocus: false,
      validator: (value) {
        if (formData.usernamesEnabled && (value == null || value.isEmpty)) {
          return _globalService.getStringWithNumberStr(
              Const.IS_REQUIRED, _globalService.getString(Const.USERNAME));
        }
        return null;
      },
      style: Theme.of(context).textTheme.bodyText2.copyWith(
        color: Styles.textColor(context),
        fontSize: 16,
      ),
      onChanged: (value) => formData.username = value,
      decoration: InputDecoration(
        hintText: _globalService.getString(Const.USERNAME),
        contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, -5.0),
        suffixIcon: Icon(Icons.person_outline_rounded),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        )
      ),
      textInputAction: TextInputAction.next,
    );

    final password = TextFormField(
      autofocus: false,
      obscureText: _obscurePassword,
      style: Theme.of(context).textTheme.bodyText2.copyWith(
        color: Styles.textColor(context),
        fontSize: 16,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return _globalService.getString(Const.LOGIN_PASS_REQ);
        }
        return null;
      },
      onChanged: (value) => formData.password = value,
      decoration: InputDecoration(
        hintText: _globalService.getString(Const.LOGIN_PASS),
        contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, -5.0),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          ),
          onPressed: _toggle,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        )
      ),
      textInputAction: TextInputAction.done,
      maxLength: 30,

    );

    final loginButton = CustomButton(
      label: _globalService.getString(Const.LOGIN_LOGIN_BTN).toUpperCase(),
      shape: ButtonShape.Rounded,
      onClick: () {
        if (formData.usernamesEnabled)
          formData.username = !formData.username.contains('@') ? formData.username.substring(0,1) == '0'
              ? '+63' + formData.username.substring(1)
              : formData.username : formData.username;

        print(formData.username);
        if (_formKey.currentState.validate()) {
          removeFocusFromInputField(context);
          _bloc.postLoginFormData(formData);
        }
      },
    );

    final registerLabel = Column(
      children: [
        TextButton(
          child: Text(
            _globalService.getString(Const.LOGIN_FORGOT_PASS),
            style: Theme.of(context).textTheme.bodyText2.copyWith(
              color: Styles.textColor(context),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          onPressed: () => Navigator.of(context).pushNamed(
            ForgotPasswordScreen.routeName
          ),
        ),
        TextButton(
          child: Text(
            _globalService.getString(Const.LOGIN_NEW_CUSTOMER),
            style: Theme.of(context).textTheme.bodyText2.copyWith(
              color: Styles.textColor(context),
              fontSize: 14,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pushNamed(
              RegistrationScreen.routeName,
              arguments: RegistrationScreenArguments(getCustomerInfo: false),
            );
          },
        )
      ],
    );

    // return Form(
    //   key: _formKey,
    //   child: Container(
    //     decoration: BoxDecoration(
    //         // image: DecorationImage(
    //         //     image: AssetImage(AppConstants.loginBackground),
    //         //     fit: BoxFit.cover)
    //     ),
    //     child: Center(
    //       child: Padding(
    //         padding: EdgeInsets.symmetric(horizontal: 20),
    //         child: Card(
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(10),
    //             side: BorderSide(
    //               color: Colors.grey.shade400,
    //             )
    //           ),
    //           elevation: 0,
    //           child: Padding(
    //             padding: EdgeInsets.symmetric(horizontal: 15),
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               mainAxisSize: MainAxisSize.min,
    //               children: <Widget>[
    //                 SizedBox(height: 48.0),
    //                 formData.usernamesEnabled ? username : email,
    //                 SizedBox(height: 8.0),
    //                 password,
    //                 SizedBox(height: 10.0),
    //                 loginButton,
    //                 registerLabel
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );

    final loginFacebook = SocialLoginButton(
      buttonType: SocialLoginButtonType.facebook,
      borderRadius: 60,
      height: 40,
      onPressed: () async {

        var result = await FacebookAuth.instance.login(
            permissions: ["public_profile", "email"]
        );

        if (result.status == LoginStatus.success) {
          var accessToken = result.accessToken;

          var userData = await FacebookAuth.instance.getUserData();
          var email = userData['email'];

          formData.username = email;
          formData.email = email;
          formData.customProperties.accessToken = accessToken.token;
          formData.customProperties.externalIdentifier = userData["id"];
          formData.customProperties.authenticationScheme = "Facebook";
          formData.customProperties.externalDisplayIdentifier = userData["name"];


          // if (_formKey.currentState.validate()) {
            removeFocusFromInputField(context);
            _bloc.postLoginFormData(formData);
          // };
        }
        else {
        }
      },
    );

    final loginGoogle = SocialLoginButton(
      buttonType: SocialLoginButtonType.google,
      borderRadius: 60,
      height: 40,
      onPressed: () async {
        var result = await _googleSignIn.signIn();
        var auth = await result.authentication;

        var email = _googleSignIn.currentUser.email;
        var user = _googleSignIn.currentUser.displayName;
        var idToken = auth.idToken;
        var accessToken = auth.accessToken;

        formData.username = email;
        formData.email = email;
        formData.customProperties.idToken = idToken;
        formData.customProperties.accessToken = accessToken;
        formData.customProperties.authenticationScheme = "Google";
        formData.customProperties.externalIdentifier = email;
        formData.customProperties.externalDisplayIdentifier = user;

        // if (_formKey.currentState.validate()) {
        removeFocusFromInputField(context);
        _bloc.postLoginFormData(formData);


      },
    );

    final loginApple = SocialLoginButton(
      buttonType: SocialLoginButtonType.apple,
      borderRadius: 60,
      height: 40,
      onPressed: () {},
    );

    final row = Row(
      children: <Widget>[
        Expanded(
            child: Divider()
        ),
        Text("Or Sign in with Stork Account",
          style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 10.0,
              color: Color(0xffbbbbbb)
          ),
        ),
        Expanded(
            child: Divider()
        ),
      ]
    );

    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
            children: <Widget>[
              SizedBox(height: 80.0),
              Center(
                child: Image.asset('assets/app_logo.png',scale: 0.8,
                ),
              ),
              SizedBox(height: 40.0),
              loginFacebook,
              SizedBox(height: 8.0),
              loginGoogle,
              defaultTargetPlatform == TargetPlatform.iOS ? SizedBox(height: 8.0) : SizedBox.shrink(),
              defaultTargetPlatform == TargetPlatform.iOS ? loginApple : SizedBox.shrink(),
              SizedBox(height: 20.0),
              row,
              SizedBox(height: 20.0),
              formData.usernamesEnabled ? username : email,
              SizedBox(height: 8.0),
              password,
              SizedBox(height: 10.0),
              loginButton,
              registerLabel,
            ]
        ),
      ),
    );

  }

  void checkSignUp(String fName,String email,String Id){
    RegisterFormData formData;
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: true
              ? Text(_globalService.getString(Const.TITLE_REGISTER))
              : Text(_globalService.getString(Const.ACCOUNT_INFO)),
        ),
        body: StreamBuilder<ApiResponse<RegisterFormData>>(
          stream: _bloc2.registerFormStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return Loading(loadingMessage: snapshot.data.message);
                  break;
                case Status.COMPLETED:
                  return null;//populateRegisterForm(snapshot.data.data);
                  break;
                case Status.ERROR:
                  return Error(
                    errorMessage: snapshot.data.message,
                    onRetryPressed: () => true
                        ? _bloc2.fetchRegisterFormData()
                        : _bloc2.fetchCustomerInfo(),
                  );
                  break;
              }
            }
            return SizedBox.shrink();
          },
        ),
      );
    }

    formData.firstName = fName;
    formData.lastName = fName;
    formData.username = email;
    formData.dateOfBirthDay = 1;
    formData.dateOfBirthMonth = 1;
    formData.dateOfBirthYear = 1990;
    formData.email = email;
    formData.password = Id;
    formData.confirmPassword = Id;

    attributeManager = CustomAttributeManager(
      context: context,
      onClick: (priceAdjNeeded) {
        setState(() {
          // updating UI to show selected attribute values
        });
      },
    );

    _bloc2.postRegisterFormData(formData, attributeManager.getSelectedAttributes('customer_attribute'));


  }
}



