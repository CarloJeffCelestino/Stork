import 'package:nopcart_flutter/model/SaveBillingResponse.dart';

class OrderSummaryResponse {
  OrderSummaryResponse({
    this.data,
    this.message,
    this.errorList,
  });

  ConfirmModel data;
  String message;
  List<String> errorList;

  factory OrderSummaryResponse.fromJson(Map<String, dynamic> json) => OrderSummaryResponse(
    data: json["Data"] == null ? null : ConfirmModel.fromJson(json["Data"]),
    message: json["Message"] == null ? null : json["Message"],
    errorList: json["ErrorList"] == null ? null : List<String>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : data.toJson(),
    "Message": message == null ? null : message,
    "ErrorList": errorList == null ? null : List<dynamic>.from(errorList.map((x) => x)),
  };
}