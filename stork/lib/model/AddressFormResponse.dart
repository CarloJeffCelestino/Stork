import 'package:nopcart_flutter/model/CustomProperties.dart';
import 'package:nopcart_flutter/model/GetBillingAddressResponse.dart';
import 'package:nopcart_flutter/model/requestbody/FormValue.dart';

class AddressFormResponse {
  AddressFormResponse({
    this.data,
    this.formValues,
    this.message,
    this.errorList,
  });

  AddressFormData data;
  String message;
  List<String> errorList;
  List<FormValue> formValues;

  AddressFormResponse copyWith({
    AddressFormData data,
    List<FormValue> formValues,
    String message,
    List<String> errorList,
  }) =>
      AddressFormResponse(
        data: data ?? this.data,
        formValues: formValues ?? this.formValues,
        message: message ?? this.message,
        errorList: errorList ?? this.errorList,
      );

  factory AddressFormResponse.fromJson(Map<String, dynamic> json) => AddressFormResponse(
    data: json["Data"] == null ? null : AddressFormData.fromJson(json["Data"]),
    formValues: json["FormValues"] == null ? null : List<FormValue>.from(json["FormValues"].map((x) => FormValue.fromJson(x))),
    message: json["Message"] == null ? null : json["Message"],
    errorList: json["ErrorList"] == null ? null : List<String>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : data.toJson(),
    "FormValues": formValues == null ? null : List<dynamic>.from(formValues.map((x) => x.toJson())),
    "Message": message == null ? null : message,
    "ErrorList": errorList == null ? null : List<dynamic>.from(errorList.map((x) => x)),
  };
}

class AddressFormData {
  AddressFormData({
    this.address,
    this.customProperties,
  });

  Address address;
  CustomProperties customProperties;

  AddressFormData copyWith({
    Address address,
    CustomProperties customProperties,
  }) =>
      AddressFormData(
        address: address ?? this.address,
        customProperties: customProperties ?? this.customProperties,
      );

  factory AddressFormData.fromJson(Map<String, dynamic> json) => AddressFormData(
    address: json["Address"] == null ? null : Address.fromJson(json["Address"]),
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "Address": address == null ? null : address.toJson(),
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}