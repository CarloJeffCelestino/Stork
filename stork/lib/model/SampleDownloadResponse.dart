class SampleDownloadResponse {
  SampleDownloadResponse({
    this.data,
    this.message,
    this.errorList,
  });

  SampleDownloadData data;
  String message;
  List<String> errorList;

  factory SampleDownloadResponse.fromJson(Map<String, dynamic> json) => SampleDownloadResponse(
    data: json["Data"] == null ? null : SampleDownloadData.fromJson(json["Data"]),
    message: json["Message"] == null ? null : json["Message"],
    errorList: json["ErrorList"] == null ? null : List<String>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : data.toJson(),
    "Message": message == null ? null : message,
    "ErrorList": errorList == null ? null : List<dynamic>.from(errorList.map((x) => x)),
  };
}

class SampleDownloadData {
  SampleDownloadData({
    this.hasUserAgreement,
    this.orderItemId,
    this.redirect,
    this.downloadUrl,
  });

  bool hasUserAgreement;
  String orderItemId;
  bool redirect;
  String downloadUrl;

  factory SampleDownloadData.fromJson(Map<String, dynamic> json) => SampleDownloadData(
    hasUserAgreement: json["HasUserAgreement"] == null ? null : json["HasUserAgreement"],
    orderItemId: json["OrderItemId"] == null ? null : json["OrderItemId"],
    redirect: json["Redirect"] == null ? null : json["Redirect"],
    downloadUrl: json["DownloadUrl"] == null ? null : json["DownloadUrl"],
  );

  Map<String, dynamic> toJson() => {
    "HasUserAgreement": hasUserAgreement == null ? null : hasUserAgreement,
    "OrderItemId": orderItemId == null ? null : orderItemId,
    "Redirect": redirect == null ? null : redirect,
    "DownloadUrl": downloadUrl == null ? null : downloadUrl,
  };
}
