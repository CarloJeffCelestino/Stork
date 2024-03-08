import 'package:nopcart_flutter/model/CustomProperties.dart';
import 'package:nopcart_flutter/model/ProductSummary.dart';
import '../PictureModel.dart';

class ProductListResponse {
  ProductListResponse({
    this.data,
    this.message,
    this.errorList,
  });

  ProductListData data;
  String message;
  List<String> errorList;

  factory ProductListResponse.fromJson(Map<String, dynamic> json) => ProductListResponse(
    data: json["Data"] == null ? null : ProductListData.fromJson(json["Data"]),
    message: json["Message"] == null ? null : json["Message"],
    errorList: json["ErrorList"] == null ? null : List<String>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : data.toJson(),
    "Message": message == null ? null : message,
    "ErrorList": errorList == null ? null : List<dynamic>.from(errorList.map((x) => x)),
  };
}

class ProductListData {
  ProductListData({
    this.name,
    this.description,
    this.metaKeywords,
    this.metaDescription,
    this.metaTitle,
    this.seName,
    this.pictureModel,
    this.displayCategoryBreadcrumb,
    this.categoryBreadcrumb,
    this.subCategories,
    this.featuredProducts,
    this.catalogProductsModel,
    this.id,
    this.customProperties,
    this.endDateTimeUtc,
  });

  String name;
  String description;
  String metaKeywords;
  String metaDescription;
  String metaTitle;
  String seName;
  PictureModel pictureModel;
  bool displayCategoryBreadcrumb;
  List<ProductListData> categoryBreadcrumb;
  List<SubCategory> subCategories;
  List<ProductSummary> featuredProducts;
  CatalogProductsModel catalogProductsModel;
  num id;
  CustomProperties customProperties;
  DateTime endDateTimeUtc;

  factory ProductListData.fromJson(Map<String, dynamic> json) => ProductListData(
    name: json["Name"] == null ? null : json["Name"],
    description: json["Description"] == null ? null : json["Description"],
    metaKeywords: json["MetaKeywords"] == null ? null : json["MetaKeywords"],
    metaDescription: json["MetaDescription"] == null ? null : json["MetaDescription"],
    metaTitle: json["MetaTitle"] == null ? null : json["MetaTitle"],
    seName: json["SeName"] == null ? null : json["SeName"],
    pictureModel: json["PictureModel"] == null ? null : PictureModel.fromJson(json["PictureModel"]),
    displayCategoryBreadcrumb: json["DisplayCategoryBreadcrumb"] == null ? null : json["DisplayCategoryBreadcrumb"],
    categoryBreadcrumb: json["CategoryBreadcrumb"] == null ? null : List<ProductListData>.from(json["CategoryBreadcrumb"].map((x) => ProductListData.fromJson(x))),
    subCategories: json["SubCategories"] == null ? null : List<SubCategory>.from(json["SubCategories"].map((x) => SubCategory.fromJson(x))),
    featuredProducts: json["FeaturedProducts"] == null ? null : List<ProductSummary>.from(json["FeaturedProducts"].map((x) => ProductSummary.fromJson(x))),
    catalogProductsModel: json["CatalogProductsModel"] == null ? null : CatalogProductsModel.fromJson(json["CatalogProductsModel"]),
    id: json["Id"] == null ? null : json["Id"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
    endDateTimeUtc: json["EndDateTimeUtc"] == null ? null : DateTime.parse(json["EndDateTimeUtc"]),

  );

  Map<String, dynamic> toJson() => {
    "Name": name == null ? null : name,
    "Description": description == null ? null : description,
    "MetaKeywords": metaKeywords == null ? null : metaKeywords,
    "MetaDescription": metaDescription == null ? null : metaDescription,
    "MetaTitle": metaTitle == null ? null : metaTitle,
    "SeName": seName == null ? null : seName,
    "PictureModel": pictureModel == null ? null : pictureModel.toJson(),
    "DisplayCategoryBreadcrumb": displayCategoryBreadcrumb == null ? null : displayCategoryBreadcrumb,
    "CategoryBreadcrumb": categoryBreadcrumb == null ? null : List<dynamic>.from(categoryBreadcrumb.map((x) => x.toJson())),
    "SubCategories": subCategories == null ? null : List<dynamic>.from(subCategories.map((x) => x.toJson())),
    "FeaturedProducts": featuredProducts == null ? null : List<dynamic>.from(featuredProducts.map((x) => x)),
    "CatalogProductsModel": catalogProductsModel == null ? null : catalogProductsModel.toJson(),
    "Id": id == null ? null : id,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
    "EndDateTimeUtc": endDateTimeUtc == null ? null : endDateTimeUtc.toIso8601String(),
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
  String warningMessage;
  String noResultMessage;
  PriceRangeFilter priceRangeFilter;
  SpecificationFilter specificationFilter;
  ManufacturerFilter manufacturerFilter;
  bool allowProductSorting;
  List<AvailableSortOption> availableSortOptions;
  bool allowProductViewModeChanging;
  List<AvailableSortOption> availableViewModes;
  bool allowCustomersToSelectPageSize;
  List<AvailableSortOption> pageSizeOptions;
  dynamic orderBy;
  String viewMode;
  List<ProductSummary> products;
  num pageIndex;
  num pageNumber;
  num pageSize;
  num totalItems;
  num totalPages;
  num firstItem;
  num lastItem;
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
    availableSortOptions: json["AvailableSortOptions"] == null ? null : List<AvailableSortOption>.from(json["AvailableSortOptions"].map((x) => AvailableSortOption.fromJson(x))),
    allowProductViewModeChanging: json["AllowProductViewModeChanging"] == null ? null : json["AllowProductViewModeChanging"],
    availableViewModes: json["AvailableViewModes"] == null ? null : List<AvailableSortOption>.from(json["AvailableViewModes"].map((x) => AvailableSortOption.fromJson(x))),
    allowCustomersToSelectPageSize: json["AllowCustomersToSelectPageSize"] == null ? null : json["AllowCustomersToSelectPageSize"],
    pageSizeOptions: json["PageSizeOptions"] == null ? null : List<AvailableSortOption>.from(json["PageSizeOptions"].map((x) => AvailableSortOption.fromJson(x))),
    orderBy: json["OrderBy"] == null ? null : json["OrderBy"],
    viewMode: json["ViewMode"] == null ? null : json["ViewMode"],
    products: json["Products"] == null ? null : List<ProductSummary>.from(json["Products"].map((x) => ProductSummary.fromJson(x))),
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
    "AvailableSortOptions": availableSortOptions == null ? null : List<dynamic>.from(availableSortOptions.map((x) => x.toJson())),
    "AllowProductViewModeChanging": allowProductViewModeChanging == null ? null : allowProductViewModeChanging,
    "AvailableViewModes": availableViewModes == null ? null : List<dynamic>.from(availableViewModes.map((x) => x.toJson())),
    "AllowCustomersToSelectPageSize": allowCustomersToSelectPageSize == null ? null : allowCustomersToSelectPageSize,
    "PageSizeOptions": pageSizeOptions == null ? null : List<dynamic>.from(pageSizeOptions.map((x) => x.toJson())),
    "OrderBy": orderBy == null ? null : orderBy,
    "ViewMode": viewMode == null ? null : viewMode,
    "Products": products == null ? null : List<dynamic>.from(products.map((x) => x.toJson())),
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

class AvailableSortOption {
  AvailableSortOption({
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

  factory AvailableSortOption.fromJson(Map<String, dynamic> json) => AvailableSortOption(
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

class ManufacturerFilter {
  ManufacturerFilter({
    this.enabled,
    this.manufacturers,
    this.customProperties,
  });

  bool enabled;
  List<AvailableSortOption> manufacturers;
  CustomProperties customProperties;

  factory ManufacturerFilter.fromJson(Map<String, dynamic> json) => ManufacturerFilter(
    enabled: json["Enabled"] == null ? null : json["Enabled"],
    manufacturers: json["Manufacturers"] == null ? null : List<AvailableSortOption>.from(json["Manufacturers"].map((x) => AvailableSortOption.fromJson(x))),
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "Enabled": enabled == null ? null : enabled,
    "Manufacturers": manufacturers == null ? null : List<dynamic>.from(manufacturers.map((x) => x.toJson())),
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

  num from;
  num to;
  CustomProperties customProperties;

  factory PriceRange.fromJson(Map<String, dynamic> json) => PriceRange(
        from: json["From"] == null ? null : json["From"],
        to: json["To"] == null ? null : json["To"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "From": from == null ? null : from,
        "To": to == null ? null : to,
        "CustomProperties": customProperties.toJson(),
      };
}

class SubCategory {
  SubCategory({
    this.name,
    this.seName,
    this.description,
    this.pictureModel,
    this.id,
    this.customProperties,
  });

  String name;
  String seName;
  String description;
  PictureModel pictureModel;
  int id;
  CustomProperties customProperties;

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
    name: json["Name"] == null ? null : json["Name"],
    seName: json["SeName"] == null ? null : json["SeName"],
    description: json["Description"] == null ? null : json["Description"],
    pictureModel: json["PictureModel"] == null ? null : PictureModel.fromJson(json["PictureModel"]),
    id: json["Id"] == null ? null : json["Id"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "Name": name == null ? null : name,
    "SeName": seName == null ? null : seName,
    "Description": description == null ? null : description,
    "PictureModel": pictureModel == null ? null : pictureModel.toJson(),
    "Id": id == null ? null : id,
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
  List<Attribute> attributes;
  CustomProperties customProperties;

  factory SpecificationFilter.fromJson(Map<String, dynamic> json) => SpecificationFilter(
    enabled: json["Enabled"] == null ? null : json["Enabled"],
    attributes: json["Attributes"] == null ? null : List<Attribute>.from(json["Attributes"].map((x) => Attribute.fromJson(x))),
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "Enabled": enabled == null ? null : enabled,
    "Attributes": attributes == null ? null : List<dynamic>.from(attributes.map((x) => x.toJson())),
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class Attribute {
  Attribute({
    this.name,
    this.values,
    this.id,
    this.customProperties,
  });

  String name;
  List<Value> values;
  int id;
  CustomProperties customProperties;

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
        name: json["Name"],
        values: json["Values"] == null ? null : List<Value>.from(json["Values"].map((x) => Value.fromJson(x))),
        id: json["Id"],
        customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "Values": values == null ? null : List<dynamic>.from(values.map((x) => x.toJson())),
        "Id": id,
        "CustomProperties": customProperties == null ? null : customProperties.toJson(),
      };
}

class Value {
  Value({
    this.name,
    this.colorSquaresRgb,
    this.selected,
    this.id,
    this.customProperties,
  });

  String name;
  dynamic colorSquaresRgb;
  bool selected;
  int id;
  CustomProperties customProperties;

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        name: json["Name"],
        colorSquaresRgb: json["ColorSquaresRgb"],
        selected: json["Selected"],
        id: json["Id"],
        customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "ColorSquaresRgb": colorSquaresRgb,
        "Selected": selected,
        "Id": id,
        "CustomProperties": customProperties == null ? null : customProperties.toJson(),
      };
}
