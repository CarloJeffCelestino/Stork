import 'dart:async';

import 'package:nopcart_flutter/bloc/base_bloc.dart';
import 'package:nopcart_flutter/model/WishListResponse.dart';
import 'package:nopcart_flutter/model/requestbody/FormValue.dart';
import 'package:nopcart_flutter/model/requestbody/FormValuesRequestBody.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/repository/WishListRepository.dart';

class WishListBloc extends BaseBloc {
  WishListRepository _repository;
  StreamController _scGetWishList, _loaderSink, _scLaunchCart;

  StreamSink<ApiResponse<WishListResponse>> get wishListSink =>
      _scGetWishList.sink;
  Stream<ApiResponse<WishListResponse>> get wishListStream =>
      _scGetWishList.stream;

  StreamSink<bool> get loaderSink => _loaderSink.sink;
  Stream<bool> get loaderStream => _loaderSink.stream;

  StreamSink<bool> get launchCartSink => _scLaunchCart.sink;
  Stream<bool> get launchCartStream => _scLaunchCart.stream;

  WishListBloc() {
    _repository = WishListRepository();
    _scGetWishList = StreamController<ApiResponse<WishListResponse>>();
    _loaderSink = StreamController<bool>();
    _scLaunchCart = StreamController<bool>();
  }

  @override
  void dispose() {
    _scGetWishList?.close();
    _loaderSink?.close();
    _scLaunchCart?.close();
  }

  fetchWishListData() async {
    if(_scGetWishList.isClosed)
      return;
    wishListSink.add(ApiResponse.loading());

    try {
      WishListResponse response = await _repository.fetchWishlistItem();
      wishListSink.add(ApiResponse.completed(response));
    } catch (e) {
      wishListSink.add(ApiResponse.error(e.toString()));
      // print(e);
    }
  }

  removeItemFromWishlist(num id) async {
    if(_loaderSink.isClosed || _scGetWishList.isClosed)
      return;
    loaderSink.add(true);

    try {
      WishListResponse response = await _repository.updateWishlistItem(
        FormValuesRequestBody(
          formValues: [
            FormValue(
              key: 'removefromcart',
              value: id.toString(),
            )
          ]
        )
      );
      wishListSink.add(ApiResponse.completed(response));
      loaderSink.add(false);
    } catch (e) {
      wishListSink.add(ApiResponse.error(e.toString()));
      loaderSink.add(false);
      // print(e);
    }
  }

  moveToCart(List<num> ids, {bool goToCart = false}) async {

    if(_loaderSink.isClosed || _scGetWishList.isClosed)
      return;

    loaderSink.add(true);

    try {
      WishListResponse response = await _repository.moveItemToCart(
          FormValuesRequestBody(
              formValues: [
                for(int i=0; i<ids.length; i++)
                  FormValue(
                    key: 'addtocart',
                    value: ids[i].toString(),
                  )
              ]
          )
      );
      wishListSink.add(ApiResponse.completed(response));
      loaderSink.add(false);
      if (goToCart)
        launchCartSink.add(true);
    } catch (e) {
      wishListSink.add(ApiResponse.error(e.toString()));
      loaderSink.add(false);
      // print(e);
    }
  }
}