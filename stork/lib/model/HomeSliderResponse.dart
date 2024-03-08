class HomeSliderResponse {
  HomeSliderResponse({
    this.data,
    this.message,
    this.errorList,
  });

  HomeSliderData data;
  String message;
  List<String> errorList;

  factory HomeSliderResponse.fromJson(Map<String, dynamic> json) => HomeSliderResponse(
    data: json["Data"] == null ? null : HomeSliderData.fromJson(json["Data"]),
    message: json["Message"],
    errorList: json["ErrorList"] == null ? null : List<String>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : data.toJson(),
    "Message": message,
    "ErrorList": errorList == null ? null : List<String>.from(errorList.map((x) => x)),
  };
}

class HomeSliderData {
  HomeSliderData({
    this.isEnabled,
    this.sliders,
  });

  bool isEnabled;
  List<Sliders> sliders;

  factory HomeSliderData.fromJson(Map<String, dynamic> json) => HomeSliderData(
    isEnabled: json["IsEnabled"] == null ? null : json["IsEnabled"],
    sliders: json["Sliders"] == null ? null : List<Sliders>.from(json["Sliders"].map((x) => Sliders.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "IsEnabled": isEnabled == null ? null : isEnabled,
    "Sliders": sliders == null ? null : List<dynamic>.from(sliders.map((x) => x.toJson())),
  };
}

class Sliders {
  Sliders({
    this.imageUrl,
    this.sliderType,
    this.entityId,
    this.id,
    this.displayOrder
  });

  String imageUrl;
  int sliderType;
  int entityId;
  int id;
  int displayOrder;

  factory Sliders.fromJson(Map<String, dynamic> json) => Sliders(
    imageUrl: json["ImageUrl"] == null ? null : json["ImageUrl"],
    sliderType: json["SliderType"] == null ? null : json["SliderType"],
    entityId: json["EntityId"] == null ? null : json["EntityId"],
    id: json["Id"] == null ? null : json["Id"],
    displayOrder: json["DisplayOrder"] == null ? null : json["DisplayOrder"],
  );

  Map<String, dynamic> toJson() => {
    "ImageUrl": imageUrl == null ? null : imageUrl,
    "SliderType": sliderType == null ? null : sliderType,
    "EntityId": entityId == null ? null : entityId,
    "Id": id == null ? null : id,
    "DisplayOrder": displayOrder == null ? null : displayOrder,
  };
}
