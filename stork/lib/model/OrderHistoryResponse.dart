import 'package:nopcart_flutter/model/CustomProperties.dart';

class OrderHistoryResponse {
  OrderHistoryResponse({
    this.data,
    this.message,
    this.errorList,
  });

  OrderHistoryData data;
  String message;
  List<String> errorList;

  factory OrderHistoryResponse.fromJson(Map<String, dynamic> json) => OrderHistoryResponse(
    data: json["Data"] == null ? null : OrderHistoryData.fromJson(json["Data"]),
    message: json["Message"] == null ? null : json["Message"],
    errorList: json["ErrorList"] == null ? null : List<String>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : data.toJson(),
    "Message": message == null ? null : message,
    "ErrorList": errorList == null ? null : List<dynamic>.from(errorList.map((x) => x)),
  };
}

class OrderHistoryData {
  OrderHistoryData({
    this.orders,
    this.recurringOrders,
    this.recurringPaymentErrors,
    this.customProperties,
  });

  List<Order> orders;
  List<dynamic> recurringOrders;
  List<dynamic> recurringPaymentErrors;
  CustomProperties customProperties;

  factory OrderHistoryData.fromJson(Map<String, dynamic> json) => OrderHistoryData(
    orders: json["Orders"] == null ? null : List<Order>.from(json["Orders"].map((x) => Order.fromJson(x))),
    recurringOrders: json["RecurringOrders"] == null ? null : List<dynamic>.from(json["RecurringOrders"].map((x) => x)),
    recurringPaymentErrors: json["RecurringPaymentErrors"] == null ? null : List<dynamic>.from(json["RecurringPaymentErrors"].map((x) => x)),
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "Orders": orders == null ? null : List<dynamic>.from(orders.map((x) => x.toJson())),
    "RecurringOrders": recurringOrders == null ? null : List<dynamic>.from(recurringOrders.map((x) => x)),
    "RecurringPaymentErrors": recurringPaymentErrors == null ? null : List<dynamic>.from(recurringPaymentErrors.map((x) => x)),
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class Order {
  Order({
    this.customOrderNumber,
    this.orderTotal,
    this.isReturnRequestAllowed,
    this.orderStatusEnum,
    this.orderStatus,
    this.paymentStatus,
    this.shippingStatus,
    this.createdOn,
    this.id,
    this.customProperties,
  });

  String customOrderNumber;
  String orderTotal;
  bool isReturnRequestAllowed;
  int orderStatusEnum;
  String orderStatus;
  String paymentStatus;
  String shippingStatus;
  DateTime createdOn;
  int id;
  CustomProperties customProperties;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    customOrderNumber: json["CustomOrderNumber"] == null ? null : json["CustomOrderNumber"],
    orderTotal: json["OrderTotal"] == null ? null : json["OrderTotal"],
    isReturnRequestAllowed: json["IsReturnRequestAllowed"] == null ? null : json["IsReturnRequestAllowed"],
    orderStatusEnum: json["OrderStatusEnum"] == null ? null : json["OrderStatusEnum"],
    orderStatus: json["OrderStatus"] == null ? null : json["OrderStatus"],
    paymentStatus: json["PaymentStatus"] == null ? null : json["PaymentStatus"],
    shippingStatus: json["ShippingStatus"] == null ? null : json["ShippingStatus"],
    createdOn: json["CreatedOn"] == null ? null : DateTime.parse(json["CreatedOn"]),
    id: json["Id"] == null ? null : json["Id"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "CustomOrderNumber": customOrderNumber == null ? null : customOrderNumber,
    "OrderTotal": orderTotal == null ? null : orderTotal,
    "IsReturnRequestAllowed": isReturnRequestAllowed == null ? null : isReturnRequestAllowed,
    "OrderStatusEnum": orderStatusEnum == null ? null : orderStatusEnum,
    "OrderStatus": orderStatus == null ? null : orderStatus,
    "PaymentStatus": paymentStatus == null ? null : paymentStatus,
    "ShippingStatus": shippingStatus == null ? null : shippingStatus,
    "CreatedOn": createdOn == null ? null : createdOn.toIso8601String(),
    "Id": id == null ? null : id,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}
