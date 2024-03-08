import 'dart:async';

import 'package:nopcart_flutter/bloc/base_bloc.dart';
import 'package:nopcart_flutter/model/ChangePasswordResponse.dart';
import 'package:nopcart_flutter/model/LoginFormResponse.dart';
import 'package:nopcart_flutter/model/PasswordRecoveryResponse.dart';
import 'package:nopcart_flutter/model/UserLoginResponse.dart';
import 'package:nopcart_flutter/model/requestbody/UserLoginReqBody.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/repository/AuthRepository.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/Const.dart';

class AuthBloc implements BaseBloc {
  AuthRepository _repository;
  StreamController _scGetLogin, _scPostLogin, _scLogout,
      _scPassRecover, _scPassChange, _scPassChangePost, _scExternalAuth;

  StreamSink<ApiResponse<LoginFormData>> get loginFormSink =>
      _scGetLogin.sink;
  Stream<ApiResponse<LoginFormData>> get loginFormStream =>
      _scGetLogin.stream;

  StreamSink<ApiResponse<UserLoginData>> get loginResponseSink =>
      _scPostLogin.sink;
  Stream<ApiResponse<UserLoginData>> get loginResponseStream =>
      _scPostLogin.stream;

  StreamSink<ApiResponse<String>> get logoutResponseSink =>
      _scLogout.sink;
  Stream<ApiResponse<String>> get logoutResponseStream =>
      _scLogout.stream;

  StreamSink<ApiResponse<String>> get passRecoverSink =>
      _scPassRecover.sink;
  Stream<ApiResponse<String>> get passRecoverStream =>
      _scPassRecover.stream;

  StreamSink<ApiResponse<ChangePasswordData>> get passChangeSink =>
      _scPassChange.sink;
  Stream<ApiResponse<ChangePasswordData>> get passChangeStream =>
      _scPassChange.stream;

  StreamSink<ApiResponse<String>> get postPasswordChangeSink =>
      _scPassChangePost.sink;
  Stream<ApiResponse<String>> get postPasswordChangeStream =>
      _scPassChangePost.stream;

  StreamSink<ApiResponse<UserLoginData>> get externalAuthSink =>
      _scExternalAuth.sink;
  Stream<ApiResponse<UserLoginData>> get externalAuthStream =>
      _scExternalAuth.stream;

  AuthBloc() {
    _scGetLogin = StreamController<ApiResponse<LoginFormData>>();
    _scPostLogin = StreamController<ApiResponse<UserLoginData>>();
    _scLogout = StreamController<ApiResponse<String>>();
    _scPassRecover = StreamController<ApiResponse<String>>();
    _scPassChangePost = StreamController<ApiResponse<String>>();
    _scPassChange = StreamController<ApiResponse<ChangePasswordData>>();
    _scExternalAuth = StreamController<ApiResponse<UserLoginData>>();
    _repository = AuthRepository();
  }

  fetchLoginFormData() async {
    loginFormSink.add(ApiResponse.loading(
        GlobalService().getString(Const.COMMON_PLEASE_WAIT)));

    try {
      LoginFormResponse response = await _repository.getLoginFormData();
      loginFormSink.add(ApiResponse.completed(response.data));
    } catch (e) {
      loginFormSink.add(ApiResponse.error(e.toString()));
      // print(e.toString());
    }
  }

  postLoginFormData(LoginFormData data) async {
    UserLoginReqBody reqBody = UserLoginReqBody(data: data);

    loginResponseSink.add(ApiResponse.loading(
        GlobalService().getString(Const.COMMON_PLEASE_WAIT)));

    try {
      UserLoginResponse response = await _repository.postLoginFormData(reqBody);
      loginResponseSink.add(ApiResponse.completed(response.data));
    } catch (e) {
      loginResponseSink.add(ApiResponse.error(e.toString()));
      // print(e.toString());
    }
  }

  getExternalAuth(LoginFormData data) async {
    UserLoginReqBody reqBody = UserLoginReqBody(data: data);

    externalAuthSink.add(ApiResponse.loading(
        GlobalService().getString(Const.COMMON_PLEASE_WAIT)));

    try {
      UserLoginResponse response = await _repository.postLoginFormData(reqBody);
      loginResponseSink.add(ApiResponse.completed(response.data));
    } catch (e) {
      loginResponseSink.add(ApiResponse.error(e.toString()));
      // print(e.toString());
    }
  }
  
  postPasswordRecoverRequest(String email) async {
    passRecoverSink.add(ApiResponse.loading());
    PasswordRecoveryResponse reqBody = PasswordRecoveryResponse(
      data: PasswordRecoveryData(email: email, displayCaptcha: false),
      message: "",
      errorList: [],
    );

    try {
      PasswordRecoveryResponse response = await _repository.postPasswordRecoverRequest(reqBody);
      passRecoverSink.add(ApiResponse.completed(response.message));
    } catch (e) {
      passRecoverSink.add(ApiResponse.error(e.toString()));
      // print(e.toString());
    }
  }

  performLogout() async {
    logoutResponseSink.add(ApiResponse.loading(
        GlobalService().getString(Const.COMMON_PLEASE_WAIT)));

    try {
      String response = await _repository.performLogout();
      logoutResponseSink.add(ApiResponse.completed(response));
    } catch (e) {
      logoutResponseSink.add(ApiResponse.error(e.toString()));
      // print(e.toString());
    }
  }

  fetchChangePasswordFormData() async {
    passChangeSink.add(ApiResponse.loading());

    try {
      ChangePasswordResponse response = await _repository.getChangePassForm();
      passChangeSink.add(ApiResponse.completed(response.data));
    } catch (e) {
      passChangeSink.add(ApiResponse.error(e.toString()));
      // print(e.toString());
    }
  }

  postChangePasswordFormData(ChangePasswordData data) async {
    ChangePasswordResponse reqBody = ChangePasswordResponse(data: data);
    postPasswordChangeSink.add(ApiResponse.loading());

    try {
      ChangePasswordResponse response = await _repository.postChangePassForm(reqBody);
      postPasswordChangeSink.add(ApiResponse.completed(response.message));
    } catch (e) {
      postPasswordChangeSink.add(ApiResponse.error(e.toString()));
      // print(e.toString());
    }
  }

  @override
  void dispose() {
    _scGetLogin?.close();
    _scPostLogin?.close();
    _scLogout?.close();
    _scPassRecover?.close();
    _scPassChange?.close();
    _scPassChangePost?.close();
  }

}