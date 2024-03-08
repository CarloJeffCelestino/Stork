import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:intl/intl.dart';
import 'package:nopcart_flutter/bloc/product_list/product_list_bloc.dart';
import 'package:nopcart_flutter/customWidget/CustomAppBar.dart';
import 'package:nopcart_flutter/customWidget/cached_image.dart';
import 'package:nopcart_flutter/customWidget/loading.dart';
import 'package:nopcart_flutter/customWidget/product%20list/filter.dart';
import 'package:nopcart_flutter/customWidget/product%20list/product_list_gridview.dart';
import 'package:nopcart_flutter/customWidget/scrollview_with_scrollbar.dart';
import 'package:nopcart_flutter/model/product_list/ProductListResponse.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/pages/tabs-screen/tabs_screen.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/Const.dart';
import 'package:nopcart_flutter/utils/GetBy.dart';
import 'package:nopcart_flutter/utils/styles.dart';

class ProductListScreen extends StatefulWidget {
  static const routeName = 'product-list';
  final String type;
  final String name;
  final int id;

  ProductListScreen(this.type, this.name, this.id);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  GlobalService _globalService = GlobalService();
  ProductListBloc _bloc = ProductListBloc();

  ProductListResponse productList;
  var loaded = false;
  bool hasInitialProductsLength = false;
  String orderBy = '';
  String price = '';
  String specs = '';
  String ms = '';
  bool showFilterOptions = false;

  @override
  void dispose() {
    super.dispose();

    _bloc.dispose();
  }

  @override
  void initState() {
    super.initState();

    _bloc.prodListStream.listen((event) {
      setState(() {
        loaded = false;
      });

      if (event.status == Status.COMPLETED) {
        if (event.data.data.catalogProductsModel.products.length > 0 &&
            !hasInitialProductsLength) {
          hasInitialProductsLength = true;
        }
        setState(() {
          productList = event.data;
          loaded = true;
          // print("Product Count: ${productList.data.catalogProductsModel.products.length}");
        });
      }
    });

    _bloc.type = widget.type;
    _bloc.categoryId = widget.id;
    _bloc.pageNumber = 1;
    _bloc.orderBy = '';
    _bloc.price = '';
    _bloc.specs = '';
    _bloc.ms = '';

    _bloc.fetchProductList();
  }

  refetchProductList() {
    _bloc.pageNumber = 1;
    _bloc.orderBy = orderBy;

    _bloc.fetchProductList();
  }

  goToProductListPage(String name, int id) {
    // Go to product list page
    Navigator.pushNamed(context, ProductListScreen.routeName,
        arguments:
            ProductListScreenArguments(type: widget.type, name: name, id: id));
  }

  bool hasFilterOption() {
    if (loaded &&
        ((productList.data.catalogProductsModel.specificationFilter.enabled &&
                productList.data.catalogProductsModel.specificationFilter
                        .attributes.length >
                    0) ||
            (productList.data.catalogProductsModel.manufacturerFilter.enabled &&
                productList.data.catalogProductsModel.manufacturerFilter
                        .manufacturers.length >
                    0) ||
            (productList.data.catalogProductsModel.priceRangeFilter.enabled)) &&
        (productList.data.catalogProductsModel.products.length > 0 ||
            hasInitialProductsLength)) {
      return true;
    } else {
      return false;
    }
  }

  bool hasSortOption() {
    if (loaded &&
        productList.data.catalogProductsModel.allowProductSorting &&
        productList.data.catalogProductsModel.allowProductSorting &&
        (productList.data.catalogProductsModel.products.length > 0 ||
            hasInitialProductsLength)) {
      return true;
    } else {
      return false;
    }
  }

  bool hasSubcategories() {
    if (loaded && (productList.data?.subCategories?.length ?? 0) > 0) {
      return true;
    } else {
      return false;
    }
  }

  openSubcategories() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return ScrollViewWithScrollBar(
            child: Wrap(
              children: productList?.data?.subCategories?.map((e) => ListTile(
                onTap: () {
                  Navigator.pop(context);
                  goToProductListPage(e.name, e.id);
                },
                title: Text(
                  e.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                ),
              ))?.toList() ?? [],
            ),
          );
        });
  }

  openFilterOptions() {
    showDialog(
        context: context,
        builder: (BuildContext bc) {
          return Filter(productList.data.catalogProductsModel, _bloc);
        });
  }

  openSortOptions() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return ScrollViewWithScrollBar(
            child: Wrap(
              children: productList
                      ?.data?.catalogProductsModel?.availableSortOptions
                      ?.map((e) => ListTile(
                onTap: () {
                  // Close bottom modal sheet
                  Navigator.pop(context);
                  // Reload data with selected sort options
                  orderBy = e.value;
                  refetchProductList();
                },
                title: Text(
                  e.text,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: e.selected
                        ? Theme.of(context).primaryColor
                        : Styles.textColor(context),
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                ),
              ))
                      ?.toList() ??
                  [],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    
    var content = Stack(
      children: [
        Column(
          children: [
            if (hasSubcategories())
              InkWell(
                onTap: () {
                  openSubcategories();
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: .5),
                    ),
                  ),
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        widget.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_downward),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
              ),
            if (widget.type != GetBy.CATEGORY && (hasFilterOption() || hasSortOption()))
              Container(
                height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: .3),
                  ),
                ),
                child: Row(
                  children: [
                    if (hasFilterOption())
                      Flexible(
                        flex: 1,
                        child: InkWell(
                          onTap: () => openFilterOptions(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${_globalService.getString(Const.FILTER)}'),
                              Icon(Icons.filter_alt_rounded),
                            ],
                          ),
                        ),
                      ),
                    SizedBox(
                      width: .5,
                      child: Container(color: Colors.black),
                    ),
                    if (hasSortOption())
                      Flexible(
                        flex: 1,
                        child: InkWell(
                          onTap: () => openSortOptions(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${_globalService.getString(Const.CATALOG_ORDER_BY)}'),
                              Icon(Icons.sort),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

            if (loaded && productList.data.endDateTimeUtc != null)
              CountdownTimer(
                endTime: DateFormat("yyyy-MM-dd HH:mm:ss").parse(productList.data?.endDateTimeUtc.toString(), true).toLocal().millisecondsSinceEpoch,
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
            if (loaded &&
                productList.data.catalogProductsModel.products.length > 0)
              Expanded(
                child: ProductListGridView(widget.type, widget.id,
                    productList, orderBy, price, specs, ms, productList.data?.pictureModel?.fullSizeImageUrl),
              ),
          ],
        ),
        if (loaded &&
            productList.data.catalogProductsModel.products.length == 0)
          Column(
            children: [
              topPadding(),
              if(productList.data?.pictureModel?.fullSizeImageUrl?.isNotEmpty == true)
                CpImage(
                  url: productList.data?.pictureModel?.fullSizeImageUrl,
                  landscapePlaceholder: true,
                ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_globalService.getString(Const.COMMON_NO_DATA)),
                  ],
                ),
              )
            ],
          ),
        if (!loaded)
          Loading(
            loadingMessage: '',
          )
      ],
    );
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => widget.name?.isEmpty ? Navigator.of(context).popUntil((route) => route.settings.name == TabsScreen.routeName) : Navigator.of(context).pop(),
        ),
        title: Text(
          widget.name,
        ),
        backgroundColor: Colors.blue,
      ),
      body: _globalService.centerWidgets(content),
    );
  }

  Widget topPadding() {
    double padding = 0;

    if(hasSubcategories())
      padding += 50;

    if(hasFilterOption() || hasSortOption())
      padding+= 40;

    return SizedBox(
      height: padding,
    );
  }
}

class ProductListScreenArguments {
  String type;
  String name;
  num id;

  ProductListScreenArguments({this.type, this.name, this.id});
}
