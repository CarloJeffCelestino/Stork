import 'FormValue.dart';

class OrderHistoryRequestBody {
  OrderHistoryRequestBody({
    this.data,
  });

  OrderHistoryData data;

  factory OrderHistoryRequestBody.fromJson(Map<String, dynamic> json) => OrderHistoryRequestBody(
    data: json["Data"] == null ? null : OrderHistoryData.fromJson(json["Data"]),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : data.toJson(),
  };
}

class OrderHistoryData {
  OrderHistoryData({
    this.isPending,
    this.toShip,
    this.toDeliver,
    this.toRate,
  });

  bool isPending;
  bool toShip;
  bool toDeliver;
  bool toRate;

  factory OrderHistoryData.fromJson(Map<String, dynamic> json) => OrderHistoryData(
    isPending: json["IsPending"] == null ? null : json["IsPending"],
    toShip: json["ToShip"] == null ? null : json["ToShip"],
    toDeliver: json["ToDeliver"] == null ? null : json["ToDeliver"],
    toRate: json["TRate"] == null ? null : json["ToRate"],
  );

  Map<String, dynamic> toJson() => {
    "IsPending": isPending == null ? null : isPending,
    "ToShip": toShip == null ? null : toShip,
    "ToDeliver": toDeliver == null ? null : toDeliver,
    "ToRate": toRate == null ? null : toRate,
  };
}