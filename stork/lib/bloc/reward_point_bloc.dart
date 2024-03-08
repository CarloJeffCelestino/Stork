import 'dart:async';

import 'package:nopcart_flutter/bloc/base_bloc.dart';
import 'package:nopcart_flutter/model/RewardPointResponse.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/repository/RewardPointRepository.dart';

class RewardPointBloc extends BaseBloc {
  RewardPointRepository _repository;
  StreamController _scTopic, _scLoader;

  RewardPointData cachedData;
  num _pageNumber = 1;
  bool lastPageReached = false;

  StreamSink<ApiResponse<RewardPointData>> get rewardPointSink => _scTopic.sink;
  Stream<ApiResponse<RewardPointData>> get rewardPointStream => _scTopic.stream;

  StreamSink<ApiResponse<bool>> get loaderSink => _scLoader.sink;
  Stream<ApiResponse<bool>> get loaderStream => _scLoader.stream;

  RewardPointBloc() {
    _repository = RewardPointRepository();
    _scTopic = StreamController<ApiResponse<RewardPointData>>();
    _scLoader = StreamController<ApiResponse<bool>>();
  }

  @override
  void dispose() {
    _scTopic?.close();
    _scLoader?.close();
  }

  fetchRewardPointDetails() async {

    if(lastPageReached) return;
    if(_scTopic.isClosed || _scLoader.isClosed)
      return;

    if(_pageNumber == 1) {
      rewardPointSink.add(ApiResponse.loading());
    } else {
      loaderSink.add(ApiResponse.loading());
    }

    try {
      RewardPointResponse response = await _repository.fetchRawardPointDetails(_pageNumber);

      if(_pageNumber == 1) {
        cachedData = response?.data;
      } else {
        cachedData?.rewardPoints?.addAll(response?.data?.rewardPoints ?? []);
        cachedData?.pagerModel = response?.data?.pagerModel;
      }

      rewardPointSink.add(ApiResponse.completed(cachedData));
      if(_pageNumber > 1) {
        loaderSink.add(ApiResponse.completed(true));
      }

      _pageNumber++;
      lastPageReached = (response?.data?.pagerModel?.totalPages ?? 0) == (response?.data?.pagerModel?.currentPage ?? 0);
    } catch (e) {
      rewardPointSink.add(ApiResponse.error(e.toString()));
      if(_pageNumber > 1) {
        loaderSink.add(ApiResponse.error(e.toString()));
      }
      // print(e);
    }
  }

}