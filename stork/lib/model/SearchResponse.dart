import 'package:nopcart_flutter/model/AvailableOption.dart';
import 'package:nopcart_flutter/model/CustomProperties.dart';
import 'package:nopcart_flutter/model/product_list/ProductListResponse.dart';

class SearchResponse {
  SearchResponse({
    this.data,
    this.message,
    this.errorList,
  });

  SearchData data;
  String message;
  List<String> errorList;

  SearchResponse copyWith({
    SearchData data,
    String message,
    List<String> errorList,
  }) =>
      SearchResponse(
        data: data ?? this.data,
        message: message ?? this.message,
        errorList: errorList ?? this.errorList,
      );

  factory SearchResponse.fromJson(Map<String, dynamic> json) => SearchResponse(
    data: json["Data"] == null ? null : SearchData.fromJson(json["Data"]),
    message: json["Message"] == null ? null : json["Message"],
    errorList: json["ErrorList"] == null ? null : List<String>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : data.toJson(),
    "Message": message == null ? null : message,
    "ErrorList": errorList == null ? null : List<dynamic>.from(errorList.map((x) => x)),
  };
}

class SearchData {
  SearchData({
    this.q,
    this.categoryId,
    this.searchInSubcategory,
    this.manufacturerId,
    this.vendorId,
    this.searchInDescription,
    this.advSearchSelected,
    this.allowVendorSearch,
    this.catalogProductsModel,
    this.availableCategories,
    this.availableManufacturers,
    this.availableVendors,
    this.customProperties,
  });

  String q;
  int categoryId;
  bool searchInSubcategory;
  int manufacturerId;
  int vendorId;
  bool searchInDescription;
  bool advSearchSelected;
  bool allowVendorSearch;
  CatalogProductsModel catalogProductsModel;
  List<AvailableOption> availableCategories;
  List<AvailableOption> availableManufacturers;
  List<AvailableOption> availableVendors;
  CustomProperties customProperties;

  SearchData copyWith({
    String q,
    int cid,
    bool isc,
    int mid,
    int vid,
    bool sid,
    bool advs,
    bool asv,
    CatalogProductsModel catalogProductsModel,
    List<AvailableOption> availableCategories,
    List<AvailableOption> availableManufacturers,
    List<AvailableOption> availableVendors,
    CustomProperties customProperties,
  }) =>
      SearchData(
        q: q ?? this.q,
        categoryId: cid ?? this.categoryId,
        searchInSubcategory: isc ?? this.searchInSubcategory,
        manufacturerId: mid ?? this.manufacturerId,
        vendorId: vid ?? this.vendorId,
        searchInDescription: sid ?? this.searchInDescription,
        advSearchSelected: advs ?? this.advSearchSelected,
        allowVendorSearch: asv ?? this.allowVendorSearch,
        catalogProductsModel: catalogProductsModel ?? this.catalogProductsModel,
        availableCategories: availableCategories ?? this.availableCategories,
        availableManufacturers: availableManufacturers ?? this.availableManufacturers,
        availableVendors: availableVendors ?? this.availableVendors,
        customProperties: customProperties ?? this.customProperties,
      );

  factory SearchData.fromJson(Map<String, dynamic> json) => SearchData(
    q: json["q"] == null ? null : json["q"],
    categoryId: json["cid"] == null ? null : json["cid"],
    searchInSubcategory: json["isc"] == null ? null : json["isc"],
    manufacturerId: json["mid"] == null ? null : json["mid"],
    vendorId: json["vid"] == null ? null : json["vid"],
    searchInDescription: json["sid"] == null ? null : json["sid"],
    advSearchSelected: json["advs"] == null ? null : json["advs"],
    allowVendorSearch: json["asv"] == null ? null : json["asv"],
    catalogProductsModel: json["CatalogProductsModel"] == null ? null : CatalogProductsModel.fromJson(json["CatalogProductsModel"]),
    availableCategories: json["AvailableCategories"] == null ? null : List<AvailableOption>.from(json["AvailableCategories"].map((x) => AvailableOption.fromJson(x))),
    availableManufacturers: json["AvailableManufacturers"] == null ? null : List<AvailableOption>.from(json["AvailableManufacturers"].map((x) => AvailableOption.fromJson(x))),
    availableVendors: json["AvailableVendors"] == null ? null : List<AvailableOption>.from(json["AvailableVendors"].map((x) => AvailableOption.fromJson(x))),
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "q": q == null ? null : q,
    "cid": categoryId == null ? null : categoryId,
    "isc": searchInSubcategory == null ? null : searchInSubcategory,
    "mid": manufacturerId == null ? null : manufacturerId,
    "vid": vendorId == null ? null : vendorId,
    "sid": searchInDescription == null ? null : searchInDescription,
    "advs": advSearchSelected == null ? null : advSearchSelected,
    "asv": allowVendorSearch == null ? null : allowVendorSearch,
    "CatalogProductsModel": catalogProductsModel == null ? null : catalogProductsModel.toJson(),
    "AvailableCategories": availableCategories == null ? null : List<dynamic>.from(availableCategories.map((x) => x.toJson())),
    "AvailableManufacturers": availableManufacturers == null ? null : List<dynamic>.from(availableManufacturers.map((x) => x.toJson())),
    "AvailableVendors": availableVendors == null ? null : List<dynamic>.from(availableVendors.map((x) => x)),
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

