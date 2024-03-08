import 'dart:async';

import 'package:nopcart_flutter/bloc/base_bloc.dart';
import 'package:nopcart_flutter/model/AllVendorsResponse.dart';
import 'package:nopcart_flutter/model/ContactVendorResponse.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/repository/VendorRepository.dart';

class VendorBloc extends BaseBloc {
  VendorRepository _repository;
  StreamController _scContactUs, _scLoader, _scVendors;

  StreamSink<ApiResponse<ContactVendorData>> get contactSink => _scContactUs.sink;
  Stream<ApiResponse<ContactVendorData>> get contactStream => _scContactUs.stream;

  StreamSink<ApiResponse<List<VendorDetails>>> get vendorListSink => _scVendors.sink;
  Stream<ApiResponse<List<VendorDetails>>> get vendorListStream => _scVendors.stream;

  StreamSink<ApiResponse<String>> get loaderSink => _scLoader.sink;
  Stream<ApiResponse<String>> get loaderStream => _scLoader.stream;

  VendorBloc() {
    _repository = VendorRepository();
    _scContactUs = StreamController<ApiResponse<ContactVendorData>>();
    _scVendors = StreamController<ApiResponse<List<VendorDetails>>>();
    _scLoader = StreamController<ApiResponse<String>>();
  }

  @override
  void dispose() {
    _scContactUs?.close();
    _scLoader?.close();
    _scVendors?.close();
  }

  fetchAllVendors() async {
    if(_scVendors.isClosed)
      return;

    vendorListSink.add(ApiResponse.loading());

    try {
      AllVendorsResponse response = await _repository.fetchVendorList();
      vendorListSink.add(ApiResponse.completed(response.data));
    } catch (e) {
      vendorListSink.add(ApiResponse.error(e.toString()));
      // print(e);
    }
  }

  fetchFormData(num vendorId) async {
    if(_scContactUs.isClosed)
      return;
    contactSink.add(ApiResponse.loading());

    try {
      ContactVendorResponse response = await _repository.fetchFormData(vendorId);
      contactSink.add(ApiResponse.completed(response.data));
    } catch (e) {
      contactSink.add(ApiResponse.error(e.toString()));
      // print(e);
    }
  }

  void postEnquiry(ContactVendorData formData) async {
    loaderSink.add(ApiResponse.loading());

    try {
      ContactVendorResponse response = await _repository.postEnquiry(ContactVendorResponse(data: formData));
      loaderSink.add(ApiResponse.completed(response?.message ?? ''));
    } catch (e) {
      loaderSink.add(ApiResponse.error(e.toString()));
      // print(e);
    }
  }

}