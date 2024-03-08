import 'FormValue.dart';

class SavePaymentReqBody {
  SavePaymentReqBody({
    this.data,
    this.formValues,
  });

  SavePaymentData data;
  List<FormValue> formValues;

  factory SavePaymentReqBody.fromJson(Map<String, dynamic> json) => SavePaymentReqBody(
    data: json["Data"] == null ? null : SavePaymentData.fromJson(json["Data"]),
    formValues: json["FormValues"] == null ? null : List<FormValue>.from(json["FormValues"].map((x) => FormValue.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : data.toJson(),
    "FormValues": formValues == null ? null : List<dynamic>.from(formValues.map((x) => x.toJson())),
  };
}

class SavePaymentData {
  SavePaymentData({
    this.useRewardPoints,
  });

  bool useRewardPoints;

  factory SavePaymentData.fromJson(Map<String, dynamic> json) => SavePaymentData(
    useRewardPoints: json["UseRewardPoints"] == null ? null : json["UseRewardPoints"],
  );

  Map<String, dynamic> toJson() => {
    "UseRewardPoints": useRewardPoints == null ? null : useRewardPoints,
  };
}
