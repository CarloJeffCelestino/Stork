class SubscriptionListResponse {
  SubscriptionListResponse({
    this.data,
    this.message,
    this.errorList,
  });

  SubscriptionListData data;
  String message;
  List<String> errorList;

  factory SubscriptionListResponse.fromJson(Map<String, dynamic> json) => SubscriptionListResponse(
    data: json["Data"] == null ? null : SubscriptionListData.fromJson(json["Data"]),
    message: json["Message"] == null ? null : json["Message"],
    errorList: json["ErrorList"] == null ? null : List<String>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : data.toJson(),
    "Message": message == null ? null : message,
    "ErrorList": errorList == null ? null : List<dynamic>.from(errorList.map((x) => x)),
  };
}

class SubscriptionListData {
  SubscriptionListData({
    this.subscriptions,
    this.pagerModel,
    this.customProperties,
  });

  List<Subscription> subscriptions;
  PagerModel pagerModel;
  CustomProperties customProperties;

  factory SubscriptionListData.fromJson(Map<String, dynamic> json) => SubscriptionListData(
    subscriptions: json["Subscriptions"] == null ? null : List<Subscription>.from(json["Subscriptions"].map((x) => Subscription.fromJson(x))),
    pagerModel: json["PagerModel"] == null ? null : PagerModel.fromJson(json["PagerModel"]),
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "Subscriptions": subscriptions == null ? null : List<dynamic>.from(subscriptions.map((x) => x.toJson())),
    "PagerModel": pagerModel == null ? null : pagerModel.toJson(),
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class CustomProperties {
  CustomProperties();

  factory CustomProperties.fromJson(Map<String, dynamic> json) => CustomProperties(
  );

  Map<String, dynamic> toJson() => {
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

class Subscription {
  Subscription({
    this.productId,
    this.productName,
    this.seName,
    this.id,
    this.customProperties,
  });

  int productId;
  String productName;
  String seName;
  int id;
  CustomProperties customProperties;

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
    productId: json["ProductId"] == null ? null : json["ProductId"],
    productName: json["ProductName"] == null ? null : json["ProductName"],
    seName: json["SeName"] == null ? null : json["SeName"],
    id: json["Id"] == null ? null : json["Id"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "ProductId": productId == null ? null : productId,
    "ProductName": productName == null ? null : productName,
    "SeName": seName == null ? null : seName,
    "Id": id == null ? null : id,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}
