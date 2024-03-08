import 'package:nopcart_flutter/model/CustomProperties.dart';
import 'package:nopcart_flutter/model/EstimateShipping.dart';
import 'package:nopcart_flutter/model/GetBillingAddressResponse.dart';
import 'package:nopcart_flutter/model/ShoppingCartResponse.dart';

class CheckoutPostResponse {
  CheckoutPostResponse({
    this.data,
    this.message,
    this.errorList,
  });

  CheckoutPostResponseData data;
  String message;
  List<String> errorList;

  factory CheckoutPostResponse.fromJson(Map<String, dynamic> json) => CheckoutPostResponse(
    data: json["Data"] == null ? null : CheckoutPostResponseData.fromJson(json["Data"]),
    message: json["Message"] == null ? null : json["Message"],
    errorList: json["ErrorList"] == null ? null : List<String>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : data.toJson(),
    "Message": message == null ? null : message,
    "ErrorList": errorList == null ? null : List<dynamic>.from(errorList.map((x) => x)),
  };
}

class CheckoutPostResponseData {
  CheckoutPostResponseData({
    this.nextStep,
    this.webGuid,
    this.customerId,
    this.billingAddressModel,
    this.shippingAddressModel,
    this.shippingMethodModel,
    this.paymentMethodModel,
    this.paymentInfoModel,
    this.confirmModel,
    this.completedModel,
  });

  int nextStep;
  String webGuid;
  int customerId;
  BillingAddress billingAddressModel;
  ShippingAddressModel shippingAddressModel;
  ShippingMethodModel shippingMethodModel;
  PaymentMethodModel paymentMethodModel;
  PaymentInfoModel paymentInfoModel;
  ConfirmModel confirmModel;
  CompletedModel completedModel;

  factory CheckoutPostResponseData.fromJson(Map<String, dynamic> json) => CheckoutPostResponseData(
    nextStep: json["NextStep"] == null ? null : json["NextStep"],
    webGuid: json["WebGuid"] == null ? null : json["WebGuid"],
    customerId: json["CustomerId"] == null ? null : json["CustomerId"],
    billingAddressModel: json["BillingAddressModel"] == null ? null : BillingAddress.fromJson(json["BillingAddressModel"]),
    shippingAddressModel: json["ShippingAddressModel"] == null ? null : ShippingAddressModel.fromJson(json["ShippingAddressModel"]),
    shippingMethodModel: json["ShippingMethodModel"] == null ? null : ShippingMethodModel.fromJson(json["ShippingMethodModel"]),
    paymentMethodModel: json["PaymentMethodModel"] == null ? null : PaymentMethodModel.fromJson(json["PaymentMethodModel"]),
    paymentInfoModel: json["PaymentInfoModel"] == null ? null : PaymentInfoModel.fromJson(json["PaymentInfoModel"]),
    confirmModel: json["ConfirmModel"] == null ? null : ConfirmModel.fromJson(json["ConfirmModel"]),
    completedModel: json["CompletedModel"] == null ? null : CompletedModel.fromJson(json["CompletedModel"]),
  );

  Map<String, dynamic> toJson() => {
    "NextStep": nextStep == null ? null : nextStep,
    "WebGuid": webGuid == null ? null : webGuid,
    "CustomerId": customerId == null ? null : customerId,
    "BillingAddressModel": billingAddressModel,
    "ShippingAddressModel": shippingAddressModel == null ? null : shippingAddressModel.toJson(),
    "ShippingMethodModel": shippingMethodModel == null ? null : shippingMethodModel.toJson(),
    "PaymentMethodModel": paymentMethodModel == null ? null : paymentMethodModel.toJson(),
    "PaymentInfoModel": paymentInfoModel == null ? null : paymentInfoModel.toJson(),
    "ConfirmModel": confirmModel == null ? null : confirmModel.toJson(),
    "CompletedModel": completedModel == null ? null : completedModel.toJson(),
  };
}

class CompletedModel {
  CompletedModel({
    this.orderId,
    this.customOrderNumber,
    this.onePageCheckoutEnabled,
    this.customProperties,
  });

  int orderId;
  String customOrderNumber;
  bool onePageCheckoutEnabled;
  CustomProperties customProperties;

  factory CompletedModel.fromJson(Map<String, dynamic> json) => CompletedModel(
    orderId: json["OrderId"] == null ? null : json["OrderId"],
    customOrderNumber: json["CustomOrderNumber"],
    onePageCheckoutEnabled: json["OnePageCheckoutEnabled"] == null ? null : json["OnePageCheckoutEnabled"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "OrderId": orderId == null ? null : orderId,
    "CustomOrderNumber": customOrderNumber,
    "OnePageCheckoutEnabled": onePageCheckoutEnabled == null ? null : onePageCheckoutEnabled,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class ConfirmModel {
  ConfirmModel({
    this.cart,
    this.orderTotals,
    this.confirm,
    this.selectedCheckoutAttributes,
    this.estimateShipping,
  });

  Cart cart;
  OrderTotals orderTotals;
  Confirm confirm;
  String selectedCheckoutAttributes;
  EstimateShipping estimateShipping;

  factory ConfirmModel.fromJson(Map<String, dynamic> json) => ConfirmModel(
    cart: json["Cart"] == null ? null : Cart.fromJson(json["Cart"]),
    orderTotals: json["OrderTotals"] == null ? null : OrderTotals.fromJson(json["OrderTotals"]),
    confirm: json["Confirm"] == null ? null : Confirm.fromJson(json["Confirm"]),
    selectedCheckoutAttributes: json["SelectedCheckoutAttributes"] == null ? null : json["SelectedCheckoutAttributes"],
    estimateShipping: json["EstimateShipping"] == null ? null : EstimateShipping.fromJson(json["EstimateShipping"]),
  );

  Map<String, dynamic> toJson() => {
    "Cart": cart == null ? null : cart.toJson(),
    "OrderTotals": orderTotals == null ? null : orderTotals.toJson(),
    "Confirm": confirm == null ? null : confirm.toJson(),
    "SelectedCheckoutAttributes": selectedCheckoutAttributes,
    "EstimateShipping": estimateShipping == null ? null : estimateShipping.toJson(),
  };
}



class OrderReviewData {
  OrderReviewData({
    this.display,
    this.billingAddress,
    this.isShippable,
    this.shippingAddress,
    this.selectedPickupInStore,
    this.pickupAddress,
    this.shippingMethod,
    this.paymentMethod,
    this.customValues,
    this.customProperties,
  });

  bool display;
  Address billingAddress;
  bool isShippable;
  Address shippingAddress;
  bool selectedPickupInStore;
  Address pickupAddress;
  dynamic shippingMethod;
  dynamic paymentMethod;
  dynamic customValues;
  CustomProperties customProperties;

  factory OrderReviewData.fromJson(Map<String, dynamic> json) => OrderReviewData(
    display: json["Display"] == null ? null : json["Display"],
    billingAddress: json["BillingAddress"] == null ? null : Address.fromJson(json["BillingAddress"]),
    isShippable: json["IsShippable"] == null ? null : json["IsShippable"],
    shippingAddress: json["ShippingAddress"] == null ? null : Address.fromJson(json["ShippingAddress"]),
    selectedPickupInStore: json["SelectedPickupInStore"] == null ? null : json["SelectedPickupInStore"],
    pickupAddress: json["PickupAddress"] == null ? null : Address.fromJson(json["PickupAddress"]),
    shippingMethod: json["ShippingMethod"],
    paymentMethod: json["PaymentMethod"],
    customValues: json["CustomValues"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "Display": display == null ? null : display,
    "BillingAddress": billingAddress == null ? null : billingAddress.toJson(),
    "IsShippable": isShippable == null ? null : isShippable,
    "ShippingAddress": shippingAddress == null ? null : shippingAddress.toJson(),
    "SelectedPickupInStore": selectedPickupInStore == null ? null : selectedPickupInStore,
    "PickupAddress": pickupAddress == null ? null : pickupAddress.toJson(),
    "ShippingMethod": shippingMethod,
    "PaymentMethod": paymentMethod,
    "CustomValues": customValues == null ? null : customValues.toJson(),
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}



class Confirm {
  Confirm({
    this.termsOfServiceOnOrderConfirmPage,
    this.termsOfServicePopup,
    this.minOrderTotalWarning,
    this.warnings,
    this.customProperties,
  });

  bool termsOfServiceOnOrderConfirmPage;
  bool termsOfServicePopup;
  dynamic minOrderTotalWarning;
  List<dynamic> warnings;
  CustomProperties customProperties;

  factory Confirm.fromJson(Map<String, dynamic> json) => Confirm(
    termsOfServiceOnOrderConfirmPage: json["TermsOfServiceOnOrderConfirmPage"] == null ? null : json["TermsOfServiceOnOrderConfirmPage"],
    termsOfServicePopup: json["TermsOfServicePopup"] == null ? null : json["TermsOfServicePopup"],
    minOrderTotalWarning: json["MinOrderTotalWarning"],
    warnings: json["Warnings"] == null ? null : List<dynamic>.from(json["Warnings"].map((x) => x)),
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "TermsOfServiceOnOrderConfirmPage": termsOfServiceOnOrderConfirmPage == null ? null : termsOfServiceOnOrderConfirmPage,
    "TermsOfServicePopup": termsOfServicePopup == null ? null : termsOfServicePopup,
    "MinOrderTotalWarning": minOrderTotalWarning,
    "Warnings": warnings == null ? null : List<dynamic>.from(warnings.map((x) => x)),
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class PaymentInfoModel {
  PaymentInfoModel({
    this.paymentViewComponentName,
    this.displayOrderTotals,
    this.customProperties,
  });

  dynamic paymentViewComponentName;
  bool displayOrderTotals;
  CustomProperties customProperties;

  factory PaymentInfoModel.fromJson(Map<String, dynamic> json) => PaymentInfoModel(
    paymentViewComponentName: json["PaymentViewComponentName"],
    displayOrderTotals: json["DisplayOrderTotals"] == null ? null : json["DisplayOrderTotals"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "PaymentViewComponentName": paymentViewComponentName,
    "DisplayOrderTotals": displayOrderTotals == null ? null : displayOrderTotals,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class PaymentMethodModel {
  PaymentMethodModel({
    this.paymentMethods,
    this.displayRewardPoints,
    this.rewardPointsBalance,
    this.rewardPointsAmount,
    this.rewardPointsEnoughToPayForOrder,
    this.useRewardPoints,
    this.customProperties,
  });

  List<PaymentMethod> paymentMethods;
  bool displayRewardPoints;
  int rewardPointsBalance;
  String rewardPointsAmount;
  bool rewardPointsEnoughToPayForOrder;
  bool useRewardPoints;
  CustomProperties customProperties;

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) => PaymentMethodModel(
    paymentMethods: json["PaymentMethods"] == null ? null : List<PaymentMethod>.from(json["PaymentMethods"].map((x) => PaymentMethod.fromJson(x))),
    displayRewardPoints: json["DisplayRewardPoints"] == null ? null : json["DisplayRewardPoints"],
    rewardPointsBalance: json["RewardPointsBalance"] == null ? null : json["RewardPointsBalance"],
    rewardPointsAmount: json["RewardPointsAmount"],
    rewardPointsEnoughToPayForOrder: json["RewardPointsEnoughToPayForOrder"] == null ? null : json["RewardPointsEnoughToPayForOrder"],
    useRewardPoints: json["UseRewardPoints"] == null ? null : json["UseRewardPoints"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "PaymentMethods": paymentMethods == null ? null : List<dynamic>.from(paymentMethods.map((x) => x.toJson())),
    "DisplayRewardPoints": displayRewardPoints == null ? null : displayRewardPoints,
    "RewardPointsBalance": rewardPointsBalance == null ? null : rewardPointsBalance,
    "RewardPointsAmount": rewardPointsAmount,
    "RewardPointsEnoughToPayForOrder": rewardPointsEnoughToPayForOrder == null ? null : rewardPointsEnoughToPayForOrder,
    "UseRewardPoints": useRewardPoints == null ? null : useRewardPoints,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class PaymentMethod {
  PaymentMethod({
    this.paymentMethodSystemName,
    this.name,
    this.description,
    this.fee,
    this.selected,
    this.logoUrl,
    this.customProperties,
  });

  String paymentMethodSystemName;
  String name;
  String description;
  String fee;
  bool selected;
  String logoUrl;
  CustomProperties customProperties;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
    paymentMethodSystemName: json["PaymentMethodSystemName"] == null ? null : json["PaymentMethodSystemName"],
    name: json["Name"] == null ? null : json["Name"],
    description: json["Description"] == null ? null : json["Description"],
    fee: json["Fee"] == null ? null : json["Fee"],
    selected: json["Selected"] == null ? null : json["Selected"],
    logoUrl: json["LogoUrl"] == null ? null : json["LogoUrl"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "PaymentMethodSystemName": paymentMethodSystemName == null ? null : paymentMethodSystemName,
    "Name": name == null ? null : name,
    "Description": description == null ? null : description,
    "Fee": fee == null ? null : fee,
    "Selected": selected == null ? null : selected,
    "LogoUrl": logoUrl == null ? null : logoUrl,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}


class ShippingAddressModel {
  ShippingAddressModel({
    this.existingAddresses,
    this.invalidExistingAddresses,
    this.shippingNewAddress,
    this.newAddressPreselected,
    this.displayPickupInStore,
    this.pickupPointsModel,
    this.customProperties,
  });

  List<Address> existingAddresses;
  List<Address> invalidExistingAddresses;
  Address shippingNewAddress;
  bool newAddressPreselected;
  bool displayPickupInStore;
  PickupPointsModel pickupPointsModel;
  CustomProperties customProperties;

  factory ShippingAddressModel.fromJson(Map<String, dynamic> json) => ShippingAddressModel(
    existingAddresses: json["ExistingAddresses"] == null ? null : List<Address>.from(json["ExistingAddresses"].map((x) => Address.fromJson(x))),
    invalidExistingAddresses: json["InvalidExistingAddresses"] == null ? null : List<Address>.from(json["InvalidExistingAddresses"].map((x) => Address.fromJson(x))),
    shippingNewAddress: json["ShippingNewAddress"] == null ? null : Address.fromJson(json["ShippingNewAddress"]),
    newAddressPreselected: json["NewAddressPreselected"] == null ? null : json["NewAddressPreselected"],
    displayPickupInStore: json["DisplayPickupInStore"] == null ? null : json["DisplayPickupInStore"],
    pickupPointsModel: json["PickupPointsModel"] == null ? null : PickupPointsModel.fromJson(json["PickupPointsModel"]),
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "ExistingAddresses": existingAddresses == null ? null : List<dynamic>.from(existingAddresses.map((x) => x.toJson())),
    "InvalidExistingAddresses": invalidExistingAddresses == null ? null : List<dynamic>.from(invalidExistingAddresses.map((x) => x)),
    "ShippingNewAddress": shippingNewAddress == null ? null : shippingNewAddress.toJson(),
    "NewAddressPreselected": newAddressPreselected == null ? null : newAddressPreselected,
    "DisplayPickupInStore": displayPickupInStore == null ? null : displayPickupInStore,
    "PickupPointsModel": pickupPointsModel == null ? null : pickupPointsModel.toJson(),
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class PickupPointsModel {
  PickupPointsModel({
    this.warnings,
    this.pickupPoints,
    this.allowPickupInStore,
    this.pickupInStore,
    this.pickupInStoreOnly,
    this.displayPickupPointsOnMap,
    this.googleMapsApiKey,
    this.customProperties,
  });

  List<String> warnings;
  List<PickupPoint> pickupPoints;
  bool allowPickupInStore;
  bool pickupInStore;
  bool pickupInStoreOnly;
  bool displayPickupPointsOnMap;
  String googleMapsApiKey;
  CustomProperties customProperties;

  factory PickupPointsModel.fromJson(Map<String, dynamic> json) => PickupPointsModel(
    warnings: json["Warnings"] == null ? null : List<String>.from(json["Warnings"].map((x) => x)),
    pickupPoints: json["PickupPoints"] == null ? null : List<PickupPoint>.from(json["PickupPoints"].map((x) => PickupPoint.fromJson(x))),
    allowPickupInStore: json["AllowPickupInStore"] == null ? null : json["AllowPickupInStore"],
    pickupInStore: json["PickupInStore"] == null ? null : json["PickupInStore"],
    pickupInStoreOnly: json["PickupInStoreOnly"] == null ? null : json["PickupInStoreOnly"],
    displayPickupPointsOnMap: json["DisplayPickupPointsOnMap"] == null ? null : json["DisplayPickupPointsOnMap"],
    googleMapsApiKey: json["GoogleMapsApiKey"] == null ? null : json["GoogleMapsApiKey"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "Warnings": warnings == null ? null : List<dynamic>.from(warnings.map((x) => x)),
    "PickupPoints": pickupPoints == null ? null : List<dynamic>.from(pickupPoints.map((x) => x.toJson())),
    "AllowPickupInStore": allowPickupInStore == null ? null : allowPickupInStore,
    "PickupInStore": pickupInStore == null ? null : pickupInStore,
    "PickupInStoreOnly": pickupInStoreOnly == null ? null : pickupInStoreOnly,
    "DisplayPickupPointsOnMap": displayPickupPointsOnMap == null ? null : displayPickupPointsOnMap,
    "GoogleMapsApiKey": googleMapsApiKey == null ? null : googleMapsApiKey,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class PickupPoint {
  PickupPoint({
    this.id,
    this.name,
    this.description,
    this.providerSystemName,
    this.address,
    this.city,
    this.county,
    this.stateName,
    this.countryName,
    this.zipPostalCode,
    this.latitude,
    this.longitude,
    this.pickupFee,
    this.openingHours,
    this.customProperties,
  });

  String id;
  String name;
  String description;
  String providerSystemName;
  String address;
  String city;
  String county;
  String stateName;
  String countryName;
  String zipPostalCode;
  num latitude;
  num longitude;
  String pickupFee;
  String openingHours;
  CustomProperties customProperties;

  factory PickupPoint.fromJson(Map<String, dynamic> json) => PickupPoint(
    id: json["Id"] == null ? null : json["Id"],
    name: json["Name"] == null ? null : json["Name"],
    description: json["Description"],
    providerSystemName: json["ProviderSystemName"] == null ? null : json["ProviderSystemName"],
    address: json["Address"] == null ? null : json["Address"],
    city: json["City"] == null ? null : json["City"],
    county: json["County"] == null ? null : json["County"],
    stateName: json["StateName"] == null ? null : json["StateName"],
    countryName: json["CountryName"] == null ? null : json["CountryName"],
    zipPostalCode: json["ZipPostalCode"] == null ? null : json["ZipPostalCode"],
    latitude: json["Latitude"] == null ? null : json["Latitude"],
    longitude: json["Longitude"] == null ? null : json["Longitude"],
    pickupFee: json["PickupFee"] == null ? null : json["PickupFee"],
    openingHours: json["OpeningHours"] == null ? null : json["OpeningHours"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "Id": id == null ? null : id,
    "Name": name == null ? null : name,
    "Description": description,
    "ProviderSystemName": providerSystemName == null ? null : providerSystemName,
    "Address": address == null ? null : address,
    "City": city == null ? null : city,
    "County": county,
    "StateName": stateName == null ? null : stateName,
    "CountryName": countryName == null ? null : countryName,
    "ZipPostalCode": zipPostalCode == null ? null : zipPostalCode,
    "Latitude": latitude,
    "Longitude": longitude,
    "PickupFee": pickupFee == null ? null : pickupFee,
    "OpeningHours": openingHours == null ? null : openingHours,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class ShippingMethodModel {
  ShippingMethodModel({
    this.shippingMethods,
    this.notifyCustomerAboutShippingFromMultipleLocations,
    this.warnings,
    this.displayPickupInStore,
    this.pickupPointsModel,
    this.customProperties,
  });

  List<ShippingMethod> shippingMethods;
  bool notifyCustomerAboutShippingFromMultipleLocations;
  List<String> warnings;
  bool displayPickupInStore;
  dynamic pickupPointsModel;
  CustomProperties customProperties;

  factory ShippingMethodModel.fromJson(Map<String, dynamic> json) => ShippingMethodModel(
    shippingMethods: json["ShippingMethods"] == null ? null : List<ShippingMethod>.from(json["ShippingMethods"].map((x) => ShippingMethod.fromJson(x))),
    notifyCustomerAboutShippingFromMultipleLocations: json["NotifyCustomerAboutShippingFromMultipleLocations"] == null ? null : json["NotifyCustomerAboutShippingFromMultipleLocations"],
    warnings: json["Warnings"] == null ? null : List<String>.from(json["Warnings"].map((x) => x)),
    displayPickupInStore: json["DisplayPickupInStore"] == null ? null : json["DisplayPickupInStore"],
    pickupPointsModel: json["PickupPointsModel"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "ShippingMethods": shippingMethods == null ? null : List<dynamic>.from(shippingMethods.map((x) => x.toJson())),
    "NotifyCustomerAboutShippingFromMultipleLocations": notifyCustomerAboutShippingFromMultipleLocations == null ? null : notifyCustomerAboutShippingFromMultipleLocations,
    "Warnings": warnings == null ? null : List<dynamic>.from(warnings.map((x) => x)),
    "DisplayPickupInStore": displayPickupInStore == null ? null : displayPickupInStore,
    "PickupPointsModel": pickupPointsModel,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class ShippingMethod {
  ShippingMethod({
    this.shippingRateComputationMethodSystemName,
    this.name,
    this.description,
    this.fee,
    this.selected,
    this.shippingOption,
    this.customProperties,
  });

  String shippingRateComputationMethodSystemName;
  String name;
  String description;
  String fee;
  bool selected;
  String shippingOption;
  CustomProperties customProperties;

  factory ShippingMethod.fromJson(Map<String, dynamic> json) => ShippingMethod(
    shippingRateComputationMethodSystemName: json["ShippingRateComputationMethodSystemName"] == null ? null : json["ShippingRateComputationMethodSystemName"],
    name: json["Name"] == null ? null : json["Name"],
    description: json["Description"] == null ? null : json["Description"],
    fee: json["Fee"] == null ? null : json["Fee"],
    selected: json["Selected"] == null ? null : json["Selected"],
    shippingOption: json["ShippingOption"] == null ? null : json["ShippingOption"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "ShippingRateComputationMethodSystemName": shippingRateComputationMethodSystemName == null ? null : shippingRateComputationMethodSystemName,
    "Name": name == null ? null : name,
    "Description": description == null ? null : description,
    "Fee": fee == null ? null : fee,
    "Selected": selected == null ? null : selected,
    "ShippingOption": shippingOption == null ? null : shippingOption,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

