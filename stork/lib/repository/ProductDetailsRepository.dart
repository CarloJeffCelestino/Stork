

import 'package:nopcart_flutter/model/AddToCartResponse.dart';
import 'package:nopcart_flutter/model/BaseResponse.dart';
import 'package:nopcart_flutter/model/SubscriptionStatusResponse.dart';
import 'package:nopcart_flutter/model/FileDownloadResponse.dart';
import 'package:nopcart_flutter/model/FileUploadResponse.dart';
import 'package:nopcart_flutter/model/ProductAttrChangeResponse.dart';
import 'package:nopcart_flutter/model/ProductDetailsResponse.dart';
import 'package:nopcart_flutter/model/SampleDownloadResponse.dart';
import 'package:nopcart_flutter/model/home/BestSellerProductResponse.dart';
import 'package:nopcart_flutter/model/requestbody/FormValuesRequestBody.dart';
import 'package:nopcart_flutter/networking/ApiBaseHelper.dart';
import 'package:nopcart_flutter/networking/Endpoints.dart';
import 'package:nopcart_flutter/utils/AppConstants.dart';
import 'package:nopcart_flutter/utils/FileResponse.dart';
import 'package:nopcart_flutter/utils/utility.dart';

class ProductDetailsRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<ProductDetailsResponse> fetchProductDetails(int productId) async {
    final response = await _helper.get('${Endpoints.productDetails}/$productId');
    return ProductDetailsResponse.fromJson(response);
  }

  Future<dynamic> addProductToCart(
      int productId, int cartType, FormValuesRequestBody requestBody) async {
    final response = await _helper.post(
        '${Endpoints.addProductToCart}/$productId/$cartType',
        requestBody);
    return AddToCartResponse.fromJson(response);
  }

  Future<BestSellerProductResponse> fetchRelatedProducts(int productId) async {
    final response = await _helper.get('${Endpoints.relatedProducts}/$productId/300');
    return BestSellerProductResponse.fromJson(response);
  }

  Future<BestSellerProductResponse> fetchCrossSellProducts(int productId) async {
    final response = await _helper.get('${Endpoints.crossSellProduct}/$productId/300');
    return BestSellerProductResponse.fromJson(response);
  }

  Future<ProductAttrChangeResponse> postSelectedAttributes(
    int productId,
    FormValuesRequestBody requestBody,
  ) async {
    final response = await _helper.post(
        '${Endpoints.productAttributeChange}/$productId', requestBody);
    return ProductAttrChangeResponse.fromJson(response);
  }

  Future<FileUploadResponse> uploadFile(String filePath, String attributeId) async {
    final response = await _helper.multipart('${Endpoints.uploadFileProductAttribute}/$attributeId', filePath);
    return FileUploadResponse.fromJson(response);
  }

  Future<FileDownloadResponse> downloadSample(num productId) async {
    final FileResponse response = await _helper.getFile('${Endpoints.sampleDownload}/$productId');

    if(response.isFile) {
      return FileDownloadResponse<SampleDownloadResponse>(
        file: await saveFileToDisk(response, showNotification: true),
      );
    } else {
      return FileDownloadResponse<SampleDownloadResponse>(
          jsonResponse: SampleDownloadResponse.fromJson(response.jsonStr),
      );
    }
  }

  Future<SubscriptionStatusResponse> fetchSubscriptionStatus(num productId) async {
    final response = await _helper.get('${Endpoints.subscriptionStatus}/$productId');
    return SubscriptionStatusResponse.fromJson(response);
  }

  Future<BaseResponse> changeSubscriptionStatus(num productId) async {
    final response = await _helper.post('${Endpoints.subscriptionStatus}/$productId', AppConstants.EMPTY_POST_BODY);
    return BaseResponse.fromJson(response);
  }

  Future<ProductDetailsResponse> fetchProductByBarcode(String barcodeValue) async {
    final response = await _helper.get('${Endpoints.productByBarcode}/$barcodeValue');
    return ProductDetailsResponse.fromJson(response);
  }
}
