class EstimateShippingResponse {
  EstimateShippingResponse({
    this.data,
    this.message,
    this.errorList,
  });

  EstimateShippingData data;
  String message;
  List<String> errorList;

  factory EstimateShippingResponse.fromJson(Map<String, dynamic> json) => EstimateShippingResponse(
    data: json["Data"] == null ? null : EstimateShippingData.fromJson(json["Data"]),
    message: json["Message"] == null ? null : json["Message"],
    errorList: json["ErrorList"] == null ? null : List<String>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : data.toJson(),
    "Message": message == null ? null : message,
    "ErrorList": errorList == null ? null : List<dynamic>.from(errorList.map((x) => x)),
  };
}

class EstimateShippingData {
  EstimateShippingData({
    this.shippingOptions,
    this.success,
    this.errors,
    this.customProperties,
  });

  List<ShippingOption> shippingOptions;
  bool success;
  List<dynamic> errors;
  CustomProperties customProperties;

  factory EstimateShippingData.fromJson(Map<String, dynamic> json) => EstimateShippingData(
    shippingOptions: json["ShippingOptions"] == null ? null : List<ShippingOption>.from(json["ShippingOptions"].map((x) => ShippingOption.fromJson(x))),
    success: json["Success"] == null ? null : json["Success"],
    errors: json["Errors"] == null ? null : List<dynamic>.from(json["Errors"].map((x) => x)),
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "ShippingOptions": shippingOptions == null ? null : List<dynamic>.from(shippingOptions.map((x) => x.toJson())),
    "Success": success == null ? null : success,
    "Errors": errors == null ? null : List<dynamic>.from(errors.map((x) => x)),
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class CustomProperties {
  CustomProperties();

  factory CustomProperties.fromJson(Map<String, dynamic> json) => CustomProperties(
  );

  Map<String, dynamic> toJson() => {
  };
}

class ShippingOption {
  ShippingOption({
    this.deliveryDateFormat,
    this.description,
    this.name,
    this.price,
    this.rate,
    this.selected,
    this.shippingRateComputationMethodSystemName,
  });

  dynamic deliveryDateFormat;
  String description;
  String name;
  String price;
  num rate;
  bool selected;
  String shippingRateComputationMethodSystemName;

  factory ShippingOption.fromJson(Map<String, dynamic> json) => ShippingOption(
    deliveryDateFormat: json["DeliveryDateFormat"],
    description: json["Description"] == null ? null : json["Description"],
    name: json["Name"] == null ? null : json["Name"],
    price: json["Price"] == null ? null : json["Price"],
    rate: json["Rate"] == null ? null : json["Rate"],
    selected: json["Selected"] == null ? null : json["Selected"],
    shippingRateComputationMethodSystemName: json["ShippingRateComputationMethodSystemName"] == null ? null : json["ShippingRateComputationMethodSystemName"],
  );

  Map<String, dynamic> toJson() => {
    "DeliveryDateFormat": deliveryDateFormat,
    "Description": description == null ? null : description,
    "Name": name == null ? null : name,
    "Price": price == null ? null : price,
    "Rate": rate == null ? null : rate,
    "Selected": selected == null ? null : selected,
    "ShippingRateComputationMethodSystemName": shippingRateComputationMethodSystemName == null ? null : shippingRateComputationMethodSystemName,
  };
}
