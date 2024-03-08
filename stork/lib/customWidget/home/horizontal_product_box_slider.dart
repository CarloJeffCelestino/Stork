import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:intl/intl.dart';
import 'package:nopcart_flutter/customWidget/home/product_box_header.dart';
import 'package:nopcart_flutter/customWidget/product%20box/product_box_horizontal.dart';
import 'package:nopcart_flutter/model/ProductSummary.dart';
import 'package:nopcart_flutter/model/home/CategoriesWithProductsResponse.dart';
import 'package:nopcart_flutter/pages/home/all_manufacturers_screen.dart';
import 'package:nopcart_flutter/pages/product-list/product_list_screen.dart';
import 'package:nopcart_flutter/utils/GetBy.dart';

class HorizontalSlider extends StatefulWidget {
  final String title;
  final num categoryId;
  final bool showSeeAllBtn;
  final bool showSubcategories;
  final List<CategoriesWithProducts> subcategories;
  final String image;
  final bool location;
  final DateTime endDateTimeUtc;
  final bool wideProduct;
  final bool hasGradient;
  final List<ProductSummary> productList;

  const HorizontalSlider(this.title, this.showSeeAllBtn, this.showSubcategories,
  this.subcategories, this.productList, {Key key, this.categoryId, this.image, this.location = false, this.endDateTimeUtc, this.wideProduct = false, this.hasGradient = true}) : super(key: key);

  @override
  _HorizontalSliderState createState() => _HorizontalSliderState();
}

class _HorizontalSliderState extends State<HorizontalSlider> {
  bool showSlider = true;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if (widget.showSubcategories && widget.subcategories.isNotEmpty) {
      showSlider = false;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            ProductBoxHeader(
                widget.title,
                false,
                widget.showSubcategories,
                widget.subcategories,
                categoryId: widget.categoryId,
                hasGradient: widget.hasGradient
            ),
            ...widget.subcategories.map<Widget>((e) {
              return HorizontalSlider(
                e.name,
                e.products.isEmpty ? false : true,
                false,
                [],
                e.products,
                categoryId: e.id,
                hasGradient: false,
                image: e.fullSizeImageUrl,
              );
            }).toList(),
        ],
      );
    }

    return showSlider
    ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductBoxHeader(
          widget.title,
          widget.wideProduct ? false : widget.showSeeAllBtn,
          widget.showSubcategories,
          widget.subcategories,
          categoryId: widget.categoryId,
          hasGradient: widget.hasGradient
        ),

        if (widget.endDateTimeUtc != null)
          Container(
            child: Row(
                children: [
                  CountdownTimer(
                    onEnd: () {
                      setState(() {
                        showSlider = false;
                      });
                    },
                    endTime: DateFormat("yyyy-MM-dd HH:mm:ss").parse(widget.endDateTimeUtc.toString(), true).toLocal().millisecondsSinceEpoch,
                    widgetBuilder: (_, CurrentRemainingTime time) {
                      NumberFormat formatter = new NumberFormat("00");

                      return Container(
                          margin: EdgeInsets.all(9),
                          child: Row(
                              children: [
                                if (time.days != null && time.days > 0)
                                  SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 2,
                                            offset: Offset(0, 3), // changes position of shadow
                                          )
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                            '${formatter.format(time.days)}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12
                                            )
                                        ),
                                      ),
                                    ),
                                  ),
                                if (time.days != null && time.days > 0)
                                  Text(
                                      ' : ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )
                                  ),

                                if (time.hours != null && time.hours > 0)
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                          offset: Offset(0, 3), // changes position of shadow
                                        )
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                          '${formatter.format(time.hours)}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                                if (time.hours != null && time.hours > 0)
                                Text(
                                    ' : ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold
                                    )
                                ),
                                if (time.min != null && time.min > 0)
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                          offset: Offset(0, 3), // changes position of shadow
                                        )
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                          '${formatter.format(time.min)}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                                if (time.min != null && time.min > 0)
                                Text(
                                    ' : ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold
                                    )
                                ),
                                if (time.sec != null && time.sec > 0)
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                          offset: Offset(0, 3), // changes position of shadow
                                        )
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                          '${formatter.format(time.sec)}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                          )
                      );
                      // 'days: [ ${time.days} ], hours: [ ${time.hours} ], min: [ ${time.min} ], sec: [ ${time.sec} ]');
                    },
                  ),
                  Spacer(),
                  SizedBox(
                    width: 96,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(ProductListScreen.routeName,
                            arguments: ProductListScreenArguments(
                              id: widget.categoryId,
                              name: widget.title,
                              type: GetBy.CATEGORY,
                            ));
                      },
                      child: Row(
                        children: [
                          Text(
                            'See all deals',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Icon(
                            Icons.chevron_right_outlined,
                            color: Colors.grey,
                            size: 12,
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              )
          ),

        widget.image != null && widget.image.isNotEmpty && !widget.showSeeAllBtn
        ? GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductListScreen.routeName,
                arguments: ProductListScreenArguments(
                  id: widget.categoryId,
                  name: widget.title,
                  type: GetBy.CATEGORY,
                ));
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Image.network(widget.image,),
            margin: EdgeInsets.only(top: 8.0),
          ),
        )
        : widget.image != null && widget.image.isNotEmpty
        ? Container(
            width: MediaQuery.of(context).size.width,
            child: Image.network(widget.image),
            margin: EdgeInsets.only(top: 8.0),
          )
        : Container(),
        if (widget.productList.isNotEmpty)
          SizedBox(
            height: widget.wideProduct ? 155: 230,
            width: MediaQuery.of(context).size.width,
            child: widget.wideProduct
              ? Card(
                elevation: 3,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.productList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return HorizontalProductBox(widget.productList[index], location: widget.location, wideProduct: widget.wideProduct);
                        }),
                  )
                )
            )
            : ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: widget.productList.length,
                itemBuilder: (BuildContext context, int index) {
                  return HorizontalProductBox(widget.productList[index], location: widget.location, wideProduct: widget.wideProduct);
                }),
          ),
      ],
    )
    : Container();
  }
}
