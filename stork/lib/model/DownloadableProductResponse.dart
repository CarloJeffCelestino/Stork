import 'package:nopcart_flutter/model/CustomProperties.dart';

class DownloadableProductResponse {
  DownloadableProductResponse({
    this.data,
    this.message,
    this.errorList,
  });

  DownloadableProductData data;
  String message;
  List<String> errorList;

  DownloadableProductResponse copyWith({
    DownloadableProductData data,
    String message,
    List<String> errorList,
  }) =>
      DownloadableProductResponse(
        data: data ?? this.data,
        message: message ?? this.message,
        errorList: errorList ?? this.errorList,
      );

  factory DownloadableProductResponse.fromJson(Map<String, dynamic> json) => DownloadableProductResponse(
    data: json["Data"] == null ? null : DownloadableProductData.fromJson(json["Data"]),
    message: json["Message"] == null ? null : json["Message"],
    errorList: json["ErrorList"] == null ? null : List<String>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : data.toJson(),
    "Message": message == null ? null : message,
    "ErrorList": errorList == null ? null : List<dynamic>.from(errorList.map((x) => x)),
  };
}

class DownloadableProductData {
  DownloadableProductData({
    this.items,
    this.customProperties,
  });

  List<DownloadableProductItem> items;
  CustomProperties customProperties;

  DownloadableProductData copyWith({
    List<DownloadableProductItem> items,
    CustomProperties customProperties,
  }) =>
      DownloadableProductData(
        items: items ?? this.items,
        customProperties: customProperties ?? this.customProperties,
      );

  factory DownloadableProductData.fromJson(Map<String, dynamic> json) => DownloadableProductData(
    items: json["Items"] == null ? null : List<DownloadableProductItem>.from(json["Items"].map((x) => DownloadableProductItem.fromJson(x))),
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "Items": items == null ? null : List<dynamic>.from(items.map((x) => x.toJson())),
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class DownloadableProductItem {
  DownloadableProductItem({
    this.orderItemGuid,
    this.orderId,
    this.customOrderNumber,
    this.productId,
    this.productName,
    this.productSeName,
    this.productAttributes,
    this.downloadId,
    this.licenseId,
    this.createdOn,
    this.customProperties,
  });

  String orderItemGuid;
  int orderId;
  String customOrderNumber;
  int productId;
  String productName;
  String productSeName;
  String productAttributes;
  int downloadId;
  int licenseId;
  DateTime createdOn;
  CustomProperties customProperties;

  DownloadableProductItem copyWith({
    String orderItemGuid,
    int orderId,
    String customOrderNumber,
    int productId,
    String productName,
    String productSeName,
    String productAttributes,
    int downloadId,
    int licenseId,
    DateTime createdOn,
    CustomProperties customProperties,
  }) =>
      DownloadableProductItem(
        orderItemGuid: orderItemGuid ?? this.orderItemGuid,
        orderId: orderId ?? this.orderId,
        customOrderNumber: customOrderNumber ?? this.customOrderNumber,
        productId: productId ?? this.productId,
        productName: productName ?? this.productName,
        productSeName: productSeName ?? this.productSeName,
        productAttributes: productAttributes ?? this.productAttributes,
        downloadId: downloadId ?? this.downloadId,
        licenseId: licenseId ?? this.licenseId,
        createdOn: createdOn ?? this.createdOn,
        customProperties: customProperties ?? this.customProperties,
      );

  factory DownloadableProductItem.fromJson(Map<String, dynamic> json) => DownloadableProductItem(
    orderItemGuid: json["OrderItemGuid"] == null ? null : json["OrderItemGuid"],
    orderId: json["OrderId"] == null ? null : json["OrderId"],
    customOrderNumber: json["CustomOrderNumber"] == null ? null : json["CustomOrderNumber"],
    productId: json["ProductId"] == null ? null : json["ProductId"],
    productName: json["ProductName"] == null ? null : json["ProductName"],
    productSeName: json["ProductSeName"] == null ? null : json["ProductSeName"],
    productAttributes: json["ProductAttributes"] == null ? null : json["ProductAttributes"],
    downloadId: json["DownloadId"] == null ? null : json["DownloadId"],
    licenseId: json["LicenseId"] == null ? null : json["LicenseId"],
    createdOn: json["CreatedOn"] == null ? null : DateTime.parse(json["CreatedOn"]),
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "OrderItemGuid": orderItemGuid == null ? null : orderItemGuid,
    "OrderId": orderId == null ? null : orderId,
    "CustomOrderNumber": customOrderNumber == null ? null : customOrderNumber,
    "ProductId": productId == null ? null : productId,
    "ProductName": productName == null ? null : productName,
    "ProductSeName": productSeName == null ? null : productSeName,
    "ProductAttributes": productAttributes == null ? null : productAttributes,
    "DownloadId": downloadId == null ? null : downloadId,
    "LicenseId": licenseId == null ? null : licenseId,
    "CreatedOn": createdOn == null ? null : createdOn.toIso8601String(),
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}
