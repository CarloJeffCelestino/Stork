import 'package:nopcart_flutter/model/CustomProperties.dart';

class RewardPointResponse {
  RewardPointResponse({
    this.data,
    this.message,
    this.errorList,
  });

  RewardPointData data;
  String message;
  List<String> errorList;

  RewardPointResponse copyWith({
    RewardPointData data,
    String message,
    List<String> errorList,
  }) =>
      RewardPointResponse(
        data: data ?? this.data,
        message: message ?? this.message,
        errorList: errorList ?? this.errorList,
      );

  factory RewardPointResponse.fromJson(Map<String, dynamic> json) => RewardPointResponse(
    data: json["Data"] == null ? null : RewardPointData.fromJson(json["Data"]),
    message: json["Message"] == null ? null : json["Message"],
    errorList: json["ErrorList"] == null ? null : List<String>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : data.toJson(),
    "Message": message == null ? null : message,
    "ErrorList": errorList == null ? null : List<dynamic>.from(errorList.map((x) => x)),
  };
}

class RewardPointData {
  RewardPointData({
    this.rewardPoints,
    this.pagerModel,
    this.rewardPointsBalance,
    this.rewardPointsAmount,
    this.minimumRewardPointsBalance,
    this.minimumRewardPointsAmount,
    this.customProperties,
  });

  List<RewardPoint> rewardPoints;
  PagerModel pagerModel;
  int rewardPointsBalance;
  String rewardPointsAmount;
  int minimumRewardPointsBalance;
  String minimumRewardPointsAmount;
  CustomProperties customProperties;

  RewardPointData copyWith({
    List<RewardPoint> rewardPoints,
    PagerModel pagerModel,
    int rewardPointsBalance,
    String rewardPointsAmount,
    int minimumRewardPointsBalance,
    String minimumRewardPointsAmount,
    CustomProperties customProperties,
  }) =>
      RewardPointData(
        rewardPoints: rewardPoints ?? this.rewardPoints,
        pagerModel: pagerModel ?? this.pagerModel,
        rewardPointsBalance: rewardPointsBalance ?? this.rewardPointsBalance,
        rewardPointsAmount: rewardPointsAmount ?? this.rewardPointsAmount,
        minimumRewardPointsBalance: minimumRewardPointsBalance ?? this.minimumRewardPointsBalance,
        minimumRewardPointsAmount: minimumRewardPointsAmount ?? this.minimumRewardPointsAmount,
        customProperties: customProperties ?? this.customProperties,
      );

  factory RewardPointData.fromJson(Map<String, dynamic> json) => RewardPointData(
    rewardPoints: json["RewardPoints"] == null ? null : List<RewardPoint>.from(json["RewardPoints"].map((x) => RewardPoint.fromJson(x))),
    pagerModel: json["PagerModel"] == null ? null : PagerModel.fromJson(json["PagerModel"]),
    rewardPointsBalance: json["RewardPointsBalance"] == null ? null : json["RewardPointsBalance"],
    rewardPointsAmount: json["RewardPointsAmount"] == null ? null : json["RewardPointsAmount"],
    minimumRewardPointsBalance: json["MinimumRewardPointsBalance"] == null ? null : json["MinimumRewardPointsBalance"],
    minimumRewardPointsAmount: json["MinimumRewardPointsAmount"] == null ? null : json["MinimumRewardPointsAmount"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "RewardPoints": rewardPoints == null ? null : List<dynamic>.from(rewardPoints.map((x) => x.toJson())),
    "PagerModel": pagerModel == null ? null : pagerModel.toJson(),
    "RewardPointsBalance": rewardPointsBalance == null ? null : rewardPointsBalance,
    "RewardPointsAmount": rewardPointsAmount == null ? null : rewardPointsAmount,
    "MinimumRewardPointsBalance": minimumRewardPointsBalance == null ? null : minimumRewardPointsBalance,
    "MinimumRewardPointsAmount": minimumRewardPointsAmount == null ? null : minimumRewardPointsAmount,
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

  PagerModel copyWith({
    int currentPage,
    int individualPagesDisplayedCount,
    int pageIndex,
    int pageSize,
    bool showFirst,
    bool showIndividualPages,
    bool showLast,
    bool showNext,
    bool showPagerItems,
    bool showPrevious,
    bool showTotalSummary,
    int totalPages,
    int totalRecords,
    String routeActionName,
    bool useRouteLinks,
    RouteValues routeValues,
  }) =>
      PagerModel(
        currentPage: currentPage ?? this.currentPage,
        individualPagesDisplayedCount: individualPagesDisplayedCount ?? this.individualPagesDisplayedCount,
        pageIndex: pageIndex ?? this.pageIndex,
        pageSize: pageSize ?? this.pageSize,
        showFirst: showFirst ?? this.showFirst,
        showIndividualPages: showIndividualPages ?? this.showIndividualPages,
        showLast: showLast ?? this.showLast,
        showNext: showNext ?? this.showNext,
        showPagerItems: showPagerItems ?? this.showPagerItems,
        showPrevious: showPrevious ?? this.showPrevious,
        showTotalSummary: showTotalSummary ?? this.showTotalSummary,
        totalPages: totalPages ?? this.totalPages,
        totalRecords: totalRecords ?? this.totalRecords,
        routeActionName: routeActionName ?? this.routeActionName,
        useRouteLinks: useRouteLinks ?? this.useRouteLinks,
        routeValues: routeValues ?? this.routeValues,
      );

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

  RouteValues copyWith({
    int pageNumber,
  }) =>
      RouteValues(
        pageNumber: pageNumber ?? this.pageNumber,
      );

  factory RouteValues.fromJson(Map<String, dynamic> json) => RouteValues(
    pageNumber: json["pageNumber"] == null ? null : json["pageNumber"],
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber == null ? null : pageNumber,
  };
}

class RewardPoint {
  RewardPoint({
    this.points,
    this.pointsBalance,
    this.message,
    this.createdOn,
    this.endDate,
    this.id,
    this.customProperties,
  });

  num points;
  String pointsBalance;
  String message;
  DateTime createdOn;
  DateTime endDate;
  int id;
  CustomProperties customProperties;

  RewardPoint copyWith({
    int points,
    String pointsBalance,
    String message,
    DateTime createdOn,
    DateTime endDate,
    int id,
    CustomProperties customProperties,
  }) =>
      RewardPoint(
        points: points ?? this.points,
        pointsBalance: pointsBalance ?? this.pointsBalance,
        message: message ?? this.message,
        createdOn: createdOn ?? this.createdOn,
        endDate: endDate ?? this.endDate,
        id: id ?? this.id,
        customProperties: customProperties ?? this.customProperties,
      );

  factory RewardPoint.fromJson(Map<String, dynamic> json) => RewardPoint(
    points: json["Points"] == null ? null : json["Points"],
    pointsBalance: json["PointsBalance"] == null ? null : json["PointsBalance"],
    message: json["Message"] == null ? null : json["Message"],
    createdOn: json["CreatedOn"] == null ? null : DateTime.parse(json["CreatedOn"]),
    endDate: json["EndDate"] == null ? null : DateTime.parse(json["EndDate"]),
    id: json["Id"] == null ? null : json["Id"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "Points": points == null ? null : points,
    "PointsBalance": pointsBalance == null ? null : pointsBalance,
    "Message": message == null ? null : message,
    "CreatedOn": createdOn == null ? null : createdOn.toIso8601String(),
    "EndDate": endDate == null ? null : endDate.toIso8601String(),
    "Id": id == null ? null : id,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}
