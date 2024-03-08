import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart' as jwt;
import 'package:mime/mime.dart';
import 'package:nopcart_flutter/model/BaseResponse.dart';
import 'package:nopcart_flutter/networking/Endpoints.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/AppConstants.dart';
import 'package:nopcart_flutter/utils/FileResponse.dart';
import 'package:flutter/foundation.dart';

import 'AppException.dart';

class ApiBaseHelper {
  final String _baseUrl = Endpoints.base_url;

  Future<dynamic> get(String url) async {
    // print('Get, url $url');
    var responseJson;

    try {
      final response = await http
          .get(Uri.parse(_baseUrl + url), headers: getRequestHeader())
          .timeout(
        Duration(seconds: 30),
        onTimeout: () {
          throw FetchDataException(408, 'Request timeout');
        },
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      // print('No net');
      throw FetchDataException(0, 'No Internet connection');
    }

    // print('Get received!');
    return responseJson;
  }

  Future<dynamic> post(String url, dynamic requestBody) async {
    var body = json.encode(requestBody);
    var responseJson;

    // print('Post, url $url, reqBody: ${body.toString()}');

    try {
      final response = await http.post(Uri.parse(_baseUrl + url),
          headers: getRequestHeader(), body: body);
      responseJson = _returnResponse(response);
    } on SocketException {
      // print('No net');
      throw FetchDataException(0, 'No Internet connection');
    }

    // print('Post received!');
    return responseJson;
  }

  Future<dynamic> multipart(String url, String filePath) async {
    var request = http.MultipartRequest('POST', Uri.parse(_baseUrl + url));
    request.headers.addAll(getRequestHeader());
    // request.fields['key'] = 'value';
    var responseJson;

    // detect mimetype of the file
    final mimeType = lookupMimeType(filePath);
    final mimeSplitted = mimeType?.split('/') ?? [];
    final mimePart1 = mimeSplitted.isNotEmpty ? mimeSplitted[0] : 'application';
    final mimePart2 = mimeSplitted.length > 1 ? mimeSplitted[1] : 'unknown';
    final fileName = filePath.split('/').last ?? 'uploadedFile';

    // print('Multipart Post, url $url, file: $filePath, mime: $mimePart1/$mimePart2');

    try {
      request.files.add(http.MultipartFile(
        'file',
        File(filePath).readAsBytes().asStream(),
        File(filePath).lengthSync(),
        filename: fileName,
        contentType: MediaType(mimePart1, mimePart2)
      ));
      var responseStream = await request.send();
      var response = await http.Response.fromStream(responseStream);
      responseJson = _returnResponse(response);
    } catch(e) {
      // print(e.toString());
    }

    // print('Multipart response received!');
    return responseJson;
  }

  Future<FileResponse> getFile(String url) async {
    // print('Get, url $url');
    FileResponse responseJson;

    try {
      final response = await http.get(Uri.parse(_baseUrl + url),
          headers: getRequestHeader());

      var contentType = response.headers['content-type'] ?? '';

      if(contentType.contains('application/json')) {
        responseJson = FileResponse(jsonStr: _returnResponse(response));
      } else {
        List<String> tokens = response.headers['content-disposition']?.split(";") ?? [];
        String filename = 'new_file.${contentType.split('/').last}';
        for (var i = 0; i < tokens.length; i++) {
          if (tokens[i].contains('filename') && !tokens[i].contains('filename*')) {
            filename = tokens[i]
                .substring(tokens[i].indexOf("=") + 1, tokens[i].length);
            break;
          }
        }

        responseJson = FileResponse(fileBytes: response.bodyBytes, filename: filename);
      }
    } on SocketException {
      // print('No net');
      throw FetchDataException(0, 'No Internet connection');
    }

    // print('Get received!');
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        if(response.body!=null && response.body.isNotEmpty) {
          Map<String, dynamic> responseJson = jsonDecode(response.body.toString());
          // log(responseJson.toString());

          var errorMsg = parseErrorMessage(response.body.toString());
          if(errorMsg.isNotEmpty && errorMsg!=response.body) {
            throw BadRequestException(response.statusCode, errorMsg);
          }
          
          return responseJson;
        }
        return '';
      case 302:
      case 400:
      case 401:
      case 403:
      case 404:
      case 500:
        throw BadRequestException(
            response.statusCode, parseErrorMessage(response.body.toString()));
      default:
        throw FetchDataException(response.statusCode,
            'Network error. StatusCode : ${response.statusCode}');
    }
  }

  Map<String, String> getRequestHeader() {

    final claimSet = jwt.JwtClaim(
      issuedAt: DateTime.now(),
      otherClaims: <String, dynamic>{
        'NST_KEY': AppConstants.NstKey,
      },
    );

    String jwtToken = jwt.issueJwtHS256(claimSet, AppConstants.NstSecret);

    var map = {
      'NST': jwtToken,
      'deviceId': GlobalService().getDeviceId(),
      'Content-Type': 'application/json',
    };

    if (!kIsWeb)
      map['User-Agent'] = 'storkph.flutter/v1';

    if (GlobalService().getAuthToken().isNotEmpty)
      map['Token'] = GlobalService().getAuthToken();

    // // print('header: ${map.toString()}');

    return map;
  }

  String parseErrorMessage(String response) {
    var error = "";
    try {
      error =
          BaseResponse.fromJson(jsonDecode(response)).getFormattedErrorMsg();
    } catch (e) {
      error = response;
    }

    return error;
  }
}
