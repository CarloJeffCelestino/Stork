import 'package:nopcart_flutter/model/ShoppingCartResponse.dart';

class PostCheckoutAttrResponse {
  PostCheckoutAttrResponse({
    this.cart,
    this.orderTotals,
    this.selectedCheckoutAttributess,
    this.enabledAttributeIds,
    this.disabledAttributeIds
  });

  Cart cart;
  OrderTotals orderTotals;
  String selectedCheckoutAttributess;
  List<dynamic> enabledAttributeIds;
  List<dynamic> disabledAttributeIds;

  factory PostCheckoutAttrResponse.fromJson(Map<String, dynamic> json) => PostCheckoutAttrResponse(
    cart: json["Cart"] == null ? null : Cart.fromJson(json["Cart"]),
    orderTotals: json["OrderTotals"] == null ? null : OrderTotals.fromJson(json["OrderTotals"]),
    selectedCheckoutAttributess: json["SelectedCheckoutAttributess"] == null ? null : json["SelectedCheckoutAttributess"],
    enabledAttributeIds: json["EnabledAttributeIds"] == null ? null : List<dynamic>.from(json["EnabledAttributeIds"].map((x) => x)),
    disabledAttributeIds: json["DisabledAttributeIds"] == null ? null : List<dynamic>.from(json["DisabledAttributeIds"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Cart": cart == null ? null : cart.toJson(),
    "OrderTotals": orderTotals == null ? null : orderTotals.toJson(),
    "SelectedCheckoutAttributess": selectedCheckoutAttributess == null ? null : selectedCheckoutAttributess,
    "EnabledAttributeIds": enabledAttributeIds == null ? null : List<dynamic>.from(enabledAttributeIds.map((x) => x)),
    "DisabledAttributeIds": disabledAttributeIds == null ? null : List<dynamic>.from(disabledAttributeIds.map((x) => x)),
  };
}