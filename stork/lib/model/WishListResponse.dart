import 'package:nopcart_flutter/model/AvailableOption.dart';
import 'package:nopcart_flutter/model/CustomProperties.dart';
import 'package:nopcart_flutter/model/PictureModel.dart';

class WishListResponse {
  WishListResponse({
    this.data,
    this.message,
    this.errorList,
  });

  WishListData data;
  String message;
  List<String> errorList;

  factory WishListResponse.fromJson(Map<String, dynamic> json) => WishListResponse(
    data: json["Data"] == null ? null : WishListData.fromJson(json["Data"]),
    message: json["Message"] == null ? null : json["Message"],
    errorList: json["ErrorList"] == null ? null : List<String>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : data.toJson(),
    "Message": message == null ? null : message,
    "ErrorList": errorList == null ? null : List<dynamic>.from(errorList.map((x) => x)),
  };
}

class WishListData {
  WishListData({
    this.customerGuid,
    this.customerFullname,
    this.emailWishlistEnabled,
    this.showSku,
    this.showProductImages,
    this.isEditable,
    this.displayAddToCart,
    this.displayTaxShippingInfo,
    this.items,
    this.warnings,
    this.customProperties,
  });

  String customerGuid;
  String customerFullname;
  bool emailWishlistEnabled;
  bool showSku;
  bool showProductImages;
  bool isEditable;
  bool displayAddToCart;
  bool displayTaxShippingInfo;
  List<WishListItem> items;
  List<String> warnings;
  CustomProperties customProperties;

  factory WishListData.fromJson(Map<String, dynamic> json) => WishListData(
    customerGuid: json["CustomerGuid"] == null ? null : json["CustomerGuid"],
    customerFullname: json["CustomerFullname"] == null ? null : json["CustomerFullname"],
    emailWishlistEnabled: json["EmailWishlistEnabled"] == null ? null : json["EmailWishlistEnabled"],
    showSku: json["ShowSku"] == null ? null : json["ShowSku"],
    showProductImages: json["ShowProductImages"] == null ? null : json["ShowProductImages"],
    isEditable: json["IsEditable"] == null ? null : json["IsEditable"],
    displayAddToCart: json["DisplayAddToCart"] == null ? null : json["DisplayAddToCart"],
    displayTaxShippingInfo: json["DisplayTaxShippingInfo"] == null ? null : json["DisplayTaxShippingInfo"],
    items: json["Items"] == null ? null : List<WishListItem>.from(json["Items"].map((x) => WishListItem.fromJson(x))),
    warnings: json["Warnings"] == null ? null : List<String>.from(json["Warnings"].map((x) => x)),
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "CustomerGuid": customerGuid == null ? null : customerGuid,
    "CustomerFullname": customerFullname == null ? null : customerFullname,
    "EmailWishlistEnabled": emailWishlistEnabled == null ? null : emailWishlistEnabled,
    "ShowSku": showSku == null ? null : showSku,
    "ShowProductImages": showProductImages == null ? null : showProductImages,
    "IsEditable": isEditable == null ? null : isEditable,
    "DisplayAddToCart": displayAddToCart == null ? null : displayAddToCart,
    "DisplayTaxShippingInfo": displayTaxShippingInfo == null ? null : displayTaxShippingInfo,
    "Items": items == null ? null : List<dynamic>.from(items.map((x) => x.toJson())),
    "Warnings": warnings == null ? null : List<dynamic>.from(warnings.map((x) => x)),
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class WishListItem {
  WishListItem({
    this.sku,
    this.picture,
    this.productId,
    this.productName,
    this.productSeName,
    this.unitPrice,
    this.subTotal,
    this.discount,
    this.maximumDiscountedQty,
    this.quantity,
    this.allowedQuantities,
    this.attributeInfo,
    this.recurringInfo,
    this.rentalInfo,
    this.allowItemEditing,
    this.warnings,
    this.id,
    this.customProperties,
  });

  String sku;
  PictureModel picture;
  int productId;
  String productName;
  String productSeName;
  String unitPrice;
  String subTotal;
  dynamic discount;
  dynamic maximumDiscountedQty;
  int quantity;
  List<AvailableOption> allowedQuantities;
  String attributeInfo;
  dynamic recurringInfo;
  dynamic rentalInfo;
  bool allowItemEditing;
  List<String> warnings;
  int id;
  CustomProperties customProperties;

  factory WishListItem.fromJson(Map<String, dynamic> json) => WishListItem(
    sku: json["Sku"] == null ? null : json["Sku"],
    picture: json["Picture"] == null ? null : PictureModel.fromJson(json["Picture"]),
    productId: json["ProductId"] == null ? null : json["ProductId"],
    productName: json["ProductName"] == null ? null : json["ProductName"],
    productSeName: json["ProductSeName"] == null ? null : json["ProductSeName"],
    unitPrice: json["UnitPrice"] == null ? null : json["UnitPrice"],
    subTotal: json["SubTotal"] == null ? null : json["SubTotal"],
    discount: json["Discount"],
    maximumDiscountedQty: json["MaximumDiscountedQty"],
    quantity: json["Quantity"] == null ? null : json["Quantity"],
    allowedQuantities: json["AllowedQuantities"] == null ? null : List<AvailableOption>.from(json["AllowedQuantities"].map((x) => AvailableOption.fromJson(x))),
    attributeInfo: json["AttributeInfo"] == null ? null : json["AttributeInfo"],
    recurringInfo: json["RecurringInfo"],
    rentalInfo: json["RentalInfo"],
    allowItemEditing: json["AllowItemEditing"] == null ? null : json["AllowItemEditing"],
    warnings: json["Warnings"] == null ? null : List<String>.from(json["Warnings"].map((x) => x)),
    id: json["Id"] == null ? null : json["Id"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "Sku": sku == null ? null : sku,
    "Picture": picture == null ? null : picture.toJson(),
    "ProductId": productId == null ? null : productId,
    "ProductName": productName == null ? null : productName,
    "ProductSeName": productSeName == null ? null : productSeName,
    "UnitPrice": unitPrice == null ? null : unitPrice,
    "SubTotal": subTotal == null ? null : subTotal,
    "Discount": discount,
    "MaximumDiscountedQty": maximumDiscountedQty,
    "Quantity": quantity == null ? null : quantity,
    "AllowedQuantities": allowedQuantities == null ? null : List<AvailableOption>.from(allowedQuantities.map((x) => x)),
    "AttributeInfo": attributeInfo == null ? null : attributeInfo,
    "RecurringInfo": recurringInfo,
    "RentalInfo": rentalInfo,
    "AllowItemEditing": allowItemEditing == null ? null : allowItemEditing,
    "Warnings": warnings == null ? null : List<dynamic>.from(warnings.map((x) => x)),
    "Id": id == null ? null : id,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}
