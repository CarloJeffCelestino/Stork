import 'package:nopcart_flutter/model/requestbody/FormValue.dart';

class FormValuesRequestBody {
  FormValuesRequestBody({
    this.formValues,
  });

  List<FormValue> formValues;

  factory FormValuesRequestBody.fromJson(Map<String, dynamic> json) =>
      FormValuesRequestBody(
        formValues: List<FormValue>.from(
            json["FormValues"].map((x) => FormValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "FormValues": List<dynamic>.from(formValues.map((x) => x.toJson())),
      };
}
