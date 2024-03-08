import 'package:nopcart_flutter/model/CustomProperties.dart';

class ReturnRequestResponse {
  ReturnRequestResponse({
    this.data,
    this.message,
    this.errorList,
  });

  ReturnRequestData data;
  String message;
  List<String> errorList;

  factory ReturnRequestResponse.fromJson(Map<String, dynamic> json) => ReturnRequestResponse(
    data: json["Data"] == null ? null : ReturnRequestData.fromJson(json["Data"]),
    message: json["Message"] == null ? null : json["Message"],
    errorList: json["ErrorList"] == null ? null : List<String>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : data.toJson(),
    "Message": message == null ? null : message,
    "ErrorList": errorList == null ? null : List<dynamic>.from(errorList.map((x) => x)),
  };
}

class ReturnRequestData {
  ReturnRequestData({
    this.orderId,
    this.customOrderNumber,
    this.items,
    this.returnRequestReasonId,
    this.availableReturnReasons,
    this.returnRequestActionId,
    this.availableReturnActions,
    this.comments,
    this.allowFiles,
    this.uploadedFileGuid,
    this.result,
    this.customProperties,
  });

  int orderId;
  String customOrderNumber;
  List<ReturnRequestProduct> items;
  int returnRequestReasonId;
  List<AvailableReturn> availableReturnReasons;
  int returnRequestActionId;
  List<AvailableReturn> availableReturnActions;
  String comments;
  bool allowFiles;
  String uploadedFileGuid;
  String result;
  CustomProperties customProperties;

  factory ReturnRequestData.fromJson(Map<String, dynamic> json) => ReturnRequestData(
    orderId: json["OrderId"] == null ? null : json["OrderId"],
    customOrderNumber: json["CustomOrderNumber"] == null ? null : json["CustomOrderNumber"],
    items: json["Items"] == null ? null : List<ReturnRequestProduct>.from(json["Items"].map((x) => ReturnRequestProduct.fromJson(x))),
    returnRequestReasonId: json["ReturnRequestReasonId"] == null ? null : json["ReturnRequestReasonId"],
    availableReturnReasons: json["AvailableReturnReasons"] == null ? null : List<AvailableReturn>.from(json["AvailableReturnReasons"].map((x) => AvailableReturn.fromJson(x))),
    returnRequestActionId: json["ReturnRequestActionId"] == null ? null : json["ReturnRequestActionId"],
    availableReturnActions: json["AvailableReturnActions"] == null ? null : List<AvailableReturn>.from(json["AvailableReturnActions"].map((x) => AvailableReturn.fromJson(x))),
    comments: json["Comments"] == null ? null : json["Comments"],
    allowFiles: json["AllowFiles"] == null ? null : json["AllowFiles"],
    uploadedFileGuid: json["UploadedFileGuid"] == null ? null : json["UploadedFileGuid"],
    result: json["Result"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "OrderId": orderId == null ? null : orderId,
    "CustomOrderNumber": customOrderNumber == null ? null : customOrderNumber,
    "Items": items == null ? null : List<dynamic>.from(items.map((x) => x.toJson())),
    "ReturnRequestReasonId": returnRequestReasonId == null ? null : returnRequestReasonId,
    "AvailableReturnReasons": availableReturnReasons == null ? null : List<dynamic>.from(availableReturnReasons.map((x) => x.toJson())),
    "ReturnRequestActionId": returnRequestActionId == null ? null : returnRequestActionId,
    "AvailableReturnActions": availableReturnActions == null ? null : List<dynamic>.from(availableReturnActions.map((x) => x.toJson())),
    "Comments": comments == null ? null : comments,
    "AllowFiles": allowFiles == null ? null : allowFiles,
    "UploadedFileGuid": uploadedFileGuid == null ? null : uploadedFileGuid,
    "Result": result,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class AvailableReturn {
  AvailableReturn({
    this.name,
    this.id,
    this.customProperties,
  });

  String name;
  int id;
  CustomProperties customProperties;

  factory AvailableReturn.fromJson(Map<String, dynamic> json) => AvailableReturn(
    name: json["Name"] == null ? null : json["Name"],
    id: json["Id"] == null ? null : json["Id"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "Name": name == null ? null : name,
    "Id": id == null ? null : id,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class ReturnRequestProduct {
  ReturnRequestProduct({
    this.productId,
    this.productName,
    this.productSeName,
    this.attributeInfo,
    this.unitPrice,
    this.quantity,
    this.id,
    this.customProperties,
  });

  int productId;
  String productName;
  String productSeName;
  String attributeInfo;
  String unitPrice;
  int quantity;
  int id;
  CustomProperties customProperties;

  factory ReturnRequestProduct.fromJson(Map<String, dynamic> json) => ReturnRequestProduct(
    productId: json["ProductId"] == null ? null : json["ProductId"],
    productName: json["ProductName"] == null ? null : json["ProductName"],
    productSeName: json["ProductSeName"] == null ? null : json["ProductSeName"],
    attributeInfo: json["AttributeInfo"] == null ? null : json["AttributeInfo"],
    unitPrice: json["UnitPrice"] == null ? null : json["UnitPrice"],
    quantity: json["Quantity"] == null ? null : json["Quantity"],
    id: json["Id"] == null ? null : json["Id"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "ProductId": productId == null ? null : productId,
    "ProductName": productName == null ? null : productName,
    "ProductSeName": productSeName == null ? null : productSeName,
    "AttributeInfo": attributeInfo == null ? null : attributeInfo,
    "UnitPrice": unitPrice == null ? null : unitPrice,
    "Quantity": quantity == null ? null : quantity,
    "Id": id == null ? null : id,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}
