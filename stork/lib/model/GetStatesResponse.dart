import 'package:nopcart_flutter/model/CustomProperties.dart';

class GetStatesResponse {
  GetStatesResponse({
    this.data,
    this.message,
    this.errorList,
  });

  List<AvailableStates> data;
  String message;
  List<String> errorList;

  factory GetStatesResponse.fromJson(Map<String, dynamic> json) => GetStatesResponse(
    data: json["Data"] == null ? null : List<AvailableStates>.from(json["Data"].map((x) => AvailableStates.fromJson(x))),
    message: json["Message"] == null ? null : json["Message"],
    errorList: json["ErrorList"] == null ? null : List<String>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    "Message": message == null ? null : message,
    "ErrorList": errorList == null ? null : List<dynamic>.from(errorList.map((x) => x)),
  };
}

class AvailableStates {
  AvailableStates({
    this.id,
    this.name,
    this.customProperties,
  });

  int id;
  String name;
  CustomProperties customProperties;

  factory AvailableStates.fromJson(Map<String, dynamic> json) => AvailableStates(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

