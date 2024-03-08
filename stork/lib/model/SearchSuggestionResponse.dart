class SearchSuggestionResponse {
  SearchSuggestionResponse({
    this.data,
    this.message,
    this.errorList,
  });

  List<SearchSuggestionData> data;
  String message;
  List<String> errorList;

  factory SearchSuggestionResponse.fromJson(Map<String, dynamic> json) => SearchSuggestionResponse(
    data: json["Data"] == null ? null : List<SearchSuggestionData>.from(json["Data"].map((x) => SearchSuggestionData.fromJson(x))),
    message: json["Message"] == null ? null : json["Message"],
    errorList: json["ErrorList"] == null ? null : List<String>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    "Message": message == null ? null : message,
    "ErrorList": errorList == null ? null : List<dynamic>.from(errorList.map((x) => x)),
  };
}

class SearchSuggestionData {
  SearchSuggestionData({
    this.label,
    this.productId,
    this.productPictureUrl,
    this.showLinkToResultSearch,
  });

  String label;
  int productId;
  String productPictureUrl;
  bool showLinkToResultSearch;

  factory SearchSuggestionData.fromJson(Map<String, dynamic> json) => SearchSuggestionData(
    label: json["label"] == null ? null : json["label"],
    productId: json["productid"] == null ? null : json["productid"],
    productPictureUrl: json["productpictureurl"],
    showLinkToResultSearch: json["showlinktoresultsearch"] == null ? null : json["showlinktoresultsearch"],
  );

  Map<String, dynamic> toJson() => {
    "label": label == null ? null : label,
    "productid": productId == null ? null : productId,
    "productpictureurl": productPictureUrl,
    "showlinktoresultsearch": showLinkToResultSearch == null ? null : showLinkToResultSearch,
  };
}
