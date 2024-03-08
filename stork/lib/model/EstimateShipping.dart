import 'package:nopcart_flutter/model/AvailableOption.dart';
import 'package:nopcart_flutter/model/CustomProperties.dart';

class EstimateShipping {
  EstimateShipping({
    this.productId,
    this.requestDelay,
    this.enabled,
    this.countryId,
    this.stateProvinceId,
    this.zipPostalCode,
    this.useCity,
    this.city,
    this.availableCountries,
    this.availableStates,
    this.customProperties,
  });

  num productId;
  int requestDelay;
  bool enabled;
  int countryId;
  int stateProvinceId;
  String zipPostalCode;
  bool useCity;
  String city;
  List<AvailableOption> availableCountries;
  List<AvailableOption> availableStates;
  CustomProperties customProperties;

  EstimateShipping copyWith({
    num productId,
    int requestDelay,
    bool enabled,
    int countryId,
    int stateProvinceId,
    String zipPostalCode,
    bool useCity,
    String city,
    List<AvailableOption> availableCountries,
    List<AvailableOption> availableStates,
    CustomProperties customProperties,
  }) =>
      EstimateShipping(
        productId: productId ?? this.productId,
        requestDelay: requestDelay ?? this.requestDelay,
        enabled: enabled ?? this.enabled,
        countryId: countryId ?? this.countryId,
        stateProvinceId: stateProvinceId ?? this.stateProvinceId,
        zipPostalCode: zipPostalCode ?? this.zipPostalCode,
        useCity: useCity ?? this.useCity,
        city: city ?? this.city,
        availableCountries: availableCountries ?? this.availableCountries,
        availableStates: availableStates ?? this.availableStates,
        customProperties: customProperties ?? this.customProperties,
      );

  factory EstimateShipping.fromJson(Map<String, dynamic> json) => EstimateShipping(
    productId: json["ProductId"] == null ? null : json["ProductId"],
    requestDelay: json["RequestDelay"] == null ? null : json["RequestDelay"],
    enabled: json["Enabled"] == null ? null : json["Enabled"],
    countryId: json["CountryId"],
    stateProvinceId: json["StateProvinceId"],
    zipPostalCode: json["ZipPostalCode"],
    useCity: json["UseCity"] == null ? null : json["UseCity"],
    city: json["City"] == null ? null : json["City"],
    availableCountries: json["AvailableCountries"] == null ? null : List<AvailableOption>.from(json["AvailableCountries"].map((x) => AvailableOption.fromJson(x))),
    availableStates: json["AvailableStates"] == null ? null : List<AvailableOption>.from(json["AvailableStates"].map((x) => AvailableOption.fromJson(x))),
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "ProductId": productId == null ? null : productId,
    "RequestDelay": requestDelay == null ? null : requestDelay,
    "Enabled": enabled == null ? null : enabled,
    "CountryId": countryId,
    "StateProvinceId": stateProvinceId,
    "ZipPostalCode": zipPostalCode,
    "UseCity": useCity == null ? null : useCity,
    "City": city == null ? null : city,
    "AvailableCountries": availableCountries == null ? null : List<dynamic>.from(availableCountries.map((x) => x.toJson())),
    "AvailableStates": availableStates == null ? null : List<dynamic>.from(availableStates.map((x) => x.toJson())),
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}