import 'package:nopcart_flutter/model/AvailableOption.dart';
import 'package:nopcart_flutter/model/CustomProperties.dart';

class UserLoginResponse {
  UserLoginResponse({
    this.data,
    this.message,
    this.errorList,
  });

  UserLoginData data;
  String message;
  List<String> errorList;

  factory UserLoginResponse.fromJson(Map<String, dynamic> json) => UserLoginResponse(
    data: UserLoginData.fromJson(json["Data"]),
    message: json["Message"],
    errorList: List<String>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Data": data.toJson(),
    "Message": message,
    "ErrorList": List<dynamic>.from(errorList.map((x) => x)),
  };
}

class UserLoginData {
  UserLoginData({
    this.customerInfo,
    this.token,
  });

  CustomerInfo customerInfo;
  String token;

  factory UserLoginData.fromJson(Map<String, dynamic> json) => UserLoginData(
    customerInfo: CustomerInfo.fromJson(json["CustomerInfo"]),
    token: json["Token"],
  );

  Map<String, dynamic> toJson() => {
    "CustomerInfo": customerInfo.toJson(),
    "Token": token,
  };
}

class CustomerInfo {
  CustomerInfo({
    this.email,
    this.emailToRevalidate,
    this.checkUsernameAvailabilityEnabled,
    this.allowUsersToChangeUsernames,
    this.usernamesEnabled,
    this.username,
    this.genderEnabled,
    this.gender,
    this.firstName,
    this.lastName,
    this.dateOfBirthEnabled,
    this.dateOfBirthDay,
    this.dateOfBirthMonth,
    this.dateOfBirthYear,
    this.dateOfBirthRequired,
    this.companyEnabled,
    this.companyRequired,
    this.company,
    this.streetAddressEnabled,
    this.streetAddressRequired,
    this.streetAddress,
    this.streetAddress2Enabled,
    this.streetAddress2Required,
    this.streetAddress2,
    this.zipPostalCodeEnabled,
    this.zipPostalCodeRequired,
    this.zipPostalCode,
    this.cityEnabled,
    this.cityRequired,
    this.city,
    this.countyEnabled,
    this.countyRequired,
    this.county,
    this.countryEnabled,
    this.countryRequired,
    this.countryId,
    this.availableCountries,
    this.stateProvinceEnabled,
    this.stateProvinceRequired,
    this.stateProvinceId,
    this.availableStates,
    this.phoneEnabled,
    this.phoneRequired,
    this.phone,
    this.faxEnabled,
    this.faxRequired,
    this.fax,
    this.newsletterEnabled,
    this.newsletter,
    this.signatureEnabled,
    this.signature,
    this.timeZoneId,
    this.allowCustomersToSetTimeZone,
    this.availableTimeZones,
    this.vatNumber,
    this.vatNumberStatusNote,
    this.displayVatNumber,
    this.associatedExternalAuthRecords,
    this.numberOfExternalAuthenticationProviders,
    this.allowCustomersToRemoveAssociations,
    this.customerAttributes,
    this.gdprConsents,
    this.customProperties,
  });

  String email;
  dynamic emailToRevalidate;
  bool checkUsernameAvailabilityEnabled;
  bool allowUsersToChangeUsernames;
  bool usernamesEnabled;
  String username;
  bool genderEnabled;
  String gender;
  String firstName;
  String lastName;
  bool dateOfBirthEnabled;
  int dateOfBirthDay;
  int dateOfBirthMonth;
  int dateOfBirthYear;
  bool dateOfBirthRequired;
  bool companyEnabled;
  bool companyRequired;
  String company;
  bool streetAddressEnabled;
  bool streetAddressRequired;
  String streetAddress;
  bool streetAddress2Enabled;
  bool streetAddress2Required;
  dynamic streetAddress2;
  bool zipPostalCodeEnabled;
  bool zipPostalCodeRequired;
  dynamic zipPostalCode;
  bool cityEnabled;
  bool cityRequired;
  dynamic city;
  bool countyEnabled;
  bool countyRequired;
  dynamic county;
  bool countryEnabled;
  bool countryRequired;
  int countryId;
  List<AvailableOption> availableCountries;
  bool stateProvinceEnabled;
  bool stateProvinceRequired;
  int stateProvinceId;
  List<AvailableOption> availableStates;
  bool phoneEnabled;
  bool phoneRequired;
  String phone;
  bool faxEnabled;
  bool faxRequired;
  dynamic fax;
  bool newsletterEnabled;
  bool newsletter;
  bool signatureEnabled;
  dynamic signature;
  dynamic timeZoneId;
  bool allowCustomersToSetTimeZone;
  List<AvailableOption> availableTimeZones;
  dynamic vatNumber;
  String vatNumberStatusNote;
  bool displayVatNumber;
  List<dynamic> associatedExternalAuthRecords;
  int numberOfExternalAuthenticationProviders;
  bool allowCustomersToRemoveAssociations;
  List<CustomerAttribute> customerAttributes;
  List<GdprConsent> gdprConsents;
  CustomProperties customProperties;

  factory CustomerInfo.fromJson(Map<String, dynamic> json) => CustomerInfo(
    email: json["Email"],
    emailToRevalidate: json["EmailToRevalidate"],
    checkUsernameAvailabilityEnabled: json["CheckUsernameAvailabilityEnabled"],
    allowUsersToChangeUsernames: json["AllowUsersToChangeUsernames"],
    usernamesEnabled: json["UsernamesEnabled"],
    username: json["Username"],
    genderEnabled: json["GenderEnabled"],
    gender: json["Gender"],
    firstName: json["FirstName"],
    lastName: json["LastName"],
    dateOfBirthEnabled: json["DateOfBirthEnabled"],
    dateOfBirthDay: json["DateOfBirthDay"],
    dateOfBirthMonth: json["DateOfBirthMonth"],
    dateOfBirthYear: json["DateOfBirthYear"],
    dateOfBirthRequired: json["DateOfBirthRequired"],
    companyEnabled: json["CompanyEnabled"],
    companyRequired: json["CompanyRequired"],
    company: json["Company"],
    streetAddressEnabled: json["StreetAddressEnabled"],
    streetAddressRequired: json["StreetAddressRequired"],
    streetAddress: json["StreetAddress"],
    streetAddress2Enabled: json["StreetAddress2Enabled"],
    streetAddress2Required: json["StreetAddress2Required"],
    streetAddress2: json["StreetAddress2"],
    zipPostalCodeEnabled: json["ZipPostalCodeEnabled"],
    zipPostalCodeRequired: json["ZipPostalCodeRequired"],
    zipPostalCode: json["ZipPostalCode"],
    cityEnabled: json["CityEnabled"],
    cityRequired: json["CityRequired"],
    city: json["City"],
    countyEnabled: json["CountyEnabled"],
    countyRequired: json["CountyRequired"],
    county: json["County"],
    countryEnabled: json["CountryEnabled"],
    countryRequired: json["CountryRequired"],
    countryId: json["CountryId"],
    availableCountries: List<AvailableOption>.from(json["AvailableCountries"].map((x) => AvailableOption.fromJson(x))),
    stateProvinceEnabled: json["StateProvinceEnabled"],
    stateProvinceRequired: json["StateProvinceRequired"],
    stateProvinceId: json["StateProvinceId"],
    availableStates: List<AvailableOption>.from(json["AvailableStates"].map((x) => AvailableOption.fromJson(x))),
    phoneEnabled: json["PhoneEnabled"],
    phoneRequired: json["PhoneRequired"],
    phone: json["Phone"],
    faxEnabled: json["FaxEnabled"],
    faxRequired: json["FaxRequired"],
    fax: json["Fax"],
    newsletterEnabled: json["NewsletterEnabled"],
    newsletter: json["Newsletter"],
    signatureEnabled: json["SignatureEnabled"],
    signature: json["Signature"],
    timeZoneId: json["TimeZoneId"],
    allowCustomersToSetTimeZone: json["AllowCustomersToSetTimeZone"],
    availableTimeZones: List<AvailableOption>.from(json["AvailableTimeZones"].map((x) => AvailableOption.fromJson(x))),
    vatNumber: json["VatNumber"],
    vatNumberStatusNote: json["VatNumberStatusNote"],
    displayVatNumber: json["DisplayVatNumber"],
    associatedExternalAuthRecords: List<dynamic>.from(json["AssociatedExternalAuthRecords"].map((x) => x)),
    numberOfExternalAuthenticationProviders: json["NumberOfExternalAuthenticationProviders"],
    allowCustomersToRemoveAssociations: json["AllowCustomersToRemoveAssociations"],
    customerAttributes: List<CustomerAttribute>.from(json["CustomerAttributes"].map((x) => CustomerAttribute.fromJson(x))),
    gdprConsents: List<GdprConsent>.from(json["GdprConsents"].map((x) => GdprConsent.fromJson(x))),
    customProperties: CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "Email": email,
    "EmailToRevalidate": emailToRevalidate,
    "CheckUsernameAvailabilityEnabled": checkUsernameAvailabilityEnabled,
    "AllowUsersToChangeUsernames": allowUsersToChangeUsernames,
    "UsernamesEnabled": usernamesEnabled,
    "Username": username,
    "GenderEnabled": genderEnabled,
    "Gender": gender,
    "FirstName": firstName,
    "LastName": lastName,
    "DateOfBirthEnabled": dateOfBirthEnabled,
    "DateOfBirthDay": dateOfBirthDay,
    "DateOfBirthMonth": dateOfBirthMonth,
    "DateOfBirthYear": dateOfBirthYear,
    "DateOfBirthRequired": dateOfBirthRequired,
    "CompanyEnabled": companyEnabled,
    "CompanyRequired": companyRequired,
    "Company": company,
    "StreetAddressEnabled": streetAddressEnabled,
    "StreetAddressRequired": streetAddressRequired,
    "StreetAddress": streetAddress,
    "StreetAddress2Enabled": streetAddress2Enabled,
    "StreetAddress2Required": streetAddress2Required,
    "StreetAddress2": streetAddress2,
    "ZipPostalCodeEnabled": zipPostalCodeEnabled,
    "ZipPostalCodeRequired": zipPostalCodeRequired,
    "ZipPostalCode": zipPostalCode,
    "CityEnabled": cityEnabled,
    "CityRequired": cityRequired,
    "City": city,
    "CountyEnabled": countyEnabled,
    "CountyRequired": countyRequired,
    "County": county,
    "CountryEnabled": countryEnabled,
    "CountryRequired": countryRequired,
    "CountryId": countryId,
    "AvailableCountries": List<dynamic>.from(availableCountries.map((x) => x.toJson())),
    "StateProvinceEnabled": stateProvinceEnabled,
    "StateProvinceRequired": stateProvinceRequired,
    "StateProvinceId": stateProvinceId,
    "AvailableStates": List<dynamic>.from(availableStates.map((x) => x.toJson())),
    "PhoneEnabled": phoneEnabled,
    "PhoneRequired": phoneRequired,
    "Phone": phone,
    "FaxEnabled": faxEnabled,
    "FaxRequired": faxRequired,
    "Fax": fax,
    "NewsletterEnabled": newsletterEnabled,
    "Newsletter": newsletter,
    "SignatureEnabled": signatureEnabled,
    "Signature": signature,
    "TimeZoneId": timeZoneId,
    "AllowCustomersToSetTimeZone": allowCustomersToSetTimeZone,
    "AvailableTimeZones": List<dynamic>.from(availableTimeZones.map((x) => x.toJson())),
    "VatNumber": vatNumber,
    "VatNumberStatusNote": vatNumberStatusNote,
    "DisplayVatNumber": displayVatNumber,
    "AssociatedExternalAuthRecords": List<dynamic>.from(associatedExternalAuthRecords.map((x) => x)),
    "NumberOfExternalAuthenticationProviders": numberOfExternalAuthenticationProviders,
    "AllowCustomersToRemoveAssociations": allowCustomersToRemoveAssociations,
    "CustomerAttributes": List<dynamic>.from(customerAttributes.map((x) => x.toJson())),
    "GdprConsents": List<dynamic>.from(gdprConsents.map((x) => x.toJson())),
    "CustomProperties": customProperties.toJson(),
  };
}

class CustomerAttribute {
  CustomerAttribute({
    this.name,
    this.isRequired,
    this.defaultValue,
    this.attributeControlType,
    this.values,
    this.id,
    this.customProperties,
  });

  String name;
  bool isRequired;
  String defaultValue;
  int attributeControlType;
  List<dynamic> values;
  int id;
  CustomProperties customProperties;

  factory CustomerAttribute.fromJson(Map<String, dynamic> json) => CustomerAttribute(
    name: json["Name"],
    isRequired: json["IsRequired"],
    defaultValue: json["DefaultValue"],
    attributeControlType: json["AttributeControlType"],
    values: List<dynamic>.from(json["Values"].map((x) => x)),
    id: json["Id"],
    customProperties: CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "Name": name,
    "IsRequired": isRequired,
    "DefaultValue": defaultValue,
    "AttributeControlType": attributeControlType,
    "Values": List<dynamic>.from(values.map((x) => x)),
    "Id": id,
    "CustomProperties": customProperties.toJson(),
  };
}

class GdprConsent {
  GdprConsent({
    this.message,
    this.isRequired,
    this.requiredMessage,
    this.accepted,
    this.id,
    this.customProperties,
  });

  String message;
  bool isRequired;
  String requiredMessage;
  bool accepted;
  int id;
  CustomProperties customProperties;

  factory GdprConsent.fromJson(Map<String, dynamic> json) => GdprConsent(
    message: json["Message"],
    isRequired: json["IsRequired"],
    requiredMessage: json["RequiredMessage"],
    accepted: json["Accepted"],
    id: json["Id"],
    customProperties: CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "Message": message,
    "IsRequired": isRequired,
    "RequiredMessage": requiredMessage,
    "Accepted": accepted,
    "Id": id,
    "CustomProperties": customProperties.toJson(),
  };
}
