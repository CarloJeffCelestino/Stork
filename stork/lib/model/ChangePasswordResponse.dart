import 'package:nopcart_flutter/model/CustomProperties.dart';

class ChangePasswordResponse {
  ChangePasswordResponse({
    this.data,
    this.message,
    this.errorList,
  });

  ChangePasswordData data;
  String message;
  List<String> errorList;

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) => ChangePasswordResponse(
    data: json["Data"] == null ? null : ChangePasswordData.fromJson(json["Data"]),
    message: json["Message"] == null ? null : json["Message"],
    errorList: json["ErrorList"] == null ? null : List<String>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : data.toJson(),
    "Message": message == null ? null : message,
    "ErrorList": errorList == null ? null : List<dynamic>.from(errorList.map((x) => x)),
  };
}

class ChangePasswordData {
  ChangePasswordData({
    this.oldPassword,
    this.newPassword,
    this.confirmNewPassword,
    this.customProperties,
  });

  String oldPassword;
  String newPassword;
  String confirmNewPassword;
  CustomProperties customProperties;

  factory ChangePasswordData.fromJson(Map<String, dynamic> json) => ChangePasswordData(
    oldPassword: json["OldPassword"] == null ? null : json["OldPassword"],
    newPassword: json["NewPassword"] == null ? null : json["NewPassword"],
    confirmNewPassword: json["ConfirmNewPassword"] == null ? null : json["ConfirmNewPassword"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "OldPassword": oldPassword == null ? null : oldPassword,
    "NewPassword": newPassword == null ? null : newPassword,
    "ConfirmNewPassword": confirmNewPassword == null ? null : confirmNewPassword,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}
