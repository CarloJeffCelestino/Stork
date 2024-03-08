import 'dart:async';

import 'package:nopcart_flutter/bloc/base_bloc.dart';
import 'package:nopcart_flutter/model/ContactUsResponse.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/repository/ContactUsRepository.dart';

class ContactUsBloc extends BaseBloc {
  ContactUsRepository _repository;
  StreamController _scContactUs, _scLoader;

  StreamSink<ApiResponse<ContactUsData>> get contactSink => _scContactUs.sink;
  Stream<ApiResponse<ContactUsData>> get contactStream => _scContactUs.stream;

  StreamSink<ApiResponse<String>> get loaderSink => _scLoader.sink;
  Stream<ApiResponse<String>> get loaderStream => _scLoader.stream;

  ContactUsBloc() {
    _repository = ContactUsRepository();
    _scContactUs = StreamController<ApiResponse<ContactUsData>>();
    _scLoader = StreamController<ApiResponse<String>>();
  }

  @override
  void dispose() {
    _scContactUs?.close();
    _scLoader?.close();
  }

  fetchFormData() async {
    if(_scContactUs.isClosed)
      return;
    contactSink.add(ApiResponse.loading());

    try {
      ContactUsResponse response = await _repository.fetchFormData();
      contactSink.add(ApiResponse.completed(response.data));
    } catch (e) {
      contactSink.add(ApiResponse.error(e.toString()));
      // print(e);
    }
  }

  void postEnquiry(ContactUsData formData) async {
    if(_scLoader.isClosed)
      return;
    loaderSink.add(ApiResponse.loading());

    try {
      ContactUsResponse response = await _repository.postEnquiry(ContactUsResponse(data: formData));
      loaderSink.add(ApiResponse.completed(response?.message ?? ''));
    } catch (e) {
      loaderSink.add(ApiResponse.error(e.toString()));
      // print(e);
    }
  }

}