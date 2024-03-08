import 'package:nopcart_flutter/model/AvailableOption.dart';
import 'package:nopcart_flutter/model/CustomAttribute.dart';
import 'package:nopcart_flutter/model/CustomProperties.dart';
import 'package:nopcart_flutter/model/EstimateShipping.dart';
import 'package:nopcart_flutter/model/GetBillingAddressResponse.dart';
import 'package:nopcart_flutter/model/PictureModel.dart';

class ShoppingCartResponse {
  ShoppingCartResponse({
    this.data,
    this.message,
    this.errorList,
  });

  CartData data;
  String message;
  List<String> errorList;

  factory ShoppingCartResponse.fromJson(Map<String, dynamic> json) => ShoppingCartResponse(
    data: json["Data"] == null ? null : CartData.fromJson(json["Data"]),
    message: json["Message"] == null ? null : json["Message"],
    errorList: json["ErrorList"] == null ? null : List<String>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : data.toJson(),
    "Message": message == null ? null : message,
    "ErrorList": errorList == null ? null : List<dynamic>.from(errorList.map((x) => x)),
  };
}

class CartData {
  CartData({
    this.cart,
    this.orderTotals,
    this.selectedCheckoutAttributes,
    this.estimateShipping,
  });

  Cart cart;
  OrderTotals orderTotals;
  String selectedCheckoutAttributes;
  EstimateShipping estimateShipping;

  factory CartData.fromJson(Map<String, dynamic> json) => CartData(
    cart: json["Cart"] == null ? null : Cart.fromJson(json["Cart"]),
    orderTotals: json["OrderTotals"] == null ? null : OrderTotals.fromJson(json["OrderTotals"]),
    selectedCheckoutAttributes: json["SelectedCheckoutAttributes"] == null ? null : json["SelectedCheckoutAttributes"],
    estimateShipping: json["EstimateShipping"] == null ? null : EstimateShipping.fromJson(json["EstimateShipping"]),
  );

  Map<String, dynamic> toJson() => {
    "Cart": cart == null ? null : cart.toJson(),
    "OrderTotals": orderTotals == null ? null : orderTotals.toJson(),
    "SelectedCheckoutAttributes": selectedCheckoutAttributes == null ? null : selectedCheckoutAttributes,
    "EstimateShipping": estimateShipping == null ? null : estimateShipping.toJson(),
  };
}

class Cart {
  Cart({
    this.onePageCheckoutEnabled,
    this.showSku,
    this.showProductImages,
    this.isEditable,
    this.items,
    this.checkoutAttributes,
    this.warnings,
    this.minOrderSubtotalWarning,
    this.displayTaxShippingInfo,
    this.termsOfServiceOnShoppingCartPage,
    this.termsOfServiceOnOrderConfirmPage,
    this.termsOfServicePopup,
    this.discountBox,
    this.giftCardBox,
    this.orderReviewData,
    this.buttonPaymentMethodViewComponentNames,
    this.hideCheckoutButton,
    this.showVendorName,
    this.customProperties,
  });

  bool onePageCheckoutEnabled;
  bool showSku;
  bool showProductImages;
  bool isEditable;
  List<CartItem> items;
  List<CustomAttribute> checkoutAttributes;
  List<String> warnings;
  String minOrderSubtotalWarning;
  bool displayTaxShippingInfo;
  bool termsOfServiceOnShoppingCartPage;
  bool termsOfServiceOnOrderConfirmPage;
  bool termsOfServicePopup;
  DiscountBox discountBox;
  GiftCardBox giftCardBox;
  OrderReviewData orderReviewData;
  List<dynamic> buttonPaymentMethodViewComponentNames;
  bool hideCheckoutButton;
  bool showVendorName;
  CustomProperties customProperties;

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
    onePageCheckoutEnabled: json["OnePageCheckoutEnabled"] == null ? null : json["OnePageCheckoutEnabled"],
    showSku: json["ShowSku"] == null ? null : json["ShowSku"],
    showProductImages: json["ShowProductImages"] == null ? null : json["ShowProductImages"],
    isEditable: json["IsEditable"] == null ? null : json["IsEditable"],
    items: json["Items"] == null ? null : List<CartItem>.from(json["Items"].map((x) => CartItem.fromJson(x))),
    checkoutAttributes: json["CheckoutAttributes"] == null ? null : List<CustomAttribute>.from(json["CheckoutAttributes"].map((x) => CustomAttribute.fromJson(x))),
    warnings: json["Warnings"] == null ? null : List<String>.from(json["Warnings"].map((x) => x)),
    minOrderSubtotalWarning: json["MinOrderSubtotalWarning"],
    displayTaxShippingInfo: json["DisplayTaxShippingInfo"] == null ? null : json["DisplayTaxShippingInfo"],
    termsOfServiceOnShoppingCartPage: json["TermsOfServiceOnShoppingCartPage"] == null ? null : json["TermsOfServiceOnShoppingCartPage"],
    termsOfServiceOnOrderConfirmPage: json["TermsOfServiceOnOrderConfirmPage"] == null ? null : json["TermsOfServiceOnOrderConfirmPage"],
    termsOfServicePopup: json["TermsOfServicePopup"] == null ? null : json["TermsOfServicePopup"],
    discountBox: json["DiscountBox"] == null ? null : DiscountBox.fromJson(json["DiscountBox"]),
    giftCardBox: json["GiftCardBox"] == null ? null : GiftCardBox.fromJson(json["GiftCardBox"]),
    orderReviewData: json["OrderReviewData"] == null ? null : OrderReviewData.fromJson(json["OrderReviewData"]),
    buttonPaymentMethodViewComponentNames: json["ButtonPaymentMethodViewComponentNames"] == null ? null : List<dynamic>.from(json["ButtonPaymentMethodViewComponentNames"].map((x) => x)),
    hideCheckoutButton: json["HideCheckoutButton"] == null ? null : json["HideCheckoutButton"],
    showVendorName: json["ShowVendorName"] == null ? null : json["ShowVendorName"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "OnePageCheckoutEnabled": onePageCheckoutEnabled == null ? null : onePageCheckoutEnabled,
    "ShowSku": showSku == null ? null : showSku,
    "ShowProductImages": showProductImages == null ? null : showProductImages,
    "IsEditable": isEditable == null ? null : isEditable,
    "Items": items == null ? null : List<dynamic>.from(items.map((x) => x.toJson())),
    "CheckoutAttributes": checkoutAttributes == null ? null : List<dynamic>.from(checkoutAttributes.map((x) => x.toJson())),
    "Warnings": warnings == null ? null : List<dynamic>.from(warnings.map((x) => x)),
    "MinOrderSubtotalWarning": minOrderSubtotalWarning,
    "DisplayTaxShippingInfo": displayTaxShippingInfo == null ? null : displayTaxShippingInfo,
    "TermsOfServiceOnShoppingCartPage": termsOfServiceOnShoppingCartPage == null ? null : termsOfServiceOnShoppingCartPage,
    "TermsOfServiceOnOrderConfirmPage": termsOfServiceOnOrderConfirmPage == null ? null : termsOfServiceOnOrderConfirmPage,
    "TermsOfServicePopup": termsOfServicePopup == null ? null : termsOfServicePopup,
    "DiscountBox": discountBox == null ? null : discountBox.toJson(),
    "GiftCardBox": giftCardBox == null ? null : giftCardBox.toJson(),
    "OrderReviewData": orderReviewData == null ? null : orderReviewData.toJson(),
    "ButtonPaymentMethodViewComponentNames": buttonPaymentMethodViewComponentNames == null ? null : List<dynamic>.from(buttonPaymentMethodViewComponentNames.map((x) => x)),
    "HideCheckoutButton": hideCheckoutButton == null ? null : hideCheckoutButton,
    "ShowVendorName": showVendorName == null ? null : showVendorName,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class DiscountBox {
  DiscountBox({
    this.appliedDiscountsWithCodes,
    this.display,
    this.messages,
    this.isApplied,
    this.customProperties,
  });

  List<AppliedDiscountsWithCode> appliedDiscountsWithCodes;
  bool display;
  List<String> messages;
  bool isApplied;
  CustomProperties customProperties;

  factory DiscountBox.fromJson(Map<String, dynamic> json) => DiscountBox(
    appliedDiscountsWithCodes: json["AppliedDiscountsWithCodes"] == null ? null : List<AppliedDiscountsWithCode>.from(json["AppliedDiscountsWithCodes"].map((x) => AppliedDiscountsWithCode.fromJson(x))),
    display: json["Display"] == null ? null : json["Display"],
    messages: json["Messages"] == null ? null : List<String>.from(json["Messages"].map((x) => x)),
    isApplied: json["IsApplied"] == null ? null : json["IsApplied"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "AppliedDiscountsWithCodes": appliedDiscountsWithCodes == null ? null : List<dynamic>.from(appliedDiscountsWithCodes.map((x) => x.toJson())),
    "Display": display == null ? null : display,
    "Messages": messages == null ? null : List<dynamic>.from(messages.map((x) => x)),
    "IsApplied": isApplied == null ? null : isApplied,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class AppliedDiscountsWithCode {
  AppliedDiscountsWithCode({
    this.couponCode,
    this.id,
    this.customProperties,
  });

  String couponCode;
  int id;
  CustomProperties customProperties;

  factory AppliedDiscountsWithCode.fromJson(Map<String, dynamic> json) => AppliedDiscountsWithCode(
    couponCode: json["CouponCode"],
    id: json["Id"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "CouponCode": couponCode,
    "Id": id,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class GiftCardBox {
  GiftCardBox({
    this.display,
    this.message,
    this.isApplied,
    this.customProperties,
  });

  bool display;
  String message;
  bool isApplied;
  CustomProperties customProperties;

  factory GiftCardBox.fromJson(Map<String, dynamic> json) => GiftCardBox(
    display: json["Display"] == null ? null : json["Display"],
    message: json["Message"] == null ? null : json["Message"],
    isApplied: json["IsApplied"] == null ? null : json["IsApplied"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "Display": display == null ? null : display,
    "Message": message == null ? null : message,
    "IsApplied": isApplied == null ? null : isApplied,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class CartItem {
  CartItem({
    this.sku,
    this.vendorName,
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
    this.disableRemoval,
    this.warnings,
    this.id,
    this.customProperties,
  });

  String sku;
  String vendorName;
  PictureModel picture;
  int productId;
  String productName;
  String productSeName;
  String unitPrice;
  String subTotal;
  String discount;
  dynamic maximumDiscountedQty;
  int quantity;
  List<AvailableOption> allowedQuantities;
  String attributeInfo;
  dynamic recurringInfo;
  dynamic rentalInfo;
  bool allowItemEditing;
  bool disableRemoval;
  List<String> warnings;
  int id;
  CustomProperties customProperties;

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    sku: json["Sku"] == null ? null : json["Sku"],
    vendorName: json["VendorName"] == null ? null : json["VendorName"],
    picture: json["Picture"] == null ? null : PictureModel.fromJson(json["Picture"]),
    productId: json["ProductId"] == null ? null : json["ProductId"],
    productName: json["ProductName"] == null ? null : json["ProductName"],
    productSeName: json["ProductSeName"] == null ? null : json["ProductSeName"],
    unitPrice: json["UnitPrice"] == null ? null : json["UnitPrice"],
    subTotal: json["SubTotal"] == null ? null : json["SubTotal"],
    discount: json["Discount"] == null ? null : json["Discount"],
    maximumDiscountedQty: json["MaximumDiscountedQty"] == null ? null : json["MaximumDiscountedQty"],
    quantity: json["Quantity"] == null ? null : json["Quantity"],
    allowedQuantities: json["AllowedQuantities"] == null ? null : List<AvailableOption>.from(json["AllowedQuantities"].map((x) => AvailableOption.fromJson(x))),
    attributeInfo: json["AttributeInfo"] == null ? null : json["AttributeInfo"],
    recurringInfo: json["RecurringInfo"],
    rentalInfo: json["RentalInfo"],
    allowItemEditing: json["AllowItemEditing"] == null ? null : json["AllowItemEditing"],
    disableRemoval: json["DisableRemoval"] == null ? null : json["DisableRemoval"],
    warnings: json["Warnings"] == null ? null : List<String>.from(json["Warnings"].map((x) => x)),
    id: json["Id"] == null ? null : json["Id"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "Sku": sku == null ? null : sku,
    "VendorName": vendorName == null ? null : vendorName,
    "Picture": picture == null ? null : picture.toJson(),
    "ProductId": productId == null ? null : productId,
    "ProductName": productName == null ? null : productName,
    "ProductSeName": productSeName == null ? null : productSeName,
    "UnitPrice": unitPrice == null ? null : unitPrice,
    "SubTotal": subTotal == null ? null : subTotal,
    "Discount": discount == null ? null : discount,
    "MaximumDiscountedQty": maximumDiscountedQty == null ? null : maximumDiscountedQty,
    "Quantity": quantity == null ? null : quantity,
    "AllowedQuantities": allowedQuantities == null ? null : List<dynamic>.from(allowedQuantities.map((x) => x.toJson())),
    "AttributeInfo": attributeInfo == null ? null : attributeInfo,
    "RecurringInfo": recurringInfo,
    "RentalInfo": rentalInfo,
    "AllowItemEditing": allowItemEditing == null ? null : allowItemEditing,
    "DisableRemoval": disableRemoval == null ? null : disableRemoval,
    "Warnings": warnings == null ? null : List<dynamic>.from(warnings.map((x) => x)),
    "Id": id == null ? null : id,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class OrderReviewData {
  OrderReviewData({
    this.display,
    this.billingAddress,
    this.isShippable,
    this.shippingAddress,
    this.selectedPickupInStore,
    this.pickupAddress,
    this.shippingMethod,
    this.paymentMethod,
    this.customValues,
    this.customProperties,
  });

  bool display;
  Address billingAddress;
  bool isShippable;
  Address shippingAddress;
  bool selectedPickupInStore;
  Address pickupAddress;
  String shippingMethod;
  String paymentMethod;
  CustomProperties customValues;
  CustomProperties customProperties;

  factory OrderReviewData.fromJson(Map<String, dynamic> json) => OrderReviewData(
    display: json["Display"] == null ? null : json["Display"],
    billingAddress: json["BillingAddress"] == null ? null : Address.fromJson(json["BillingAddress"]),
    isShippable: json["IsShippable"] == null ? null : json["IsShippable"],
    shippingAddress: json["ShippingAddress"] == null ? null : Address.fromJson(json["ShippingAddress"]),
    selectedPickupInStore: json["SelectedPickupInStore"] == null ? null : json["SelectedPickupInStore"],
    pickupAddress: json["PickupAddress"] == null ? null : Address.fromJson(json["PickupAddress"]),
    shippingMethod: json["ShippingMethod"] == null ? null : json["ShippingMethod"],
    paymentMethod: json["PaymentMethod"] == null ? null : json["PaymentMethod"],
    customValues: json["CustomValues"] == null ? null : CustomProperties.fromJson(json["CustomValues"]),
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "Display": display == null ? null : display,
    "BillingAddress": billingAddress == null ? null : billingAddress.toJson(),
    "IsShippable": isShippable == null ? null : isShippable,
    "ShippingAddress": shippingAddress == null ? null : shippingAddress.toJson(),
    "SelectedPickupInStore": selectedPickupInStore == null ? null : selectedPickupInStore,
    "PickupAddress": pickupAddress == null ? null : pickupAddress.toJson(),
    "ShippingMethod": shippingMethod == null ? null : shippingMethod,
    "PaymentMethod": paymentMethod == null ? null : paymentMethod,
    "CustomValues": customValues == null ? null : customValues.toJson(),
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class OrderTotals {
  OrderTotals({
    this.isEditable,
    this.subTotal,
    this.subTotalDiscount,
    this.shipping,
    this.requiresShipping,
    this.selectedShippingMethod,
    this.hideShippingTotal,
    this.paymentMethodAdditionalFee,
    this.tax,
    this.taxRates,
    this.displayTax,
    this.displayTaxRates,
    this.giftCards,
    this.orderTotalDiscount,
    this.redeemedRewardPoints,
    this.redeemedRewardPointsAmount,
    this.willEarnRewardPoints,
    this.orderTotal,
    this.customProperties,
  });

  bool isEditable;
  String subTotal;
  String subTotalDiscount;
  String shipping;
  bool requiresShipping;
  String selectedShippingMethod;
  bool hideShippingTotal;
  String paymentMethodAdditionalFee;
  String tax;
  List<TaxRate> taxRates;
  bool displayTax;
  bool displayTaxRates;
  List<GiftCard> giftCards;
  String orderTotalDiscount;
  num redeemedRewardPoints;
  String redeemedRewardPointsAmount;
  num willEarnRewardPoints;
  String orderTotal;
  CustomProperties customProperties;

  factory OrderTotals.fromJson(Map<String, dynamic> json) => OrderTotals(
    isEditable: json["IsEditable"] == null ? null : json["IsEditable"],
    subTotal: json["SubTotal"] == null ? null : json["SubTotal"],
    subTotalDiscount: json["SubTotalDiscount"],
    shipping: json["Shipping"] == null ? null : json["Shipping"],
    requiresShipping: json["RequiresShipping"] == null ? null : json["RequiresShipping"],
    selectedShippingMethod: json["SelectedShippingMethod"] == null ? null : json["SelectedShippingMethod"],
    hideShippingTotal: json["HideShippingTotal"] == null ? null : json["HideShippingTotal"],
    paymentMethodAdditionalFee: json["PaymentMethodAdditionalFee"] == null ? null : json["PaymentMethodAdditionalFee"],
    tax: json["Tax"] == null ? null : json["Tax"],
    taxRates: json["TaxRates"] == null ? null : List<TaxRate>.from(json["TaxRates"].map((x) => TaxRate.fromJson(x))),
    displayTax: json["DisplayTax"] == null ? null : json["DisplayTax"],
    displayTaxRates: json["DisplayTaxRates"] == null ? null : json["DisplayTaxRates"],
    giftCards: json["GiftCards"] == null ? null : List<GiftCard>.from(json["GiftCards"].map((x) => GiftCard.fromJson(x))),
    orderTotalDiscount: json["OrderTotalDiscount"] == null ? null : json["OrderTotalDiscount"],
    redeemedRewardPoints: json["RedeemedRewardPoints"] == null ? null : json["RedeemedRewardPoints"],
    redeemedRewardPointsAmount: json["RedeemedRewardPointsAmount"],
    willEarnRewardPoints: json["WillEarnRewardPoints"] == null ? null : json["WillEarnRewardPoints"],
    orderTotal: json["OrderTotal"] == null ? null : json["OrderTotal"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "IsEditable": isEditable == null ? null : isEditable,
    "SubTotal": subTotal == null ? null : subTotal,
    "SubTotalDiscount": subTotalDiscount,
    "Shipping": shipping == null ? null : shipping,
    "RequiresShipping": requiresShipping == null ? null : requiresShipping,
    "SelectedShippingMethod": selectedShippingMethod == null ? null : selectedShippingMethod,
    "HideShippingTotal": hideShippingTotal == null ? null : hideShippingTotal,
    "PaymentMethodAdditionalFee": paymentMethodAdditionalFee == null ? null : paymentMethodAdditionalFee,
    "Tax": tax == null ? null : tax,
    "TaxRates": taxRates == null ? null : List<dynamic>.from(taxRates.map((x) => x.toJson())),
    "DisplayTax": displayTax == null ? null : displayTax,
    "DisplayTaxRates": displayTaxRates == null ? null : displayTaxRates,
    "GiftCards": giftCards == null ? null : List<dynamic>.from(giftCards.map((x) => x)),
    "OrderTotalDiscount": orderTotalDiscount == null ? null : orderTotalDiscount,
    "RedeemedRewardPoints": redeemedRewardPoints == null ? null : redeemedRewardPoints,
    "RedeemedRewardPointsAmount": redeemedRewardPointsAmount,
    "WillEarnRewardPoints": willEarnRewardPoints == null ? null : willEarnRewardPoints,
    "OrderTotal": orderTotal == null ? null : orderTotal,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class GiftCard {
  GiftCard({
    this.couponCode,
    this.amount,
    this.id,
    this.remaining,
  });

  String couponCode;
  String amount;
  num id;
  String remaining;

  factory GiftCard.fromJson(Map<String, dynamic> json) => GiftCard(
    couponCode: json["CouponCode"],
    amount: json["Amount"],
    id: json["Id"],
    remaining: json["Remaining"],
  );

  Map<String, dynamic> toJson() => {
    "CouponCode": couponCode,
    "Amount": amount,
    "Id": id,
    "Remaining": remaining,
  };
}


class TaxRate {
  TaxRate({
    this.rate,
    this.value,
    this.customProperties,
  });

  String rate;
  String value;
  CustomProperties customProperties;

  factory TaxRate.fromJson(Map<String, dynamic> json) => TaxRate(
    rate: json["Rate"] == null ? null : json["Rate"],
    value: json["Value"] == null ? null : json["Value"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "Rate": rate == null ? null : rate,
    "Value": value == null ? null : value,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}


