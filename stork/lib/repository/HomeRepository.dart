import 'package:nopcart_flutter/model/home/BestSellerProductResponse.dart';
import 'package:nopcart_flutter/model/home/CategoriesWithProductsResponse.dart';
import 'package:nopcart_flutter/model/home/FeaturedProductResponse.dart';
import 'package:nopcart_flutter/model/HomeSliderResponse.dart';
import 'package:nopcart_flutter/model/home/ManufacturersResponse.dart';
import 'package:nopcart_flutter/model/home/NearbyProductsResponse.dart';
import 'package:nopcart_flutter/networking/ApiBaseHelper.dart';
import 'package:nopcart_flutter/networking/Endpoints.dart';

class HomeRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<HomeSliderResponse> fetchHomePageSliders() async {
    final response = await _helper.get(Endpoints.homePageBanner);
    return HomeSliderResponse.fromJson(response);
  }

  Future<FeaturedProductResponse> fetchFeaturedProducts() async {
    final response = await _helper.get(Endpoints.homeFeaturedProduct);
    return FeaturedProductResponse.fromJson(response);
  }

  Future<BestSellerProductResponse> fetchBestSellerProducts() async {
    final response = await _helper.get(Endpoints.homeBestsellerProducts);
    return BestSellerProductResponse.fromJson(response);
  }

  Future<CategoriesWithProductsResponse> fetchCategoriesWithProducts() async {
    final response = await _helper.get(Endpoints.homeCategoryWithProducts);
    return CategoriesWithProductsResponse.fromJson(response);
  }

  Future<ManufacturersResponse> fetchManufacturers() async {
    final response = await _helper.get(Endpoints.homeManufacturers);
    return ManufacturersResponse.fromJson(response);
  }

  Future<NearbyProductsResponse> fetchNearbyProducts() async {
    final response = await _helper.get(Endpoints.homeNearbyProducts);
    return NearbyProductsResponse.fromJson(response);
  }

  Future<ManufacturersResponse> fetchAllManufacturers() async {
    final response = await _helper.get(Endpoints.allManufacturers);
    return ManufacturersResponse.fromJson(response);
  }
}
