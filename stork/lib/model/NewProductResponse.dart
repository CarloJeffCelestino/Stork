import 'package:nopcart_flutter/model/ProductSummary.dart';

class NewProductResponse {
  NewProductResponse({
    this.data,
    this.message,
    this.errorList,
  });

  List<ProductSummary> data;
  String message;
  List<String> errorList;

  factory NewProductResponse.fromJson(Map<String, dynamic> json) => NewProductResponse(
    data: json["Data"] == null ? null : List<ProductSummary>.from(json["Data"].map((x) => ProductSummary.fromJson(x))),
    message: json["Message"] == null ? null : json["Message"],
    errorList: json["ErrorList"] == null ? null : List<String>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    "Message": message == null ? null : message,
    "ErrorList": errorList == null ? null : List<dynamic>.from(errorList.map((x) => x)),
  };
}