import 'package:nopcart_flutter/model/CustomProperties.dart';

class ContactVendorResponse {
  ContactVendorResponse({
    this.data,
    this.message,
    this.errorList,
  });

  ContactVendorData data;
  String message;
  List<String> errorList;

  factory ContactVendorResponse.fromJson(Map<String, dynamic> json) => ContactVendorResponse(
    data: json["Data"] == null ? null : ContactVendorData.fromJson(json["Data"]),
    message: json["Message"] == null ? null : json["Message"],
    errorList: json["ErrorList"] == null ? null : List<String>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : data.toJson(),
    "Message": message == null ? null : message,
    "ErrorList": errorList == null ? null : List<dynamic>.from(errorList.map((x) => x)),
  };
}

class ContactVendorData {
  ContactVendorData({
    this.vendorId,
    this.vendorName,
    this.email,
    this.subject,
    this.subjectEnabled,
    this.enquiry,
    this.fullName,
    this.successfullySent,
    this.result,
    this.displayCaptcha,
    this.customProperties,
  });

  int vendorId;
  String vendorName;
  String email;
  String subject;
  bool subjectEnabled;
  String enquiry;
  String fullName;
  bool successfullySent;
  dynamic result;
  bool displayCaptcha;
  CustomProperties customProperties;

  factory ContactVendorData.fromJson(Map<String, dynamic> json) => ContactVendorData(
    vendorId: json["VendorId"] == null ? null : json["VendorId"],
    vendorName: json["VendorName"] == null ? null : json["VendorName"],
    email: json["Email"] == null ? null : json["Email"],
    subject: json["Subject"] == null ? null : json["Subject"],
    subjectEnabled: json["SubjectEnabled"] == null ? null : json["SubjectEnabled"],
    enquiry: json["Enquiry"] == null ? null : json["Enquiry"],
    fullName: json["FullName"] == null ? null : json["FullName"],
    successfullySent: json["SuccessfullySent"] == null ? null : json["SuccessfullySent"],
    result: json["Result"],
    displayCaptcha: json["DisplayCaptcha"] == null ? null : json["DisplayCaptcha"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "VendorId": vendorId == null ? null : vendorId,
    "VendorName": vendorName == null ? null : vendorName,
    "Email": email == null ? null : email,
    "Subject": subject == null ? null : subject,
    "SubjectEnabled": subjectEnabled == null ? null : subjectEnabled,
    "Enquiry": enquiry == null ? null : enquiry,
    "FullName": fullName == null ? null : fullName,
    "SuccessfullySent": successfullySent == null ? null : successfullySent,
    "Result": result,
    "DisplayCaptcha": displayCaptcha == null ? null : displayCaptcha,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

