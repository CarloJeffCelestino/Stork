import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:nopcart_flutter/bloc/base_bloc.dart';
import 'package:nopcart_flutter/model/FileDownloadResponse.dart';
import 'package:nopcart_flutter/model/OrderDetailsResponse.dart';
import 'package:nopcart_flutter/model/OrderHistoryResponse.dart';
import 'package:nopcart_flutter/model/SampleDownloadResponse.dart';
import 'package:nopcart_flutter/model/requestbody/OrderHistoryRequestBody.dart' as req;
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/repository/OrderRepository.dart';

class OrderBloc extends BaseBloc {
  OrderRepository _repository;
  StreamController _scOrderHistory, _scLoader, _scOrderDetails,
      _scReorder, _scRepostPayment, _scPdf, _scFileDownload;

  StreamSink<ApiResponse<OrderHistoryResponse>> get orderHistorySink =>
      _scOrderHistory.sink;
  Stream<ApiResponse<OrderHistoryResponse>> get orderHistoryStream =>
      _scOrderHistory.stream;

  StreamSink<bool> get loaderSink => _scLoader.sink;
  Stream<bool> get loaderStream => _scLoader.stream;

  StreamSink<ApiResponse<bool>> get reorderSink => _scReorder.sink;
  Stream<ApiResponse<bool>> get reorderStream => _scReorder.stream;

  StreamSink<num> get pdfLinkSink => _scPdf.sink;
  Stream<num> get pdfLinkStream => _scPdf.stream;

  StreamSink<ApiResponse<bool>> get repostSink => _scRepostPayment.sink;
  Stream<ApiResponse<bool>> get repostStream => _scRepostPayment.stream;

  StreamSink<ApiResponse<OrderDetailsResponse>> get orderDetailsSink =>
      _scOrderDetails.sink;
  Stream<ApiResponse<OrderDetailsResponse>> get orderDetailsStream =>
      _scOrderDetails.stream;

  StreamSink<ApiResponse<FileDownloadResponse<SampleDownloadResponse>>> get fileDownloadSink =>
      _scFileDownload.sink;
  Stream<ApiResponse<FileDownloadResponse<SampleDownloadResponse>>> get fileDownloadStream =>
      _scFileDownload.stream;

  OrderBloc() {
    _repository = OrderRepository();
    _scOrderHistory = StreamController<ApiResponse<OrderHistoryResponse>>();
    _scLoader = StreamController<bool>();
    _scPdf = StreamController<num>();
    _scReorder = StreamController<ApiResponse<bool>>();
    _scRepostPayment = StreamController<ApiResponse<bool>>();
    _scOrderDetails = StreamController<ApiResponse<OrderDetailsResponse>>();
    _scFileDownload = StreamController<ApiResponse<FileDownloadResponse<SampleDownloadResponse>>>();
  }

  @override
  void dispose() {
    _scOrderHistory?.close();
    _scLoader?.close();
    _scReorder?.close();
    _scRepostPayment?.close();
    _scOrderDetails?.close();
    _scPdf?.close();
    _scFileDownload?.close();
  }

  fetchOrderHistory({bool isPending = false, bool toShip = false, bool toDeliver = false, bool toRate = false }) async {
    if(_scOrderHistory.isClosed)
      return;
    orderHistorySink.add(ApiResponse.loading());

    var reqBody = req.OrderHistoryRequestBody(
      data: req.OrderHistoryData(
        isPending: isPending,
        toShip: toShip,
        toDeliver: toDeliver,
        toRate: toRate,
      )
    );

    try {
      OrderHistoryResponse response = await _repository.fetchOrderHistory(reqBody);
      orderHistorySink.add(ApiResponse.completed(response));
    } catch (e) {
      orderHistorySink.add(ApiResponse.error(e.toString()));
      // print(e);
    }
  }

  fetchOrderDetails(num orderId) async {
    if(_scOrderDetails.isClosed)
      return;
    orderDetailsSink.add(ApiResponse.loading());

    try {
      OrderDetailsResponse response = await _repository.fetchOrderDetails(orderId);
      orderDetailsSink.add(ApiResponse.completed(response));
      pdfLinkSink.add((response.data?.pdfInvoiceDisabled ?? false)
        ? -1 : (response?.data?.id ?? -1));
    } catch (e) {
      orderDetailsSink.add(ApiResponse.error(e.toString()));
      // print(e.toString());
    }
  }

  reorder(num orderId) async {
    if(_scReorder.isClosed)
      return;
    reorderSink.add(ApiResponse.loading());

    try {
      await _repository.reorder(orderId);
      reorderSink.add(ApiResponse.completed(true));
    } catch (e) {
      reorderSink.add(ApiResponse.error(e.toString()));
      // print(e.toString());
    }
  }

  repostPayment(num orderId) async {
    if(_scRepostPayment.isClosed)
      return;
    repostSink.add(ApiResponse.loading());

    try {
      await _repository.repostPayment(orderId);
      repostSink.add(ApiResponse.completed(true));
    } catch (e) {
      repostSink.add(ApiResponse.error(e.toString()));
      // print(e.toString());
    }
  }

  downloadPdfInvoice({@required num orderId}) async {
    if(_scFileDownload.isClosed)
      return;
    fileDownloadSink.add(ApiResponse.loading());

    try {
      FileDownloadResponse<SampleDownloadResponse> response = await _repository.downloadPdfInvoice(orderId);
      fileDownloadSink.add(ApiResponse.completed(response));
    } catch (e) {
      fileDownloadSink.add(ApiResponse.error(e.toString()));
      // print(e.toString());
    }
  }

  downloadNotesAttachment(int noteId) async {
    if(_scFileDownload.isClosed)
      return;
    fileDownloadSink.add(ApiResponse.loading());

    try {
      FileDownloadResponse<SampleDownloadResponse> response = await _repository.downloadNotesAttachment(noteId);
      fileDownloadSink.add(ApiResponse.completed(response));
    } catch (e) {
      fileDownloadSink.add(ApiResponse.error(e.toString()));
      // print(e.toString());
    }
  }

}