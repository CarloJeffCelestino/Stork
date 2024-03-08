import 'package:nopcart_flutter/model/CustomProperties.dart';
import 'package:nopcart_flutter/model/GetBillingAddressResponse.dart';
import 'package:nopcart_flutter/model/ShoppingCartResponse.dart';

class OrderDetailsResponse {
  OrderDetailsResponse({
    this.data,
    this.message,
    this.errorList,
  });

  OrderDetailsData data;
  String message;
  List<String> errorList;

  factory OrderDetailsResponse.fromJson(Map<String, dynamic> json) => OrderDetailsResponse(
    data: json["Data"] == null ? null : OrderDetailsData.fromJson(json["Data"]),
    message: json["Message"] == null ? null : json["Message"],
    errorList: json["ErrorList"] == null ? null : List<String>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : data.toJson(),
    "Message": message == null ? null : message,
    "ErrorList": errorList == null ? null : List<dynamic>.from(errorList.map((x) => x)),
  };
}

class OrderDetailsData {
  OrderDetailsData({
    this.printMode,
    this.pdfInvoiceDisabled,
    this.customOrderNumber,
    this.createdOn,
    this.orderStatus,
    this.isReOrderAllowed,
    this.isReturnRequestAllowed,
    this.isShippable,
    this.pickupInStore,
    this.pickupAddress,
    this.shippingStatus,
    this.shippingAddress,
    this.shippingMethod,
    this.shipments,
    this.billingAddress,
    this.vatNumber,
    this.paymentMethod,
    this.paymentMethodStatus,
    this.canRePostProcessPayment,
    this.customValues,
    this.orderSubtotal,
    this.orderSubTotalDiscount,
    this.orderShipping,
    this.paymentMethodAdditionalFee,
    this.checkoutAttributeInfo,
    this.pricesIncludeTax,
    this.displayTaxShippingInfo,
    this.tax,
    this.taxRates,
    this.displayTax,
    this.displayTaxRates,
    this.orderTotalDiscount,
    this.redeemedRewardPoints,
    this.redeemedRewardPointsAmount,
    this.orderTotal,
    this.giftCards,
    this.showSku,
    this.items,
    this.orderNotes,
    this.showVendorName,
    this.id,
    this.customProperties,
  });

  bool printMode;
  bool pdfInvoiceDisabled;
  String customOrderNumber;
  DateTime createdOn;
  String orderStatus;
  bool isReOrderAllowed;
  bool isReturnRequestAllowed;
  bool isShippable;
  bool pickupInStore;
  Address pickupAddress;
  String shippingStatus;
  Address shippingAddress;
  String shippingMethod;
  List<ShipmentItem> shipments;
  Address billingAddress;
  String vatNumber;
  String paymentMethod;
  String paymentMethodStatus;
  bool canRePostProcessPayment;
  CustomProperties customValues;
  String orderSubtotal;
  String orderSubTotalDiscount;
  String orderShipping;
  String paymentMethodAdditionalFee;
  String checkoutAttributeInfo;
  bool pricesIncludeTax;
  bool displayTaxShippingInfo;
  String tax;
  List<TaxRate> taxRates;
  bool displayTax;
  bool displayTaxRates;
  String orderTotalDiscount;
  int redeemedRewardPoints;
  String redeemedRewardPointsAmount;
  String orderTotal;
  List<GiftCard> giftCards;
  bool showSku;
  List<Item> items;
  List<OrderNotes> orderNotes;
  bool showVendorName;
  int id;
  CustomProperties customProperties;

  factory OrderDetailsData.fromJson(Map<String, dynamic> json) => OrderDetailsData(
    printMode: json["PrintMode"] == null ? null : json["PrintMode"],
    pdfInvoiceDisabled: json["PdfInvoiceDisabled"] == null ? null : json["PdfInvoiceDisabled"],
    customOrderNumber: json["CustomOrderNumber"] == null ? null : json["CustomOrderNumber"],
    createdOn: json["CreatedOn"] == null ? null : DateTime.parse(json["CreatedOn"]),
    orderStatus: json["OrderStatus"] == null ? null : json["OrderStatus"],
    isReOrderAllowed: json["IsReOrderAllowed"] == null ? null : json["IsReOrderAllowed"],
    isReturnRequestAllowed: json["IsReturnRequestAllowed"] == null ? null : json["IsReturnRequestAllowed"],
    isShippable: json["IsShippable"] == null ? null : json["IsShippable"],
    pickupInStore: json["PickupInStore"] == null ? null : json["PickupInStore"],
    pickupAddress: json["PickupAddress"] == null ? null : Address.fromJson(json["PickupAddress"]),
    shippingStatus: json["ShippingStatus"] == null ? null : json["ShippingStatus"],
    shippingAddress: json["ShippingAddress"] == null ? null : Address.fromJson(json["ShippingAddress"]),
    shippingMethod: json["ShippingMethod"] == null ? null : json["ShippingMethod"],
    shipments: json["Shipments"] == null ? null : List<ShipmentItem>.from(json["Shipments"].map((x) => ShipmentItem.fromJson(x))),
    billingAddress: json["BillingAddress"] == null ? null : Address.fromJson(json["BillingAddress"]),
    vatNumber: json["VatNumber"],
    paymentMethod: json["PaymentMethod"] == null ? null : json["PaymentMethod"],
    paymentMethodStatus: json["PaymentMethodStatus"] == null ? null : json["PaymentMethodStatus"],
    canRePostProcessPayment: json["CanRePostProcessPayment"] == null ? null : json["CanRePostProcessPayment"],
    customValues: json["CustomValues"] == null ? null : CustomProperties.fromJson(json["CustomValues"]),
    orderSubtotal: json["OrderSubtotal"] == null ? null : json["OrderSubtotal"],
    orderSubTotalDiscount: json["OrderSubTotalDiscount"],
    orderShipping: json["OrderShipping"] == null ? null : json["OrderShipping"],
    paymentMethodAdditionalFee: json["PaymentMethodAdditionalFee"],
    checkoutAttributeInfo: json["CheckoutAttributeInfo"] == null ? null : json["CheckoutAttributeInfo"],
    pricesIncludeTax: json["PricesIncludeTax"] == null ? null : json["PricesIncludeTax"],
    displayTaxShippingInfo: json["DisplayTaxShippingInfo"] == null ? null : json["DisplayTaxShippingInfo"],
    tax: json["Tax"] == null ? null : json["Tax"],
    taxRates: json["TaxRates"] == null ? null : List<TaxRate>.from(json["TaxRates"].map((x) => TaxRate.fromJson(x))),
    displayTax: json["DisplayTax"] == null ? null : json["DisplayTax"],
    displayTaxRates: json["DisplayTaxRates"] == null ? null : json["DisplayTaxRates"],
    orderTotalDiscount: json["OrderTotalDiscount"],
    redeemedRewardPoints: json["RedeemedRewardPoints"] == null ? null : json["RedeemedRewardPoints"],
    redeemedRewardPointsAmount: json["RedeemedRewardPointsAmount"],
    orderTotal: json["OrderTotal"] == null ? null : json["OrderTotal"],
    giftCards: json["GiftCards"] == null ? null : List<GiftCard>.from(json["GiftCards"].map((x) => GiftCard.fromJson(x))),
    showSku: json["ShowSku"] == null ? null : json["ShowSku"],
    items: json["Items"] == null ? null : List<Item>.from(json["Items"].map((x) => Item.fromJson(x))),
    orderNotes: json["OrderNotes"] == null ? null : List<OrderNotes>.from(json["OrderNotes"].map((x) => OrderNotes.fromJson(x))),
    showVendorName: json["ShowVendorName"] == null ? null : json["ShowVendorName"],
    id: json["Id"] == null ? null : json["Id"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "PrintMode": printMode == null ? null : printMode,
    "PdfInvoiceDisabled": pdfInvoiceDisabled == null ? null : pdfInvoiceDisabled,
    "CustomOrderNumber": customOrderNumber == null ? null : customOrderNumber,
    "CreatedOn": createdOn == null ? null : createdOn.toIso8601String(),
    "OrderStatus": orderStatus == null ? null : orderStatus,
    "IsReOrderAllowed": isReOrderAllowed == null ? null : isReOrderAllowed,
    "IsReturnRequestAllowed": isReturnRequestAllowed == null ? null : isReturnRequestAllowed,
    "IsShippable": isShippable == null ? null : isShippable,
    "PickupInStore": pickupInStore == null ? null : pickupInStore,
    "PickupAddress": pickupAddress == null ? null : pickupAddress.toJson(),
    "ShippingStatus": shippingStatus == null ? null : shippingStatus,
    "ShippingAddress": shippingAddress == null ? null : shippingAddress.toJson(),
    "ShippingMethod": shippingMethod == null ? null : shippingMethod,
    "Shipments": shipments == null ? null : List<dynamic>.from(shipments.map((x) => x.toJson())),
    "BillingAddress": billingAddress == null ? null : billingAddress.toJson(),
    "VatNumber": vatNumber,
    "PaymentMethod": paymentMethod == null ? null : paymentMethod,
    "PaymentMethodStatus": paymentMethodStatus == null ? null : paymentMethodStatus,
    "CanRePostProcessPayment": canRePostProcessPayment == null ? null : canRePostProcessPayment,
    "CustomValues": customValues == null ? null : customValues.toJson(),
    "OrderSubtotal": orderSubtotal == null ? null : orderSubtotal,
    "OrderSubTotalDiscount": orderSubTotalDiscount,
    "OrderShipping": orderShipping == null ? null : orderShipping,
    "PaymentMethodAdditionalFee": paymentMethodAdditionalFee,
    "CheckoutAttributeInfo": checkoutAttributeInfo == null ? null : checkoutAttributeInfo,
    "PricesIncludeTax": pricesIncludeTax == null ? null : pricesIncludeTax,
    "DisplayTaxShippingInfo": displayTaxShippingInfo == null ? null : displayTaxShippingInfo,
    "Tax": tax == null ? null : tax,
    "TaxRates": taxRates == null ? null : List<dynamic>.from(taxRates.map((x) => x.toJson())),
    "DisplayTax": displayTax == null ? null : displayTax,
    "DisplayTaxRates": displayTaxRates == null ? null : displayTaxRates,
    "OrderTotalDiscount": orderTotalDiscount,
    "RedeemedRewardPoints": redeemedRewardPoints == null ? null : redeemedRewardPoints,
    "RedeemedRewardPointsAmount": redeemedRewardPointsAmount,
    "OrderTotal": orderTotal == null ? null : orderTotal,
    "GiftCards": giftCards == null ? null : List<dynamic>.from(giftCards.map((x) => x.toJson())),
    "ShowSku": showSku == null ? null : showSku,
    "Items": items == null ? null : List<dynamic>.from(items.map((x) => x.toJson())),
    "OrderNotes": orderNotes == null ? null : List<dynamic>.from(orderNotes.map((x) => x.toJson())),
    "ShowVendorName": showVendorName == null ? null : showVendorName,
    "Id": id == null ? null : id,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class Item {
  Item({
    this.orderItemGuid,
    this.sku,
    this.productId,
    this.productName,
    this.productSeName,
    this.unitPrice,
    this.subTotal,
    this.quantity,
    this.attributeInfo,
    this.rentalInfo,
    this.vendorName,
    this.downloadId,
    this.licenseId,
    this.id,
    this.customProperties,
  });

  String orderItemGuid;
  String sku;
  int productId;
  String productName;
  String productSeName;
  String unitPrice;
  String subTotal;
  int quantity;
  String attributeInfo;
  dynamic rentalInfo;
  String vendorName;
  int downloadId;
  int licenseId;
  int id;
  CustomProperties customProperties;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    orderItemGuid: json["OrderItemGuid"] == null ? null : json["OrderItemGuid"],
    sku: json["Sku"] == null ? null : json["Sku"],
    productId: json["ProductId"] == null ? null : json["ProductId"],
    productName: json["ProductName"] == null ? null : json["ProductName"],
    productSeName: json["ProductSeName"] == null ? null : json["ProductSeName"],
    unitPrice: json["UnitPrice"] == null ? null : json["UnitPrice"],
    subTotal: json["SubTotal"] == null ? null : json["SubTotal"],
    quantity: json["Quantity"] == null ? null : json["Quantity"],
    attributeInfo: json["AttributeInfo"] == null ? null : json["AttributeInfo"],
    rentalInfo: json["RentalInfo"],
    vendorName: json["VendorName"] == null ? null : json["VendorName"],
    downloadId: json["DownloadId"] == null ? null : json["DownloadId"],
    licenseId: json["LicenseId"] == null ? null : json["LicenseId"],
    id: json["Id"] == null ? null : json["Id"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "OrderItemGuid": orderItemGuid == null ? null : orderItemGuid,
    "Sku": sku == null ? null : sku,
    "ProductId": productId == null ? null : productId,
    "ProductName": productName == null ? null : productName,
    "ProductSeName": productSeName == null ? null : productSeName,
    "UnitPrice": unitPrice == null ? null : unitPrice,
    "SubTotal": subTotal == null ? null : subTotal,
    "Quantity": quantity == null ? null : quantity,
    "AttributeInfo": attributeInfo == null ? null : attributeInfo,
    "RentalInfo": rentalInfo,
    "VendorName": vendorName == null ? null : vendorName,
    "DownloadId": downloadId == null ? null : downloadId,
    "LicenseId": licenseId == null ? null : licenseId,
    "Id": id == null ? null : id,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class OrderNotes {
  OrderNotes({
    this.createdOn,
    this.note,
    this.hasDownload,
    this.id,
  });

  String createdOn;
  String note;
  bool hasDownload;
  int id;

  factory OrderNotes.fromJson(Map<String, dynamic> json) => OrderNotes(
    createdOn: json["CreatedOn"] == null ? null : json["CreatedOn"],
    note: json["Note"] == null ? null : json["Note"],
    hasDownload: json["HasDownload"] == null ? null : json["HasDownload"],
    id: json["Id"] == null ? null : json["Id"],
  );

  Map<String, dynamic> toJson() => {
    "CreatedOn": createdOn == null ? null : createdOn,
    "Note": note == null ? null : note,
    "HasDownload": hasDownload == null ? null : hasDownload,
    "Id": id == null ? null : id,
  };
}

class ShipmentItem {
  ShipmentItem({
    this.deliveryDate,
    this.shippedDate,
    this.trackingNumber,
    this.id,
  });

  DateTime deliveryDate;
  DateTime shippedDate;
  String trackingNumber;
  int id;

  factory ShipmentItem.fromJson(Map<String, dynamic> json) => ShipmentItem(
    deliveryDate: json["DeliveryDate"] == null ? null : DateTime.parse(json["DeliveryDate"]),
    shippedDate: json["ShippedDate"] == null ? null : DateTime.parse(json["ShippedDate"]),
    trackingNumber: json["TrackingNumber"] == null ? null : json["TrackingNumber"],
    id: json["Id"] == null ? null : json["Id"],
  );

  Map<String, dynamic> toJson() => {
    "DeliveryDate": deliveryDate == null ? null : deliveryDate.toIso8601String(),
    "ShippedDate": shippedDate == null ? null : shippedDate.toIso8601String(),
    "TrackingNumber": trackingNumber == null ? null : trackingNumber,
    "Id": id == null ? null : id,
  };
}


