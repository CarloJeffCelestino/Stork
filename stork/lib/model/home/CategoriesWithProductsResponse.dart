import 'package:nopcart_flutter/model/CustomProperties.dart';
import 'package:nopcart_flutter/model/ProductSummary.dart';

class CategoriesWithProductsResponse {
  CategoriesWithProductsResponse({
    this.data,
    this.message,
    this.errorList,
  });

  List<CategoriesWithProducts> data;
  String message;
  List<String> errorList;



  factory CategoriesWithProductsResponse.fromJson(Map<String, dynamic> json) => CategoriesWithProductsResponse(
    data: json["Data"] == null ? null : List<CategoriesWithProducts>.from(json["Data"].map((x) => CategoriesWithProducts.fromJson(x))),
    message: json["Message"] == null ? null : json["Message"],
    errorList: json["ErrorList"] == null ? null : List<String>.from(json["ErrorList"].map((x) => x)),

  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    "Message": message == null ? null : message,
    "ErrorList": errorList == null ? null : List<dynamic>.from(errorList.map((x) => x)),
  };
}

class CategoriesWithProducts {
  CategoriesWithProducts({
    this.name,
    this.seName,
    this.subCategories,
    this.products,
    this.id,
    this.customProperties,
    this.fullSizeImageUrl,
    this.endDateTimeUtc,

  });

  String name;
  String seName;
  List<CategoriesWithProducts> subCategories;
  List<ProductSummary> products;
  int id;
  CustomProperties customProperties;
  String fullSizeImageUrl;
  DateTime endDateTimeUtc;


  factory CategoriesWithProducts.fromJson(Map<String, dynamic> json) => CategoriesWithProducts(
    name: json["Name"] == null ? null : json["Name"],
    seName: json["SeName"] == null ? null : json["SeName"],
    subCategories: json["SubCategories"] == null ? null : List<CategoriesWithProducts>.from(json["SubCategories"].map((x) => CategoriesWithProducts.fromJson(x))),
    products: json["Products"] == null ? null : List<ProductSummary>.from(json["Products"].map((x) => ProductSummary.fromJson(x))),
    id: json["Id"] == null ? null : json["Id"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
    fullSizeImageUrl: json["FullSizeImageUrl"] == null ? null : json["FullSizeImageUrl"],
    endDateTimeUtc: json["EndDateTimeUtc"] == null ? null : DateTime.parse(json["EndDateTimeUtc"]),

  );

  Map<String, dynamic> toJson() => {
    "Name": name == null ? null : name,
    "SeName": seName == null ? null : seName,
    "SubCategories": subCategories == null ? null : List<dynamic>.from(subCategories.map((x) => x.toJson())),
    "Products": products == null ? null : List<dynamic>.from(products.map((x) => x.toJson())),
    "Id": id == null ? null : id,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
    "FullSizeImageUrl": fullSizeImageUrl == null ? null : fullSizeImageUrl,
    "EndDateTimeUtc": endDateTimeUtc == null ? null : endDateTimeUtc.toIso8601String(),
  };
}
