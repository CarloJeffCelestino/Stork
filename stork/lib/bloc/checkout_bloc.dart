import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nopcart_flutter/bloc/base_bloc.dart';
import 'package:nopcart_flutter/model/AvailableOption.dart';
import 'package:nopcart_flutter/model/GetBillingAddressResponse.dart';
import 'package:nopcart_flutter/model/SaveBillingResponse.dart';
import 'package:nopcart_flutter/model/ShoppingCartResponse.dart';
import 'package:nopcart_flutter/model/requestbody/FormValue.dart';
import 'package:nopcart_flutter/model/requestbody/FormValuesRequestBody.dart';
import 'package:nopcart_flutter/model/requestbody/OrderSummaryReponse.dart';
import 'package:nopcart_flutter/model/requestbody/SaveBillingReqBody.dart';
import 'package:nopcart_flutter/model/requestbody/SavePaymentReqBody.dart';
import 'package:nopcart_flutter/model/requestbody/SaveShippingReqBody.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/repository/CheckoutRepository.dart';
import 'package:nopcart_flutter/utils/CheckoutConstants.dart';
import 'package:nopcart_flutter/utils/extensions.dart';
import 'package:nopcart_flutter/utils/utility.dart';

class CheckoutBloc implements BaseBloc {
  CheckoutRepository _repository;
  StreamController _scLoader, _scGetBilling, _scCheckoutPost, _scStates;

  int currentStep = 1;

  // address
  AvailableOption selectedCountry;
  ApiResponse<List<AvailableOption>> statesDropdownInitialData = ApiResponse.error('');

  // billing address
  List<Address> existingBillingAddress;
  bool showNewBillingAddress;
  bool shipToSameAddress;
  Address selectedExistingBillingAddress;

  // shipping address
  List<Address> existingShippingAddress;
  bool showNewShippingAddress;
  bool storePickup;
  Address selectedExistingShippingAddress;
  List<PickupPoint> pickupPointAddress;
  PickupPoint selectedPickupAddress;

  // shipping method
  ShippingMethod selectedShippingMethod;

  // payment method
  PaymentMethod selectedPaymentMethod;
  bool userRewardPoint = false;

  // order complete
  num orderId = 0;
  String orderNumber = '';
  String warningMsg = '';

  StreamSink<bool> get loaderSink => _scLoader.sink;
  Stream<bool> get loaderStream => _scLoader.stream;

  StreamSink<ApiResponse<GetBillingAddressResponse>> get getBillingSink => _scGetBilling.sink;
  Stream<ApiResponse<GetBillingAddressResponse>> get getBillingStream => _scGetBilling.stream;

  StreamSink<ApiResponse<CheckoutPostResponse>> get checkoutPostSink => _scCheckoutPost.sink;
  Stream<ApiResponse<CheckoutPostResponse>> get checkoutPostStream => _scCheckoutPost.stream;

  StreamSink<ApiResponse<List<AvailableOption>>> get statesListSink => _scStates.sink;
  Stream<ApiResponse<List<AvailableOption>>> get statesListStream => _scStates.stream;

  CheckoutBloc() {
    _repository = CheckoutRepository();
    _scGetBilling = StreamController<ApiResponse<GetBillingAddressResponse>>();
    _scCheckoutPost = StreamController<ApiResponse<CheckoutPostResponse>>();
    _scLoader = StreamController<bool>();
    _scStates = StreamController<ApiResponse<List<AvailableOption>>>.broadcast();
  }

  @override
  void dispose() {
    _scLoader?.close();
    _scGetBilling?.close();
    _scCheckoutPost?.close();
    _scStates?.close();
  }

  void fetchBillingAddress() async {
    getBillingSink.add(ApiResponse.loading());

    try {
      GetBillingAddressResponse response = await _repository.fetchBillingAddress();

      this.existingBillingAddress = [...response.data.billingAddress.existingAddresses];
      this.existingBillingAddress.add(Address(
        id: -1,
      )); // New address option to show on dropdown menu

      showNewBillingAddress = response.data?.billingAddress?.existingAddresses?.isEmpty == true;
      shipToSameAddress = response.data?.billingAddress?.shipToSameAddress ?? false;
      selectedExistingBillingAddress =
          response.data?.billingAddress?.existingAddresses?.safeFirst();
      selectedCountry = response.data?.billingAddress
          ?.billingNewAddress?.availableCountries?.safeFirst();

      getBillingSink.add(ApiResponse.completed(response));
    } catch (e) {
      getBillingSink.add(ApiResponse.error(e.toString()));
      // print(e);
    }
  }

  fetchStatesByCountryId(int countryId) async {
    statesListSink.add(ApiResponse.loading(''));

    try {
      var stateList = await fetchStatesList(countryId);

      statesDropdownInitialData = ApiResponse.completed(stateList);
      statesListSink.add(statesDropdownInitialData);

    } catch (e) {
      statesDropdownInitialData = ApiResponse.error(e);
      statesListSink.add(ApiResponse.completed(List<AvailableOption>.empty()));
      // print(e);
    }
  }

  void saveBillingAddress({
    @required bool newAddress,
    List<FormValue> formValue,
    Address address,
  }) async{
    SaveBillingReqBody reqBody;

    if (!newAddress) {
      reqBody = SaveBillingReqBody(
          data: SaveBillingData(shipToSameAddress: false),
          // data: SaveBillingData(shipToSameAddress: this.shipToSameAddress),
          formValues: [
            FormValue(
              key: 'billing_address_id',
              value: this.selectedExistingBillingAddress.id.toString(),
            )
          ]);
    } else {
      reqBody = SaveBillingReqBody(
        data: SaveBillingData(
          shipToSameAddress: false,
          // shipToSameAddress: this.shipToSameAddress,
          billingNewAddress: address.copyWith(
            availableStates: [],
          ),
        ),
        formValues: formValue ?? [],
      );
    }

    checkoutPostSink.add(ApiResponse.loading());
    try {
      CheckoutPostResponse response = await _repository.saveBillingAddress(reqBody);
      this.currentStep = response?.data?.nextStep ?? -1;

      statesDropdownInitialData = ApiResponse.error('');
      checkoutPostSink.add(ApiResponse.completed(response));
    } catch (e) {
      statesDropdownInitialData = ApiResponse.error('');
      checkoutPostSink.add(ApiResponse.error(e.toString()));
      // print(e);
    }
  }

  void saveShippingAddress({
    @required bool isNewAddress,
    List<FormValue> formValue,
    Address address,
  }) async {
    SaveShippingReqBody reqBody;

    if (this.storePickup) {
      reqBody = SaveShippingReqBody(formValues: [
        FormValue(
          key: 'pickup-points-id',
          value: '${this.selectedPickupAddress.id}___Pickup.PickupInStore',
        ),
        FormValue(
          key: 'pickupinstore',
          value: 'true',
        ),
      ]);
    } else {
      if (isNewAddress) {
        reqBody = SaveShippingReqBody(
          data: SaveShippingReqData(
            shippingNewAddress: address,
          ),
          formValues: formValue ?? [],
        );
      } else {
        reqBody = SaveShippingReqBody(formValues: [
          FormValue(
            key: 'shipping_address_id',
            value: this.selectedExistingShippingAddress.id.toString(),
          )
        ]);
      }
    }

    checkoutPostSink.add(ApiResponse.loading());
    try {
      CheckoutPostResponse response =
          await _repository.saveShippingAddress(reqBody);
      this.currentStep = response?.data?.nextStep ?? -1;

      checkoutPostSink.add(ApiResponse.completed(response));
    } catch (e) {
      checkoutPostSink.add(ApiResponse.error(e.toString()));
      // print(e);
    }
  }

  void saveShippingMethod() async{
    FormValuesRequestBody reqBody = FormValuesRequestBody(
      formValues: [
        FormValue(
          key: 'shippingoption',
          value: '${this.selectedShippingMethod.name}___${this
              .selectedShippingMethod.shippingRateComputationMethodSystemName}'
        )
      ]
    );

    checkoutPostSink.add(ApiResponse.loading());
    try {
      CheckoutPostResponse response = await _repository.saveShippingMethod(reqBody);
      this.currentStep = response?.data?.nextStep ?? -1;

      checkoutPostSink.add(ApiResponse.completed(response));
    } catch (e) {
      checkoutPostSink.add(ApiResponse.error(e.toString()));
      // print(e);
    }
  }

  void savePaymentMethod() async{
    var reqBody = SavePaymentReqBody(
      data: SavePaymentData(useRewardPoints: this.userRewardPoint),
      formValues: [
        FormValue(
            key: 'paymentmethod',
            value: this.selectedPaymentMethod.paymentMethodSystemName
        ),
      ]
    );

    checkoutPostSink.add(ApiResponse.loading());
    try {
      CheckoutPostResponse response = await _repository.savePaymentMethod(reqBody);
      this.currentStep = response?.data?.nextStep ?? -1;

      checkoutPostSink.add(ApiResponse.completed(response));
    } catch (e) {
      checkoutPostSink.add(ApiResponse.error(e.toString()));
      // print(e);
    }
  }

  void getConfirmOrderData() async{
    checkoutPostSink.add(ApiResponse.loading());
    try {
      OrderSummaryResponse response = await _repository.getConfirmOrder();
      this.currentStep = 6;
      _updateWarningMessage(response?.data?.cart);

      checkoutPostSink.add(
        ApiResponse.completed(
          CheckoutPostResponse(
            data: CheckoutPostResponseData(nextStep: 6, confirmModel: response.data),
          ),
        ),
      );
    } catch (e) {
      checkoutPostSink.add(ApiResponse.error(e.toString()));
      // print(e);
    }
  }

  void confirmOrder() async{
    checkoutPostSink.add(ApiResponse.loading());
    try {
      CheckoutPostResponse response = await _repository.confirmOrder();
      _updateWarningMessage(response?.data?.confirmModel?.cart);
      this.currentStep = response?.data?.nextStep ?? -1;

      checkoutPostSink.add(ApiResponse.completed(response));
    } catch (e) {
      checkoutPostSink.add(ApiResponse.error(e.toString()));
      // print(e);
    }
  }

  /// Not updating UI for this API call
  void orderComplete() async{
    checkoutPostSink.add(ApiResponse.loading());
    try {
      CheckoutPostResponse response = await _repository.orderComplete();
      this.currentStep = response?.data?.nextStep ?? -1;
      this.orderId = response?.data?.completedModel?.orderId ?? 0;
      this.orderNumber = response?.data?.completedModel?.customOrderNumber ?? '';

      checkoutPostSink.add(ApiResponse.completed(response));
    } catch (e) {
      checkoutPostSink.add(ApiResponse.error(e.toString()));
      // print(e);
    }
  }

  void gotoNextStep(int step) {
    if(step == CheckoutConstants.ConfirmOrder) {
      getConfirmOrderData();
    } else if(step == CheckoutConstants.Completed) {
      checkoutPostSink.add(
        ApiResponse.completed(
          CheckoutPostResponse(
            data: CheckoutPostResponseData(nextStep: CheckoutConstants.Completed),
          ),
        ),
      );
    } else if(step == CheckoutConstants.LeaveCheckout) {
      checkoutPostSink.add(
        ApiResponse.completed(
          CheckoutPostResponse(
            data: CheckoutPostResponseData(nextStep: CheckoutConstants.LeaveCheckout),
          ),
        ),
      );
    }
  }

  void _updateWarningMessage(Cart cart) {
    warningMsg = '';
    var hasMinValueWaring = cart?.minOrderSubtotalWarning != null &&
        cart?.minOrderSubtotalWarning?.isNotEmpty == true;

    if(hasMinValueWaring) {
      warningMsg = '$warningMsg${cart?.minOrderSubtotalWarning ?? ''}\n';
    }
    cart?.warnings?.forEach((element) {
      warningMsg = '$warningMsg$element\n';
    });
    warningMsg.trimRight();
  }

}