import 'dart:async';

import 'package:nopcart_flutter/bloc/base_bloc.dart';
import 'package:nopcart_flutter/model/SubscriptionListResponse.dart';
import 'package:nopcart_flutter/model/requestbody/FormValue.dart';
import 'package:nopcart_flutter/model/requestbody/FormValuesRequestBody.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/repository/SubscriptionRepository.dart';

class SubscriptionBloc implements BaseBloc {
  SubscriptionRepository _repository;
  StreamController _scSubscriptionList, _scLoader;
  int _pageNumber;
  bool _hasNextPage;
  SubscriptionListData _cachedData;
  List<int> selectedItems;

  StreamSink<ApiResponse<SubscriptionListData>> get subscriptionListSink =>
      _scSubscriptionList.sink;
  Stream<ApiResponse<SubscriptionListData>> get subscriptionListStream =>
      _scSubscriptionList.stream;

  StreamSink<ApiResponse<String>> get loaderSink => _scLoader.sink;
  Stream<ApiResponse<String>> get loaderStream => _scLoader.stream;

  SubscriptionBloc() {
    _repository = SubscriptionRepository();
    _scSubscriptionList = StreamController<ApiResponse<SubscriptionListData>>();
    _scLoader = StreamController<ApiResponse<String>>.broadcast();
    _pageNumber = 1;
    _hasNextPage = true;
    selectedItems = [];
  }

  @override
  void dispose() {
    _scSubscriptionList?.close();
    _scLoader?.close();
  }

  setSelectionStatus(num id, bool selected) {
    selected ? selectedItems.add(id) : selectedItems.remove(id);
  }

  isSelected(num id) {
    return selectedItems.contains(id);
  }

  fetchSubscriptionList() async {

    if(!_hasNextPage) return;
    if(_scLoader.isClosed || _scSubscriptionList.isClosed)
      return;

    if(_pageNumber == 1) {
      subscriptionListSink.add(ApiResponse.loading());
    } else {
      loaderSink.add(ApiResponse.loading());
    }

    try {
      SubscriptionListResponse response = await _repository.fetchSubscriptions(_pageNumber);

      if(_pageNumber == 1) {
        _cachedData = response?.data;
      } else {
        _cachedData?.subscriptions?.addAll(response?.data?.subscriptions ?? []);
        _cachedData?.pagerModel = response?.data?.pagerModel;
      }

      subscriptionListSink.add(ApiResponse.completed(_cachedData));
      if(_pageNumber > 1) {
        loaderSink.add(ApiResponse.completed(''));
      }

      _hasNextPage = (response.data?.pagerModel?.currentPage ?? 1) <
          (response.data?.pagerModel?.totalPages ?? 1);
      _pageNumber++;
    } catch (e) {
      subscriptionListSink.add(ApiResponse.error(e.toString()));
      if(_pageNumber > 1) {
        loaderSink.add(ApiResponse.error(e.toString()));
      }
      // print(e.toString());
    }
  }

  unsubscribeSelected() async {
    if(selectedItems.isEmpty)
      return;

    _pageNumber = 1;
    var reqBody = FormValuesRequestBody(
      formValues: selectedItems
          .map((e) => FormValue(key: 'biss$e', value: 'on'))
          .toList(),
    );

    loaderSink.add(ApiResponse.loading());
    try {
      SubscriptionListResponse unSubResponse;
      // unsubscribe api returns http 302 from flutter but 200 from postman
      // in both cased products are being unsubscribed successfully
      // this is a temporary workaround. have to fix later
      try {
        unSubResponse = await _repository.unsubscribe(reqBody);
      } catch(e) {
        // if response is http 302
        unSubResponse = await _repository.fetchSubscriptions(_pageNumber);
      }
      _cachedData = unSubResponse?.data;
      subscriptionListSink.add(ApiResponse.completed(_cachedData));
      loaderSink.add(ApiResponse.completed(''));

      _hasNextPage = (unSubResponse.data?.pagerModel?.currentPage ?? 1) <
          (unSubResponse.data?.pagerModel?.totalPages ?? 1);
      _pageNumber++;
    } catch (e) {
      subscriptionListSink.add(ApiResponse.error(e.toString()));
      loaderSink.add(ApiResponse.error(e.toString()));
      // print(e.toString());
    }
  }
}