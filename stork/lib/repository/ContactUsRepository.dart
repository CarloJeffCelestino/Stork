import 'package:nopcart_flutter/model/ContactUsResponse.dart';
import 'package:nopcart_flutter/networking/ApiBaseHelper.dart';
import 'package:nopcart_flutter/networking/Endpoints.dart';

class ContactUsRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<ContactUsResponse> fetchFormData() async {
    final response = await _helper.get(Endpoints.contactUs);
    return ContactUsResponse.fromJson(response);
  }

  Future<ContactUsResponse> postEnquiry(ContactUsResponse reqBody) async {
    final response = await _helper.post(Endpoints.contactUs, reqBody);
    return ContactUsResponse.fromJson(response);
  }

}