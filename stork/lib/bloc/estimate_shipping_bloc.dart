import 'dart:async';

import 'package:nopcart_flutter/bloc/base_bloc.dart';
import 'package:nopcart_flutter/model/AvailableOption.dart';
import 'package:nopcart_flutter/model/EstimateShipping.dart';
import 'package:nopcart_flutter/model/EstimateShippingResponse.dart';
import 'package:nopcart_flutter/model/requestbody/EstimateShippingReqBody.dart';
import 'package:nopcart_flutter/model/requestbody/FormValue.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/repository/BaseRepository.dart';
import 'package:nopcart_flutter/utils/utility.dart';

class EstimateShippingBloc extends BaseBloc {
  BaseRepository _repository;
  StreamController _scStates, _scResult;
  String selectedMethod, preSelectedShippingMethod;
  bool estimationForProduct;

  StreamSink<ApiResponse<List<AvailableOption>>> get statesSink =>
      _scStates.sink;
  Stream<ApiResponse<List<AvailableOption>>> get statesStream =>
      _scStates.stream;

  StreamSink<ApiResponse<EstimateShippingData>> get resultSink =>
      _scResult.sink;
  Stream<ApiResponse<EstimateShippingData>> get resultStream =>
      _scResult.stream;

  EstimateShippingBloc(
    EstimateShipping estimateShipping,
    bool estimationForProduct,
    List<FormValue> formValues,
    String preSelectedShippingMethod,
  ) {
    selectedMethod = '';
    _repository = BaseRepository();
    _scStates = StreamController<ApiResponse<List<AvailableOption>>>();
    _scResult = StreamController<ApiResponse<EstimateShippingData>>();
    statesSink.add(ApiResponse.completed(estimateShipping?.availableStates ?? []));
    this.preSelectedShippingMethod= preSelectedShippingMethod;
    this.estimationForProduct = estimationForProduct;

    for(AvailableOption element in (estimateShipping?.availableCountries ?? [])) {
      if(element.selected == true) {
        estimateShipping?.countryId = int.tryParse(element.value ?? '0') ?? 0;
        break;
      }
    }

    for(AvailableOption element in (estimateShipping?.availableStates ?? [])) {
      if(element.selected == true) {
        estimateShipping?.stateProvinceId = int.tryParse(element.value ?? '0') ?? 0;
        break;
      }
    }

    if ((estimateShipping?.countryId ?? 0) > 0 &&
        (estimateShipping?.stateProvinceId ?? 0) > 0) {
      estimationForProduct
          ? estimateShippingForProduct(estimateShipping, formValues)
          : estimateShippingForCart(estimateShipping);
    }
  }

  fetchStates(AvailableOption country) async {
    int countryId = int.tryParse(country.value) ?? -1;

    if(countryId == -1)
      return;

    statesSink.add(ApiResponse.loading());
    var statesList = await fetchStatesList(countryId);
    statesSink.add(ApiResponse.completed(statesList));
  }

  estimateShippingForCart(EstimateShipping estimateShipping) async {

    EstimateShippingReqBody reqBody = EstimateShippingReqBody(
      data: estimateShipping.copyWith(
          availableCountries: [],
          availableStates: []
      ),
      formValues: []
    );

    resultSink.add(ApiResponse.loading());

    try {
      var response = await _repository.estimateShipping(reqBody);
      defineSelectedItem(response);
      resultSink.add(ApiResponse.completed(response.data));
    } catch (e) {
      resultSink.add(ApiResponse.error(e.toString()));
    }
  }

  void estimateShippingForProduct(
    EstimateShipping estimateShipping,
    List<FormValue> productFormValues,
  ) async {

    EstimateShippingReqBody reqBody = EstimateShippingReqBody(
      data: estimateShipping.copyWith(
          availableCountries: [],
          availableStates: []
      ),
      formValues: productFormValues
    );

    resultSink.add(ApiResponse.loading());

    try {
      var response = await _repository.productEstimateShipping(reqBody);
      defineSelectedItem(response);
      resultSink.add(ApiResponse.completed(response.data));
    } catch (e) {
      resultSink.add(ApiResponse.error(e.toString()));
    }
  }

  void defineSelectedItem(EstimateShippingResponse response) {
    if(preSelectedShippingMethod.isNotEmpty) {
      selectedMethod = preSelectedShippingMethod;
      preSelectedShippingMethod = '';
    } else {
      response.data.shippingOptions.forEach((element) {
        if(element.selected == true) {
          selectedMethod = getMethodId(element);
        }
      });
    }
  }

  String getMethodId(ShippingOption element) {
    return '${element.name}_${element.shippingRateComputationMethodSystemName}';
  }

  @override
  void dispose() {
    _scStates?.close();
    _scResult?.close();
  }
}