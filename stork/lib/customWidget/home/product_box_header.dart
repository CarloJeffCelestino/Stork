import 'package:flutter/material.dart';
import 'package:nopcart_flutter/customWidget/scrollview_with_scrollbar.dart';
import 'package:nopcart_flutter/model/home/CategoriesWithProductsResponse.dart';
import 'package:nopcart_flutter/model/home/ManufacturersResponse.dart';
import 'package:nopcart_flutter/pages/home/all_manufacturers_screen.dart';
import 'package:nopcart_flutter/pages/product-list/product_list_screen.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/Const.dart';
import 'package:nopcart_flutter/utils/GetBy.dart';

class ProductBoxHeader extends StatelessWidget {
  final GlobalService _globalService = GlobalService();

  final String title;
  final num categoryId;
  final bool showSeeAllBtn;
  final bool showSubcategories;
  final bool hasGradient;
  final List<CategoriesWithProducts> subcategories;
  final List<ManufacturerData> manufacturerList;

  ProductBoxHeader(this.title, this.showSeeAllBtn, this.showSubcategories,
      this.subcategories, {this.categoryId, this.manufacturerList, this.hasGradient = true});

  void openSubcategoriesActionSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return ScrollViewWithScrollBar(
            child: Wrap(
              children: [
                for(var index=0; index<this.subcategories.length; index++)
                  ListTile(
                    onTap: () {
                      Navigator.of(context).popAndPushNamed(
                          ProductListScreen.routeName,
                          arguments: ProductListScreenArguments(
                            id: subcategories[index].id,
                            name: subcategories[index].name,
                            type: GetBy.CATEGORY,
                          )
                      );
                    },
                    title: Text(
                      subcategories[index].name,
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                    ),
                  )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {

    var width = MediaQuery.of(context).size.width;
    // var showOverflow = showSubcategories == true && subcategories.length > 0;

    return Row(
      children: [
        Container(
          width: 150,
          margin: hasGradient ? EdgeInsets.only(top:10, bottom:0.0) : EdgeInsets.all(0),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                  gradient: hasGradient ? LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.white,
                      Colors.orange.shade700,
                    ],
                  ) : null
              ),
              child: Center(
                child: Padding(
                  padding: hasGradient ? EdgeInsets.all(8) : EdgeInsets.all(0),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            )
          ),
        ),
        Spacer(),
        if (showSeeAllBtn == true)
          SizedBox(
            height: 50,
            width: 75,
            child: TextButton(
              onPressed: () {

                if(manufacturerList?.isNotEmpty == true) {
                  Navigator.of(context).pushNamed(AllManufacturersScreen.routeName,
                      arguments: AllManufacturersScreenArgs(title));
                } else {
                  Navigator.of(context).pushNamed(ProductListScreen.routeName,
                      arguments: ProductListScreenArguments(
                        id: categoryId,
                        name: title,
                        type: GetBy.CATEGORY,
                      ));
                }
              },
              child: Padding(
                padding: EdgeInsets.all(4),
                child: Text(
                  '${_globalService.getString(Const.COMMON_SEE_ALL)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ),
          ),
        // if (showOverflow)
        //   SizedBox(
        //     width: 35,
        //     child: IconButton(
        //       icon: Icon(Icons.more_vert),
        //       padding: EdgeInsets.zero,
        //       onPressed: () {
        //         openSubcategoriesActionSheet(context);
        //       },
        //     ),
        //   ),
        // if (!showOverflow)
        //   SizedBox(
        //     width: 5,
        //   )
      ],
    );
  }
}
