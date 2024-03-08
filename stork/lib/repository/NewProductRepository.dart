import 'package:nopcart_flutter/model/NewProductResponse.dart';
import 'package:nopcart_flutter/networking/ApiBaseHelper.dart';
import 'package:nopcart_flutter/networking/Endpoints.dart';

class NewProductRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<NewProductResponse> fetchNewProducts() async {
    final response = await _helper.get(Endpoints.newProducts);
    return NewProductResponse.fromJson(response);
  }
}