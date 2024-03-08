import 'dart:async';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nopcart_flutter/bloc/base_bloc.dart';
import 'package:nopcart_flutter/model/AddToCartResponse.dart';
import 'package:nopcart_flutter/model/AvailableOption.dart';
import 'package:nopcart_flutter/model/BaseResponse.dart';
import 'package:nopcart_flutter/model/FileDownloadResponse.dart';
import 'package:nopcart_flutter/model/FileUploadResponse.dart';
import 'package:nopcart_flutter/model/ProductAttrChangeResponse.dart';
import 'package:nopcart_flutter/model/ProductDetailsResponse.dart';
import 'package:nopcart_flutter/model/ProductSummary.dart';
import 'package:nopcart_flutter/model/SampleDownloadResponse.dart';
import 'package:nopcart_flutter/model/SubscriptionStatusResponse.dart';
import 'package:nopcart_flutter/model/home/BestSellerProductResponse.dart';
import 'package:nopcart_flutter/model/requestbody/FormValue.dart';
import 'package:nopcart_flutter/model/requestbody/FormValuesRequestBody.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/repository/ProductDetailsRepository.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/AppConstants.dart';
import 'package:nopcart_flutter/utils/Const.dart';
import 'package:nopcart_flutter/utils/extensions.dart';

class ProductDetailsBloc implements BaseBloc {
  ProductDetailsRepository _repository;
  StreamController _scProdDetails, _scAddToCart, _scloader, _scSampleDownload,
      _scGoToCart, _scRelatedProduct, _scCrossSell, _scFileUpload, _scTitle,
      _scSubscriptionStatus, _scChangeSubscription;

  DateTime rentalStartDate, rentalEndDate;
  AvailableOption selectedQuantity;
  bool redirectToCart = false;
  ProductDetails _cachedProductDetails;
  List<num> disabledAttributeIds = [];
  String selectedShippingMethod = '';
  int carouselIndex = 0;
  final sliderCtrl = CarouselController(

      );

  StreamSink<ApiResponse<ProductDetails>> get prodDetailsSink =>
      _scProdDetails.sink;

  Stream<ApiResponse<ProductDetails>> get prodDetailsStream =>
      _scProdDetails.stream;

  StreamSink<ApiResponse<AddToCartResponse>> get addToCartSink =>
      _scAddToCart.sink;

  Stream<ApiResponse<AddToCartResponse>> get addToCartStream =>
      _scAddToCart.stream;

  StreamSink<bool> get loaderSink => _scloader.sink;
  Stream<bool> get loaderStream => _scloader.stream;

  StreamSink<String> get titleSink => _scTitle.sink;
  Stream<String> get titleStream => _scTitle.stream;

  StreamSink<bool> get redirectToCartSink => _scGoToCart.sink;
  Stream<bool> get redirectToCartStream => _scGoToCart.stream;

  StreamSink<ApiResponse<FileUploadData>> get fileUploadSink => _scFileUpload.sink;
  Stream<ApiResponse<FileUploadData>> get fileUploadStream => _scFileUpload.stream;

  StreamSink<ApiResponse<List<ProductSummary>>> get relatedProductSink =>
      _scRelatedProduct.sink;
  Stream<ApiResponse<List<ProductSummary>>> get relatedProductStream =>
      _scRelatedProduct.stream;

  StreamSink<ApiResponse<List<ProductSummary>>> get crossSellSink =>
      _scCrossSell.sink;
  Stream<ApiResponse<List<ProductSummary>>> get crossSellStream =>
      _scCrossSell.stream;

  StreamSink<ApiResponse<FileDownloadResponse<SampleDownloadResponse>>> get sampleDownloadSink =>
      _scSampleDownload.sink;
  Stream<ApiResponse<FileDownloadResponse<SampleDownloadResponse>>> get sampleDownloadStream =>
      _scSampleDownload.stream;

  StreamSink<ApiResponse<SubscriptionStatusResponseData>> get subStatusSink =>
      _scSubscriptionStatus.sink;
  Stream<ApiResponse<SubscriptionStatusResponseData>> get subStatusStream =>
      _scSubscriptionStatus.stream;

  StreamSink<ApiResponse<String>> get changeStatusSink => _scChangeSubscription.sink;
  Stream<ApiResponse<String>> get changeStatusStream => _scChangeSubscription.stream;

  ProductDetailsBloc() {
    _scProdDetails = StreamController<ApiResponse<ProductDetails>>();
    _scAddToCart = StreamController<ApiResponse<AddToCartResponse>>();
    _repository = ProductDetailsRepository();
    _scloader = StreamController<bool>();
    _scGoToCart = StreamController<bool>();
    _scTitle = StreamController<String>();
    _scRelatedProduct = StreamController<ApiResponse<List<ProductSummary>>>();
    _scCrossSell = StreamController<ApiResponse<List<ProductSummary>>>();
    _scFileUpload = StreamController<ApiResponse<FileUploadData>>();
    _scSampleDownload = StreamController<ApiResponse<FileDownloadResponse<SampleDownloadResponse>>>();
    _scSubscriptionStatus = StreamController<ApiResponse<SubscriptionStatusResponseData>>();
    _scChangeSubscription = StreamController<ApiResponse<String>>();
  }

  fetchProductDetails(int productId) async {
    prodDetailsSink.add(ApiResponse.loading(
        GlobalService().getString(Const.COMMON_PLEASE_WAIT)));

    try {
      ProductDetailsResponse response = await _repository.fetchProductDetails(productId);
      titleSink.add(response?.data?.name ?? '');
      selectedQuantity = response?.data?.addToCart?.allowedQuantities?.safeFirst();
      _cachedProductDetails = response.data;

      // pre-selected attributes
      List<FormValue> preselectedAttributes = [];
      response.data?.productAttributes?.forEach((attribute) {
        attribute.values?.forEach((element) {
          if (element.isPreSelected) preselectedAttributes.add(
            FormValue(
              key: '${AppConstants.productAttributePrefix}_${attribute.id.toString()}',
              value: element.id.toString(),
            )
          );
        });
      });

      if (preselectedAttributes.isNotEmpty) {
        await postSelectedAttributes(
          productId,
          preselectedAttributes,
          showLoader: false,
        );
      }
      prodDetailsSink.add(ApiResponse.completed(_cachedProductDetails));
    } catch (e) {
      prodDetailsSink.add(ApiResponse.error(e.toString()));
      // debugprint(e.toString());
    }
  }

  void setAssociatedProduct(ProductDetails productDetails) {
    prodDetailsSink.add(ApiResponse.completed(productDetails));
  }

  addToCart(int productId, int cartType, ProductDetails product, List<FormValue> formValues) async {
    loaderSink.add(true);

    // append product related form values (gift card info, rental product info...)
    // with product attributes form values
    formValues.addAll(getProductFormValues(product));

    addToCartSink.add(ApiResponse.loading());

    try {
      AddToCartResponse response =
          await _repository.addProductToCart(productId, cartType, FormValuesRequestBody(formValues: formValues));
      addToCartSink.add(ApiResponse.completed(response));
      loaderSink.add(false);
      if(redirectToCart) redirectToCartSink.add(true);
    } catch (e) {
      addToCartSink.add(ApiResponse.error(e.toString()));
      loaderSink.add(false);
      // debugprint(e.toString());
    }
  }

  void getSubscriptionStatus(num productId) async {
    subStatusSink.add(ApiResponse.loading());

    try {
      SubscriptionStatusResponse response = await _repository.fetchSubscriptionStatus(productId);
      subStatusSink.add(ApiResponse.completed(response.data));
    } catch (e) {
      subStatusSink.add(ApiResponse.error(e.toString()));
      // print(e.toString());
    }
  }

  changeSubscriptionStatus(num productId) async {
    changeStatusSink.add(ApiResponse.loading());

    try {
      BaseResponse response = await _repository.changeSubscriptionStatus(productId);
      changeStatusSink.add(ApiResponse.completed(response.message));
    } catch (e) {
      changeStatusSink.add(ApiResponse.error(e.toString()));
      // print(e.toString());
    }
  }

  void fetchRelatedProducts(num productId) async{
    relatedProductSink.add(ApiResponse.loading());

    try {
      BestSellerProductResponse response = await _repository.fetchRelatedProducts(productId);
      relatedProductSink.add(ApiResponse.completed(response.data));
    } catch (e) {
      relatedProductSink.add(ApiResponse.error(e.toString()));
      // debugprint(e.toString());
    }
  }

  void fetchCrossSellProducts(num productId) async{
    crossSellSink.add(ApiResponse.loading());

    try {
      BestSellerProductResponse response = await _repository.fetchCrossSellProducts(productId);
      crossSellSink.add(ApiResponse.completed(response.data));
    } catch (e) {
      crossSellSink.add(ApiResponse.error(e.toString()));
      // debugprint(e.toString());
    }
  }

  Future<void> postSelectedAttributes(num productId, List<FormValue> formValues,
      {bool showLoader = true}) async {

    if(formValues.isEmpty) {
      return;
    }

    if(showLoader) {
      loaderSink.add(true);
    }

    formValues.add(FormValue(
      key: 'ValidateAttributeConditions',
      value: 'true',
    ));
    formValues.add(FormValue(
      key: 'LoadPicture',
      value: 'true',
    ));

    try {
      ProductAttrChangeResponse response =
      await _repository.postSelectedAttributes(
        productId,
        FormValuesRequestBody(formValues: formValues),
      );

      updatePrice(response);
      updateProductImage(response);

      if(showLoader) {
        prodDetailsSink.add(ApiResponse.completed(_cachedProductDetails));
        loaderSink.add(false);
      }
    } catch (e) {
      if(showLoader) {
        loaderSink.add(false);
      }
    }
  }

  void uploadFile(String filePath, num attributeId) async {
    fileUploadSink.add(ApiResponse.loading());

    try {
      FileUploadResponse response = await _repository.uploadFile(
          filePath, attributeId.toString());
      var uploadFileData = response.data;
      uploadFileData.attributedId = attributeId;

      fileUploadSink.add(ApiResponse.completed(uploadFileData));
    } catch (e) {
      fileUploadSink.add(ApiResponse.error(e.toString()));
      // debugprint(e.toString());
    }
  }

  void downloadSample(num productId) async {
    sampleDownloadSink.add(ApiResponse.loading());

    try {
      FileDownloadResponse<SampleDownloadResponse> response = await _repository.downloadSample(productId);
      sampleDownloadSink.add(ApiResponse.completed(response));
    } catch (e) {
      sampleDownloadSink.add(ApiResponse.error(e.toString()));
      // debugprint(e.toString());
    }
  }

  List<FormValue> getProductFormValues(ProductDetails product) {

    num productId = product.id;
    List<FormValue> formValues = [];

    // entered price
    if(product?.addToCart?.customerEntersPrice == true) {
      formValues.add(FormValue(
        key: 'addtocart_$productId.CustomerEnteredPrice',
        value: product.addToCart.customerEnteredPrice.toString(),
      ));
    } else {
      var quantity = selectedQuantity != null ? int.tryParse(selectedQuantity?.value ?? '1') ?? 1 : product.addToCart.enteredQuantity ?? 1;
      formValues.add(
        FormValue(
          key: 'addtocart_$productId.EnteredQuantity',
          value: '$quantity',
        ),
      );
    }
    // gift card
    if (product?.giftCard?.isGiftCard == true) {
      formValues.add(FormValue(
        key: "giftcard_$productId.Message",
        value: '${product.giftCard?.message}',
      ));
      formValues.add(FormValue(
        key: "giftcard_$productId.SenderName",
        value: '${product.giftCard?.senderName}',
      ));
      formValues.add(FormValue(
        key: "giftcard_$productId.SenderEmail",
        value: '${product.giftCard?.senderEmail}',
      ));
      formValues.add(FormValue(
        key: "giftcard_$productId.RecipientName",
        value: '${product.giftCard?.recipientName}',
      ));
      formValues.add(FormValue(
        key: "giftcard_$productId.RecipientEmail",
        value: '${product.giftCard?.recipientEmail}',
      ));
    }
    // rental date
    if(product?.isRental == true) {
      var formatter = DateFormat('MM/dd/yyyy');

      if (rentalStartDate != null)
        formValues.add(FormValue(
          key: 'rental_start_date_${product.id}',
          value: formatter.format(rentalStartDate ?? DateTime.now()),
        ));

      if (rentalEndDate != null)
        formValues.add(FormValue(
          key: 'rental_end_date_${product.id} ',
          value: formatter.format(rentalEndDate ?? DateTime.now()),
        ));
    }

    return formValues;
  }

  void updatePrice(ProductAttrChangeResponse response) {
    _cachedProductDetails.isFreeShipping = response.data?.isFreeShipping ?? false;
    _cachedProductDetails.productPrice?.price = response.data?.price ?? '';
    _cachedProductDetails.gtin = response.data?.gtin ?? '';
    _cachedProductDetails.sku = response.data?.sku ?? '';
    _cachedProductDetails.stockAvailability = response.data?.stockAvailability ?? '';
    _cachedProductDetails.defaultPictureModel.fullSizeImageUrl = response.data?.pictureFullSizeUrl ?? '';
    _cachedProductDetails.defaultPictureModel.imageUrl = response.data?.pictureDefaultSizeUrl ?? '';
    disabledAttributeIds = response?.data?.disabledAttributeMappingIds ?? [];
  }

  /// update image on slider based on selected product attributes
  void updateProductImage(ProductAttrChangeResponse response) {
    if (response?.data?.pictureDefaultSizeUrl?.isNotEmpty == true) {
      for (var i = 0; i < (_cachedProductDetails?.pictureModels?.length ?? 0); i++) {
        final picModel = _cachedProductDetails.pictureModels[i];

        if (picModel.imageUrl == response.data.pictureDefaultSizeUrl) {
          carouselIndex = i;
          sliderCtrl.jumpToPage(i);
          break;
        }
      }
    }
  }

  @override
  void dispose() {
    _scProdDetails?.close();
    _scAddToCart?.close();
    _scloader?.close();
    _scGoToCart?.close();
    _scCrossSell?.close();
    _scRelatedProduct?.close();
    _scFileUpload?.close();
    _scTitle?.close();
    _scSampleDownload?.close();
    _scChangeSubscription?.close();
    _scSubscriptionStatus?.close();
  }
}
