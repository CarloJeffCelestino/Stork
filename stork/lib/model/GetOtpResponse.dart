import 'package:nopcart_flutter/model/CustomProperties.dart';

class GetOtpResponse {
  GetOtpResponse({
    this.data,
    this.message,
    this.errorList,
  });

  GetOtpData data;
  String message;
  List<String> errorList;

  factory GetOtpResponse.fromJson(Map<String, dynamic> json) => GetOtpResponse(
    data: json["Data"] == null ? null : GetOtpData.fromJson(json["Data"]),
    message: json["Message"] == null ? null : json["Message"],
    errorList: json["ErrorList"] == null ? null : List<String>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : data.toJson(),
    "Message": message == null ? null : message,
    "ErrorList": errorList == null ? null : List<dynamic>.from(errorList.map((x) => x)),
  };
}

class GetOtpData {
  GetOtpData({
    this.phoneNumber,
    this.clientTransactionId,
    this.otpCode,
    this.referenceCode
  });

  String phoneNumber;
  String clientTransactionId;
  String otpCode;
  String referenceCode;

  factory GetOtpData.fromJson(Map<String, dynamic> json) => GetOtpData(
    phoneNumber: json["PhoneNumber"] == null ? null : json["PhoneNumber"],
    clientTransactionId: json["ClientTransactionId"] == null ? null : json["ClientTransactionId"],
    otpCode: json["OtpCode"] == null ? null : json["OtpCode"],
    referenceCode: json["ReferenceCode"] == null ? null : json["ReferenceCode"],
  );

  Map<String, dynamic> toJson() => {
    "PhoneNumber": phoneNumber == null ? null : phoneNumber,
    "ClientTransactionId": clientTransactionId == null ? null : clientTransactionId,
    "OtpCode": otpCode == null ? null : otpCode,
    "referenceCode": referenceCode == null ? null : referenceCode,
  };
}
