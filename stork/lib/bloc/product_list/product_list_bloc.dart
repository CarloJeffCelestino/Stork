import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:nopcart_flutter/model/product_list/ProductListResponse.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/repository/product_list/ProductListRepository.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/Const.dart';

class ProductListBloc {
  ProductListRepository _prodListRepository;
  StreamController _prodListStreamCtrl;

  StreamSink<ApiResponse<ProductListResponse>> get prodListSink =>
      _prodListStreamCtrl.sink;
  Stream<ApiResponse<ProductListResponse>> get prodListStream =>
      _prodListStreamCtrl.stream;

  ProductListBloc() {
    _prodListRepository = ProductListRepository();
    _prodListStreamCtrl =
        StreamController<ApiResponse<ProductListResponse>>.broadcast();
  }

  String type;
  int categoryId;
  int pageNumber;
  String orderBy;
  String price;
  String specs;
  String ms;

  fetchProductList() async {
    prodListSink.add(ApiResponse.loading(
        GlobalService().getString(Const.COMMON_PLEASE_WAIT)));

    try {
      Map<String, String> queryParams = {
        'PageNumber': pageNumber.toString(),
        'PageSize': kIsWeb ? '24' : '9',
        'orderby': orderBy,
        'price': price,
        'specs': specs,
        'ms': ms,
      };

      print(kIsWeb);
      print(queryParams['PageSize']);

      ProductListResponse response = await _prodListRepository.fetchProductList(
          type, categoryId, queryParams);
      prodListSink.add(ApiResponse.completed(response));
    } catch (e) {
      prodListSink.add(ApiResponse.error(e.toString()));
      // print(e);
    }
  }

  dispose() {
    _prodListStreamCtrl.close();
  }
}
