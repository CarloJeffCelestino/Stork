

class BaseResponse {
  BaseResponse({
    this.message,
    this.errorList,
  });

  String message;
  List<String> errorList;

  factory BaseResponse.fromJson(Map<String, dynamic> json) => BaseResponse(
    message: json["Message"],
    errorList: List<String>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Message": message,
    "ErrorList": List<dynamic>.from(errorList.map((x) => x)),
  };

  String getFormattedErrorMsg() {
    var msg = "";

    errorList.forEach((element) {
      msg = msg + " " + element + "\n";
    });

    return msg.trimRight();
  }
}
