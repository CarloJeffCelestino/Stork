
import 'package:nopcart_flutter/model/DownloadableProductResponse.dart';
import 'package:nopcart_flutter/model/FileDownloadResponse.dart';
import 'package:nopcart_flutter/model/SampleDownloadResponse.dart';
import 'package:nopcart_flutter/model/UserAgreementResponse.dart';
import 'package:nopcart_flutter/networking/ApiBaseHelper.dart';
import 'package:nopcart_flutter/networking/Endpoints.dart';
import 'package:nopcart_flutter/utils/FileResponse.dart';
import 'package:nopcart_flutter/utils/utility.dart';

class DownloadableProdRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<DownloadableProductResponse> fetchDownloadableProducts() async {
    final response = await _helper.get(Endpoints.downloadableProducts);
    return DownloadableProductResponse.fromJson(response);
  }

  Future<UserAgreementResponse> fetchUserAgreementText(String guid) async {
    final response = await _helper.get('${Endpoints.userAgreement}/$guid');
    return UserAgreementResponse.fromJson(response);
  }

  Future<FileDownloadResponse> downloadFile(String guid, String consent) async {
    final FileResponse response = await _helper.getFile('${Endpoints.getDownload}/$guid/$consent');

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