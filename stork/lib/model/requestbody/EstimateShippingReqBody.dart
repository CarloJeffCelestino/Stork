import 'package:nopcart_flutter/model/EstimateShipping.dart';
import 'package:nopcart_flutter/model/requestbody/FormValue.dart';

class EstimateShippingReqBody {
  EstimateShippingReqBody({
    this.data,
    this.formValues,
  });

  EstimateShipping data;
  List<FormValue> formValues;

  factory EstimateShippingReqBody.fromJson(Map<String, dynamic> json) =>
      EstimateShippingReqBody(
        data: json["Data"] == null ? null : EstimateShipping.fromJson(json["Data"]),
        formValues: json["FormValues"] == null ? null : List<FormValue>.from(json["FormValues"].map((x) => FormValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Data": data == null ? null : data.toJson(),
        "FormValues": formValues == null ? null : List<dynamic>.from(formValues.map((x) => x.toJson())),
      };
}
