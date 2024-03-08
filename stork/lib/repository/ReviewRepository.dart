import 'package:nopcart_flutter/model/CustomerReviewResponse.dart';
import 'package:nopcart_flutter/model/PostHelpfulnessResponse.dart';
import 'package:nopcart_flutter/model/ProductReviewResponse.dart';
import 'package:nopcart_flutter/model/requestbody/FormValuesRequestBody.dart';
import 'package:nopcart_flutter/model/requestbody/PostReviewReqBody.dart';
import 'package:nopcart_flutter/networking/ApiBaseHelper.dart';
import 'package:nopcart_flutter/networking/Endpoints.dart';

class ReviewRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<ProductReviewResponse> fetchProductReviews(num productId) async {
    final response = await _helper.get('${Endpoints.productReviews}/$productId');
    return ProductReviewResponse.fromJson(response);
  }

  Future<ProductReviewResponse> postProductReview(num productId, PostReviewReqBody reqBody) async {
    final response = await _helper.post('${Endpoints.addProductReview}/$productId', reqBody);
    return ProductReviewResponse.fromJson(response);
  }

  Future<CustomerReviewResponse> fetchMyReviews(num pageNumber) async {
    final response = await _helper.get('${Endpoints.productReviews}?pageNumber=$pageNumber');
    return CustomerReviewResponse.fromJson(response);
  }

  Future<PostHelpfulnessResponse> postReviewHelpfulness(num reviewId, FormValuesRequestBody reqBody) async {
    final response = await _helper.post('${Endpoints.addReviewHelpfulness}/$reviewId', reqBody);
    return PostHelpfulnessResponse.fromJson(response);
  }
}