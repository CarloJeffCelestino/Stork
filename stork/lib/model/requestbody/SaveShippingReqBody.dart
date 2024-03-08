import 'package:nopcart_flutter/model/GetBillingAddressResponse.dart';

import 'FormValue.dart';

class SaveShippingReqBody {
  SaveShippingReqBody({
    this.data,
    this.formValues,
  });

  SaveShippingReqData data;
  List<FormValue> formValues;

  factory SaveShippingReqBody.fromJson(Map<String, dynamic> json) => SaveShippingReqBody(
    data: json["Data"] == null ? null : SaveShippingReqData.fromJson(json["Data"]),
    formValues: json["FormValues"] == null ? null : List<FormValue>.from(json["FormValues"].map((x) => FormValue.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : data.toJson(),
    "FormValues": formValues == null ? null : List<dynamic>.from(formValues.map((x) => x.toJson())),
  };
}

class SaveShippingReqData {
  SaveShippingReqData({
    // this.pickupInStore,
    this.shippingNewAddress,
  });

  // bool pickupInStore;
  Address shippingNewAddress;

  factory SaveShippingReqData.fromJson(Map<String, dynamic> json) => SaveShippingReqData(
    // pickupInStore: json["PickupInStore"] == null ? null : json["PickupInStore"],
    shippingNewAddress: json["ShippingNewAddress"] == null ? null : Address.fromJson(json["ShippingNewAddress"]),
  );

  Map<String, dynamic> toJson() => {
    // "PickupInStore": pickupInStore == null ? null : pickupInStore,
    "ShippingNewAddress": shippingNewAddress == null ? null : shippingNewAddress,
  };
}

