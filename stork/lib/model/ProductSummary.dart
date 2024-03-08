import 'package:nopcart_flutter/model/CustomProperties.dart';
import 'package:nopcart_flutter/model/PictureModel.dart';

class ProductSummary {
  ProductSummary({
    this.name,
    this.shortDescription,
    this.fullDescription,
    this.seName,
    this.sku,
    this.productType,
    this.markAsNew,
    this.productPrice,
    this.defaultPictureModel,
    this.productSpecificationModel,
    this.reviewOverviewModel,
    this.id,
    this.customProperties,
  });

  String name;
  String shortDescription;
  String fullDescription;
  String seName;
  String sku;
  int productType;
  bool markAsNew;
  ProductSummaryPrice productPrice;
  PictureModel defaultPictureModel;
  ProductSpecificationModel productSpecificationModel;
  ReviewOverviewModel reviewOverviewModel;
  int id;
  CustomProperties customProperties;

  factory ProductSummary.fromJson(Map<String, dynamic> json) => ProductSummary(
    name: json["Name"] == null ? null : json["Name"],
    shortDescription: json["ShortDescription"] == null ? null : json["ShortDescription"],
    fullDescription: json["FullDescription"] == null ? null : json["FullDescription"],
    seName: json["SeName"] == null ? null : json["SeName"],
    sku: json["Sku"] == null ? null : json["Sku"],
    productType: json["ProductType"] == null ? null : json["ProductType"],
    markAsNew: json["MarkAsNew"] == null ? null : json["MarkAsNew"],
    productPrice: json["ProductPrice"] == null ? null : ProductSummaryPrice.fromJson(json["ProductPrice"]),
    defaultPictureModel: json["DefaultPictureModel"] == null ? null : PictureModel.fromJson(json["DefaultPictureModel"]),
    productSpecificationModel: json["ProductSpecificationModel"] == null ? null : ProductSpecificationModel.fromJson(json["ProductSpecificationModel"]),
    reviewOverviewModel: json["ReviewOverviewModel"] == null ? null : ReviewOverviewModel.fromJson(json["ReviewOverviewModel"]),
    id: json["Id"] == null ? null : json["Id"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),

  );

  Map<String, dynamic> toJson() => {
    "Name": name == null ? null : name,
    "ShortDescription": shortDescription == null ? null : shortDescription,
    "FullDescription": fullDescription == null ? null : fullDescription,
    "SeName": seName == null ? null : seName,
    "Sku": sku == null ? null : sku,
    "ProductType": productType == null ? null : productType,
    "MarkAsNew": markAsNew == null ? null : markAsNew,
    "ProductPrice": productPrice == null ? null : productPrice.toJson(),
    "DefaultPictureModel": defaultPictureModel == null ? null : defaultPictureModel.toJson(),
    "ProductSpecificationModel": productSpecificationModel == null ? null : productSpecificationModel.toJson(),
    "ReviewOverviewModel": reviewOverviewModel == null ? null : reviewOverviewModel.toJson(),
    "Id": id == null ? null : id,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}


class ProductSpecificationModel {
  ProductSpecificationModel({
    this.groups,
    this.customProperties,
  });

  List<dynamic> groups;
  CustomProperties customProperties;

  factory ProductSpecificationModel.fromJson(Map<String, dynamic> json) => ProductSpecificationModel(
    groups: json["Groups"] == null ? null : List<dynamic>.from(json["Groups"].map((x) => x)),
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "Groups": groups == null ? null : List<dynamic>.from(groups.map((x) => x)),
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class ReviewOverviewModel {
  ReviewOverviewModel({
    this.productId,
    this.ratingSum,
    this.totalReviews,
    this.allowCustomerReviews,
    this.canAddNewReview,
    this.customProperties,
  });

  int productId;
  int ratingSum;
  int totalReviews;
  bool allowCustomerReviews;
  bool canAddNewReview;
  CustomProperties customProperties;

  factory ReviewOverviewModel.fromJson(Map<String, dynamic> json) => ReviewOverviewModel(
    productId: json["ProductId"] == null ? null : json["ProductId"],
    ratingSum: json["RatingSum"] == null ? null : json["RatingSum"],
    totalReviews: json["TotalReviews"] == null ? null : json["TotalReviews"],
    allowCustomerReviews: json["AllowCustomerReviews"] == null ? null : json["AllowCustomerReviews"],
    canAddNewReview: json["CanAddNewReview"] == null ? null : json["CanAddNewReview"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "ProductId": productId == null ? null : productId,
    "RatingSum": ratingSum == null ? null : ratingSum,
    "TotalReviews": totalReviews == null ? null : totalReviews,
    "AllowCustomerReviews": allowCustomerReviews == null ? null : allowCustomerReviews,
    "CanAddNewReview": canAddNewReview == null ? null : canAddNewReview,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class ProductSummaryPrice {
  ProductSummaryPrice({
    this.oldPrice,
    this.price,
    this.priceValue,
    this.oldPriceValue,
    this.basePricePAngV,
    this.disableBuyButton,
    this.disableWishlistButton,
    this.disableAddToCompareListButton,
    this.availableForPreOrder,
    this.preOrderAvailabilityStartDateTimeUtc,
    this.isRental,
    this.forceRedirectionAfterAddingToCart,
    this.displayTaxShippingInfo,
    this.customProperties,
  });

  String oldPrice;
  String price;
  num priceValue;
  num oldPriceValue;
  String basePricePAngV;
  bool disableBuyButton;
  bool disableWishlistButton;
  bool disableAddToCompareListButton;
  bool availableForPreOrder;
  dynamic preOrderAvailabilityStartDateTimeUtc;
  bool isRental;
  bool forceRedirectionAfterAddingToCart;
  bool displayTaxShippingInfo;
  CustomProperties customProperties;

  factory ProductSummaryPrice.fromJson(Map<String, dynamic> json) => ProductSummaryPrice(
    oldPrice: json["OldPrice"] == null ? null : json["OldPrice"],
    price: json["Price"] == null ? null : json["Price"],
    priceValue: json["PriceValue"] == null ? null : json["PriceValue"],
    oldPriceValue: json["OldPriceValue"] == null ? null : json["OldPriceValue"],
    basePricePAngV: json["BasePricePAngV"],
    disableBuyButton: json["DisableBuyButton"] == null ? null : json["DisableBuyButton"],
    disableWishlistButton: json["DisableWishlistButton"] == null ? null : json["DisableWishlistButton"],
    disableAddToCompareListButton: json["DisableAddToCompareListButton"] == null ? null : json["DisableAddToCompareListButton"],
    availableForPreOrder: json["AvailableForPreOrder"] == null ? null : json["AvailableForPreOrder"],
    preOrderAvailabilityStartDateTimeUtc: json["PreOrderAvailabilityStartDateTimeUtc"],
    isRental: json["IsRental"] == null ? null : json["IsRental"],
    forceRedirectionAfterAddingToCart: json["ForceRedirectionAfterAddingToCart"] == null ? null : json["ForceRedirectionAfterAddingToCart"],
    displayTaxShippingInfo: json["DisplayTaxShippingInfo"] == null ? null : json["DisplayTaxShippingInfo"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "OldPrice": oldPrice == null ? null : oldPrice,
    "Price": price == null ? null : price,
    "PriceValue": priceValue == null ? null : priceValue,
    "OldPriceValue": oldPriceValue == null ? null : oldPriceValue,
    "BasePricePAngV": basePricePAngV,
    "DisableBuyButton": disableBuyButton == null ? null : disableBuyButton,
    "DisableWishlistButton": disableWishlistButton == null ? null : disableWishlistButton,
    "DisableAddToCompareListButton": disableAddToCompareListButton == null ? null : disableAddToCompareListButton,
    "AvailableForPreOrder": availableForPreOrder == null ? null : availableForPreOrder,
    "PreOrderAvailabilityStartDateTimeUtc": preOrderAvailabilityStartDateTimeUtc,
    "IsRental": isRental == null ? null : isRental,
    "ForceRedirectionAfterAddingToCart": forceRedirectionAfterAddingToCart == null ? null : forceRedirectionAfterAddingToCart,
    "DisplayTaxShippingInfo": displayTaxShippingInfo == null ? null : displayTaxShippingInfo,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

