import 'package:nopcart_flutter/model/AvailableOption.dart';
import 'package:nopcart_flutter/model/CustomAttribute.dart';
import 'package:nopcart_flutter/model/CustomProperties.dart';
import 'package:nopcart_flutter/model/EstimateShipping.dart';
import 'package:nopcart_flutter/model/PictureModel.dart';

class ProductDetailsResponse {
  ProductDetailsResponse({
    this.data,
    this.message,
    this.errorList,
  });

  ProductDetails data;
  String message;
  List<String> errorList;

  factory ProductDetailsResponse.fromJson(Map<String, dynamic> json) => ProductDetailsResponse(
    data: json["Data"] == null ? null : ProductDetails.fromJson(json["Data"]),
    message: json["Message"] == null ? null : json["Message"],
    errorList: json["ErrorList"] == null ? null : List<String>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : data.toJson(),
    "Message": message == null ? null : message,
    "ErrorList": errorList == null ? null : List<dynamic>.from(errorList.map((x) => x)),
  };
}

class ProductDetails {
  ProductDetails({
    this.defaultPictureZoomEnabled,
    this.defaultPictureModel,
    this.pictureModels,
    this.name,
    this.shortDescription,
    this.fullDescription,
    this.metaKeywords,
    this.metaDescription,
    this.metaTitle,
    this.seName,
    this.visibleIndividually,
    this.productType,
    this.showSku,
    this.sku,
    this.showManufacturerPartNumber,
    this.manufacturerPartNumber,
    this.showGtin,
    this.gtin,
    this.showVendor,
    this.vendorModel,
    this.hasSampleDownload,
    this.giftCard,
    this.isShipEnabled,
    this.isFreeShipping,
    this.freeShippingNotificationEnabled,
    this.deliveryDate,
    this.isRental,
    this.rentalStartDate,
    this.rentalEndDate,
    this.availableEndDate,
    this.manageInventoryMethod,
    this.stockAvailability,
    this.displayBackInStockSubscription,
    this.emailAFriendEnabled,
    this.compareProductsEnabled,
    this.pageShareCode,
    this.productPrice,
    this.addToCart,
    this.breadcrumb,
    this.productTags,
    this.productAttributes,
    this.productSpecificationModel,
    this.productManufacturers,
    this.productReviewOverview,
    this.productEstimateShipping,
    this.tierPrices,
    this.associatedProducts,
    this.displayDiscontinuedMessage,
    this.currentStoreName,
    this.inStock,
    this.allowAddingOnlyExistingAttributeCombinations,
    this.id,
    this.customProperties,
  });

  bool defaultPictureZoomEnabled;
  PictureModel defaultPictureModel;
  List<PictureModel> pictureModels;
  String name;
  String shortDescription;
  String fullDescription;
  dynamic metaKeywords;
  String metaDescription;
  String metaTitle;
  String seName;
  bool visibleIndividually;
  num productType;
  bool showSku;
  String sku;
  bool showManufacturerPartNumber;
  dynamic manufacturerPartNumber;
  bool showGtin;
  String gtin;
  bool showVendor;
  VendorModel vendorModel;
  bool hasSampleDownload;
  GiftCard giftCard;
  bool isShipEnabled;
  bool isFreeShipping;
  bool freeShippingNotificationEnabled;
  String deliveryDate;
  bool isRental;
  dynamic rentalStartDate;
  dynamic rentalEndDate;
  dynamic availableEndDate;
  num manageInventoryMethod;
  String stockAvailability;
  bool displayBackInStockSubscription;
  bool emailAFriendEnabled;
  bool compareProductsEnabled;
  String pageShareCode;
  ProductPrice productPrice;
  AddToCart addToCart;
  Breadcrumb breadcrumb;
  List<VendorModel> productTags;
  List<CustomAttribute> productAttributes;
  ProductSpecificationModel productSpecificationModel;
  List<VendorModel> productManufacturers;
  ProductReviewOverview productReviewOverview;
  EstimateShipping productEstimateShipping;
  List<TierPrice> tierPrices;
  List<ProductDetails> associatedProducts;
  bool displayDiscontinuedMessage;
  String currentStoreName;
  bool inStock;
  bool allowAddingOnlyExistingAttributeCombinations;
  num id;
  CustomProperties customProperties;

  factory ProductDetails.fromJson(Map<String, dynamic> json) => ProductDetails(
    defaultPictureZoomEnabled: json["DefaultPictureZoomEnabled"] == null ? null : json["DefaultPictureZoomEnabled"],
    defaultPictureModel: json["DefaultPictureModel"] == null ? null : PictureModel.fromJson(json["DefaultPictureModel"]),
    pictureModels: json["PictureModels"] == null ? null : List<PictureModel>.from(json["PictureModels"].map((x) => PictureModel.fromJson(x))),
    name: json["Name"] == null ? null : json["Name"],
    shortDescription: json["ShortDescription"] == null ? null : json["ShortDescription"],
    fullDescription: json["FullDescription"] == null ? null : json["FullDescription"],
    metaKeywords: json["MetaKeywords"],
    metaDescription: json["MetaDescription"],
    metaTitle: json["MetaTitle"],
    seName: json["SeName"] == null ? null : json["SeName"],
    visibleIndividually: json["VisibleIndividually"] == null ? null : json["VisibleIndividually"],
    productType: json["ProductType"] == null ? null : json["ProductType"],
    showSku: json["ShowSku"] == null ? null : json["ShowSku"],
    sku: json["Sku"] == null ? null : json["Sku"],
    showManufacturerPartNumber: json["ShowManufacturerPartNumber"] == null ? null : json["ShowManufacturerPartNumber"],
    manufacturerPartNumber: json["ManufacturerPartNumber"] == null ? null : json["ManufacturerPartNumber"],
    showGtin: json["ShowGtin"] == null ? null : json["ShowGtin"],
    gtin: json["Gtin"] == null ? null : json["Gtin"],
    showVendor: json["ShowVendor"] == null ? null : json["ShowVendor"],
    vendorModel: json["VendorModel"] == null ? null : VendorModel.fromJson(json["VendorModel"]),
    hasSampleDownload: json["HasSampleDownload"] == null ? null : json["HasSampleDownload"],
    giftCard: json["GiftCard"] == null ? null : GiftCard.fromJson(json["GiftCard"]),
    isShipEnabled: json["IsShipEnabled"] == null ? null : json["IsShipEnabled"],
    isFreeShipping: json["IsFreeShipping"] == null ? null : json["IsFreeShipping"],
    freeShippingNotificationEnabled: json["FreeShippingNotificationEnabled"] == null ? null : json["FreeShippingNotificationEnabled"],
    deliveryDate: json["DeliveryDate"] == null ? null : json["DeliveryDate"],
    isRental: json["IsRental"] == null ? null : json["IsRental"],
    rentalStartDate: json["RentalStartDate"] == null ? null : json["RentalStartDate"],
    rentalEndDate: json["RentalEndDate"] == null ? null : json["RentalEndDate"],
    availableEndDate: json["AvailableEndDate"] == null ? null : json["AvailableEndDate"],
    manageInventoryMethod: json["ManageInventoryMethod"] == null ? null : json["ManageInventoryMethod"],
    stockAvailability: json["StockAvailability"] == null ? null : json["StockAvailability"],
    displayBackInStockSubscription: json["DisplayBackInStockSubscription"] == null ? null : json["DisplayBackInStockSubscription"],
    emailAFriendEnabled: json["EmailAFriendEnabled"] == null ? null : json["EmailAFriendEnabled"],
    compareProductsEnabled: json["CompareProductsEnabled"] == null ? null : json["CompareProductsEnabled"],
    pageShareCode: json["PageShareCode"] == null ? null : json["PageShareCode"],
    productPrice: json["ProductPrice"] == null ? null : ProductPrice.fromJson(json["ProductPrice"]),
    addToCart: json["AddToCart"] == null ? null : AddToCart.fromJson(json["AddToCart"]),
    breadcrumb: json["Breadcrumb"] == null ? null : Breadcrumb.fromJson(json["Breadcrumb"]),
    productTags: json["ProductTags"] == null ? null : List<VendorModel>.from(json["ProductTags"].map((x) => VendorModel.fromJson(x))),
    productAttributes: json["ProductAttributes"] == null ? null : List<CustomAttribute>.from(json["ProductAttributes"].map((x) => CustomAttribute.fromJson(x))),
    productSpecificationModel: json["ProductSpecificationModel"] == null ? null : ProductSpecificationModel.fromJson(json["ProductSpecificationModel"]),
    productManufacturers: json["ProductManufacturers"] == null ? null : List<VendorModel>.from(json["ProductManufacturers"].map((x) => VendorModel.fromJson(x))),
    productReviewOverview: json["ProductReviewOverview"] == null ? null : ProductReviewOverview.fromJson(json["ProductReviewOverview"]),
    productEstimateShipping: json["ProductEstimateShipping"] == null ? null : EstimateShipping.fromJson(json["ProductEstimateShipping"]),
    tierPrices: json["TierPrices"] == null ? null : List<TierPrice>.from(json["TierPrices"].map((x) => TierPrice.fromJson(x))),
    associatedProducts: json["AssociatedProducts"] == null ? null : List<ProductDetails>.from(json["AssociatedProducts"].map((x) => ProductDetails.fromJson(x))),
    displayDiscontinuedMessage: json["DisplayDiscontinuedMessage"] == null ? null : json["DisplayDiscontinuedMessage"],
    currentStoreName: json["CurrentStoreName"] == null ? null : json["CurrentStoreName"],
    inStock: json["InStock"] == null ? null : json["InStock"],
    allowAddingOnlyExistingAttributeCombinations: json["AllowAddingOnlyExistingAttributeCombinations"] == null ? null : json["AllowAddingOnlyExistingAttributeCombinations"],
    id: json["Id"] == null ? null : json["Id"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "DefaultPictureZoomEnabled": defaultPictureZoomEnabled == null ? null : defaultPictureZoomEnabled,
    "DefaultPictureModel": defaultPictureModel == null ? null : defaultPictureModel.toJson(),
    "PictureModels": pictureModels == null ? null : List<dynamic>.from(pictureModels.map((x) => x.toJson())),
    "Name": name == null ? null : name,
    "ShortDescription": shortDescription == null ? null : shortDescription,
    "FullDescription": fullDescription == null ? null : fullDescription,
    "MetaKeywords": metaKeywords,
    "MetaDescription": metaDescription,
    "MetaTitle": metaTitle,
    "SeName": seName == null ? null : seName,
    "VisibleIndividually": visibleIndividually == null ? null : visibleIndividually,
    "ProductType": productType == null ? null : productType,
    "ShowSku": showSku == null ? null : showSku,
    "Sku": sku == null ? null : sku,
    "ShowManufacturerPartNumber": showManufacturerPartNumber == null ? null : showManufacturerPartNumber,
    "ManufacturerPartNumber": manufacturerPartNumber,
    "ShowGtin": showGtin == null ? null : showGtin,
    "Gtin": gtin,
    "ShowVendor": showVendor == null ? null : showVendor,
    "VendorModel": vendorModel == null ? null : vendorModel.toJson(),
    "HasSampleDownload": hasSampleDownload == null ? null : hasSampleDownload,
    "GiftCard": giftCard == null ? null : giftCard.toJson(),
    "IsShipEnabled": isShipEnabled == null ? null : isShipEnabled,
    "IsFreeShipping": isFreeShipping == null ? null : isFreeShipping,
    "FreeShippingNotificationEnabled": freeShippingNotificationEnabled == null ? null : freeShippingNotificationEnabled,
    "DeliveryDate": deliveryDate,
    "IsRental": isRental == null ? null : isRental,
    "RentalStartDate": rentalStartDate,
    "RentalEndDate": rentalEndDate,
    "AvailableEndDate": availableEndDate,
    "ManageInventoryMethod": manageInventoryMethod == null ? null : manageInventoryMethod,
    "StockAvailability": stockAvailability == null ? null : stockAvailability,
    "DisplayBackInStockSubscription": displayBackInStockSubscription == null ? null : displayBackInStockSubscription,
    "EmailAFriendEnabled": emailAFriendEnabled == null ? null : emailAFriendEnabled,
    "CompareProductsEnabled": compareProductsEnabled == null ? null : compareProductsEnabled,
    "PageShareCode": pageShareCode,
    "ProductPrice": productPrice == null ? null : productPrice.toJson(),
    "AddToCart": addToCart == null ? null : addToCart.toJson(),
    "Breadcrumb": breadcrumb == null ? null : breadcrumb.toJson(),
    "ProductTags": productTags == null ? null : List<dynamic>.from(productTags.map((x) => x.toJson())),
    "ProductAttributes": productAttributes == null ? null : List<dynamic>.from(productAttributes.map((x) => x.toJson())),
    "ProductSpecificationModel": productSpecificationModel == null ? null : productSpecificationModel.toJson(),
    "ProductManufacturers": productManufacturers == null ? null : List<dynamic>.from(productManufacturers.map((x) => x.toJson())),
    "ProductReviewOverview": productReviewOverview == null ? null : productReviewOverview.toJson(),
    "ProductEstimateShipping": productEstimateShipping == null ? null : productEstimateShipping.toJson(),
    "TierPrices": tierPrices == null ? null : List<dynamic>.from(tierPrices.map((x) => x.toJson())),
    "AssociatedProducts": associatedProducts == null ? null : List<dynamic>.from(associatedProducts.map((x) => x.toJson())),
    "DisplayDiscontinuedMessage": displayDiscontinuedMessage == null ? null : displayDiscontinuedMessage,
    "CurrentStoreName": currentStoreName == null ? null : currentStoreName,
    "InStock": inStock == null ? null : inStock,
    "AllowAddingOnlyExistingAttributeCombinations": allowAddingOnlyExistingAttributeCombinations == null ? null : allowAddingOnlyExistingAttributeCombinations,
    "Id": id == null ? null : id,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class AddToCart {
  AddToCart({
    this.productId,
    this.enteredQuantity,
    this.minimumQuantityNotification,
    this.allowedQuantities,
    this.customerEntersPrice,
    this.customerEnteredPrice,
    this.customerEnteredPriceRange,
    this.disableBuyButton,
    this.disableWishlistButton,
    this.isRental,
    this.availableForPreOrder,
    this.preOrderAvailabilityStartDateTimeUtc,
    this.preOrderAvailabilityStartDateTimeUserTime,
    this.updatedShoppingCartItemId,
    this.updateShoppingCartItemType,
    this.customProperties,
  });

  num productId;
  num enteredQuantity;
  dynamic minimumQuantityNotification;
  List<AvailableOption> allowedQuantities;
  bool customerEntersPrice;
  num customerEnteredPrice;
  String customerEnteredPriceRange;
  bool disableBuyButton;
  bool disableWishlistButton;
  bool isRental;
  bool availableForPreOrder;
  dynamic preOrderAvailabilityStartDateTimeUtc;
  dynamic preOrderAvailabilityStartDateTimeUserTime;
  num updatedShoppingCartItemId;
  dynamic updateShoppingCartItemType;
  CustomProperties customProperties;

  factory AddToCart.fromJson(Map<String, dynamic> json) => AddToCart(
    productId: json["ProductId"] == null ? null : json["ProductId"],
    enteredQuantity: json["EnteredQuantity"] == null ? null : json["EnteredQuantity"],
    minimumQuantityNotification: json["MinimumQuantityNotification"],
    allowedQuantities: json["AllowedQuantities"] == null ? null : List<AvailableOption>.from(json["AllowedQuantities"].map((x) => AvailableOption.fromJson(x))),
    customerEntersPrice: json["CustomerEntersPrice"] == null ? null : json["CustomerEntersPrice"],
    customerEnteredPrice: json["CustomerEnteredPrice"] == null ? null : json["CustomerEnteredPrice"],
    customerEnteredPriceRange: json["CustomerEnteredPriceRange"],
    disableBuyButton: json["DisableBuyButton"] == null ? null : json["DisableBuyButton"],
    disableWishlistButton: json["DisableWishlistButton"] == null ? null : json["DisableWishlistButton"],
    isRental: json["IsRental"] == null ? null : json["IsRental"],
    availableForPreOrder: json["AvailableForPreOrder"] == null ? null : json["AvailableForPreOrder"],
    preOrderAvailabilityStartDateTimeUtc: json["PreOrderAvailabilityStartDateTimeUtc"],
    preOrderAvailabilityStartDateTimeUserTime: json["PreOrderAvailabilityStartDateTimeUserTime"],
    updatedShoppingCartItemId: json["UpdatedShoppingCartItemId"] == null ? null : json["UpdatedShoppingCartItemId"],
    updateShoppingCartItemType: json["UpdateShoppingCartItemType"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "ProductId": productId == null ? null : productId,
    "EnteredQuantity": enteredQuantity == null ? null : enteredQuantity,
    "MinimumQuantityNotification": minimumQuantityNotification,
    "AllowedQuantities": allowedQuantities == null ? null : List<dynamic>.from(allowedQuantities.map((x) => x.toJson())),
    "CustomerEntersPrice": customerEntersPrice == null ? null : customerEntersPrice,
    "CustomerEnteredPrice": customerEnteredPrice == null ? null : customerEnteredPrice,
    "CustomerEnteredPriceRange": customerEnteredPriceRange,
    "DisableBuyButton": disableBuyButton == null ? null : disableBuyButton,
    "DisableWishlistButton": disableWishlistButton == null ? null : disableWishlistButton,
    "IsRental": isRental == null ? null : isRental,
    "AvailableForPreOrder": availableForPreOrder == null ? null : availableForPreOrder,
    "PreOrderAvailabilityStartDateTimeUtc": preOrderAvailabilityStartDateTimeUtc,
    "PreOrderAvailabilityStartDateTimeUserTime": preOrderAvailabilityStartDateTimeUserTime,
    "UpdatedShoppingCartItemId": updatedShoppingCartItemId == null ? null : updatedShoppingCartItemId,
    "UpdateShoppingCartItemType": updateShoppingCartItemType,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class Breadcrumb {
  Breadcrumb({
    this.enabled,
    this.productId,
    this.productName,
    this.productSeName,
    this.categoryBreadcrumb,
    this.customProperties,
  });

  bool enabled;
  num productId;
  String productName;
  String productSeName;
  List<CategoryBreadcrumb> categoryBreadcrumb;
  CustomProperties customProperties;

  factory Breadcrumb.fromJson(Map<String, dynamic> json) => Breadcrumb(
    enabled: json["Enabled"] == null ? null : json["Enabled"],
    productId: json["ProductId"] == null ? null : json["ProductId"],
    productName: json["ProductName"] == null ? null : json["ProductName"],
    productSeName: json["ProductSeName"] == null ? null : json["ProductSeName"],
    categoryBreadcrumb: json["CategoryBreadcrumb"] == null ? null : List<CategoryBreadcrumb>.from(json["CategoryBreadcrumb"].map((x) => CategoryBreadcrumb.fromJson(x))),
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "Enabled": enabled == null ? null : enabled,
    "ProductId": productId == null ? null : productId,
    "ProductName": productName == null ? null : productName,
    "ProductSeName": productSeName == null ? null : productSeName,
    "CategoryBreadcrumb": categoryBreadcrumb == null ? null : List<dynamic>.from(categoryBreadcrumb.map((x) => x.toJson())),
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class CategoryBreadcrumb {
  CategoryBreadcrumb({
    this.name,
    this.seName,
    this.numberOfProducts,
    this.includeInTopMenu,
    this.subCategories,
    this.haveSubCategories,
    this.route,
    this.id,
    this.customProperties,
  });

  String name;
  String seName;
  dynamic numberOfProducts;
  bool includeInTopMenu;
  List<dynamic> subCategories;
  bool haveSubCategories;
  dynamic route;
  num id;
  CustomProperties customProperties;

  factory CategoryBreadcrumb.fromJson(Map<String, dynamic> json) => CategoryBreadcrumb(
    name: json["Name"] == null ? null : json["Name"],
    seName: json["SeName"] == null ? null : json["SeName"],
    numberOfProducts: json["NumberOfProducts"],
    includeInTopMenu: json["IncludeInTopMenu"] == null ? null : json["IncludeInTopMenu"],
    subCategories: json["SubCategories"] == null ? null : List<dynamic>.from(json["SubCategories"].map((x) => x)),
    haveSubCategories: json["HaveSubCategories"] == null ? null : json["HaveSubCategories"],
    route: json["Route"],
    id: json["Id"] == null ? null : json["Id"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "Name": name == null ? null : name,
    "SeName": seName == null ? null : seName,
    "NumberOfProducts": numberOfProducts,
    "IncludeInTopMenu": includeInTopMenu == null ? null : includeInTopMenu,
    "SubCategories": subCategories == null ? null : List<dynamic>.from(subCategories.map((x) => x)),
    "HaveSubCategories": haveSubCategories == null ? null : haveSubCategories,
    "Route": route,
    "Id": id == null ? null : id,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class GiftCard {
  GiftCard({
    this.isGiftCard,
    this.recipientName,
    this.recipientEmail,
    this.senderName,
    this.senderEmail,
    this.message,
    this.giftCardType,
    this.customProperties,
  });

  bool isGiftCard;
  String recipientName;
  String recipientEmail;
  String senderName;
  String senderEmail;
  String message;
  num giftCardType;
  CustomProperties customProperties;

  factory GiftCard.fromJson(Map<String, dynamic> json) => GiftCard(
    isGiftCard: json["IsGiftCard"] == null ? null : json["IsGiftCard"],
    recipientName: json["RecipientName"],
    recipientEmail: json["RecipientEmail"],
    senderName: json["SenderName"],
    senderEmail: json["SenderEmail"],
    message: json["Message"],
    giftCardType: json["GiftCardType"] == null ? null : json["GiftCardType"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "IsGiftCard": isGiftCard == null ? null : isGiftCard,
    "RecipientName": recipientName,
    "RecipientEmail": recipientEmail,
    "SenderName": senderName,
    "SenderEmail": senderEmail,
    "Message": message,
    "GiftCardType": giftCardType == null ? null : giftCardType,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class ProductPrice {
  ProductPrice({
    this.currencyCode,
    this.oldPrice,
    this.price,
    this.priceWithDiscount,
    this.priceValue,
    this.customerEntersPrice,
    this.callForPrice,
    this.productId,
    this.hidePrices,
    this.isRental,
    this.rentalPrice,
    this.displayTaxShippingInfo,
    this.basePricePAngV,
    this.customProperties,
  });

  String currencyCode;
  String oldPrice;
  String price;
  String priceWithDiscount;
  double priceValue;
  bool customerEntersPrice;
  bool callForPrice;
  num productId;
  bool hidePrices;
  bool isRental;
  String rentalPrice;
  bool displayTaxShippingInfo;
  String basePricePAngV;
  CustomProperties customProperties;

  factory ProductPrice.fromJson(Map<String, dynamic> json) => ProductPrice(
    currencyCode: json["CurrencyCode"] == null ? null : json["CurrencyCode"],
    oldPrice: json["OldPrice"] == null ? null : json["OldPrice"],
    price: json["Price"] == null ? null : json["Price"],
    priceWithDiscount: json["PriceWithDiscount"] == null ? null : json["PriceWithDiscount"],
    priceValue: json["PriceValue"] == null ? null : json["PriceValue"],
    customerEntersPrice: json["CustomerEntersPrice"] == null ? null : json["CustomerEntersPrice"],
    callForPrice: json["CallForPrice"] == null ? null : json["CallForPrice"],
    productId: json["ProductId"] == null ? null : json["ProductId"],
    hidePrices: json["HidePrices"] == null ? null : json["HidePrices"],
    isRental: json["IsRental"] == null ? null : json["IsRental"],
    rentalPrice: json["RentalPrice"] == null ? null : json["RentalPrice"],
    displayTaxShippingInfo: json["DisplayTaxShippingInfo"] == null ? null : json["DisplayTaxShippingInfo"],
    basePricePAngV: json["BasePricePAngV"] == null ? null : json["BasePricePAngV"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "CurrencyCode": currencyCode == null ? null : currencyCode,
    "OldPrice": oldPrice,
    "Price": price == null ? null : price,
    "PriceWithDiscount": priceWithDiscount,
    "PriceValue": priceValue == null ? null : priceValue,
    "CustomerEntersPrice": customerEntersPrice == null ? null : customerEntersPrice,
    "CallForPrice": callForPrice == null ? null : callForPrice,
    "ProductId": productId == null ? null : productId,
    "HidePrices": hidePrices == null ? null : hidePrices,
    "IsRental": isRental == null ? null : isRental,
    "RentalPrice": rentalPrice,
    "DisplayTaxShippingInfo": displayTaxShippingInfo == null ? null : displayTaxShippingInfo,
    "BasePricePAngV": basePricePAngV,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class ProductReviewOverview {
  ProductReviewOverview({
    this.productId,
    this.ratingSum,
    this.totalReviews,
    this.allowCustomerReviews,
    this.canAddNewReview,
    this.customProperties,
  });

  num productId;
  num ratingSum;
  num totalReviews;
  bool allowCustomerReviews;
  bool canAddNewReview;
  CustomProperties customProperties;

  factory ProductReviewOverview.fromJson(Map<String, dynamic> json) => ProductReviewOverview(
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

class ProductSpecificationModel {
  ProductSpecificationModel({
    this.groups,
    this.customProperties,
  });

  List<Group> groups;
  CustomProperties customProperties;

  factory ProductSpecificationModel.fromJson(Map<String, dynamic> json) => ProductSpecificationModel(
    groups: json["Groups"] == null ? null : List<Group>.from(json["Groups"].map((x) => Group.fromJson(x))),
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "Groups": groups == null ? null : List<dynamic>.from(groups.map((x) => x.toJson())),
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class Group {
  Group({
    this.name,
    this.attributes,
    this.id,
    this.customProperties,
  });

  String name;
  List<SpecificationAttr> attributes;
  num id;
  CustomProperties customProperties;

  factory Group.fromJson(Map<String, dynamic> json) => Group(
    name: json["Name"],
    attributes: json["Attributes"] == null ? null : List<SpecificationAttr>.from(json["Attributes"].map((x) => SpecificationAttr.fromJson(x))),
    id: json["Id"],
    customProperties: CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "Name": name,
    "Attributes": attributes == null ? null : List<dynamic>.from(attributes.map((x) => x.toJson())),
    "Id": id,
    "CustomProperties": customProperties.toJson(),
  };
}

class SpecificationAttr {
  SpecificationAttr({
    this.name,
    this.values,
    this.id,
  });

  String name;
  List<SpecificationAttrValue> values;
  int id;

  factory SpecificationAttr.fromJson(Map<String, dynamic> json) => SpecificationAttr(
    name: json["Name"] == null ? null : json["Name"],
    values: json["Values"] == null ? null : List<SpecificationAttrValue>.from(json["Values"].map((x) => SpecificationAttrValue.fromJson(x))),
    id: json["Id"] == null ? null : json["Id"],
  );

  Map<String, dynamic> toJson() => {
    "Name": name == null ? null : name,
    "Values": values == null ? null : List<dynamic>.from(values.map((x) => x.toJson())),
    "Id": id == null ? null : id,
  };
}

class SpecificationAttrValue {
  SpecificationAttrValue({
    this.attributeTypeId,
    this.valueRaw,
    this.colorSquaresRgb,
    this.customProperties,
  });

  int attributeTypeId;
  String valueRaw;
  String colorSquaresRgb;
  CustomProperties customProperties;

  factory SpecificationAttrValue.fromJson(Map<String, dynamic> json) => SpecificationAttrValue(
    attributeTypeId: json["AttributeTypeId"] == null ? null : json["AttributeTypeId"],
    valueRaw: json["ValueRaw"] == null ? null : json["ValueRaw"],
    colorSquaresRgb: json["ColorSquaresRgb"] == null ? null : json["ColorSquaresRgb"],
    customProperties: json["CustomProperties"] == null ? null : CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "AttributeTypeId": attributeTypeId == null ? null : attributeTypeId,
    "ValueRaw": valueRaw == null ? null : valueRaw,
    "ColorSquaresRgb": colorSquaresRgb == null ? null : colorSquaresRgb,
    "CustomProperties": customProperties == null ? null : customProperties.toJson(),
  };
}

class TierPrice {
  TierPrice({
    this.price,
    this.quantity,
  });

  String price;
  int quantity;

  factory TierPrice.fromJson(Map<String, dynamic> json) => TierPrice(
    price: json["Price"] == null ? null : json["Price"],
    quantity: json["Quantity"] == null ? null : json["Quantity"],
  );

  Map<String, dynamic> toJson() => {
    "Price": price == null ? null : price,
    "Quantity": quantity == null ? null : quantity,
  };
}

class VendorModel {
  VendorModel({
    this.name,
    this.seName,
    this.productCount,
    this.id,
    this.customProperties,
  });

  String name;
  String seName;
  num productCount;
  num id;
  CustomProperties customProperties;

  factory VendorModel.fromJson(Map<String, dynamic> json) => VendorModel(
    name: json["Name"] == null ? null : json["Name"],
    seName: json["SeName"] == null ? null : json["SeName"],
    productCount: json["ProductCount"] == null ? null : json["ProductCount"],
    id: json["Id"],
    customProperties: CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "Name": name == null ? null : name,
    "SeName": seName == null ? null : seName,
    "ProductCount": productCount == null ? null : productCount,
    "Id": id,
    "CustomProperties": customProperties.toJson(),
  };
}
