import 'dart:async';

import 'package:nopcart_flutter/bloc/base_bloc.dart';
import 'package:nopcart_flutter/model/home/BestSellerProductResponse.dart';
import 'package:nopcart_flutter/model/home/CategoriesWithProductsResponse.dart';
import 'package:nopcart_flutter/model/home/FeaturedProductResponse.dart';
import 'package:nopcart_flutter/model/HomeSliderResponse.dart';
import 'package:nopcart_flutter/model/home/ManufacturersResponse.dart';
import 'package:nopcart_flutter/model/home/NearbyProductsResponse.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/repository/HomeRepository.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/Const.dart';

class HomeBloc implements BaseBloc {
  HomeRepository _homeRepository;
  StreamController _sliderStreamController,
      _featureProductStreamController,
      // _featureProductStreamController3,
      // _featureProductStreamController4,
      _bestSellerProductsStreamCtrl,
      _categoriesWithProdStreamCtrl,
      _manufacturersStreamCtrl,
      _nearbyProductsStreamCtrl;

  // Slider stream
  StreamSink<ApiResponse<HomeSliderResponse>> get sliderSink =>
      _sliderStreamController.sink;
  Stream<ApiResponse<HomeSliderResponse>> get sliderStream =>
      _sliderStreamController.stream;

  // Featured products stream
  StreamSink<ApiResponse<FeaturedProductResponse>> get featuredProdSink =>
      _featureProductStreamController.sink;
  Stream<ApiResponse<FeaturedProductResponse>> get featuredProdStream =>
      _featureProductStreamController.stream;

  StreamSink<ApiResponse<NearbyProductsResponse>> get nearbyProductsSink =>
      _nearbyProductsStreamCtrl.sink;
  Stream<ApiResponse<NearbyProductsResponse>> get nearbyProductsStream =>
      _nearbyProductsStreamCtrl.stream;

  // StreamSink<ApiResponse<FeaturedProductResponse>> get featuredProdSink3 =>
  //     _featureProductStreamController3.sink;
  // Stream<ApiResponse<FeaturedProductResponse>> get featuredProdStream3 =>
  //     _featureProductStreamController3.stream;
  //
  // StreamSink<ApiResponse<FeaturedProductResponse>> get featuredProdSink4 =>
  //     _featureProductStreamController4.sink;
  // Stream<ApiResponse<FeaturedProductResponse>> get featuredProdStream4 =>
  //     _featureProductStreamController4.stream;

  // Best seller products stream
  StreamSink<ApiResponse<BestSellerProductResponse>> get bestSellerProdSink =>
      _bestSellerProductsStreamCtrl.sink;
  Stream<ApiResponse<BestSellerProductResponse>> get bestSellerProdStream =>
      _bestSellerProductsStreamCtrl.stream;

  // Categories with products stream
  StreamSink<ApiResponse<CategoriesWithProductsResponse>>
      get categoriesWithProdSink => _categoriesWithProdStreamCtrl.sink;
  Stream<ApiResponse<CategoriesWithProductsResponse>>
      get categoriesWithProdStream => _categoriesWithProdStreamCtrl.stream;

  // Manufacturers stream controller
  StreamSink<ApiResponse<ManufacturersResponse>> get manufacturersSink =>
      _manufacturersStreamCtrl.sink;
  Stream<ApiResponse<ManufacturersResponse>> get manufacturersStream =>
      _manufacturersStreamCtrl.stream;

  HomeBloc() {
    _sliderStreamController =
        StreamController<ApiResponse<HomeSliderResponse>>();

    _featureProductStreamController =
        StreamController<ApiResponse<FeaturedProductResponse>>();
    //
    // _featureProductStreamController3 =
    //     StreamController<ApiResponse<FeaturedProductResponse>>();
    //
    // _featureProductStreamController4 =
    //     StreamController<ApiResponse<FeaturedProductResponse>>();

    _bestSellerProductsStreamCtrl =
        StreamController<ApiResponse<BestSellerProductResponse>>();

    _categoriesWithProdStreamCtrl =
        StreamController<ApiResponse<CategoriesWithProductsResponse>>();

    _nearbyProductsStreamCtrl =
        StreamController<ApiResponse<NearbyProductsResponse>>();

    _manufacturersStreamCtrl =
        StreamController<ApiResponse<ManufacturersResponse>>();

    _homeRepository = HomeRepository();
  }

  fetchHomeBanners() async {
    if(_sliderStreamController.isClosed)
      return;
    sliderSink.add(ApiResponse.loading(
        GlobalService().getString(Const.COMMON_PLEASE_WAIT)));

    try {
      HomeSliderResponse movies = await _homeRepository.fetchHomePageSliders();
      sliderSink.add(ApiResponse.completed(movies));
    } catch (e) {
      sliderSink.add(ApiResponse.error(e.toString()));
      // print(e);
    }
  }

  getFeaturedProducts() async {
    if(_featureProductStreamController.isClosed)
      return;
    featuredProdSink.add(ApiResponse.loading(
        GlobalService().getString(Const.COMMON_PLEASE_WAIT)));

    try {
      var featuredProductResponse =
          await _homeRepository.fetchFeaturedProducts();
      featuredProdSink.add(ApiResponse.completed(featuredProductResponse));
    } catch (e) {
      featuredProdSink.add(ApiResponse.error(e.toString()));
      // print(e);
    }
  }

  // getFeaturedProducts3() async {
  //   featuredProdSink3.add(ApiResponse.loading(
  //       GlobalService().getString(Const.COMMON_PLEASE_WAIT)));
  //
  //   try {
  //     var featuredProductResponse =
  //     await _homeRepository.fetchFeaturedProducts();
  //     featuredProdSink3.add(ApiResponse.completed(featuredProductResponse));
  //   } catch (e) {
  //     featuredProdSink3.add(ApiResponse.error(e.toString()));
  //     // print(e);
  //   }
  // }
  //
  // getFeaturedProducts4() async {
  //   featuredProdSink4.add(ApiResponse.loading(
  //       GlobalService().getString(Const.COMMON_PLEASE_WAIT)));
  //
  //   try {
  //     var featuredProductResponse =
  //     await _homeRepository.fetchFeaturedProducts();
  //     featuredProdSink4.add(ApiResponse.completed(featuredProductResponse));
  //   } catch (e) {
  //     featuredProdSink4.add(ApiResponse.error(e.toString()));
  //     // print(e);
  //   }
  // }

  fetchBestSellerProducts() async {
    if(_bestSellerProductsStreamCtrl.isClosed)
      return;
    bestSellerProdSink.add(ApiResponse.loading(
        GlobalService().getString(Const.COMMON_PLEASE_WAIT)));

    try {
      var bestSellerProductsRes =
          await _homeRepository.fetchBestSellerProducts();
      bestSellerProdSink.add(ApiResponse.completed(bestSellerProductsRes));
    } catch (e) {
      bestSellerProdSink.add(ApiResponse.error(e.toString()));
      // print(e);
    }
  }

  fetchCategoriesWithProducts() async {
    if(_categoriesWithProdStreamCtrl.isClosed)
      return;
    categoriesWithProdSink.add(ApiResponse.loading(
        GlobalService().getString(Const.COMMON_PLEASE_WAIT)));

    try {
      var categoriesWithProdsRes = await _homeRepository.fetchCategoriesWithProducts();

      // remove empty categories
      // categoriesWithProdsRes.data.removeWhere((element)
      //   => element.products.isEmpty
      // );

      categoriesWithProdSink.add(ApiResponse.completed(categoriesWithProdsRes));
    } catch (e) {
      categoriesWithProdSink.add(ApiResponse.error(e.toString()));
      // print(e);
    }
  }

  fetchManufacturers() async {
    if(_manufacturersStreamCtrl.isClosed)
      return;
    manufacturersSink.add(ApiResponse.loading(
        GlobalService().getString(Const.COMMON_PLEASE_WAIT)));

    try {
      var manufacturersRes = await _homeRepository.fetchManufacturers();
      manufacturersSink.add(ApiResponse.completed(manufacturersRes));
    } catch (e) {
      manufacturersSink.add(ApiResponse.error(e.toString()));
      // print(e);
    }
  }

  fetchNearbyProducts() async {
    if(_nearbyProductsStreamCtrl.isClosed)
      return;
    nearbyProductsSink.add(ApiResponse.loading(
        GlobalService().getString(Const.COMMON_PLEASE_WAIT)));

    try {
      var nearbyProductsRes =
      await _homeRepository.fetchNearbyProducts();
      nearbyProductsSink.add(ApiResponse.completed(nearbyProductsRes));
    } catch (e) {
      nearbyProductsSink.add(ApiResponse.error(e.toString()));
      // print(e);
    }
  }

  @override
  dispose() {
    _sliderStreamController?.close();
    _featureProductStreamController?.close();
    _bestSellerProductsStreamCtrl?.close();
    _nearbyProductsStreamCtrl?.close();
    _categoriesWithProdStreamCtrl?.close();
    _manufacturersStreamCtrl?.close();
  }
}
