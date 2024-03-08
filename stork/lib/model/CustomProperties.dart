import 'package:nopcart_flutter/model/GetBillingAddressResponse.dart';

class CustomProperties {

  CustomProperties({
      this.address,
      this.productMinMax,
      this.displayOrder,

      this.rewardPoints,

      // Authentication
      this.authenticationScheme,
      this.accessToken,
      this.idToken,
      this.externalIdentifier,
      this.externalDisplayIdentifier,
  });

  Address address;
  ProductMinMax productMinMax;
  int displayOrder;
  String authenticationScheme;
  num rewardPoints;
  String accessToken;
  String idToken;
  String externalIdentifier;
  String externalDisplayIdentifier;

  factory CustomProperties.fromJson(Map<String, dynamic> json) => CustomProperties(
    address: json["AddressModel"] == null ? null : Address.fromJson(json["AddressModel"]),
    productMinMax: json["ProductMinMaxModel"] == null ? null : ProductMinMax.fromJson(json["ProductMinMaxModel"]),
    rewardPoints: json["RewardPoints"] == null ? null : json["RewardPoints"],
    displayOrder: json["DisplayOrder"] == null ? null : json["DisplayOrder"],
    authenticationScheme: json["AuthenticationScheme"] == null ? null : json["AuthenticationScheme"],
    accessToken: json["AccessToken"] == null ? null : json["AccessToken"],
    idToken: json["IdToken"] == null ? null : json["IdToken"],
    externalIdentifier: json["ExternalIdentifier"] == null ? null : json["ExternalIdentifier"],
    externalDisplayIdentifier: json["ExternalDisplayIdentifier"] == null ? null : json["ExternalDisplayIdentifier"],
  );

  Map<String, dynamic> toJson() => {
    "AddressModel": address == null ? null : address.toJson(),
    "ProductMinMaxModel": productMinMax == null ? null : productMinMax.toJson(),
    "DisplayOrder": displayOrder == null ? null : displayOrder,
    "AuthenticationScheme": authenticationScheme == null ? null : authenticationScheme,
    "RewardPoints": rewardPoints == null ? null : rewardPoints,
    "AccessToken": accessToken == null ? null : accessToken,
    "IdToken": idToken == null ? null : idToken,
    "ExternalIdentifier": externalIdentifier == null ? null : externalIdentifier,
    "ExternalDisplayIdentifier": externalDisplayIdentifier == null ? null : externalDisplayIdentifier,
  };
}

class ProductMinMax {
  ProductMinMax({
    this.min,
    this.minValue,
    this.max,
    this.maxValue,
    this.maxRewardPoints,
    this.minRewardPoints,
  });

  String min;
  num minValue;
  String max;
  num maxValue;
  num maxRewardPoints;
  num minRewardPoints;

  factory ProductMinMax.fromJson(Map<String, dynamic> json) => ProductMinMax(
    min: json["Min"] == null ? null : json["Min"],
    minValue: json["MinValue"] == null ? null : json["MinValue"],
    max: json["Max"] == null ? null : json["Max"],
    maxValue: json["MaxValue"] == null ? null : json["MaxValue"],
    maxRewardPoints: json["MaxRewardPoints"] == null ? null : json["MaxRewardPoints"],
    minRewardPoints: json["MinRewardPoints"] == null ? null : json["MinRewardPoints"],
  );

  Map<String, dynamic> toJson() => {
    "Min": min == null ? null : min,
    "MinValue": minValue == null ? null : minValue,
    "Max": max == null ? null : max,
    "MaxValue": maxValue == null ? null : maxValue,
    "MaxRewardPoints": maxRewardPoints == null ? null : maxRewardPoints,
    "MinRewardPoints": minRewardPoints == null ? null : minRewardPoints,
  };
}