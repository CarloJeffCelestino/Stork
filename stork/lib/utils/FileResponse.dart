import 'dart:typed_data';

class FileResponse {
  final Uint8List fileBytes;
  final jsonStr;
  final filename;
  bool isFile;

  FileResponse({this.fileBytes, this.jsonStr, this.filename}) {
    this.isFile = this.fileBytes != null;
  }
}