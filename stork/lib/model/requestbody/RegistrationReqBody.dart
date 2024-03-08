import 'package:nopcart_flutter/model/RegisterFormResponse.dart';
import 'package:nopcart_flutter/model/requestbody/FormValue.dart';

class RegistrationReqBody {
  RegistrationReqBody({
    this.data,
    this.formValues,
  });

  RegisterFormData data;
  List<FormValue> formValues;

  factory RegistrationReqBody.fromJson(Map<String, dynamic> json) => RegistrationReqBody(
    data: RegisterFormData.fromJson(json["Data"]),
    formValues: List<FormValue>.from(json["FormValues"].map((x) => FormValue.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Data": data.toJson(),
    "FormValues": List<dynamic>.from(formValues.map((x) => x.toJson())),
  };
}





