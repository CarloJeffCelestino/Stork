import 'dart:async';

import 'package:nopcart_flutter/bloc/base_bloc.dart';
import 'package:nopcart_flutter/model/FileDownloadResponse.dart';
import 'package:nopcart_flutter/model/FileUploadResponse.dart';
import 'package:nopcart_flutter/model/ReturnRequestHistoryResponse.dart';
import 'package:nopcart_flutter/model/ReturnRequestResponse.dart';
import 'package:nopcart_flutter/model/SampleDownloadResponse.dart';
import 'package:nopcart_flutter/model/requestbody/FormValue.dart';
import 'package:nopcart_flutter/model/requestbody/ReturnRequestBody.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/repository/ReturnRequestRepository.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/Const.dart';

class ReturnRequestBloc extends BaseBloc {
  ReturnRequestRepository _repository;
  StreamController _scForm, _scMsg, _scFileUpload, _scHistory, _scFileDownload;
  AvailableReturn selectedAction, selectedReason;
  Map<num, num> quantityMap = Map();
  String fileGuid = '';
  String selectedFileName = '';

  StreamSink<ApiResponse<ReturnRequestData>> get formSink => _scForm.sink;
  Stream<ApiResponse<ReturnRequestData>> get formStream => _scForm.stream;

  StreamSink<ApiResponse<ReturnReqHistoryData>> get historySink => _scHistory.sink;
  Stream<ApiResponse<ReturnReqHistoryData>> get historyStream => _scHistory.stream;

  StreamSink<ApiResponse<String>> get messageSink => _scMsg.sink;
  Stream<ApiResponse<String>> get messageStream => _scMsg.stream;

  StreamSink<ApiResponse<FileUploadData>> get fileUploadSink => _scFileUpload.sink;
  Stream<ApiResponse<FileUploadData>> get fileUploadStream => _scFileUpload.stream;

  StreamSink<ApiResponse<FileDownloadResponse<SampleDownloadResponse>>> get fileDownloadSink =>
      _scFileDownload.sink;
  Stream<ApiResponse<FileDownloadResponse<SampleDownloadResponse>>> get fileDownloadStream =>
      _scFileDownload.stream;

  ReturnRequestBloc() {
    _repository = ReturnRequestRepository();
    _scForm = StreamController<ApiResponse<ReturnRequestData>>();
    _scMsg = StreamController<ApiResponse<String>>();
    _scFileUpload = StreamController<ApiResponse<FileUploadData>>();
    _scHistory = StreamController<ApiResponse<ReturnReqHistoryData>>();
    _scFileDownload = StreamController<ApiResponse<FileDownloadResponse<SampleDownloadResponse>>>();
  }

  @override
  void dispose() {
    _scForm?.close();
    _scMsg?.close();
    _scFileUpload?.close();
    _scHistory?.close();
    _scFileDownload?.close();
  }

  void fetchReturnRequestFormData(num orderId) async {
    formSink.add(ApiResponse.loading());

    try {
      ReturnRequestResponse response = await _repository.fetchReturnRequestForm(orderId);

      // add primary selected items
      selectedAction = AvailableReturn(
          id: -1,
          name: GlobalService().getString(Const.RETURN_REQ_ACTION)
      );

      selectedReason = AvailableReturn(
          id: -1,
          name: GlobalService().getString(Const.RETURN_REQ_REASON)
      );

      response.data.availableReturnActions.insertAll(0, [ selectedAction ]);
      response.data.availableReturnReasons.insertAll(0, [ selectedReason ]);
      response.data.returnRequestReasonId = -1;
      response.data.returnRequestActionId = -1;

      response?.data?.items?.forEach((element) {
        quantityMap[element.id] = 0;
      });

      formSink.add(ApiResponse.completed(response.data));
    } catch (e) {
      formSink.add(ApiResponse.error(e.toString()));
      // print(e);
    }
  }

  void submitForm(ReturnRequestData data) async {
    messageSink.add(ApiResponse.loading());

    var reqBody = ReturnRequestBody(data: data, formValues: []);
    quantityMap.forEach((key, value) {
      if(value > 0)
        reqBody.formValues.add(FormValue(
          key: 'quantity$key', value: value.toString(),
        ));
    });
    if(fileGuid.isNotEmpty)
      reqBody.data.uploadedFileGuid = fileGuid;

    try {
      ReturnRequestResponse response = await _repository.postReturnRequestForm(
          data.orderId, reqBody,
      );
      messageSink.add(ApiResponse.completed(response.data?.result ?? ''));
    } catch (e) {
      messageSink.add(ApiResponse.error(e.toString()));
      // print(e);
    }
  }

  void uploadFile(String filePath) async {
    fileUploadSink.add(ApiResponse.loading());

    try {
      FileUploadResponse response = await _repository.uploadFile(filePath);
      var uploadFileData = response.data;

      fileUploadSink.add(ApiResponse.completed(uploadFileData));
    } catch (e) {
      fileUploadSink.add(ApiResponse.error(e.toString()));
      // print(e.toString());
    }
  }

  void fetchReturnRequestHistory() async {
    historySink.add(ApiResponse.loading());

    try {
      ReturnReqHistoryResponse response = await _repository.fetchReturnRequestHistory();
      historySink.add(ApiResponse.completed(response.data));
    } catch (e) {
      historySink.add(ApiResponse.error(e.toString()));
      // print(e);
    }
  }

  void downloadFile(String fileGuid) async {
    fileDownloadSink.add(ApiResponse.loading());

    try {
      FileDownloadResponse<SampleDownloadResponse> response = await _repository.downloadFile(fileGuid);
      fileDownloadSink.add(ApiResponse.completed(response));
    } catch (e) {
      fileDownloadSink.add(ApiResponse.error(e.toString()));
      // print(e.toString());
    }
  }

}