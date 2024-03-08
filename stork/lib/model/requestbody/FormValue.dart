class FormValue {
  FormValue({
    this.key,
    this.value,
  });

  String key;
  String value;

  factory FormValue.fromJson(Map<String, dynamic> json) => FormValue(
        key: json["Key"],
        value: json["Value"],
      );

  Map<String, dynamic> toJson() => {
        "Key": key,
        "Value": value,
      };
}
