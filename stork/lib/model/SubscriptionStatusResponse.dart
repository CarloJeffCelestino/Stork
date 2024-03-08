import 'package:nopcart_flutter/model/CustomProperties.dart';

class SubscriptionStatusResponse {
  SubscriptionStatusResponse({
    this.data,
    this.message,
    this.errorList,
  });

  SubscriptionStatusResponseData data;
  String message;
  List<String> errorList;

  factory SubscriptionStatusResponse.fromJson(Map<String, dynamic> json) => SubscriptionStatusResponse(
    data: json["Data"] == null ? null : SubscriptionStatusResponseData.fromJson(json["Data"]),
    message: json["Message"] == null ? null : json["Message"],
    errorList: json["ErrorList"] == null ? null : List<String>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : data.toJson(),
    "Message": message == null ? null : message,
    "ErrorList": errorList == null ? null : List<dynamic>.from(errorList.map((x) => x)),
  };
}

class SubscriptionStatusResponseData {
  SubscriptionStatusResponseData({
    this.productId,
    this.productName,
    this.productSeName,
    this.isCurrentCustomerRegistered,
    this.subscriptionAllowed,
    this.alreadySubscribed,
    this.maximumBackInStockSubscriptions,
    this.currentNumberOfBackInStockSubscriptions,
    this.customProperties,
  });

  int productId;
  String productName;
  String productSeName;
  bool isCurrentCustomerRegistered;
  bool subscriptionAllowed;
  bool alreadySubscribed;
  int maximumBackInStockSubscriptions;
  int currentNumberOfBackInStockSubscriptions;
  CustomProperties customProperties;

  factory SubscriptionStatusResponseData.fromJson(Map<String, dynamic> json) => SubscriptionStatusResponseData(
    productId: json["ProductId"] == null ? null : json["ProductId"],
    productName: json["ProductName"] == null ? null : json["ProductName"],
    productSeName: json["ProductSeName"] == null ? null : json["ProductSeName"],
    isCurrentCustomerRegistered: json["IsCurrentCustomerRegistered"] == null ? null : json["IsCurrentCustomerRegistered"],
    subscriptionAllowed: json["SubscriptionAllowed"] == null ? null : json["SubscriptionAllowed"],
    alreadySubscribed: json["AlreadySubscribed"] == null ? null : json["AlreadySubscribed"],
    maximumBackInStockSubscriptions: json["MaximumBackInStockSubscriptions"] == null ? null : json["MaximumBackInStockSubscriptions"],
    currentNumberOfBackInStockSubscriptions: json["CurrentNumberOfBackInStockSubscriptions"] == null ? null : json["CurrentNumberOfBackInStockSubscriptions"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "ProductId": productId == null ? null : productId,
    "ProductName": productName == null ? null : productName,
    "ProductSeName": productSeName == null ? null : productSeName,
    "IsCurrentCustomerRegistered": isCurrentCustomerRegistered == null ? null : isCurrentCustomerRegistered,
    "SubscriptionAllowed": subscriptionAllowed == null ? null : subscriptionAllowed,
    "AlreadySubscribed": alreadySubscribed == null ? null : alreadySubscribed,
    "MaximumBackInStockSubscriptions": maximumBackInStockSubscriptions == null ? null : maximumBackInStockSubscriptions,
    "CurrentNumberOfBackInStockSubscriptions": currentNumberOfBackInStockSubscriptions == null ? null : currentNumberOfBackInStockSubscriptions,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}
