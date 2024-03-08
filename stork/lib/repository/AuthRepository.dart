import 'package:nopcart_flutter/model/ChangePasswordResponse.dart';
import 'package:nopcart_flutter/model/GetAvatarResponse.dart';
import 'package:nopcart_flutter/model/GetOtpResponse.dart';
import 'package:nopcart_flutter/model/LoginFormResponse.dart';
import 'package:nopcart_flutter/model/PasswordRecoveryResponse.dart';
import 'package:nopcart_flutter/model/RegisterFormResponse.dart';
import 'package:nopcart_flutter/model/UserLoginResponse.dart';
import 'package:nopcart_flutter/model/requestbody/RegistrationReqBody.dart';
import 'package:nopcart_flutter/model/requestbody/UserLoginReqBody.dart';
import 'package:nopcart_flutter/networking/ApiBaseHelper.dart';
import 'package:nopcart_flutter/networking/Endpoints.dart';
import 'package:nopcart_flutter/repository/BaseRepository.dart';
import 'package:nopcart_flutter/utils/AppConstants.dart';

class AuthRepository extends BaseRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<LoginFormResponse> getLoginFormData() async {
    final response = await _helper.get(Endpoints.userLogin);
    return LoginFormResponse.fromJson(response);
  }

  Future<UserLoginResponse> postLoginFormData(UserLoginReqBody reqBody) async {
    final response = await _helper.post(Endpoints.userLogin, reqBody);
    return UserLoginResponse.fromJson(response);
  }

  Future<String> performLogout() async {
    final response = await _helper.get(Endpoints.userLogout);
    return response.toString();
  }

  Future<RegisterFormResponse> getRegisterFormData() async {
    final response = await _helper.get(Endpoints.userRegister);
    return RegisterFormResponse.fromJson(response);
  }

  Future<RegisterFormResponse> postRegisterFormData(RegistrationReqBody reqBody) async {
    final response = await _helper.post(Endpoints.userRegister, reqBody);
    return RegisterFormResponse.fromJson(response);
  }

  Future<RegisterFormResponse> getCustomerInfo() async {
    final response = await _helper.get(Endpoints.customerInfo);
    return RegisterFormResponse.fromJson(response);
  }

  Future<RegisterFormResponse> updateCustomerInfo(RegistrationReqBody reqBody) async {
    final response = await _helper.post(Endpoints.customerInfo, reqBody);
    return RegisterFormResponse.fromJson(response);
  }

  Future<PasswordRecoveryResponse> postPasswordRecoverRequest(PasswordRecoveryResponse reqBody) async {
    final response = await _helper.post(Endpoints.passwordRecovery, reqBody);
    return PasswordRecoveryResponse.fromJson(response);
  }

  Future<ChangePasswordResponse> getChangePassForm() async {
    final response = await _helper.get(Endpoints.passwordChange);
    return ChangePasswordResponse.fromJson(response);
  }

  Future<ChangePasswordResponse> postChangePassForm(ChangePasswordResponse reqBody) async {
    final response = await _helper.post(Endpoints.passwordChange, reqBody);
    return ChangePasswordResponse.fromJson(response);
  }

  Future<GetAvatarResponse> fetchAvatar() async {
    final response = await _helper.get(Endpoints.getAvatar);
    return GetAvatarResponse.fromJson(response);
  }

  Future<GetAvatarResponse> removeAvatar() async {
    final response = await _helper.post(Endpoints.removeAvatar, AppConstants.EMPTY_POST_BODY);
    return GetAvatarResponse.fromJson(response);
  }

  Future<GetAvatarResponse> uploadAvatar(String filePath) async {
    final response = await _helper.multipart(
        Endpoints.uploadAvatar, filePath,
    );
    return GetAvatarResponse.fromJson(response);
  }

  Future<GetOtpResponse> getOtp(String phoneNumber) async {
    final response = await _helper.get(
      '${Endpoints.getOtp}?phoneNumber=${Uri.encodeComponent(phoneNumber)}'
    );
    return GetOtpResponse.fromJson(response);
  }

  Future<GetOtpResponse> validateOtp(GetOtpData validateOtp) async {
    final response = await _helper.post(
      '${Endpoints.validateOtp}',
      validateOtp.toJson()
    );
    return GetOtpResponse.fromJson(response);
  }
}