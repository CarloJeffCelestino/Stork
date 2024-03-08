import 'dart:io';

class FileDownloadResponse<T> {
  final T jsonResponse;
  final File file;

  FileDownloadResponse({this.jsonResponse, this.file});
}