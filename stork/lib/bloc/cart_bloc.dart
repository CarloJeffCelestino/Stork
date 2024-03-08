import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nopcart_flutter/bloc/base_bloc.dart';
import 'package:nopcart_flutter/model/FileUploadResponse.dart';
import 'package:nopcart_flutter/model/PostCheckoutAttrResponse.dart';
import 'package:nopcart_flutter/model/ShoppingCartResponse.dart';
import 'package:nopcart_flutter/model/requestbody/FormValue.dart';
import 'package:nopcart_flutter/model/requestbody/FormValuesRequestBody.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/repository/CartRepository.dart';

class CartBloc extends BaseBloc {
  CartRepository _repository;
  StreamController _scGetCart, _loaderSink, _scLaunchCheckoutScreen,
      _scErrorMsg, _scFileUpload;

  StreamSink<ApiResponse<ShoppingCartResponse>> get cartSink => _scGetCart.sink;
  Stream<ApiResponse<ShoppingCartResponse>> get cartStream => _scGetCart.stream;

  StreamSink<ApiResponse<FileUploadData>> get fileUploadSink => _scFileUpload.sink;
  Stream<ApiResponse<FileUploadData>> get fileUploadStream => _scFileUpload.stream;

  StreamSink<bool> get loaderSink => _loaderSink.sink;
  Stream<bool> get loaderStream => _loaderSink.stream;

  StreamSink<bool> get launchCheckoutSink => _scLaunchCheckoutScreen.sink;
  Stream<bool> get launchCheckoutStream => _scLaunchCheckoutScreen.stream;

  StreamSink<String> get errorMsgSink => _scErrorMsg.sink;
  Stream<String> get errorMsgStream => _scErrorMsg.stream;

  String enteredCouponCode, enteredGiftCardCode;
  String warningMsg = '';
  String selectedShippingMethod = '';

  CartBloc() {
    _repository = CartRepository();
    _scGetCart = StreamController<ApiResponse<ShoppingCartResponse>>();
    _scFileUpload = StreamController<ApiResponse<FileUploadData>>();
    _loaderSink = StreamController<bool>();
    _scErrorMsg = StreamController<String>();
    _scLaunchCheckoutScreen = StreamController<bool>();
    enteredCouponCode = '';
    enteredGiftCardCode = '';
  }

  fetchCartData() async {
    if(_scGetCart.isClosed || _loaderSink.isClosed)
      return;
    cartSink.add(ApiResponse.loading());

    try {
      ShoppingCartResponse response = await _repository.fetchCartDetails();
      _updateWarningMessage(response.data.cart);
      cartSink.add(ApiResponse.completed(response));
    } catch (e) {
      cartSink.add(ApiResponse.error(e.toString()));
      // print(e);
    }
  }

  updateItemQuantity(CartItem product, num quantity) async {
    List<FormValue> formValues = [];
    formValues.add(FormValue(
        key: 'itemquantity${product.id}',
        value: quantity.toString()));
    FormValuesRequestBody requestBody = FormValuesRequestBody(formValues: formValues);

    await _updateCart(requestBody);
  }

  removeItemFromCart(num cartId) async {
    FormValuesRequestBody requestBody = FormValuesRequestBody(formValues: [
      FormValue(
        key: 'removefromcart',
        value: cartId.toString(),
      ),
    ]);

    await _updateCart(requestBody);
  }

  _updateCart(FormValuesRequestBody requestBody) async {
    if(_scGetCart.isClosed)
      return;
    loaderSink.add(true);

    try {
      ShoppingCartResponse response = await _repository.updateShoppingCart(requestBody);
      _updateWarningMessage(response.data.cart);
      cartSink.add(ApiResponse.completed(response));
      loaderSink.add(false);
    } catch (e) {
      cartSink.add(ApiResponse.error(e.toString()));
      loaderSink.add(false);
      // print(e);
    }
  }

  postCheckoutAttributes(List<FormValue> data, bool checkoutClicked) async {
    if(_loaderSink.isClosed || _scLaunchCheckoutScreen.isClosed || _scGetCart.isClosed)
      return;
    loaderSink.add(true);

    var reqBody = FormValuesRequestBody(
      formValues: data,
    );

    try {
      PostCheckoutAttrResponse response = await _repository.postCheckoutAttribute(reqBody);
      cartSink.add(ApiResponse.completed(ShoppingCartResponse(
        data: CartData(
          cart: response.cart,
          orderTotals: response.orderTotals,
          selectedCheckoutAttributes: response.selectedCheckoutAttributess,
        ),
      )));
      loaderSink.add(false);
      launchCheckoutSink.add(checkoutClicked);
    } catch (e) {
      cartSink.add(ApiResponse.error(e.toString()));
      loaderSink.add(false);
      launchCheckoutSink.add(false);
    }
  }

  applyDiscountCoupon(String couponCode) async{
    FormValuesRequestBody requestBody = FormValuesRequestBody(formValues: [
      FormValue(
        key: 'discountcouponcode',
        value: couponCode,
      ),
    ]);

    loaderSink.add(true);

    try {
      ShoppingCartResponse response = await _repository.applyCoupon(requestBody);
      _updateWarningMessage(response.data.cart);
      cartSink.add(ApiResponse.completed(response));
      loaderSink.add(false);

      String couponMessage = '';
      response.data?.cart?.discountBox?.messages?.forEach((element) {
        couponMessage = couponMessage + element + '\n';
      });
      couponMessage = couponMessage.trimRight();

      if(couponMessage.isNotEmpty)
        errorMsgSink.add(couponMessage);
    } catch (e) {
      cartSink.add(ApiResponse.error(e.toString()));
      loaderSink.add(false);
      // debugprint(e);
    }
  }

  removeDiscountCoupon(AppliedDiscountsWithCode coupon) async{
    FormValuesRequestBody requestBody = FormValuesRequestBody(formValues: [
      FormValue(
        key: 'removediscount-${coupon.id}',
        value: coupon.couponCode,
      ),
    ]);

    loaderSink.add(true);

    try {
      ShoppingCartResponse response = await _repository.removeCoupon(requestBody);
      _updateWarningMessage(response.data.cart);
      cartSink.add(ApiResponse.completed(response));
      loaderSink.add(false);

      String couponMessage = '';
      response.data?.cart?.discountBox?.messages?.forEach((element) {
        couponMessage = couponMessage + element + '\n';
      });
      couponMessage = couponMessage.trimRight();

      if(couponMessage.isNotEmpty)
        errorMsgSink.add(couponMessage);
    } catch (e) {
      cartSink.add(ApiResponse.error(e.toString()));
      loaderSink.add(false);
      // debugprint(e);
    }
  }

  applyGiftCard(String couponCode) async{
    FormValuesRequestBody requestBody = FormValuesRequestBody(formValues: [
      FormValue(
        key: 'giftcardcouponcode',
        value: couponCode,
      ),
    ]);

    loaderSink.add(true);

    try {
      ShoppingCartResponse response = await _repository.applyGiftCard(requestBody);
      _updateWarningMessage(response.data.cart);
      cartSink.add(ApiResponse.completed(response));
      loaderSink.add(false);

      if(response.data?.cart?.giftCardBox?.message?.isNotEmpty == true)
        errorMsgSink.add(response.data?.cart?.giftCardBox?.message);
    } catch (e) {
      cartSink.add(ApiResponse.error(e.toString()));
      loaderSink.add(false);
      // debugprint(e);
    }
  }

  void removeGiftCard(GiftCard giftCard) async {
    FormValuesRequestBody requestBody = FormValuesRequestBody(formValues: [
      FormValue(
        key: 'removegiftcard-${giftCard.id}',
        value: giftCard.couponCode,
      ),
    ]);

    loaderSink.add(true);

    try {
      ShoppingCartResponse response = await _repository.removeGiftCard(requestBody);
      _updateWarningMessage(response.data.cart);
      cartSink.add(ApiResponse.completed(response));
      loaderSink.add(false);

      if(response.data?.cart?.giftCardBox?.message?.isNotEmpty == true)
        errorMsgSink.add(response.data?.cart?.giftCardBox?.message);
    } catch (e) {
      cartSink.add(ApiResponse.error(e.toString()));
      loaderSink.add(false);
      // debugprint(e);
    }
  }

  void uploadFile(String filePath, num attributeId) async {
    fileUploadSink.add(ApiResponse.loading());

    try {
      FileUploadResponse response = await _repository.uploadFile(filePath, attributeId.toString());
      var uploadFileData = response.data;
      uploadFileData.attributedId = attributeId;

      fileUploadSink.add(ApiResponse.completed(uploadFileData));
    } catch (e) {
      fileUploadSink.add(ApiResponse.error(e.toString()));
      // debugprint(e.toString());
    }
  }

  void _updateWarningMessage(Cart cart) {
    warningMsg = '';
    var hasMinValueWaring = cart?.minOrderSubtotalWarning != null &&
        cart?.minOrderSubtotalWarning?.isNotEmpty == true;

    if(hasMinValueWaring) {
      warningMsg = '$warningMsg${cart?.minOrderSubtotalWarning ?? ''}\n';
    }
    cart?.warnings?.forEach((element) {
      warningMsg = '$warningMsg$element\n';
    });
    warningMsg.trimRight();
  }

  @override
  void dispose() {
    _scGetCart?.close();
    _loaderSink?.close();
    _scErrorMsg?.close();
    _scFileUpload?.close();
    _scLaunchCheckoutScreen?.close();
  }

}