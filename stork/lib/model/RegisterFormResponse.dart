import 'package:nopcart_flutter/model/AvailableOption.dart';
import 'package:nopcart_flutter/model/CustomAttribute.dart';
import 'package:nopcart_flutter/model/CustomProperties.dart';
import 'package:nopcart_flutter/model/UserLoginResponse.dart';

class RegisterFormResponse {
  RegisterFormResponse({
    this.data,
    this.message,
    this.errorList,
  });

  RegisterFormData data;
  String message;
  List<String> errorList;

  factory RegisterFormResponse.fromJson(Map<String, dynamic> json) => RegisterFormResponse(
    data: RegisterFormData.fromJson(json["Data"]),
    message: json["Message"],
    errorList: List<String>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Data": data.toJson(),
    "Message": message,
    "ErrorList": List<String>.from(errorList.map((x) => x)),
  };
}

class RegisterFormData {
  RegisterFormData({
    this.email,
    this.enteringEmailTwice,
    this.confirmEmail,
    this.usernamesEnabled,
    this.username,
    this.checkUsernameAvailabilityEnabled,
    this.password,
    this.confirmPassword,
    this.genderEnabled,
    this.gender,
    this.firstNameEnabled,
    this.firstName,
    this.firstNameRequired,
    this.lastNameEnabled,
    this.lastName,
    this.lastNameRequired,
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
    this.acceptPrivacyPolicyEnabled,
    this.acceptPrivacyPolicyPopup,
    this.timeZoneId,
    this.allowCustomersToSetTimeZone,
    this.availableTimeZones,
    this.vatNumber,
    this.displayVatNumber,
    this.honeypotEnabled,
    this.displayCaptcha,
    this.customerAttributes,
    this.gdprConsents,
    this.customProperties,
  });

  String email;
  bool enteringEmailTwice;
  String confirmEmail;
  bool usernamesEnabled;
  String username;
  bool checkUsernameAvailabilityEnabled;
  String password;
  String confirmPassword;
  bool genderEnabled;
  String gender;
  bool firstNameEnabled;
  String firstName;
  bool firstNameRequired;
  bool lastNameEnabled;
  String lastName;
  bool lastNameRequired;
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
  String streetAddress2;
  bool zipPostalCodeEnabled;
  bool zipPostalCodeRequired;
  String zipPostalCode;
  bool cityEnabled;
  bool cityRequired;
  String city;
  bool countyEnabled;
  bool countyRequired;
  String county;
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
  String fax;
  bool newsletterEnabled;
  bool newsletter;
  bool acceptPrivacyPolicyEnabled;
  bool acceptPrivacyPolicyPopup;
  num timeZoneId;
  bool allowCustomersToSetTimeZone;
  List<AvailableOption> availableTimeZones;
  String vatNumber;
  bool displayVatNumber;
  bool honeypotEnabled;
  bool displayCaptcha;
  List<CustomAttribute> customerAttributes;
  List<GdprConsent> gdprConsents;
  CustomProperties customProperties;

  RegisterFormData copyWith({
    String email,
    bool enteringEmailTwice,
    String confirmEmail,
    bool usernamesEnabled,
    String username,
    bool checkUsernameAvailabilityEnabled,
    String password,
    String confirmPassword,
    bool genderEnabled,
    String gender,
    bool firstNameEnabled,
    String firstName,
    bool firstNameRequired,
    bool lastNameEnabled,
    String lastName,
    bool lastNameRequired,
    bool dateOfBirthEnabled,
    int dateOfBirthDay,
    int dateOfBirthMonth,
    int dateOfBirthYear,
    bool dateOfBirthRequired,
    bool companyEnabled,
    bool companyRequired,
    String company,
    bool streetAddressEnabled,
    bool streetAddressRequired,
    String streetAddress,
    bool streetAddress2Enabled,
    bool streetAddress2Required,
    String streetAddress2,
    bool zipPostalCodeEnabled,
    bool zipPostalCodeRequired,
    String zipPostalCode,
    bool cityEnabled,
    bool cityRequired,
    String city,
    bool countyEnabled,
    bool countyRequired,
    String county,
    bool countryEnabled,
    bool countryRequired,
    int countryId,
    List<AvailableOption> availableCountries,
    bool stateProvinceEnabled,
    bool stateProvinceRequired,
    int stateProvinceId,
    List<AvailableOption> availableStates,
    bool phoneEnabled,
    bool phoneRequired,
    String phone,
    bool faxEnabled,
    bool faxRequired,
    String fax,
    bool newsletterEnabled,
    bool newsletter,
    bool acceptPrivacyPolicyEnabled,
    bool acceptPrivacyPolicyPopup,
    num timeZoneId,
    bool allowCustomersToSetTimeZone,
    List<AvailableOption> availableTimeZones,
    String vatNumber,
    bool displayVatNumber,
    bool honeypotEnabled,
    bool displayCaptcha,
    List<CustomAttribute> customerAttributes,
    List<GdprConsent> gdprConsents,
    CustomProperties customProperties,
  }) =>
      RegisterFormData(
        email: email ?? this.email,
        enteringEmailTwice: enteringEmailTwice ?? this.enteringEmailTwice,
        confirmEmail: confirmEmail ?? this.confirmEmail,
        usernamesEnabled: usernamesEnabled ?? this.usernamesEnabled,
        username: username ?? this.username,
        checkUsernameAvailabilityEnabled: checkUsernameAvailabilityEnabled ?? this.checkUsernameAvailabilityEnabled,
        password: password ?? this.password,
        confirmPassword: confirmPassword ?? this.confirmPassword,
        genderEnabled: genderEnabled ?? this.genderEnabled,
        gender: gender ?? this.gender,
        firstNameEnabled: firstNameEnabled ?? this.firstNameEnabled,
        firstName: firstName ?? this.firstName,
        firstNameRequired: firstNameRequired ?? this.firstNameRequired,
        lastNameEnabled: lastNameEnabled ?? this.lastNameEnabled,
        lastName: lastName ?? this.lastName,
        lastNameRequired: lastNameRequired ?? this.lastNameRequired,
        dateOfBirthEnabled: dateOfBirthEnabled ?? this.dateOfBirthEnabled,
        dateOfBirthDay: dateOfBirthDay ?? this.dateOfBirthDay,
        dateOfBirthMonth: dateOfBirthMonth ?? this.dateOfBirthMonth,
        dateOfBirthYear: dateOfBirthYear ?? this.dateOfBirthYear,
        dateOfBirthRequired: dateOfBirthRequired ?? this.dateOfBirthRequired,
        companyEnabled: companyEnabled ?? this.companyEnabled,
        companyRequired: companyRequired ?? this.companyRequired,
        company: company ?? this.company,
        streetAddressEnabled: streetAddressEnabled ?? this.streetAddressEnabled,
        streetAddressRequired: streetAddressRequired ?? this.streetAddressRequired,
        streetAddress: streetAddress ?? this.streetAddress,
        streetAddress2Enabled: streetAddress2Enabled ?? this.streetAddress2Enabled,
        streetAddress2Required: streetAddress2Required ?? this.streetAddress2Required,
        streetAddress2: streetAddress2 ?? this.streetAddress2,
        zipPostalCodeEnabled: zipPostalCodeEnabled ?? this.zipPostalCodeEnabled,
        zipPostalCodeRequired: zipPostalCodeRequired ?? this.zipPostalCodeRequired,
        zipPostalCode: zipPostalCode ?? this.zipPostalCode,
        cityEnabled: cityEnabled ?? this.cityEnabled,
        cityRequired: cityRequired ?? this.cityRequired,
        city: city ?? this.city,
        countyEnabled: countyEnabled ?? this.countyEnabled,
        countyRequired: countyRequired ?? this.countyRequired,
        county: county ?? this.county,
        countryEnabled: countryEnabled ?? this.countryEnabled,
        countryRequired: countryRequired ?? this.countryRequired,
        countryId: countryId ?? this.countryId,
        availableCountries: availableCountries ?? this.availableCountries,
        stateProvinceEnabled: stateProvinceEnabled ?? this.stateProvinceEnabled,
        stateProvinceRequired: stateProvinceRequired ?? this.stateProvinceRequired,
        stateProvinceId: stateProvinceId ?? this.stateProvinceId,
        availableStates: availableStates ?? this.availableStates,
        phoneEnabled: phoneEnabled ?? this.phoneEnabled,
        phoneRequired: phoneRequired ?? this.phoneRequired,
        phone: phone ?? this.phone,
        faxEnabled: faxEnabled ?? this.faxEnabled,
        faxRequired: faxRequired ?? this.faxRequired,
        fax: fax ?? this.fax,
        newsletterEnabled: newsletterEnabled ?? this.newsletterEnabled,
        newsletter: newsletter ?? this.newsletter,
        acceptPrivacyPolicyEnabled: acceptPrivacyPolicyEnabled ?? this.acceptPrivacyPolicyEnabled,
        acceptPrivacyPolicyPopup: acceptPrivacyPolicyPopup ?? this.acceptPrivacyPolicyPopup,
        timeZoneId: timeZoneId ?? this.timeZoneId,
        allowCustomersToSetTimeZone: allowCustomersToSetTimeZone ?? this.allowCustomersToSetTimeZone,
        availableTimeZones: availableTimeZones ?? this.availableTimeZones,
        vatNumber: vatNumber ?? this.vatNumber,
        displayVatNumber: displayVatNumber ?? this.displayVatNumber,
        honeypotEnabled: honeypotEnabled ?? this.honeypotEnabled,
        displayCaptcha: displayCaptcha ?? this.displayCaptcha,
        customerAttributes: customerAttributes ?? this.customerAttributes,
        gdprConsents: gdprConsents ?? this.gdprConsents,
        customProperties: customProperties ?? this.customProperties,
      );

  factory RegisterFormData.fromJson(Map<String, dynamic> json) => RegisterFormData(
    email: json["Email"],
    enteringEmailTwice: json["EnteringEmailTwice"],
    confirmEmail: json["ConfirmEmail"],
    usernamesEnabled: json["UsernamesEnabled"],
    username: json["Username"],
    checkUsernameAvailabilityEnabled: json["CheckUsernameAvailabilityEnabled"],
    password: json["Password"],
    confirmPassword: json["ConfirmPassword"],
    genderEnabled: json["GenderEnabled"],
    gender: json["Gender"],
    firstNameEnabled: json["FirstNameEnabled"],
    firstName: json["FirstName"],
    firstNameRequired: json["FirstNameRequired"],
    lastNameEnabled: json["LastNameEnabled"],
    lastName: json["LastName"],
    lastNameRequired: json["LastNameRequired"],
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
    acceptPrivacyPolicyEnabled: json["AcceptPrivacyPolicyEnabled"],
    acceptPrivacyPolicyPopup: json["AcceptPrivacyPolicyPopup"],
    timeZoneId: json["TimeZoneId"],
    allowCustomersToSetTimeZone: json["AllowCustomersToSetTimeZone"],
    availableTimeZones: List<AvailableOption>.from(json["AvailableTimeZones"].map((x) => AvailableOption.fromJson(x))),
    vatNumber: json["VatNumber"],
    displayVatNumber: json["DisplayVatNumber"],
    honeypotEnabled: json["HoneypotEnabled"],
    displayCaptcha: json["DisplayCaptcha"],
    customerAttributes: json["CustomerAttributes"] == null ? null : List<CustomAttribute>.from(json["CustomerAttributes"].map((x) => CustomAttribute.fromJson(x))),
    gdprConsents: List<GdprConsent>.from(json["GdprConsents"].map((x) => GdprConsent.fromJson(x))),
    customProperties: CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "Email": email,
    "EnteringEmailTwice": enteringEmailTwice,
    "ConfirmEmail": confirmEmail,
    "UsernamesEnabled": usernamesEnabled,
    "Username": username,
    "CheckUsernameAvailabilityEnabled": checkUsernameAvailabilityEnabled,
    "Password": password,
    "ConfirmPassword": confirmPassword,
    "GenderEnabled": genderEnabled,
    "Gender": gender,
    "FirstNameEnabled": firstNameEnabled,
    "FirstName": firstName,
    "FirstNameRequired": firstNameRequired,
    "LastNameEnabled": lastNameEnabled,
    "LastName": lastName,
    "LastNameRequired": lastNameRequired,
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
    "AcceptPrivacyPolicyEnabled": acceptPrivacyPolicyEnabled,
    "AcceptPrivacyPolicyPopup": acceptPrivacyPolicyPopup,
    "TimeZoneId": timeZoneId,
    "AllowCustomersToSetTimeZone": allowCustomersToSetTimeZone,
    "AvailableTimeZones": List<dynamic>.from(availableTimeZones.map((x) => x.toJson())),
    "VatNumber": vatNumber,
    "DisplayVatNumber": displayVatNumber,
    "HoneypotEnabled": honeypotEnabled,
    "DisplayCaptcha": displayCaptcha,
    "CustomerAttributes": List<dynamic>.from(customerAttributes.map((x) => x.toJson())),
    "GdprConsents": List<dynamic>.from(gdprConsents.map((x) => x.toJson())),
    "CustomProperties": customProperties.toJson(),
  };
}
