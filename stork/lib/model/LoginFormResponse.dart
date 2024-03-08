import 'package:nopcart_flutter/model/CustomProperties.dart';

class LoginFormResponse {
  LoginFormResponse({
    this.data,
    this.message,
    this.errorList,
  });

  LoginFormData data;
  String message;
  List<String> errorList;

  factory LoginFormResponse.fromJson(Map<String, dynamic> json) => LoginFormResponse(
    data: LoginFormData.fromJson(json["Data"]),
    message: json["Message"],
    errorList: List<String>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Data": data.toJson(),
    "Message": message,
    "ErrorList": List<dynamic>.from(errorList.map((x) => x)),
  };
}

class LoginFormData {
  LoginFormData({
    this.checkoutAsGuest,
    this.email,
    this.usernamesEnabled,
    this.registrationType,
    this.username,
    this.password,
    this.rememberMe,
    this.displayCaptcha,
    this.customProperties,
  });

  bool checkoutAsGuest;
  String email;
  bool usernamesEnabled;
  int registrationType;
  String username;
  String password;
  bool rememberMe;
  bool displayCaptcha;
  CustomProperties customProperties;

  factory LoginFormData.fromJson(Map<String, dynamic> json) => LoginFormData(
    checkoutAsGuest: json["CheckoutAsGuest"],
    email: json["Email"],
    usernamesEnabled: json["UsernamesEnabled"],
    registrationType: json["RegistrationType"],
    username: json["Username"],
    password: json["Password"],
    rememberMe: json["RememberMe"],
    displayCaptcha: json["DisplayCaptcha"],
    customProperties: CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "CheckoutAsGuest": checkoutAsGuest,
    "Email": email,
    "UsernamesEnabled": usernamesEnabled,
    "RegistrationType": registrationType,
    "Username": username,
    "Password": password,
    "RememberMe": rememberMe,
    "DisplayCaptcha": displayCaptcha,
    "CustomProperties": customProperties.toJson(),
  };
}
