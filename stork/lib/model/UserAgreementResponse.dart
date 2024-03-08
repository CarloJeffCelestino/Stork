class UserAgreementResponse {
  UserAgreementResponse({
    this.data,
    this.message,
    this.errorList,
  });

  UserAgreementData data;
  String message;
  List<String> errorList;

  factory UserAgreementResponse.fromJson(Map<String, dynamic> json) => UserAgreementResponse(
    data: json["Data"] == null ? null : UserAgreementData.fromJson(json["Data"]),
    message: json["Message"] == null ? null : json["Message"],
    errorList: json["ErrorList"] == null ? null : List<String>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : data.toJson(),
    "Message": message == null ? null : message,
    "ErrorList": errorList == null ? null : List<dynamic>.from(errorList.map((x) => x)),
  };
}

class UserAgreementData {
  UserAgreementData({
    this.orderItemGuid,
    this.userAgreementText,
  });

  String orderItemGuid;
  String userAgreementText;

  factory UserAgreementData.fromJson(Map<String, dynamic> json) => UserAgreementData(
    orderItemGuid: json["OrderItemGuid"] == null ? null : json["OrderItemGuid"],
    userAgreementText: json["UserAgreementText"] == null ? null : json["UserAgreementText"],
  );

  Map<String, dynamic> toJson() => {
    "OrderItemGuid": orderItemGuid == null ? null : orderItemGuid,
    "UserAgreementText": userAgreementText == null ? null : userAgreementText,
  };
}
