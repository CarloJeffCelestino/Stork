class CategoryTreeResponse {
  CategoryTreeResponse({
    this.data,
    this.message,
    this.errorList,
  });

  List<CategoryTreeResponseData> data;
  dynamic message;
  List<dynamic> errorList;

  factory CategoryTreeResponse.fromJson(Map<String, dynamic> json) =>
      CategoryTreeResponse(
        data: List<CategoryTreeResponseData>.from(
            json["Data"].map((x) => CategoryTreeResponseData.fromJson(x))),
        message: json["Message"],
        errorList: List<dynamic>.from(json["ErrorList"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "Data": List<dynamic>.from(data.map((x) => x.toJson())),
        "Message": message,
        "ErrorList": List<dynamic>.from(errorList.map((x) => x)),
      };
}

class CategoryTreeResponseData {
  CategoryTreeResponseData({
    this.categoryId,
    this.seName,
    this.name,
    this.iconUrl,
    this.subCategories,
    this.displayOrder,
  });

  int categoryId;
  String seName;
  String name;
  String iconUrl;
  List<CategoryTreeResponseData> subCategories;
  int displayOrder;
  bool isExpanded = false;

  factory CategoryTreeResponseData.fromJson(Map<String, dynamic> json) =>
      CategoryTreeResponseData(
        categoryId: json["CategoryId"],
        seName: json["SeName"],
        name: json["Name"],
        iconUrl: json["IconUrl"],
        subCategories: List<CategoryTreeResponseData>.from(json["SubCategories"]
            .map((x) => CategoryTreeResponseData.fromJson(x))),
        displayOrder: json["DisplayOrder"],

      );

  Map<String, dynamic> toJson() => {
        "CategoryId": categoryId,
        "SeName": seName,
        "Name": name,
        "IconUrl": iconUrl,
        "SubCategories":
            List<dynamic>.from(subCategories.map((x) => x.toJson())),
        "DisplayOrder": displayOrder,
      };

}
