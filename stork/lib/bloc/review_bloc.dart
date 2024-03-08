import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nopcart_flutter/bloc/base_bloc.dart';
import 'package:nopcart_flutter/model/CustomerReviewResponse.dart';
import 'package:nopcart_flutter/model/PostHelpfulnessResponse.dart';
import 'package:nopcart_flutter/model/ProductReviewResponse.dart';
import 'package:nopcart_flutter/model/requestbody/FormValue.dart';
import 'package:nopcart_flutter/model/requestbody/FormValuesRequestBody.dart';
import 'package:nopcart_flutter/model/requestbody/PostReviewReqBody.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/repository/ReviewRepository.dart';
import 'package:nopcart_flutter/utils/AppConstants.dart';

class ReviewBloc implements BaseBloc {
  ReviewRepository _repository;
  StreamController _scProdReview, _scLoader, _scCustomerReview, _scHelpfulness;

  StreamSink<ApiResponse<ProductReviewData>> get prodReviewSink => _scProdReview.sink;
  Stream<ApiResponse<ProductReviewData>> get prodReviewStream => _scProdReview.stream;

  StreamSink<ApiResponse<CustomerReviewData>> get customerReviewSink => _scCustomerReview.sink;
  Stream<ApiResponse<CustomerReviewData>> get customerReviewStream => _scCustomerReview.stream;

  StreamSink<ApiResponse<String>> get loaderSink => _scLoader.sink;
  Stream<ApiResponse<String>> get loaderStream => _scLoader.stream;

  StreamSink<ApiResponse<Helpfulness>> get helpfulnessSink => _scHelpfulness.sink;
  Stream<ApiResponse<Helpfulness>> get helpfulnessStream => _scHelpfulness.stream;

  ProductReviewData _prodReviewCachedData;
  CustomerReviewData _cachedData;
  num _pageNumber = 1;
  bool _lastPageReached = false;

  ReviewBloc() {
    _repository = ReviewRepository();
    _scProdReview = StreamController<ApiResponse<ProductReviewData>>();
    _scCustomerReview = StreamController<ApiResponse<CustomerReviewData>>();
    _scHelpfulness = StreamController<ApiResponse<Helpfulness>>();
    _scLoader = StreamController<ApiResponse<String>>();
  }

  @override
  void dispose() {
    _scProdReview?.close();
    _scLoader?.close();
    _scCustomerReview?.close();
    _scHelpfulness?.close();
  }

  void fetchProductReviews(num productId) async {
    prodReviewSink.add(ApiResponse.loading());

    try {
      ProductReviewResponse response = await _repository.fetchProductReviews(productId);
      _prodReviewCachedData = response.data;
      prodReviewSink.add(ApiResponse.completed(_prodReviewCachedData));
    } catch (e) {
      prodReviewSink.add(ApiResponse.error(e.toString()));
      // debugprint(e);
    }
  }

  void postReview(num productId, AddProductReview formData) async {
    loaderSink.add(ApiResponse.loading());

    try {
      ProductReviewResponse response = await _repository.postProductReview(
        productId,
        PostReviewReqBody(
          data: PostReviewData(
            addProductReview: formData,
          ),
        ),
      );

      _prodReviewCachedData = response.data;
      loaderSink.add(ApiResponse.completed(response?.data?.addProductReview?.result ?? ''));
      prodReviewSink.add(ApiResponse.completed(_prodReviewCachedData));

    } catch (e) {
      loaderSink.add(ApiResponse.error(e.toString()));
      // debugprint(e);
    }
  }

  void fetchCustomerReviews() async {
    if(_lastPageReached) return;

    if(_pageNumber == 1) {
      customerReviewSink.add(ApiResponse.loading());
    } else {
      loaderSink.add(ApiResponse.loading());
    }

    try {
      CustomerReviewResponse response = await _repository.fetchMyReviews(_pageNumber);

      if(_pageNumber == 1) {
        _cachedData = response?.data;
      } else {
        _cachedData?.productReviews?.addAll(response?.data?.productReviews ?? []);
        _cachedData?.pagerModel = response?.data?.pagerModel;
      }

      customerReviewSink.add(ApiResponse.completed(_cachedData));
      if(_pageNumber > 1) {
        loaderSink.add(ApiResponse.completed(''));
      }

      _pageNumber++;
      _lastPageReached = (response?.data?.pagerModel?.totalPages ?? 0) == (response?.data?.pagerModel?.currentPage ?? 0);
    } catch (e) {
      customerReviewSink.add(ApiResponse.error(e.toString()));
      if(_pageNumber > 1) {
        loaderSink.add(ApiResponse.error(e.toString()));
      }
      // debugprint(e.toString());
    }
  }

  void postHelpfulness(num productReviewId, {@required bool isHelpful}) async {
    helpfulnessSink.add(ApiResponse.loading());
    try {
      PostHelpfulnessResponse response = await _repository.postReviewHelpfulness(
        productReviewId,
          FormValuesRequestBody(formValues: [
                FormValue(
                  key: AppConstants.productReviewId,
                  value: productReviewId.toString(),
                ),
                FormValue(
                  key: AppConstants.wasReviewHelpful,
                  value: isHelpful.toString(),
                ),
              ],
          ),
      );

      var index = _prodReviewCachedData.items.indexWhere(
              (element) => element.helpfulness.productReviewId == productReviewId);
      if(index > -1) {
        _prodReviewCachedData.items[index].helpfulness = response.data;
      }

      prodReviewSink.add(ApiResponse.completed(_prodReviewCachedData));
      helpfulnessSink.add(ApiResponse.completed(response.data));
    } catch(e) {
      // debugprint(e.toString());
      helpfulnessSink.add(ApiResponse.error(e.toString()));
    }
  }
}