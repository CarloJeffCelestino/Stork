import 'package:flutter/material.dart';
import 'package:nopcart_flutter/customWidget/category_tree.dart';
import 'package:nopcart_flutter/model/category_tree/CategoryTreeResponse.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';

class CategoriesScreen extends StatefulWidget {
  final ApiResponse<CategoryTreeResponse> snapshot;
  CategoriesScreen(this.snapshot);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  GlobalService _globalService = GlobalService();

  @override
  Widget build(BuildContext context) {
    return _globalService.centerWidgets(CategoryTree(widget.snapshot));
  }
}
