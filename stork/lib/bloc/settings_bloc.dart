import 'dart:async';

import 'package:nopcart_flutter/bloc/base_bloc.dart';
import 'package:nopcart_flutter/model/AppLandingResponse.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/repository/SettingsRepository.dart';

class SettingsBloc extends BaseBloc {
  SettingsRepository _repository;
  StreamController _scAppLanding, _scChangeLang;

  StreamSink<ApiResponse<AppLandingResponse>> get appLandingSink =>
      _scAppLanding.sink;
  Stream<ApiResponse<AppLandingResponse>> get appLandingStream =>
      _scAppLanding.stream;

  StreamSink<ApiResponse<String>> get languageSink => _scChangeLang.sink;
  Stream<ApiResponse<String>> get languageStream => _scChangeLang.stream;

  SettingsBloc() {
    _repository = SettingsRepository();
    _scAppLanding = StreamController<ApiResponse<AppLandingResponse>>();
    _scChangeLang = StreamController<ApiResponse<String>>();
  }

  fetchAppLandingData() async {
    if(_scAppLanding.isClosed)
      return;
    appLandingSink.add(ApiResponse.loading());

    try {
      var response = await _repository.fetchAppLandingSettings();
      appLandingSink.add(ApiResponse.completed(response));
    } catch (e) {
      appLandingSink.add(ApiResponse.error(e.toString()));
      // print(e);
    }
  }

  changeLanguage(int languageId) async {
    if(_scChangeLang.isClosed)
      return;
    languageSink.add(ApiResponse.loading());

    try {
      var response = await _repository.changeLanguage(languageId);
      languageSink.add(ApiResponse.completed(response.message));
    } catch (e) {
      languageSink.add(ApiResponse.error(e.toString()));
      // print(e);
    }
  }

  changeCurrency(int currencyId) async {
    if(_scChangeLang.isClosed)
      return;
    languageSink.add(ApiResponse.loading());

    try {
      var response = await _repository.changeCurrency(currencyId);
      languageSink.add(ApiResponse.completed(response.message));
    } catch (e) {
      languageSink.add(ApiResponse.error(e.toString()));
      // print(e);
    }
  }

  @override
  void dispose() {
    _scAppLanding?.close();
    _scChangeLang?.close();
  }

}