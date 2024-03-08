import 'package:nopcart_flutter/model/FileDownloadResponse.dart';
import 'package:nopcart_flutter/model/FileUploadResponse.dart';
import 'package:nopcart_flutter/model/ReturnRequestHistoryResponse.dart';
import 'package:nopcart_flutter/model/ReturnRequestResponse.dart';
import 'package:nopcart_flutter/model/SampleDownloadResponse.dart';
import 'package:nopcart_flutter/model/requestbody/ReturnRequestBody.dart';
import 'package:nopcart_flutter/networking/ApiBaseHelper.dart';
import 'package:nopcart_flutter/networking/Endpoints.dart';
import 'package:nopcart_flutter/utils/FileResponse.dart';
import 'package:nopcart_flutter/utils/utility.dart';

class ReturnRequestRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<ReturnRequestResponse> fetchReturnRequestForm(num orderId) async {
    final response = await _helper.get('${Endpoints.returnRequest}/$orderId');
    return ReturnRequestResponse.fromJson(response);
  }

  Future<ReturnRequestResponse> postReturnRequestForm(
      num orderId, ReturnRequestBody reqBody) async {
    final response = await _helper.post('${Endpoints.returnRequest}/$orderId', reqBody);
    return ReturnRequestResponse.fromJson(response);
  }

  Future<FileUploadResponse> uploadFile(String filePath) async {
    final response = await _helper.multipart('${Endpoints.uploadFileReturnRequest}', filePath);
    return FileUploadResponse.fromJson(response);
  }

  Future<ReturnReqHistoryResponse> fetchReturnRequestHistory() async {
    final response = await _helper.get(Endpoints.returnRequestHistory);
    return ReturnReqHistoryResponse.fromJson(response);
  }

  Future<FileDownloadResponse> downloadFile(String guid) async {
    final FileResponse response = await _helper.getFile('${Endpoints.returnRequestFileDownload}/$guid');

    if(response.isFile) {
      return FileDownloadResponse<SampleDownloadResponse>(
        file: await saveFileToDisk(response, showNotification: true),
      );
    } else {
      return FileDownloadResponse<SampleDownloadResponse>(
        jsonResponse: SampleDownloadResponse.fromJson(response.jsonStr),
      );
    }
  }
}