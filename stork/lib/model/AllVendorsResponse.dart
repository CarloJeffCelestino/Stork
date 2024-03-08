import 'package:nopcart_flutter/model/CustomProperties.dart';
import 'package:nopcart_flutter/model/PictureModel.dart';
import 'package:nopcart_flutter/model/product_list/ProductListResponse.dart';

class AllVendorsResponse {
  AllVendorsResponse({
    this.data,
    this.message,
    this.errorList,
  });

  List<VendorDetails> data;
  String message;
  List<String> errorList;

  factory AllVendorsResponse.fromJson(Map<String, dynamic> json) => AllVendorsResponse(
    data: json["Data"] == null ? null : List<VendorDetails>.from(json["Data"].map((x) => VendorDetails.fromJson(x))),
    message: json["Message"] == null ? null : json["Message"],
    errorList: json["ErrorList"] == null ? null : List<String>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    "Message": message == null ? null : message,
    "ErrorList": errorList == null ? null : List<dynamic>.from(errorList.map((x) => x)),
  };
}

class VendorDetails {
  VendorDetails({
    this.name,
    this.description,
    this.metaKeywords,
    this.metaDescription,
    this.metaTitle,
    this.seName,
    this.allowCustomersToContactVendors,
    this.pictureModel,
    this.catalogProductsModel,
    this.id,
    this.customProperties,
  });

  String name;
  String description;
  dynamic metaKeywords;
  String metaDescription;
  String metaTitle;
  String seName;
  bool allowCustomersToContactVendors;
  PictureModel pictureModel;
  CatalogProductsModel catalogProductsModel;
  int id;
  CustomProperties customProperties;

  factory VendorDetails.fromJson(Map<String, dynamic> json) => VendorDetails(
    name: json["Name"] == null ? null : json["Name"],
    description: json["Description"] == null ? null : json["Description"],
    metaKeywords: json["MetaKeywords"],
    metaDescription: json["MetaDescription"],
    metaTitle: json["MetaTitle"],
    seName: json["SeName"] == null ? null : json["SeName"],
    allowCustomersToContactVendors: json["AllowCustomersToContactVendors"] == null ? null : json["AllowCustomersToContactVendors"],
    pictureModel: json["PictureModel"] == null ? null : PictureModel.fromJson(json["PictureModel"]),
    catalogProductsModel: json["CatalogProductsModel"] == null ? null : CatalogProductsModel.fromJson(json["CatalogProductsModel"]),
    id: json["Id"] == null ? null : json["Id"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "Name": name == null ? null : name,
    "Description": description == null ? null : description,
    "MetaKeywords": metaKeywords,
    "MetaDescription": metaDescription,
    "MetaTitle": metaTitle,
    "SeName": seName == null ? null : seName,
    "AllowCustomersToContactVendors": allowCustomersToContactVendors == null ? null : allowCustomersToContactVendors,
    "PictureModel": pictureModel == null ? null : pictureModel.toJson(),
    "CatalogProductsModel": catalogProductsModel == null ? null : catalogProductsModel.toJson(),
    "Id": id == null ? null : id,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}



