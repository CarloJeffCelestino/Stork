import 'package:nopcart_flutter/model/requestbody/FormValue.dart';

import '../GetBillingAddressResponse.dart';

class SaveBillingReqBody {
  SaveBillingReqBody({
    this.data,
    this.formValues,
  });

  SaveBillingData data;
  List<FormValue> formValues;

  factory SaveBillingReqBody.fromJson(Map<String, dynamic> json) => SaveBillingReqBody(
    data: json["Data"] == null ? null : SaveBillingData.fromJson(json["Data"]),
    formValues: json["FormValues"] == null ? null : List<FormValue>.from(json["FormValues"].map((x) => FormValue.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : data.toJson(),
    "FormValues": formValues == null ? null : List<dynamic>.from(formValues.map((x) => x.toJson())),
  };
}

class SaveBillingData {
  SaveBillingData({
    this.shipToSameAddress,
    this.billingNewAddress
  });

  bool shipToSameAddress;
  Address billingNewAddress;

  factory SaveBillingData.fromJson(Map<String, dynamic> json) => SaveBillingData(
    shipToSameAddress: json["ShipToSameAddress"] == null ? null : json["ShipToSameAddress"],
    billingNewAddress: json["BillingNewAddress"] == null ? null : Address.fromJson(json["BillingNewAddress"]),
  );

  Map<String, dynamic> toJson() => {
    "ShipToSameAddress": shipToSameAddress == null ? null : shipToSameAddress,
    "BillingNewAddress": billingNewAddress == null ? null : billingNewAddress,
  };
}
