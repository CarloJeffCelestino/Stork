import 'package:nopcart_flutter/model/ProductReviewResponse.dart';

class PostHelpfulnessResponse {
  PostHelpfulnessResponse({
    this.data,
    this.message,
    this.errorList,
  });

  Helpfulness data;
  String message;
  List<String> errorList;

  factory PostHelpfulnessResponse.fromJson(Map<String, dynamic> json) => PostHelpfulnessResponse(
    data: json["Data"] == null ? null : Helpfulness.fromJson(json["Data"]),
    message: json["Message"] == null ? null : json["Message"],
    errorList: json["ErrorList"] == null ? null : List<String>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : data.toJson(),
    "Message": message == null ? null : message,
    "ErrorList": errorList == null ? null : List<dynamic>.from(errorList.map((x) => x)),
  };
}
