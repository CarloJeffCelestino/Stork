import 'package:nopcart_flutter/model/CustomProperties.dart';

class ReturnReqHistoryResponse {
  ReturnReqHistoryResponse({
    this.data,
    this.message,
    this.errorList,
  });

  ReturnReqHistoryData data;
  String message;
  List<String> errorList;

  factory ReturnReqHistoryResponse.fromJson(Map<String, dynamic> json) => ReturnReqHistoryResponse(
    data: json["Data"] == null ? null : ReturnReqHistoryData.fromJson(json["Data"]),
    message: json["Message"] == null ? null : json["Message"],
    errorList: json["ErrorList"] == null ? null : List<String>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : data.toJson(),
    "Message": message == null ? null : message,
    "ErrorList": errorList == null ? null : List<dynamic>.from(errorList.map((x) => x)),
  };
}

class ReturnReqHistoryData {
  ReturnReqHistoryData({
    this.items,
    this.customProperties,
  });

  List<ReturnReqHistoryItem> items;
  CustomProperties customProperties;

  factory ReturnReqHistoryData.fromJson(Map<String, dynamic> json) => ReturnReqHistoryData(
    items: json["Items"] == null ? null : List<ReturnReqHistoryItem>.from(json["Items"].map((x) => ReturnReqHistoryItem.fromJson(x))),
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "Items": items == null ? null : List<dynamic>.from(items.map((x) => x.toJson())),
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class ReturnReqHistoryItem {
  ReturnReqHistoryItem({
    this.customNumber,
    this.returnRequestStatus,
    this.productId,
    this.productName,
    this.productSeName,
    this.quantity,
    this.returnReason,
    this.returnAction,
    this.comments,
    this.uploadedFileGuid,
    this.createdOn,
    this.id,
    this.customProperties,
  });

  String customNumber;
  String returnRequestStatus;
  int productId;
  String productName;
  String productSeName;
  int quantity;
  String returnReason;
  String returnAction;
  String comments;
  String uploadedFileGuid;
  DateTime createdOn;
  int id;
  CustomProperties customProperties;

  factory ReturnReqHistoryItem.fromJson(Map<String, dynamic> json) => ReturnReqHistoryItem(
    customNumber: json["CustomNumber"] == null ? null : json["CustomNumber"],
    returnRequestStatus: json["ReturnRequestStatus"] == null ? null : json["ReturnRequestStatus"],
    productId: json["ProductId"] == null ? null : json["ProductId"],
    productName: json["ProductName"] == null ? null : json["ProductName"],
    productSeName: json["ProductSeName"] == null ? null : json["ProductSeName"],
    quantity: json["Quantity"] == null ? null : json["Quantity"],
    returnReason: json["ReturnReason"] == null ? null : json["ReturnReason"],
    returnAction: json["ReturnAction"] == null ? null : json["ReturnAction"],
    comments: json["Comments"] == null ? null : json["Comments"],
    uploadedFileGuid: json["UploadedFileGuid"] == null ? null : json["UploadedFileGuid"],
    createdOn: json["CreatedOn"] == null ? null : DateTime.parse(json["CreatedOn"]),
    id: json["Id"] == null ? null : json["Id"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "CustomNumber": customNumber == null ? null : customNumber,
    "ReturnRequestStatus": returnRequestStatus == null ? null : returnRequestStatus,
    "ProductId": productId == null ? null : productId,
    "ProductName": productName == null ? null : productName,
    "ProductSeName": productSeName == null ? null : productSeName,
    "Quantity": quantity == null ? null : quantity,
    "ReturnReason": returnReason == null ? null : returnReason,
    "ReturnAction": returnAction == null ? null : returnAction,
    "Comments": comments == null ? null : comments,
    "UploadedFileGuid": uploadedFileGuid == null ? null : uploadedFileGuid,
    "CreatedOn": createdOn == null ? null : createdOn.toIso8601String(),
    "Id": id == null ? null : id,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}
