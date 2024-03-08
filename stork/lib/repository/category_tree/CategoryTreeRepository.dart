import 'package:nopcart_flutter/model/category_tree/CategoryTreeResponse.dart';
import 'package:nopcart_flutter/networking/ApiBaseHelper.dart';
import 'package:nopcart_flutter/networking/Endpoints.dart';

class CategoryTreeRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<CategoryTreeResponse> fetchCategoryTree() async {
    final response = await _helper.get(Endpoints.categoryTree);
    return CategoryTreeResponse.fromJson(response);
  }
}
