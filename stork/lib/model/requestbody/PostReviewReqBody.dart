import 'package:nopcart_flutter/model/ProductReviewResponse.dart';

class PostReviewReqBody {
  PostReviewReqBody({
    this.data,
  });

  PostReviewData data;

  factory PostReviewReqBody.fromJson(Map<String, dynamic> json) => PostReviewReqBody(
    data: json["Data"] == null ? null : PostReviewData.fromJson(json["Data"]),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : data.toJson(),
  };
}

class PostReviewData {
  PostReviewData({
    this.addProductReview,
  });

  AddProductReview addProductReview;

  factory PostReviewData.fromJson(Map<String, dynamic> json) => PostReviewData(
    addProductReview: json["AddProductReview"] == null ? null : AddProductReview.fromJson(json["AddProductReview"]),
  );

  Map<String, dynamic> toJson() => {
    "AddProductReview": addProductReview == null ? null : addProductReview.toJson(),
  };
}
