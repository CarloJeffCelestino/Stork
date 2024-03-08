import 'package:nopcart_flutter/model/CustomProperties.dart';
import 'package:nopcart_flutter/model/GetBillingAddressResponse.dart';

class AddressListResponse {
  AddressListResponse({
    this.data,
    this.message,
    this.errorList,
  });

  AddressListData data;
  String message;
  List<String> errorList;

  AddressListResponse copyWith({
    AddressListData data,
    String message,
    List<String> errorList,
  }) =>
      AddressListResponse(
        data: data ?? this.data,
        message: message ?? this.message,
        errorList: errorList ?? this.errorList,
      );

  factory AddressListResponse.fromJson(Map<String, dynamic> json) => AddressListResponse(
    data: json["Data"] == null ? null : AddressListData.fromJson(json["Data"]),
    message: json["Message"] == null ? null : json["Message"],
    errorList: json["ErrorList"] == null ? null : List<String>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : data.toJson(),
    "Message": message == null ? null : message,
    "ErrorList": errorList == null ? null : List<dynamic>.from(errorList.map((x) => x)),
  };
}

class AddressListData {
  AddressListData({
    this.addresses,
    this.customProperties,
  });

  List<Address> addresses;
  CustomProperties customProperties;

  AddressListData copyWith({
    List<Address> addresses,
    CustomProperties customProperties,
  }) =>
      AddressListData(
        addresses: addresses ?? this.addresses,
        customProperties: customProperties ?? this.customProperties,
      );

  factory AddressListData.fromJson(Map<String, dynamic> json) => AddressListData(
    addresses: json["Addresses"] == null ? null : List<Address>.from(json["Addresses"].map((x) => Address.fromJson(x))),
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "Addresses": addresses == null ? null : List<dynamic>.from(addresses.map((x) => x.toJson())),
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}


