import 'package:nopcart_flutter/model/AvailableOption.dart';
import 'package:nopcart_flutter/model/CustomAttribute.dart';
import 'package:nopcart_flutter/model/CustomProperties.dart';

class GetBillingAddressResponse {
  GetBillingAddressResponse({
    this.data,
    this.message,
    this.errorList,
  });

  GetBillingData data;
  String message;
  List<String> errorList;

  factory GetBillingAddressResponse.fromJson(Map<String, dynamic> json) => GetBillingAddressResponse(
    data: json["Data"] == null ? null : GetBillingData.fromJson(json["Data"]),
    message: json["Message"] == null ? null : json["Message"],
    errorList: json["ErrorList"] == null ? null : List<String>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : data.toJson(),
    "Message": message == null ? null : message,
    "ErrorList": errorList == null ? null : List<dynamic>.from(errorList.map((x) => x)),
  };
}

class GetBillingData {
  GetBillingData({
    this.shippingRequired,
    this.disableBillingAddressCheckoutStep,
    this.billingAddress,
    this.customProperties,
  });

  bool shippingRequired;
  bool disableBillingAddressCheckoutStep;
  BillingAddress billingAddress;
  CustomProperties customProperties;

  factory GetBillingData.fromJson(Map<String, dynamic> json) => GetBillingData(
    shippingRequired: json["ShippingRequired"] == null ? null : json["ShippingRequired"],
    disableBillingAddressCheckoutStep: json["DisableBillingAddressCheckoutStep"] == null ? null : json["DisableBillingAddressCheckoutStep"],
    billingAddress: json["BillingAddress"] == null ? null : BillingAddress.fromJson(json["BillingAddress"]),
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "ShippingRequired": shippingRequired == null ? null : shippingRequired,
    "DisableBillingAddressCheckoutStep": disableBillingAddressCheckoutStep == null ? null : disableBillingAddressCheckoutStep,
    "BillingAddress": billingAddress == null ? null : billingAddress.toJson(),
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class BillingAddress {
  BillingAddress({
    this.existingAddresses,
    this.invalidExistingAddresses,
    this.billingNewAddress,
    this.shipToSameAddress,
    this.shipToSameAddressAllowed,
    this.newAddressPreselected,
    this.customProperties,
  });

  List<Address> existingAddresses;
  List<Address> invalidExistingAddresses;
  Address billingNewAddress;
  bool shipToSameAddress;
  bool shipToSameAddressAllowed;
  bool newAddressPreselected;
  CustomProperties customProperties;

  factory BillingAddress.fromJson(Map<String, dynamic> json) => BillingAddress(
    existingAddresses: json["ExistingAddresses"] == null ? null : List<Address>.from(json["ExistingAddresses"].map((x) => Address.fromJson(x))),
    invalidExistingAddresses: json["InvalidExistingAddresses"] == null ? null : List<Address>.from(json["InvalidExistingAddresses"].map((x) => Address.fromJson(x))),
    billingNewAddress: json["BillingNewAddress"] == null ? null : Address.fromJson(json["BillingNewAddress"]),
    shipToSameAddress: json["ShipToSameAddress"] == null ? null : json["ShipToSameAddress"],
    shipToSameAddressAllowed: json["ShipToSameAddressAllowed"] == null ? null : json["ShipToSameAddressAllowed"],
    newAddressPreselected: json["NewAddressPreselected"] == null ? null : json["NewAddressPreselected"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "ExistingAddresses": existingAddresses == null ? null : List<dynamic>.from(existingAddresses.map((x) => x.toJson())),
    "InvalidExistingAddresses": invalidExistingAddresses == null ? null : List<dynamic>.from(invalidExistingAddresses.map((x) => x)),
    "BillingNewAddress": billingNewAddress == null ? null : billingNewAddress.toJson(),
    "ShipToSameAddress": shipToSameAddress == null ? null : shipToSameAddress,
    "ShipToSameAddressAllowed": shipToSameAddressAllowed == null ? null : shipToSameAddressAllowed,
    "NewAddressPreselected": newAddressPreselected == null ? null : newAddressPreselected,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class Address {
  Address({
    this.firstName,
    this.lastName,
    this.email,
    this.companyEnabled,
    this.companyRequired,
    this.company,
    this.countryEnabled,
    this.countryId,
    this.countryName,
    this.stateProvinceEnabled,
    this.stateProvinceId,
    this.stateProvinceName,
    this.countyEnabled,
    this.countyRequired,
    this.county,
    this.cityEnabled,
    this.cityRequired,
    this.city,
    this.streetAddressEnabled,
    this.streetAddressRequired,
    this.address1,
    this.streetAddress2Enabled,
    this.streetAddress2Required,
    this.address2,
    this.zipPostalCodeEnabled,
    this.zipPostalCodeRequired,
    this.zipPostalCode,
    this.phoneEnabled,
    this.phoneRequired,
    this.phoneNumber,
    this.faxEnabled,
    this.faxRequired,
    this.faxNumber,
    this.availableCountries,
    this.availableStates,
    this.formattedCustomAddressAttributes,
    this.customAddressAttributes,
    this.id,
    this.customProperties,
  });

  String firstName;
  String lastName;
  String email;
  bool companyEnabled;
  bool companyRequired;
  String company;
  bool countryEnabled;
  int countryId;
  String countryName;
  bool stateProvinceEnabled;
  int stateProvinceId;
  String stateProvinceName;
  bool countyEnabled;
  bool countyRequired;
  String county;
  bool cityEnabled;
  bool cityRequired;
  String city;
  bool streetAddressEnabled;
  bool streetAddressRequired;
  String address1;
  bool streetAddress2Enabled;
  bool streetAddress2Required;
  String address2;
  bool zipPostalCodeEnabled;
  bool zipPostalCodeRequired;
  String zipPostalCode;
  bool phoneEnabled;
  bool phoneRequired;
  String phoneNumber;
  bool faxEnabled;
  bool faxRequired;
  String faxNumber;
  List<AvailableOption> availableCountries;
  List<AvailableOption> availableStates;
  String formattedCustomAddressAttributes;
  List<CustomAttribute> customAddressAttributes;
  int id;
  CustomProperties customProperties;

  Address copyWith({
    String firstName,
    String lastName,
    String email,
    bool companyEnabled,
    bool companyRequired,
    String company,
    bool countryEnabled,
    int countryId,
    String countryName,
    bool stateProvinceEnabled,
    int stateProvinceId,
    String stateProvinceName,
    bool countyEnabled,
    bool countyRequired,
    String county,
    bool cityEnabled,
    bool cityRequired,
    String city,
    bool streetAddressEnabled,
    bool streetAddressRequired,
    String address1,
    bool streetAddress2Enabled,
    bool streetAddress2Required,
    String address2,
    bool zipPostalCodeEnabled,
    bool zipPostalCodeRequired,
    String zipPostalCode,
    bool phoneEnabled,
    bool phoneRequired,
    String phoneNumber,
    bool faxEnabled,
    bool faxRequired,
    String faxNumber,
    List<AvailableOption> availableCountries,
    List<AvailableOption> availableStates,
    String formattedCustomAddressAttributes,
    List<CustomAttribute> customAddressAttributes,
    int id,
    CustomProperties customProperties,
  }) =>
      Address(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        companyEnabled: companyEnabled ?? this.companyEnabled,
        companyRequired: companyRequired ?? this.companyRequired,
        company: company ?? this.company,
        countryEnabled: countryEnabled ?? this.countryEnabled,
        countryId: countryId ?? this.countryId,
        countryName: countryName ?? this.countryName,
        stateProvinceEnabled: stateProvinceEnabled ?? this.stateProvinceEnabled,
        stateProvinceId: stateProvinceId ?? this.stateProvinceId,
        stateProvinceName: stateProvinceName ?? this.stateProvinceName,
        countyEnabled: countyEnabled ?? this.countyEnabled,
        countyRequired: countyRequired ?? this.countyRequired,
        county: county ?? this.county,
        cityEnabled: cityEnabled ?? this.cityEnabled,
        cityRequired: cityRequired ?? this.cityRequired,
        city: city ?? this.city,
        streetAddressEnabled: streetAddressEnabled ?? this.streetAddressEnabled,
        streetAddressRequired: streetAddressRequired ?? this.streetAddressRequired,
        address1: address1 ?? this.address1,
        streetAddress2Enabled: streetAddress2Enabled ?? this.streetAddress2Enabled,
        streetAddress2Required: streetAddress2Required ?? this.streetAddress2Required,
        address2: address2 ?? this.address2,
        zipPostalCodeEnabled: zipPostalCodeEnabled ?? this.zipPostalCodeEnabled,
        zipPostalCodeRequired: zipPostalCodeRequired ?? this.zipPostalCodeRequired,
        zipPostalCode: zipPostalCode ?? this.zipPostalCode,
        phoneEnabled: phoneEnabled ?? this.phoneEnabled,
        phoneRequired: phoneRequired ?? this.phoneRequired,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        faxEnabled: faxEnabled ?? this.faxEnabled,
        faxRequired: faxRequired ?? this.faxRequired,
        faxNumber: faxNumber ?? this.faxNumber,
        availableCountries: availableCountries ?? this.availableCountries,
        availableStates: availableStates ?? this.availableStates,
        formattedCustomAddressAttributes: formattedCustomAddressAttributes ?? this.formattedCustomAddressAttributes,
        customAddressAttributes: customAddressAttributes ?? this.customAddressAttributes,
        id: id ?? this.id,
        customProperties: customProperties ?? this.customProperties,
      );

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    firstName: json["FirstName"] == null ? null : json["FirstName"],
    lastName: json["LastName"] == null ? null : json["LastName"],
    email: json["Email"] == null ? null : json["Email"],
    companyEnabled: json["CompanyEnabled"] == null ? null : json["CompanyEnabled"],
    companyRequired: json["CompanyRequired"] == null ? null : json["CompanyRequired"],
    company: json["Company"] == null ? null : json["Company"],
    countryEnabled: json["CountryEnabled"] == null ? null : json["CountryEnabled"],
    countryId: json["CountryId"] == null ? null : json["CountryId"],
    countryName: json["CountryName"] == null ? null : json["CountryName"],
    stateProvinceEnabled: json["StateProvinceEnabled"] == null ? null : json["StateProvinceEnabled"],
    stateProvinceId: json["StateProvinceId"] == null ? null : json["StateProvinceId"],
    stateProvinceName: json["StateProvinceName"] == null ? null : json["StateProvinceName"],
    countyEnabled: json["CountyEnabled"] == null ? null : json["CountyEnabled"],
    countyRequired: json["CountyRequired"] == null ? null : json["CountyRequired"],
    county: json["County"],
    cityEnabled: json["CityEnabled"] == null ? null : json["CityEnabled"],
    cityRequired: json["CityRequired"] == null ? null : json["CityRequired"],
    city: json["City"] == null ? null : json["City"],
    streetAddressEnabled: json["StreetAddressEnabled"] == null ? null : json["StreetAddressEnabled"],
    streetAddressRequired: json["StreetAddressRequired"] == null ? null : json["StreetAddressRequired"],
    address1: json["Address1"] == null ? null : json["Address1"],
    streetAddress2Enabled: json["StreetAddress2Enabled"] == null ? null : json["StreetAddress2Enabled"],
    streetAddress2Required: json["StreetAddress2Required"] == null ? null : json["StreetAddress2Required"],
    address2: json["Address2"],
    zipPostalCodeEnabled: json["ZipPostalCodeEnabled"] == null ? null : json["ZipPostalCodeEnabled"],
    zipPostalCodeRequired: json["ZipPostalCodeRequired"] == null ? null : json["ZipPostalCodeRequired"],
    zipPostalCode: json["ZipPostalCode"] == null ? null : json["ZipPostalCode"],
    phoneEnabled: json["PhoneEnabled"] == null ? null : json["PhoneEnabled"],
    phoneRequired: json["PhoneRequired"] == null ? null : json["PhoneRequired"],
    phoneNumber: json["PhoneNumber"] == null ? null : json["PhoneNumber"],
    faxEnabled: json["FaxEnabled"] == null ? null : json["FaxEnabled"],
    faxRequired: json["FaxRequired"] == null ? null : json["FaxRequired"],
    faxNumber: json["FaxNumber"],
    availableCountries: json["AvailableCountries"] == null ? null : List<AvailableOption>.from(json["AvailableCountries"].map((x) => AvailableOption.fromJson(x))),
    availableStates: json["AvailableStates"] == null ? null : List<AvailableOption>.from(json["AvailableStates"].map((x) => AvailableOption.fromJson(x))),
    formattedCustomAddressAttributes: json["FormattedCustomAddressAttributes"] == null ? null : json["FormattedCustomAddressAttributes"],
    customAddressAttributes: json["CustomAddressAttributes"] == null ? null : List<CustomAttribute>.from(json["CustomAddressAttributes"].map((x) => CustomAttribute.fromJson(x))),
    id: json["Id"] == null ? null : json["Id"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "FirstName": firstName == null ? null : firstName,
    "LastName": lastName == null ? null : lastName,
    "Email": email == null ? null : email,
    "CompanyEnabled": companyEnabled == null ? null : companyEnabled,
    "CompanyRequired": companyRequired == null ? null : companyRequired,
    "Company": company == null ? null : company,
    "CountryEnabled": countryEnabled == null ? null : countryEnabled,
    "CountryId": countryId == null ? null : countryId,
    "CountryName": countryName == null ? null : countryName,
    "StateProvinceEnabled": stateProvinceEnabled == null ? null : stateProvinceEnabled,
    "StateProvinceId": stateProvinceId == null ? null : stateProvinceId,
    "StateProvinceName": stateProvinceName == null ? null : stateProvinceName,
    "CountyEnabled": countyEnabled == null ? null : countyEnabled,
    "CountyRequired": countyRequired == null ? null : countyRequired,
    "County": county,
    "CityEnabled": cityEnabled == null ? null : cityEnabled,
    "CityRequired": cityRequired == null ? null : cityRequired,
    "City": city == null ? null : city,
    "StreetAddressEnabled": streetAddressEnabled == null ? null : streetAddressEnabled,
    "StreetAddressRequired": streetAddressRequired == null ? null : streetAddressRequired,
    "Address1": address1 == null ? null : address1,
    "StreetAddress2Enabled": streetAddress2Enabled == null ? null : streetAddress2Enabled,
    "StreetAddress2Required": streetAddress2Required == null ? null : streetAddress2Required,
    "Address2": address2,
    "ZipPostalCodeEnabled": zipPostalCodeEnabled == null ? null : zipPostalCodeEnabled,
    "ZipPostalCodeRequired": zipPostalCodeRequired == null ? null : zipPostalCodeRequired,
    "ZipPostalCode": zipPostalCode == null ? null : zipPostalCode,
    "PhoneEnabled": phoneEnabled == null ? null : phoneEnabled,
    "PhoneRequired": phoneRequired == null ? null : phoneRequired,
    "PhoneNumber": phoneNumber == null ? null : phoneNumber,
    "FaxEnabled": faxEnabled == null ? null : faxEnabled,
    "FaxRequired": faxRequired == null ? null : faxRequired,
    "FaxNumber": faxNumber,
    "AvailableCountries": availableCountries == null ? null : List<dynamic>.from(availableCountries.map((x) => x)),
    "AvailableStates": availableStates == null ? null : List<dynamic>.from(availableStates.map((x) => x)),
    "FormattedCustomAddressAttributes": formattedCustomAddressAttributes == null ? null : formattedCustomAddressAttributes,
    "CustomAddressAttributes": customAddressAttributes == null ? null : List<dynamic>.from(customAddressAttributes.map((x) => x)),
    "Id": id == null ? null : id,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };

  @override
  String toString() {
    return "$firstName $lastName";
  }
}
