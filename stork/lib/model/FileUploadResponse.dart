class FileUploadResponse {
  FileUploadResponse({
    this.data,
    this.message,
    this.errorList,
  });

  FileUploadData data;
  String message;
  List<String> errorList;

  factory FileUploadResponse.fromJson(Map<String, dynamic> json) => FileUploadResponse(
    data: json["Data"] == null ? null : FileUploadData.fromJson(json["Data"]),
    message: json["Message"] == null ? null : json["Message"],
    errorList: json["ErrorList"] == null ? null : List<String>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : data.toJson(),
    "Message": message == null ? null : message,
    "ErrorList": errorList == null ? null : List<dynamic>.from(errorList.map((x) => x)),
  };
}

class FileUploadData {
  FileUploadData({
    this.downloadUrl,
    this.downloadGuid,
    this.attributedId,
  });

  String downloadUrl;
  String downloadGuid;
  num attributedId; // This field is not in response. Used to map attribute & uploaded file

  factory FileUploadData.fromJson(Map<String, dynamic> json) => FileUploadData(
    downloadUrl: json["DownloadUrl"] == null ? null : json["DownloadUrl"],
    downloadGuid: json["DownloadGuid"] == null ? null : json["DownloadGuid"],
  );

  Map<String, dynamic> toJson() => {
    "DownloadUrl": downloadUrl == null ? null : downloadUrl,
    "DownloadGuid": downloadGuid == null ? null : downloadGuid,
  };
}
