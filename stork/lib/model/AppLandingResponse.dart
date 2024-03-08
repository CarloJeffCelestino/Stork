import 'CustomProperties.dart';

class AppLandingResponse {
  AppLandingData data;
  String message;
  List<String> errorList;

  AppLandingResponse({this.data, this.message, this.errorList});

  AppLandingResponse.fromJson(Map<String, dynamic> json) {
    data = json['Data'] != null ? new AppLandingData.fromJson(json['Data']) : null;
    message = json['Message'];
    errorList = json['ErrorList'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    data['Message'] = this.message;
    data['ErrorList'] = this.errorList;
    return data;
  }
}

class AppLandingData {
  bool showHomepageSlider;
  bool showFeaturedProducts;
  bool sliderAutoPlay;
  int sliderAutoPlayTimeout;
  bool showBestsellersOnHomepage;
  bool showHomepageCategoryProducts;
  bool showManufacturers;
  bool rtl;
  String androidVersion;
  bool andriodForceUpdate;
  String playStoreUrl;
  String iOSVersion;
  bool iOSForceUpdate;
  String appStoreUrl;
  String logoUrl;
  int totalShoppingCartProducts;
  int totalWishListProducts;
  bool showAllVendors;
  bool anonymousCheckoutAllowed;
  bool showChangeBaseUrlPanel;
  bool hasReturnRequests;
  bool hideDownloadableProducts;
  String primaryThemeColor;
  String topBarBackgroundColor;
  String topBarTextColor;
  String bottomBarBackgroundColor;
  String bottomBarActiveColor;
  String bottomBarInactiveColor;
  String gradientStartingColor;
  String gradientMiddleColor;
  String gradientEndingColor;
  bool gradientEnabled;
  int iOSProductPriceTextSize;
  int androidProductPriceTextSize;
  int ionicProductPriceTextSize;
  bool newProductsEnabled;
  bool recentlyViewedProductsEnabled;
  bool compareProductsEnabled;
  bool allowCustomersToUploadAvatars;
  int avatarMaximumSizeBytes;
  bool hideBackInStockSubscriptionsTab;
  bool rewardPointsEnabled;
  bool showProductReviewsTabOnAccountPage;
  CurrencyNavSelector currencyNavSelector;
  LanguageNavSelector languageNavSelector;
  List<StringResources> stringResources;

  AppLandingData({this.showHomepageSlider, this.showFeaturedProducts, this.sliderAutoPlay, this.sliderAutoPlayTimeout, this.showBestsellersOnHomepage, this.showHomepageCategoryProducts, this.showManufacturers, this.rtl, this.androidVersion, this.andriodForceUpdate, this.playStoreUrl, this.iOSVersion, this.iOSForceUpdate, this.appStoreUrl, this.logoUrl, this.totalShoppingCartProducts, this.totalWishListProducts, this.showAllVendors, this.anonymousCheckoutAllowed, this.showChangeBaseUrlPanel, this.hasReturnRequests, this.hideDownloadableProducts, this.primaryThemeColor, this.topBarBackgroundColor, this.topBarTextColor, this.bottomBarBackgroundColor, this.bottomBarActiveColor, this.bottomBarInactiveColor, this.gradientStartingColor, this.gradientMiddleColor, this.gradientEndingColor, this.gradientEnabled, this.iOSProductPriceTextSize, this.androidProductPriceTextSize, this.ionicProductPriceTextSize, this.newProductsEnabled, this.recentlyViewedProductsEnabled, this.compareProductsEnabled, this.allowCustomersToUploadAvatars, this.avatarMaximumSizeBytes, this.hideBackInStockSubscriptionsTab, this.currencyNavSelector, this.languageNavSelector, this.stringResources});

  AppLandingData.fromJson(Map<String, dynamic> json) {
    showHomepageSlider = json['ShowHomepageSlider'];
    showFeaturedProducts = json['ShowFeaturedProducts'];
    sliderAutoPlay = json['SliderAutoPlay'];
    sliderAutoPlayTimeout = json['SliderAutoPlayTimeout'];
    showBestsellersOnHomepage = json['ShowBestsellersOnHomepage'];
    showHomepageCategoryProducts = json['ShowHomepageCategoryProducts'];
    showManufacturers = json['ShowManufacturers'];
    rtl = json['Rtl'];
    androidVersion = json['AndroidVersion'];
    andriodForceUpdate = json['AndriodForceUpdate'];
    playStoreUrl = json['PlayStoreUrl'];
    iOSVersion = json['IOSVersion'];
    iOSForceUpdate = json['IOSForceUpdate'];
    appStoreUrl = json['AppStoreUrl'];
    logoUrl = json['LogoUrl'];
    totalShoppingCartProducts = json['TotalShoppingCartProducts'];
    totalWishListProducts = json['TotalWishListProducts'];
    showAllVendors = json['ShowAllVendors'];
    anonymousCheckoutAllowed = json['AnonymousCheckoutAllowed'];
    showChangeBaseUrlPanel = json['ShowChangeBaseUrlPanel'];
    hasReturnRequests = json['HasReturnRequests'];
    hideDownloadableProducts = json['HideDownloadableProducts'];
    primaryThemeColor = json['PrimaryThemeColor'];
    topBarBackgroundColor = json['TopBarBackgroundColor'];
    topBarTextColor = json['TopBarTextColor'];
    bottomBarBackgroundColor = json['BottomBarBackgroundColor'];
    bottomBarActiveColor = json['BottomBarActiveColor'];
    bottomBarInactiveColor = json['BottomBarInactiveColor'];
    gradientStartingColor = json['GradientStartingColor'];
    gradientMiddleColor = json['GradientMiddleColor'];
    gradientEndingColor = json['GradientEndingColor'];
    gradientEnabled = json['GradientEnabled'];
    iOSProductPriceTextSize = json['IOSProductPriceTextSize'];
    androidProductPriceTextSize = json['AndroidProductPriceTextSize'];
    ionicProductPriceTextSize = json['IonicProductPriceTextSize'];
    newProductsEnabled = json['NewProductsEnabled'];
    recentlyViewedProductsEnabled = json['RecentlyViewedProductsEnabled'];
    compareProductsEnabled = json['CompareProductsEnabled'];
    allowCustomersToUploadAvatars = json['AllowCustomersToUploadAvatars'];
    avatarMaximumSizeBytes = json['AvatarMaximumSizeBytes'];
    hideBackInStockSubscriptionsTab = json['HideBackInStockSubscriptionsTab'];
    rewardPointsEnabled = json['RewardPointsEnabled'];
    showProductReviewsTabOnAccountPage = json['ShowProductReviewsTabOnAccountPage'];
    currencyNavSelector = json['CurrencyNavSelector'] != null ? new CurrencyNavSelector.fromJson(json['CurrencyNavSelector']) : null;
    languageNavSelector = json['LanguageNavSelector'] != null ? new LanguageNavSelector.fromJson(json['LanguageNavSelector']) : null;
    if (json['StringResources'] != null) {
      stringResources = <StringResources>[];
      json['StringResources'].forEach((v) { stringResources.add(new StringResources.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ShowHomepageSlider'] = this.showHomepageSlider;
    data['ShowFeaturedProducts'] = this.showFeaturedProducts;
    data['SliderAutoPlay'] = this.sliderAutoPlay;
    data['SliderAutoPlayTimeout'] = this.sliderAutoPlayTimeout;
    data['ShowBestsellersOnHomepage'] = this.showBestsellersOnHomepage;
    data['ShowHomepageCategoryProducts'] = this.showHomepageCategoryProducts;
    data['ShowManufacturers'] = this.showManufacturers;
    data['Rtl'] = this.rtl;
    data['AndroidVersion'] = this.androidVersion;
    data['AndriodForceUpdate'] = this.andriodForceUpdate;
    data['PlayStoreUrl'] = this.playStoreUrl;
    data['IOSVersion'] = this.iOSVersion;
    data['IOSForceUpdate'] = this.iOSForceUpdate;
    data['AppStoreUrl'] = this.appStoreUrl;
    data['LogoUrl'] = this.logoUrl;
    data['TotalShoppingCartProducts'] = this.totalShoppingCartProducts;
    data['TotalWishListProducts'] = this.totalWishListProducts;
    data['ShowAllVendors'] = this.showAllVendors;
    data['AnonymousCheckoutAllowed'] = this.anonymousCheckoutAllowed;
    data['ShowChangeBaseUrlPanel'] = this.showChangeBaseUrlPanel;
    data['HasReturnRequests'] = this.hasReturnRequests;
    data['HideDownloadableProducts'] = this.hideDownloadableProducts;
    data['PrimaryThemeColor'] = this.primaryThemeColor;
    data['TopBarBackgroundColor'] = this.topBarBackgroundColor;
    data['TopBarTextColor'] = this.topBarTextColor;
    data['BottomBarBackgroundColor'] = this.bottomBarBackgroundColor;
    data['BottomBarActiveColor'] = this.bottomBarActiveColor;
    data['BottomBarInactiveColor'] = this.bottomBarInactiveColor;
    data['GradientStartingColor'] = this.gradientStartingColor;
    data['GradientMiddleColor'] = this.gradientMiddleColor;
    data['GradientEndingColor'] = this.gradientEndingColor;
    data['GradientEnabled'] = this.gradientEnabled;
    data['IOSProductPriceTextSize'] = this.iOSProductPriceTextSize;
    data['AndroidProductPriceTextSize'] = this.androidProductPriceTextSize;
    data['IonicProductPriceTextSize'] = this.ionicProductPriceTextSize;
    data['NewProductsEnabled'] = this.newProductsEnabled;
    data['RecentlyViewedProductsEnabled'] = this.recentlyViewedProductsEnabled;
    data['CompareProductsEnabled'] = this.compareProductsEnabled;
    data['AllowCustomersToUploadAvatars'] = this.allowCustomersToUploadAvatars;
    data['AvatarMaximumSizeBytes'] = this.avatarMaximumSizeBytes;
    data['HideBackInStockSubscriptionsTab'] = this.hideBackInStockSubscriptionsTab;
    data['RewardPointsEnabled'] = this.rewardPointsEnabled;
    data['ShowProductReviewsTabOnAccountPage'] = this.showProductReviewsTabOnAccountPage;
    if (this.currencyNavSelector != null) {
      data['CurrencyNavSelector'] = this.currencyNavSelector.toJson();
    }
    if (this.languageNavSelector != null) {
      data['LanguageNavSelector'] = this.languageNavSelector.toJson();
    }
    if (this.stringResources != null) {
      data['StringResources'] = this.stringResources.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CurrencyNavSelector {
  List<AvailableCurrencies> availableCurrencies;
  int currentCurrencyId;
  CustomProperties customProperties;

  CurrencyNavSelector({this.availableCurrencies, this.currentCurrencyId, this.customProperties});

  CurrencyNavSelector.fromJson(Map<String, dynamic> json) {
    if (json['AvailableCurrencies'] != null) {
      availableCurrencies = <AvailableCurrencies>[];
      json['AvailableCurrencies'].forEach((v) { availableCurrencies.add(new AvailableCurrencies.fromJson(v)); });
    }
    currentCurrencyId = json['CurrentCurrencyId'];
    customProperties = json['CustomProperties'] != null ? new CustomProperties.fromJson(json['CustomProperties']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.availableCurrencies != null) {
      data['AvailableCurrencies'] = this.availableCurrencies.map((v) => v.toJson()).toList();
    }
    data['CurrentCurrencyId'] = this.currentCurrencyId;
    if (this.customProperties != null) {
      data['CustomProperties'] = this.customProperties.toJson();
    }
    return data;
  }
}

class AvailableCurrencies {
  String name;
  String currencySymbol;
  int id;
  CustomProperties customProperties;

  AvailableCurrencies({this.name, this.currencySymbol, this.id, this.customProperties});

  AvailableCurrencies.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    currencySymbol = json['CurrencySymbol'];
    id = json['Id'];
    customProperties = json['CustomProperties'] != null ? new CustomProperties.fromJson(json['CustomProperties']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['CurrencySymbol'] = this.currencySymbol;
    data['Id'] = this.id;
    if (this.customProperties != null) {
      data['CustomProperties'] = this.customProperties.toJson();
    }
    return data;
  }
}

class LanguageNavSelector {
  List<AvailableLanguages> availableLanguages;
  int currentLanguageId;
  bool useImages;
  CustomProperties customProperties;

  LanguageNavSelector({this.availableLanguages, this.currentLanguageId, this.useImages, this.customProperties});

  LanguageNavSelector.fromJson(Map<String, dynamic> json) {
    if (json['AvailableLanguages'] != null) {
      availableLanguages = <AvailableLanguages>[];
      json['AvailableLanguages'].forEach((v) { availableLanguages.add(new AvailableLanguages.fromJson(v)); });
    }
    currentLanguageId = json['CurrentLanguageId'];
    useImages = json['UseImages'];
    customProperties = json['CustomProperties'] != null ? new CustomProperties.fromJson(json['CustomProperties']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.availableLanguages != null) {
      data['AvailableLanguages'] = this.availableLanguages.map((v) => v.toJson()).toList();
    }
    data['CurrentLanguageId'] = this.currentLanguageId;
    data['UseImages'] = this.useImages;
    if (this.customProperties != null) {
      data['CustomProperties'] = this.customProperties.toJson();
    }
    return data;
  }
}

class AvailableLanguages {
  String name;
  String flagImageFileName;
  int id;
  CustomProperties customProperties;

  AvailableLanguages({this.name, this.flagImageFileName, this.id, this.customProperties});

  AvailableLanguages.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    flagImageFileName = json['FlagImageFileName'];
    id = json['Id'];
    customProperties = json['CustomProperties'] != null ? new CustomProperties.fromJson(json['CustomProperties']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['FlagImageFileName'] = this.flagImageFileName;
    data['Id'] = this.id;
    if (this.customProperties != null) {
      data['CustomProperties'] = this.customProperties.toJson();
    }
    return data;
  }
}

class StringResources {
  String key;
  String value;

  StringResources({this.key, this.value});

  StringResources.fromJson(Map<String, dynamic> json) {
    key = json['Key'];
    value = json['Value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Key'] = this.key;
    data['Value'] = this.value;
    return data;
  }
}
