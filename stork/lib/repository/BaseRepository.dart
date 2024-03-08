import 'package:nopcart_flutter/model/AddToCartResponse.dart';
import 'package:nopcart_flutter/model/EstimateShippingResponse.dart';
import 'package:nopcart_flutter/model/GetStatesResponse.dart';
import 'package:nopcart_flutter/model/requestbody/EstimateShippingReqBody.dart';
import 'package:nopcart_flutter/model/requestbody/FormValuesRequestBody.dart';
import 'package:nopcart_flutter/networking/ApiBaseHelper.dart';
import 'package:nopcart_flutter/networking/Endpoints.dart';

class BaseRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<GetStatesResponse> getStatesByCountry(int countryId) async {
    final response = await _helper.get('${Endpoints.getStatesByCountry}/$countryId');
    return GetStatesResponse.fromJson(response);
  }

  Future<AddToCartResponse> addToCartFromProductBox(int productId, int cartType, FormValuesRequestBody reqBody) async {
    final response = await _helper.post(
      '${Endpoints.addToCartFromProductBox}/$productId/$cartType',
      reqBody,
    );
    return AddToCartResponse.fromJson(response);
  }

  Future<EstimateShippingResponse> estimateShipping(EstimateShippingReqBody reqBody) async {
    final response = await _helper.post(Endpoints.cartEstimateShipping, reqBody);
    return EstimateShippingResponse.fromJson(response);
  }

  Future<EstimateShippingResponse> productEstimateShipping(EstimateShippingReqBody reqBody) async {
    final response = await _helper.post(Endpoints.productEstimateShipping, reqBody);
    return EstimateShippingResponse.fromJson(response);
  }
}