import 'package:nopcart_flutter/model/CustomProperties.dart';

class CustomerReviewResponse {
  CustomerReviewResponse({
    this.data,
    this.message,
    this.errorList,
  });

  CustomerReviewData data;
  String message;
  List<String> errorList;

  factory CustomerReviewResponse.fromJson(Map<String, dynamic> json) => CustomerReviewResponse(
    data: json["Data"] == null ? null : CustomerReviewData.fromJson(json["Data"]),
    message: json["Message"] == null ? null : json["Message"],
    errorList: json["ErrorList"] == null ? null : List<String>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : data.toJson(),
    "Message": message == null ? null : message,
    "ErrorList": errorList == null ? null : List<dynamic>.from(errorList.map((x) => x)),
  };
}

class CustomerReviewData {
  CustomerReviewData({
    this.productReviews,
    this.pagerModel,
    this.customProperties,
  });

  List<ProductReview> productReviews;
  PagerModel pagerModel;
  CustomProperties customProperties;

  factory CustomerReviewData.fromJson(Map<String, dynamic> json) => CustomerReviewData(
    productReviews: json["ProductReviews"] == null ? null : List<ProductReview>.from(json["ProductReviews"].map((x) => ProductReview.fromJson(x))),
    pagerModel: json["PagerModel"] == null ? null : PagerModel.fromJson(json["PagerModel"]),
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "ProductReviews": productReviews == null ? null : List<dynamic>.from(productReviews.map((x) => x.toJson())),
    "PagerModel": pagerModel == null ? null : pagerModel.toJson(),
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class PagerModel {
  PagerModel({
    this.currentPage,
    this.individualPagesDisplayedCount,
    this.pageIndex,
    this.pageSize,
    this.showFirst,
    this.showIndividualPages,
    this.showLast,
    this.showNext,
    this.showPagerItems,
    this.showPrevious,
    this.showTotalSummary,
    this.totalPages,
    this.totalRecords,
    this.routeActionName,
    this.useRouteLinks,
    this.routeValues,
  });

  int currentPage;
  int individualPagesDisplayedCount;
  int pageIndex;
  int pageSize;
  bool showFirst;
  bool showIndividualPages;
  bool showLast;
  bool showNext;
  bool showPagerItems;
  bool showPrevious;
  bool showTotalSummary;
  int totalPages;
  int totalRecords;
  String routeActionName;
  bool useRouteLinks;
  RouteValues routeValues;

  factory PagerModel.fromJson(Map<String, dynamic> json) => PagerModel(
    currentPage: json["CurrentPage"] == null ? null : json["CurrentPage"],
    individualPagesDisplayedCount: json["IndividualPagesDisplayedCount"] == null ? null : json["IndividualPagesDisplayedCount"],
    pageIndex: json["PageIndex"] == null ? null : json["PageIndex"],
    pageSize: json["PageSize"] == null ? null : json["PageSize"],
    showFirst: json["ShowFirst"] == null ? null : json["ShowFirst"],
    showIndividualPages: json["ShowIndividualPages"] == null ? null : json["ShowIndividualPages"],
    showLast: json["ShowLast"] == null ? null : json["ShowLast"],
    showNext: json["ShowNext"] == null ? null : json["ShowNext"],
    showPagerItems: json["ShowPagerItems"] == null ? null : json["ShowPagerItems"],
    showPrevious: json["ShowPrevious"] == null ? null : json["ShowPrevious"],
    showTotalSummary: json["ShowTotalSummary"] == null ? null : json["ShowTotalSummary"],
    totalPages: json["TotalPages"] == null ? null : json["TotalPages"],
    totalRecords: json["TotalRecords"] == null ? null : json["TotalRecords"],
    routeActionName: json["RouteActionName"] == null ? null : json["RouteActionName"],
    useRouteLinks: json["UseRouteLinks"] == null ? null : json["UseRouteLinks"],
    routeValues: json["RouteValues"] == null ? null : RouteValues.fromJson(json["RouteValues"]),
  );

  Map<String, dynamic> toJson() => {
    "CurrentPage": currentPage == null ? null : currentPage,
    "IndividualPagesDisplayedCount": individualPagesDisplayedCount == null ? null : individualPagesDisplayedCount,
    "PageIndex": pageIndex == null ? null : pageIndex,
    "PageSize": pageSize == null ? null : pageSize,
    "ShowFirst": showFirst == null ? null : showFirst,
    "ShowIndividualPages": showIndividualPages == null ? null : showIndividualPages,
    "ShowLast": showLast == null ? null : showLast,
    "ShowNext": showNext == null ? null : showNext,
    "ShowPagerItems": showPagerItems == null ? null : showPagerItems,
    "ShowPrevious": showPrevious == null ? null : showPrevious,
    "ShowTotalSummary": showTotalSummary == null ? null : showTotalSummary,
    "TotalPages": totalPages == null ? null : totalPages,
    "TotalRecords": totalRecords == null ? null : totalRecords,
    "RouteActionName": routeActionName == null ? null : routeActionName,
    "UseRouteLinks": useRouteLinks == null ? null : useRouteLinks,
    "RouteValues": routeValues == null ? null : routeValues.toJson(),
  };
}

class RouteValues {
  RouteValues({
    this.pageNumber,
  });

  int pageNumber;

  factory RouteValues.fromJson(Map<String, dynamic> json) => RouteValues(
    pageNumber: json["pageNumber"] == null ? null : json["pageNumber"],
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber == null ? null : pageNumber,
  };
}

class ProductReview {
  ProductReview({
    this.productId,
    this.productName,
    this.productSeName,
    this.title,
    this.reviewText,
    this.replyText,
    this.rating,
    this.writtenOnStr,
    this.approvalStatus,
    this.additionalProductReviewList,
    this.customProperties,
  });

  int productId;
  String productName;
  String productSeName;
  String title;
  String reviewText;
  String replyText;
  int rating;
  String writtenOnStr;
  dynamic approvalStatus;
  List<dynamic> additionalProductReviewList;
  CustomProperties customProperties;

  factory ProductReview.fromJson(Map<String, dynamic> json) => ProductReview(
    productId: json["ProductId"] == null ? null : json["ProductId"],
    productName: json["ProductName"] == null ? null : json["ProductName"],
    productSeName: json["ProductSeName"] == null ? null : json["ProductSeName"],
    title: json["Title"] == null ? null : json["Title"],
    reviewText: json["ReviewText"] == null ? null : json["ReviewText"],
    replyText: json["ReplyText"] == null ? null : json["ReplyText"],
    rating: json["Rating"] == null ? null : json["Rating"],
    writtenOnStr: json["WrittenOnStr"] == null ? null : json["WrittenOnStr"],
    approvalStatus: json["ApprovalStatus"],
    additionalProductReviewList: json["AdditionalProductReviewList"] == null ? null : List<dynamic>.from(json["AdditionalProductReviewList"].map((x) => x)),
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "ProductId": productId == null ? null : productId,
    "ProductName": productName == null ? null : productName,
    "ProductSeName": productSeName == null ? null : productSeName,
    "Title": title == null ? null : title,
    "ReviewText": reviewText == null ? null : reviewText,
    "ReplyText": replyText == null ? null : replyText,
    "Rating": rating == null ? null : rating,
    "WrittenOnStr": writtenOnStr == null ? null : writtenOnStr,
    "ApprovalStatus": approvalStatus,
    "AdditionalProductReviewList": additionalProductReviewList == null ? null : List<dynamic>.from(additionalProductReviewList.map((x) => x)),
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}
