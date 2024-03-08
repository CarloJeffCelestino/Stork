import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:nopcart_flutter/model/AppLandingResponse.dart';
import 'package:nopcart_flutter/model/BaseResponse.dart';
import 'package:nopcart_flutter/model/requestbody/AppStartReqBody.dart';
import 'package:nopcart_flutter/networking/ApiBaseHelper.dart';
import 'package:nopcart_flutter/networking/Endpoints.dart';

class SettingsRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<AppLandingResponse> fetchAppLandingSettings() async {
    final response = await _helper.get(Endpoints.appLandingSettings);
    return AppLandingResponse.fromJson(response);
  }

  Future<BaseResponse> postFcmToken(String fcmToken) async {

    num deviceTypeId;

    if(defaultTargetPlatform == TargetPlatform.android)
      deviceTypeId = 10;
    else if(defaultTargetPlatform == TargetPlatform.iOS)
      deviceTypeId = 5;
    else
      deviceTypeId = 20;

    final response = await _helper.post(Endpoints.appStart, AppStartReqBody(
      data: AppStartData(
        deviceTypeId: deviceTypeId, // Android
        subscriptionId: fcmToken,
      )
    ));
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> changeLanguage(int languageId) async {
    final response = await _helper.get('${Endpoints.setLanguage}/$languageId');
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> changeCurrency(int currencyId) async {
    final response = await _helper.get('${Endpoints.setCurrency}/$currencyId');
    return BaseResponse.fromJson(response);
  }
}
