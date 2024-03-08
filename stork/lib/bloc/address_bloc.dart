import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nopcart_flutter/bloc/base_bloc.dart';
import 'package:nopcart_flutter/model/AddressFormResponse.dart';
import 'package:nopcart_flutter/model/AddressListResponse.dart';
import 'package:nopcart_flutter/model/AvailableOption.dart';
import 'package:nopcart_flutter/model/BaseResponse.dart';
import 'package:nopcart_flutter/model/GetBillingAddressResponse.dart';
import 'package:nopcart_flutter/model/requestbody/FormValue.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/repository/AddressRepository.dart';
import 'package:nopcart_flutter/utils/utility.dart';
import 'package:nopcart_flutter/utils/extensions.dart';

class AddressBloc implements BaseBloc {
  AddressRepository _repository;
  StreamController _scAddressList, _scLoader, _scDeleteAddress, _scAddress,
      _scStates, _scSaveAddress;

  AddressListResponse cachedAddressList;
  Address cachedAddress;
  AvailableOption selectedCountry, selectedState;

  StreamSink<ApiResponse<AddressListResponse>> get addressListSink =>
      _scAddressList.sink;
  Stream<ApiResponse<AddressListResponse>> get addressListStream =>
      _scAddressList.stream;

  StreamSink<bool> get loaderSink => _scLoader.sink;
  Stream<bool> get loaderStream => _scLoader.stream;

  StreamSink<ApiResponse<Address>> get addressSink => _scAddress.sink;
  Stream<ApiResponse<Address>> get addressStream => _scAddress.stream;

  StreamSink<ApiResponse<bool>> get deleteAddressSink => _scDeleteAddress.sink;
  Stream<ApiResponse<bool>> get deleteAddressStream => _scDeleteAddress.stream;

  StreamSink<ApiResponse<BaseResponse>> get saveAddressSink => _scSaveAddress.sink;
  Stream<ApiResponse<BaseResponse>> get saveAddressStream => _scSaveAddress.stream;

  StreamSink<ApiResponse<List<AvailableOption>>> get statesListSink => _scStates.sink;
  Stream<ApiResponse<List<AvailableOption>>> get statesListStream => _scStates.stream;

  AddressBloc() {
    _repository = AddressRepository();
    _scAddressList = StreamController<ApiResponse<AddressListResponse>>();
    _scDeleteAddress = StreamController<ApiResponse<bool>>();
    _scLoader = StreamController<bool>();
    _scSaveAddress = StreamController<ApiResponse<BaseResponse>>();
    _scAddress = StreamController<ApiResponse<Address>>();
    _scStates = StreamController<ApiResponse<List<AvailableOption>>>();
  }

  @override
  void dispose() {
    _scAddressList?.close();
    _scLoader?.close();
    _scDeleteAddress?.close();
    _scAddress?.close();
    _scStates?.close();
    _scSaveAddress?.close();
  }

  void fetchAddressList() async{
    addressListSink.add(ApiResponse.loading());

    try {
      AddressListResponse response = await _repository.fetchCustomerAddresses();
      cachedAddressList = response;
      addressListSink.add(ApiResponse.completed(response));
    } catch (e) {
      addressListSink.add(ApiResponse.error(e.toString()));
      // print(e);
    }
  }

  deleteAddress(num addressId) async {
    deleteAddressSink.add(ApiResponse.loading());

    try {
      await _repository.deleteAddressById(addressId);
      deleteAddressSink.add(ApiResponse.completed(true));

      // remove item from list
      cachedAddressList?.data?.addresses?.removeWhere((element) => element.id == addressId);
      addressListSink.add(ApiResponse.completed(cachedAddressList));
    } catch (e) {
      deleteAddressSink.add(ApiResponse.error(e.toString()));
      // debugprint(e.toString());
    }
  }

  void fetchNewAddressForm() async{
    addressSink.add(ApiResponse.loading());

    try {
      AddressFormResponse response = await _repository.fetchNewAddressForm();
      cachedAddress = response.data.address;
      setInitiallySelectedItems(cachedAddress);
      addressSink.add(ApiResponse.completed(response.data.address));
    } catch (e) {
      addressSink.add(ApiResponse.error(e.toString()));
      // print(e);
    }
  }

  void saveNewAddress(Address address, List<FormValue> formValues) async{
    saveAddressSink.add(ApiResponse.loading());

    try {
      BaseResponse response = await _repository.saveNewAddress(
        AddressFormResponse(
          data: AddressFormData(
            address: address.copyWith(availableStates: [], availableCountries: [], customAddressAttributes: []),
          ),
          formValues: formValues,
        )
      );
      saveAddressSink.add(ApiResponse.completed(response));
    } catch (e) {
      saveAddressSink.add(ApiResponse.error(e.toString()));
      // print(e);
    }
  }

  void fetchExistingAddress(num addressId) async{
    addressSink.add(ApiResponse.loading());

    try {
      AddressFormResponse response = await _repository.fetchExistingAddress(addressId);
      cachedAddress = response.data.address;
      setInitiallySelectedItems(cachedAddress);
      addressSink.add(ApiResponse.completed(response.data.address));
    } catch (e) {
      addressSink.add(ApiResponse.error(e.toString()));
      // print(e);
    }
  }

  void editAddress(num addressId, Address address, List<FormValue> formValues) async{
    saveAddressSink.add(ApiResponse.loading());

    try {
      BaseResponse response = await _repository.updateExistingAddress(
          addressId,
          AddressFormResponse(
            data: AddressFormData(
              address: address.copyWith(availableStates: [], availableCountries: [], customAddressAttributes: [],),
            ),
            formValues: formValues,
          ));
      saveAddressSink.add(ApiResponse.completed(response));
    } catch (e) {
      saveAddressSink.add(ApiResponse.error(e.toString()));
      // print(e);
    }
  }


  fetchStatesByCountryId(int countryId) async {
    statesListSink.add(ApiResponse.loading());

    try {
      var stateList = await fetchStatesList(countryId);

      this.cachedAddress.availableStates = stateList;
      this.selectedState = stateList?.safeFirstWhere(
            (element) => element.selected ?? false,
        orElse: () => stateList?.safeFirst(),
      );

      addressSink.add(ApiResponse.completed(cachedAddress));
      statesListSink.add(ApiResponse.completed(stateList));
    } catch (e) {
      this.cachedAddress.availableStates = List<AvailableOption>.empty();

      addressSink.add(ApiResponse.completed(cachedAddress));
      statesListSink.add(ApiResponse.completed(List<AvailableOption>.empty()));
      // print(e);
    }
  }

  setInitiallySelectedItems(Address formData) {

    if(selectedCountry!=null || selectedState!=null)
      return;

    selectedCountry = formData.availableCountries?.safeFirstWhere(
          (element) => element.selected ?? false,
      orElse: () => formData.availableCountries?.safeFirst(),
    );

    selectedState = formData.availableStates?.safeFirstWhere(
          (element) => element.selected ?? false,
      orElse: () => formData.availableStates?.safeFirst(),
    );
  }
}