import 'dart:async';

import 'package:nopcart_flutter/bloc/base_bloc.dart';
import 'package:nopcart_flutter/model/home/ManufacturersResponse.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/repository/HomeRepository.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/Const.dart';

class AllManufacturerBloc extends BaseBloc {
  HomeRepository _repository;
  StreamController _manufacturersStreamCtrl;

  // Manufacturers stream controller
  StreamSink<ApiResponse<List<ManufacturerData>>> get manufacturersSink =>
      _manufacturersStreamCtrl.sink;
  Stream<ApiResponse<List<ManufacturerData>>> get manufacturersStream =>
      _manufacturersStreamCtrl.stream;

  AllManufacturerBloc() {
    _repository = HomeRepository();
    _manufacturersStreamCtrl = StreamController<ApiResponse<List<ManufacturerData>>>();
  }

  @override
  void dispose() {
    _manufacturersStreamCtrl?.close();
  }

  fetchManufacturers() async {
    if(_manufacturersStreamCtrl.isClosed)
      return;
    manufacturersSink.add(ApiResponse.loading(
        GlobalService().getString(Const.COMMON_PLEASE_WAIT)));

    try {
      var manufacturersRes = await _repository.fetchAllManufacturers();
      manufacturersSink.add(ApiResponse.completed(manufacturersRes.data));
    } catch (e) {
      manufacturersSink.add(ApiResponse.error(e.toString()));
      // print(e);
    }
  }

}