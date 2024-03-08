import 'package:nopcart_flutter/model/CustomProperties.dart';

class PictureModel {
  PictureModel({
    this.imageUrl,
    this.thumbImageUrl,
    this.fullSizeImageUrl,
    this.title,
    this.alternateText,
    this.customProperties,
  });

  String imageUrl;
  String thumbImageUrl;
  String fullSizeImageUrl;
  String title;
  String alternateText;
  CustomProperties customProperties;

  factory PictureModel.fromJson(Map<String, dynamic> json) {
    if(json == null) return null;

    return PictureModel(
      imageUrl: json["ImageUrl"] == null ? null : json["ImageUrl"],
      thumbImageUrl:
          json["ThumbImageUrl"] == null ? null : json["ThumbImageUrl"],
      fullSizeImageUrl:
          json["FullSizeImageUrl"] == null ? null : json["FullSizeImageUrl"],
      title: json["Title"] == null ? null : json["Title"],
      alternateText:
          json["AlternateText"] == null ? null : json["AlternateText"],
      customProperties: CustomProperties.fromJson(json["CustomProperties"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "ImageUrl": imageUrl == null ? null : imageUrl,
    "ThumbImageUrl": thumbImageUrl == null ? null : thumbImageUrl,
    "FullSizeImageUrl": fullSizeImageUrl == null ? null : fullSizeImageUrl,
    "Title": title == null ? null : title,
    "AlternateText": alternateText == null ? null : alternateText,
    "CustomProperties": customProperties.toJson(),
  };
}