class AppStartReqBody {
  AppStartReqBody({
    this.data,
  });

  AppStartData data;

  factory AppStartReqBody.fromJson(Map<String, dynamic> json) => AppStartReqBody(
    data: json["Data"] == null ? null : AppStartData.fromJson(json["Data"]),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : data.toJson(),
  };
}

class AppStartData {
  AppStartData({
    this.deviceTypeId,
    this.subscriptionId,
  });

  int deviceTypeId;
  String subscriptionId;

  factory AppStartData.fromJson(Map<String, dynamic> json) => AppStartData(
    deviceTypeId: json["DeviceTypeId"] == null ? null : json["DeviceTypeId"],
    subscriptionId: json["SubscriptionId"] == null ? null : json["SubscriptionId"],
  );

  Map<String, dynamic> toJson() => {
    "DeviceTypeId": deviceTypeId == null ? null : deviceTypeId,
    "SubscriptionId": subscriptionId == null ? null : subscriptionId,
  };
}
