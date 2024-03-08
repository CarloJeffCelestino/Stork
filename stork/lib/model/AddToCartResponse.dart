class AddToCartResponse {
  AddToCartResponse({
    this.data,
    this.message,
    this.errorList,
  });

  AddToCartData data;
  String message;
  List<String> errorList;

  factory AddToCartResponse.fromJson(Map<String, dynamic> json) =>
      AddToCartResponse(
        data: AddToCartData.fromJson(json["Data"]),
        message: json["Message"],
        errorList: List<String>.from(json["ErrorList"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "Data": data.toJson(),
        "Message": message,
        "ErrorList": List<String>.from(errorList.map((x) => x)),
      };
}

class AddToCartData {
  AddToCartData({
    this.totalShoppingCartProducts,
    this.totalWishListProducts,
    this.redirectToDetailsPage,
    this.redirectToWishListPage,
    this.redirectToShoppingCartPage,
  });

  int totalShoppingCartProducts;
  int totalWishListProducts;
  bool redirectToDetailsPage;
  bool redirectToWishListPage;
  bool redirectToShoppingCartPage;

  factory AddToCartData.fromJson(Map<String, dynamic> json) => AddToCartData(
        totalShoppingCartProducts: json["TotalShoppingCartProducts"],
        totalWishListProducts: json["TotalWishListProducts"],
        redirectToDetailsPage: json["RedirectToDetailsPage"],
        redirectToWishListPage: json["RedirectToWishListPage"],
        redirectToShoppingCartPage: json["RedirectToShoppingCartPage"],
      );

  Map<String, dynamic> toJson() => {
        "TotalShoppingCartProducts": totalShoppingCartProducts,
        "TotalWishListProducts": totalWishListProducts,
        "RedirectToDetailsPage": redirectToDetailsPage,
        "RedirectToWishListPage": redirectToWishListPage,
        "RedirectToShoppingCartPage": redirectToShoppingCartPage,
      };
}
