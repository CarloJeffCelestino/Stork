class AvailableOption {
  AvailableOption({
    this.disabled,
    this.group,
    this.selected,
    this.text,
    this.value,
  });

  bool disabled;
  dynamic group;
  bool selected;
  String text;
  String value;

  AvailableOption copyWith({
    bool disabled,
    dynamic group,
    bool selected,
    String text,
    String value,
  }) =>
      AvailableOption(
        disabled: disabled ?? this.disabled,
        group: group ?? this.group,
        selected: selected ?? this.selected,
        text: text ?? this.text,
        value: value ?? this.value,
      );

  factory AvailableOption.fromJson(Map<String, dynamic> json) => AvailableOption(
    disabled: json["Disabled"] == null ? null : json["Disabled"],
    group: json["Group"],
    selected: json["Selected"] == null ? null : json["Selected"],
    text: json["Text"] == null ? null : json["Text"],
    value: json["Value"] == null ? null : json["Value"],
  );

  Map<String, dynamic> toJson() => {
    "Disabled": disabled == null ? null : disabled,
    "Group": group,
    "Selected": selected == null ? null : selected,
    "Text": text == null ? null : text,
    "Value": value == null ? null : value,
  };
}