import 'package:nopcart_flutter/model/ReturnRequestResponse.dart';
import 'package:nopcart_flutter/model/requestbody/FormValue.dart';

class ReturnRequestBody {
  ReturnRequestBody({
    this.data,
    this.formValues,
  });

  ReturnRequestData data;
  List<FormValue> formValues;

  factory ReturnRequestBody.fromJson(Map<String, dynamic> json) => ReturnRequestBody(
    data: json["Data"] == null ? null : ReturnRequestData.fromJson(json["Data"]),
    formValues: json["FormValues"] == null ? null : List<FormValue>.from(json["FormValues"].map((x) => FormValue.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : data.toJson(),
    "FormValues": formValues == null ? null : List<dynamic>.from(formValues.map((x) => x.toJson())),
  };
}
