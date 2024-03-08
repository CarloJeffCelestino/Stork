import 'dart:developer';

import 'package:nopcart_flutter/model/AddToCartResponse.dart';
import 'package:nopcart_flutter/model/requestbody/FormValue.dart';
import 'package:nopcart_flutter/model/requestbody/FormValuesRequestBody.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/repository/BaseRepository.dart';
import 'package:nopcart_flutter/utils/AppConstants.dart';

class ProductBoxBloc {
  BaseRepository _repository;

  ProductBoxBloc() {
    _repository = BaseRepository();
  }

  Future<ApiResponse<AddToCartResponse>> addToCart(num productId, bool isCart) async {

    FormValuesRequestBody reqBody = FormValuesRequestBody(
        formValues: [
          FormValue(
            key: 'addtocart_$productId.EnteredQuantity',
            value: '1',
          ),
        ]
    );

    try {
      AddToCartResponse response = await _repository.addToCartFromProductBox(
          productId,
          isCart ? AppConstants.typeShoppingCart : AppConstants.typeWishList,
          reqBody
      );

      // log('test 3');
      return ApiResponse.completed(response);
    } catch (e) {
      // log('test 4');

      return ApiResponse.error(e.toString());
    }
  }
}