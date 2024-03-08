class TopicResponse {
  TopicResponse({
    this.data,
    this.message,
    this.errorList,
  });

  TopicData data;
  String message;
  List<String> errorList;

  factory TopicResponse.fromJson(Map<String, dynamic> json) => TopicResponse(
    data: json["Data"] == null ? null : TopicData.fromJson(json["Data"]),
    message: json["Message"] == null ? null : json["Message"],
    errorList: json["ErrorList"] == null ? null : List<String>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : data.toJson(),
    "Message": message == null ? null : message,
    "ErrorList": errorList == null ? null : List<dynamic>.from(errorList.map((x) => x)),
  };
}

class TopicData {
  TopicData({
    this.systemName,
    this.includeInSitemap,
    this.isPasswordProtected,
    this.title,
    this.body,
    this.metaKeywords,
    this.metaDescription,
    this.metaTitle,
    this.seName,
    this.topicTemplateId,
    this.id,
  });

  String systemName;
  bool includeInSitemap;
  bool isPasswordProtected;
  String title;
  String body;
  String metaKeywords;
  String metaDescription;
  String metaTitle;
  String seName;
  int topicTemplateId;
  int id;

  factory TopicData.fromJson(Map<String, dynamic> json) => TopicData(
    systemName: json["SystemName"] == null ? null : json["SystemName"],
    includeInSitemap: json["IncludeInSitemap"] == null ? null : json["IncludeInSitemap"],
    isPasswordProtected: json["IsPasswordProtected"] == null ? null : json["IsPasswordProtected"],
    title: json["Title"] == null ? null : json["Title"],
    body: json["Body"] == null ? null : json["Body"],
    metaKeywords: json["MetaKeywords"] == null ? null : json["MetaKeywords"],
    metaDescription: json["MetaDescription"] == null ? null : json["MetaDescription"],
    metaTitle: json["MetaTitle"] == null ? null : json["MetaTitle"],
    seName: json["SeName"] == null ? null : json["SeName"],
    topicTemplateId: json["TopicTemplateId"] == null ? null : json["TopicTemplateId"],
    id: json["Id"] == null ? null : json["Id"],
  );

  Map<String, dynamic> toJson() => {
    "SystemName": systemName == null ? null : systemName,
    "IncludeInSitemap": includeInSitemap == null ? null : includeInSitemap,
    "IsPasswordProtected": isPasswordProtected == null ? null : isPasswordProtected,
    "Title": title == null ? null : title,
    "Body": body == null ? null : body,
    "MetaKeywords": metaKeywords == null ? null : metaKeywords,
    "MetaDescription": metaDescription == null ? null : metaDescription,
    "MetaTitle": metaTitle == null ? null : metaTitle,
    "SeName": seName == null ? null : seName,
    "TopicTemplateId": topicTemplateId == null ? null : topicTemplateId,
    "Id": id == null ? null : id,
  };
}
