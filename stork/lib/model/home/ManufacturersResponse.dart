import 'package:nopcart_flutter/model/CustomProperties.dart';
import 'package:nopcart_flutter/model/PictureModel.dart';

class ManufacturersResponse {
  ManufacturersResponse({
    this.data,
    this.message,
    this.errorList,
  });

  List<ManufacturerData> data;
  String message;
  List<String> errorList;

  factory ManufacturersResponse.fromJson(Map<String, dynamic> json) => ManufacturersResponse(
    data: json["Data"] == null ? null : List<ManufacturerData>.from(json["Data"].map((x) => ManufacturerData.fromJson(x))),
    message: json["Message"] == null ? null : json["Message"],
    errorList: json["ErrorList"] == null ? null : List<String>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    "Message": message == null ? null : message,
    "ErrorList": errorList == null ? null : List<dynamic>.from(errorList.map((x) => x)),
  };
}

class ManufacturerData {
  ManufacturerData({
    this.name,
    this.description,
    this.metaKeywords,
    this.metaDescription,
    this.metaTitle,
    this.seName,
    this.pictureModel,
    this.featuredProducts,
    this.catalogProductsModel,
    this.id,
    this.customProperties,
  });

  String name;
  String description;
  String metaKeywords;
  String metaDescription;
  String metaTitle;
  String seName;
  PictureModel pictureModel;
  List<dynamic> featuredProducts;
  CatalogProductsModel catalogProductsModel;
  int id;
  CustomProperties customProperties;

  factory ManufacturerData.fromJson(Map<String, dynamic> json) => ManufacturerData(
    name: json["Name"] == null ? null : json["Name"],
    description: json["Description"] == null ? null : json["Description"],
    metaKeywords: json["MetaKeywords"] == null ? null : json["MetaKeywords"],
    metaDescription: json["MetaDescription"] == null ? null : json["MetaDescription"],
    metaTitle: json["MetaTitle"] == null ? null : json["MetaTitle"],
    seName: json["SeName"] == null ? null : json["SeName"],
    pictureModel: json["PictureModel"] == null ? null : PictureModel.fromJson(json["PictureModel"]),
    featuredProducts: json["FeaturedProducts"] == null ? null : List<dynamic>.from(json["FeaturedProducts"].map((x) => x)),
    catalogProductsModel: json["CatalogProductsModel"] == null ? null : CatalogProductsModel.fromJson(json["CatalogProductsModel"]),
    id: json["Id"] == null ? null : json["Id"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "Name": name == null ? null : name,
    "Description": description == null ? null : description,
    "MetaKeywords": metaKeywords == null ? null : metaKeywords,
    "MetaDescription": metaDescription == null ? null : metaDescription,
    "MetaTitle": metaTitle == null ? null : metaTitle,
    "SeName": seName == null ? null : seName,
    "PictureModel": pictureModel == null ? null : pictureModel.toJson(),
    "FeaturedProducts": featuredProducts == null ? null : List<dynamic>.from(featuredProducts.map((x) => x)),
    "CatalogProductsModel": catalogProductsModel == null ? null : catalogProductsModel.toJson(),
    "Id": id == null ? null : id,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class CatalogProductsModel {
  CatalogProductsModel({
    this.useAjaxLoading,
    this.warningMessage,
    this.noResultMessage,
    this.priceRangeFilter,
    this.specificationFilter,
    this.manufacturerFilter,
    this.allowProductSorting,
    this.availableSortOptions,
    this.allowProductViewModeChanging,
    this.availableViewModes,
    this.allowCustomersToSelectPageSize,
    this.pageSizeOptions,
    this.orderBy,
    this.viewMode,
    this.products,
    this.pageIndex,
    this.pageNumber,
    this.pageSize,
    this.totalItems,
    this.totalPages,
    this.firstItem,
    this.lastItem,
    this.hasPreviousPage,
    this.hasNextPage,
    this.customProperties,
  });

  bool useAjaxLoading;
  dynamic warningMessage;
  dynamic noResultMessage;
  PriceRangeFilter priceRangeFilter;
  SpecificationFilter specificationFilter;
  ManufacturerFilter manufacturerFilter;
  bool allowProductSorting;
  List<dynamic> availableSortOptions;
  bool allowProductViewModeChanging;
  List<dynamic> availableViewModes;
  bool allowCustomersToSelectPageSize;
  List<dynamic> pageSizeOptions;
  dynamic orderBy;
  dynamic viewMode;
  List<dynamic> products;
  int pageIndex;
  int pageNumber;
  int pageSize;
  int totalItems;
  int totalPages;
  int firstItem;
  int lastItem;
  bool hasPreviousPage;
  bool hasNextPage;
  CustomProperties customProperties;

  factory CatalogProductsModel.fromJson(Map<String, dynamic> json) => CatalogProductsModel(
    useAjaxLoading: json["UseAjaxLoading"] == null ? null : json["UseAjaxLoading"],
    warningMessage: json["WarningMessage"],
    noResultMessage: json["NoResultMessage"],
    priceRangeFilter: json["PriceRangeFilter"] == null ? null : PriceRangeFilter.fromJson(json["PriceRangeFilter"]),
    specificationFilter: json["SpecificationFilter"] == null ? null : SpecificationFilter.fromJson(json["SpecificationFilter"]),
    manufacturerFilter: json["ManufacturerFilter"] == null ? null : ManufacturerFilter.fromJson(json["ManufacturerFilter"]),
    allowProductSorting: json["AllowProductSorting"] == null ? null : json["AllowProductSorting"],
    availableSortOptions: json["AvailableSortOptions"] == null ? null : List<dynamic>.from(json["AvailableSortOptions"].map((x) => x)),
    allowProductViewModeChanging: json["AllowProductViewModeChanging"] == null ? null : json["AllowProductViewModeChanging"],
    availableViewModes: json["AvailableViewModes"] == null ? null : List<dynamic>.from(json["AvailableViewModes"].map((x) => x)),
    allowCustomersToSelectPageSize: json["AllowCustomersToSelectPageSize"] == null ? null : json["AllowCustomersToSelectPageSize"],
    pageSizeOptions: json["PageSizeOptions"] == null ? null : List<dynamic>.from(json["PageSizeOptions"].map((x) => x)),
    orderBy: json["OrderBy"],
    viewMode: json["ViewMode"],
    products: json["Products"] == null ? null : List<dynamic>.from(json["Products"].map((x) => x)),
    pageIndex: json["PageIndex"] == null ? null : json["PageIndex"],
    pageNumber: json["PageNumber"] == null ? null : json["PageNumber"],
    pageSize: json["PageSize"] == null ? null : json["PageSize"],
    totalItems: json["TotalItems"] == null ? null : json["TotalItems"],
    totalPages: json["TotalPages"] == null ? null : json["TotalPages"],
    firstItem: json["FirstItem"] == null ? null : json["FirstItem"],
    lastItem: json["LastItem"] == null ? null : json["LastItem"],
    hasPreviousPage: json["HasPreviousPage"] == null ? null : json["HasPreviousPage"],
    hasNextPage: json["HasNextPage"] == null ? null : json["HasNextPage"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "UseAjaxLoading": useAjaxLoading == null ? null : useAjaxLoading,
    "WarningMessage": warningMessage,
    "NoResultMessage": noResultMessage,
    "PriceRangeFilter": priceRangeFilter == null ? null : priceRangeFilter.toJson(),
    "SpecificationFilter": specificationFilter == null ? null : specificationFilter.toJson(),
    "ManufacturerFilter": manufacturerFilter == null ? null : manufacturerFilter.toJson(),
    "AllowProductSorting": allowProductSorting == null ? null : allowProductSorting,
    "AvailableSortOptions": availableSortOptions == null ? null : List<dynamic>.from(availableSortOptions.map((x) => x)),
    "AllowProductViewModeChanging": allowProductViewModeChanging == null ? null : allowProductViewModeChanging,
    "AvailableViewModes": availableViewModes == null ? null : List<dynamic>.from(availableViewModes.map((x) => x)),
    "AllowCustomersToSelectPageSize": allowCustomersToSelectPageSize == null ? null : allowCustomersToSelectPageSize,
    "PageSizeOptions": pageSizeOptions == null ? null : List<dynamic>.from(pageSizeOptions.map((x) => x)),
    "OrderBy": orderBy,
    "ViewMode": viewMode,
    "Products": products == null ? null : List<dynamic>.from(products.map((x) => x)),
    "PageIndex": pageIndex == null ? null : pageIndex,
    "PageNumber": pageNumber == null ? null : pageNumber,
    "PageSize": pageSize == null ? null : pageSize,
    "TotalItems": totalItems == null ? null : totalItems,
    "TotalPages": totalPages == null ? null : totalPages,
    "FirstItem": firstItem == null ? null : firstItem,
    "LastItem": lastItem == null ? null : lastItem,
    "HasPreviousPage": hasPreviousPage == null ? null : hasPreviousPage,
    "HasNextPage": hasNextPage == null ? null : hasNextPage,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class ManufacturerFilter {
  ManufacturerFilter({
    this.enabled,
    this.manufacturers,
    this.customProperties,
  });

  bool enabled;
  List<dynamic> manufacturers;
  CustomProperties customProperties;

  factory ManufacturerFilter.fromJson(Map<String, dynamic> json) => ManufacturerFilter(
    enabled: json["Enabled"] == null ? null : json["Enabled"],
    manufacturers: json["Manufacturers"] == null ? null : List<dynamic>.from(json["Manufacturers"].map((x) => x)),
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "Enabled": enabled == null ? null : enabled,
    "Manufacturers": manufacturers == null ? null : List<dynamic>.from(manufacturers.map((x) => x)),
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class PriceRangeFilter {
  PriceRangeFilter({
    this.enabled,
    this.selectedPriceRange,
    this.availablePriceRange,
    this.customProperties,
  });

  bool enabled;
  PriceRange selectedPriceRange;
  PriceRange availablePriceRange;
  CustomProperties customProperties;

  factory PriceRangeFilter.fromJson(Map<String, dynamic> json) => PriceRangeFilter(
    enabled: json["Enabled"] == null ? null : json["Enabled"],
    selectedPriceRange: json["SelectedPriceRange"] == null ? null : PriceRange.fromJson(json["SelectedPriceRange"]),
    availablePriceRange: json["AvailablePriceRange"] == null ? null : PriceRange.fromJson(json["AvailablePriceRange"]),
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "Enabled": enabled == null ? null : enabled,
    "SelectedPriceRange": selectedPriceRange == null ? null : selectedPriceRange.toJson(),
    "AvailablePriceRange": availablePriceRange == null ? null : availablePriceRange.toJson(),
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class PriceRange {
  PriceRange({
    this.from,
    this.to,
    this.customProperties,
  });

  dynamic from;
  dynamic to;
  CustomProperties customProperties;

  factory PriceRange.fromJson(Map<String, dynamic> json) => PriceRange(
    from: json["From"],
    to: json["To"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "From": from,
    "To": to,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class SpecificationFilter {
  SpecificationFilter({
    this.enabled,
    this.attributes,
    this.customProperties,
  });

  bool enabled;
  List<dynamic> attributes;
  CustomProperties customProperties;

  factory SpecificationFilter.fromJson(Map<String, dynamic> json) => SpecificationFilter(
    enabled: json["Enabled"] == null ? null : json["Enabled"],
    attributes: json["Attributes"] == null ? null : List<dynamic>.from(json["Attributes"].map((x) => x)),
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "Enabled": enabled == null ? null : enabled,
    "Attributes": attributes == null ? null : List<dynamic>.from(attributes.map((x) => x)),
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}
