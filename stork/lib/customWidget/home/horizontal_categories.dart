import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nopcart_flutter/customWidget/cached_image.dart';
import 'package:nopcart_flutter/model/category_tree/CategoryTreeResponse.dart';
import 'package:nopcart_flutter/pages/product-list/product_list_screen.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/Const.dart';
import 'package:nopcart_flutter/utils/GetBy.dart';
import 'package:nopcart_flutter/utils/utility.dart';

class HorizontalCategories extends StatelessWidget {
  final List<CategoryTreeResponseData> categories;
  final double boxSize = 50;

  const HorizontalCategories({Key key, this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: boxSize,
            width: double.infinity,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          ProductListScreen.routeName,
                          arguments: ProductListScreenArguments(
                            id: categories[index].categoryId,
                            name: categories[index].name,
                            type: GetBy.CATEGORY,
                          )
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(5, 5, 3, 5),
                      child: Column(
                        children: [
                          Card(
                            elevation: 1.5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  categories[index].name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
