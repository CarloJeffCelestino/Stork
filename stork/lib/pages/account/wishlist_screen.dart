import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:nopcart_flutter/bloc/wishlist_bloc.dart';
import 'package:nopcart_flutter/customWidget/CustomAppBar.dart';
import 'package:nopcart_flutter/customWidget/CustomButton.dart';
import 'package:nopcart_flutter/customWidget/cached_image.dart';
import 'package:nopcart_flutter/customWidget/loading.dart';
import 'package:nopcart_flutter/customWidget/error.dart';
import 'package:nopcart_flutter/customWidget/loading_dialog.dart';
import 'package:nopcart_flutter/model/WishListResponse.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/pages/account/cart/shopping_cart_screen.dart';
import 'package:nopcart_flutter/pages/product/product_details_screen.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/ButtonShape.dart';
import 'package:nopcart_flutter/utils/Const.dart';
import 'package:nopcart_flutter/utils/styles.dart';
import 'package:nopcart_flutter/utils/utility.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({Key key}) : super(key: key);
  static const routeName = '/wishlist';

  @override
  _WishListScreenState createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  GlobalService _globalService = GlobalService();
  WishListBloc _bloc;
  List<int> _ids = [];

  @override
  void initState() {
    super.initState();
    getData();

  }

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }

  void getData() {
    _bloc = WishListBloc();

    _bloc.fetchWishListData();

    _bloc.loaderStream.listen((showLoader) {
      if (showLoader) {
        DialogBuilder(context).showLoader();
      } else {
        DialogBuilder(context).hideLoader();
      }
    });

    _bloc.launchCartStream.listen((go) {
      if (go) {
        Navigator.of(context).pushNamed(
            ShoppingCartScreen.routeName
        );
      }
    });
  }

  showSnackBar(BuildContext context, String message, bool isError) {
    var mContext = GlobalService().navigatorKey.currentContext;
    if(mContext == null)
      mContext = context;

    ScaffoldMessenger.of(mContext).hideCurrentSnackBar();

    ScaffoldMessenger.of(mContext).showSnackBar(SnackBar(
      backgroundColor: isError ? Colors.red[600] : Colors.grey[800],
      content: Text(
        stripHtmlTags(message),
        style: TextStyle(color: Colors.white),
      ),
      duration: isError
          ? Duration(seconds: 3)
          : Duration(milliseconds: 1500),
      action: isError ? SnackBarAction(
        label: '✖',
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(mContext).hideCurrentSnackBar();
        },
      ) : null,

    ));
  }

  @override
  Widget build(BuildContext context) {

    var content = _globalService.centerWidgets(StreamBuilder<ApiResponse<WishListResponse>>(
      stream: _bloc.wishListStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return Loading(loadingMessage: snapshot.data.message);
              break;
            case Status.COMPLETED:
              return rootWidget(snapshot.data.data.data);
              break;
            case Status.ERROR:
              return Error(
                errorMessage: snapshot.data.message,
                onRetryPressed: () => _bloc.fetchWishListData(),
              );
              break;
          }
        }
        return SizedBox.shrink();
      },
    ));

    return Scaffold(
      body: content,
    );
  }

  Widget rootWidget(WishListData data) {
    // update global wishlist counter
    var totalItems = 0;
    data?.items?.forEach((element) {
      totalItems += (element?.quantity ?? 0);
    });
    _globalService.updateWishListCount(totalItems);

    var btnAddAll = CustomButton(
        label: _globalService
            .getString(Const.WISHLIST_ADD_ALL_TO_CART)
            .toUpperCase(),
        // shape: ButtonShape.RoundedTop,
        onClick: () {
          // move all items from wishList to cart
          _bloc.moveToCart(data.items?.map((e) => e?.id)?.toList());
        });

    return Stack(
      children: [
        RefreshIndicator(
            onRefresh: () async {
              setState(() {
                getData();
              });
            },
          child: ListView.builder(
            itemCount: (data.items?.length ?? 0) + 1,
            itemBuilder: (context, index) {
              if (index < data.items?.length ?? 0) {
                return wishListItem(data.items[index]);
              } else {
                return SizedBox(height: 50);
              }
            },
          ),
        ),


        if (data.displayAddToCart && data.items?.isNotEmpty == true)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                      width: 96,
                      child: Row(
                        children: [
                          Checkbox(
                            checkColor: Colors.white,
                            shape: CircleBorder(),
                            value: listEquals(data.items.map((e) => e.id).toList(), _ids),
                            onChanged: (bool e) {
                              setState(() {
                                // print(data.items.map((e) => e.id).toList());
                                if (e)
                                  _ids = (data.items.map((e) => e.id).toList());
                                else
                                  _ids.clear();
                              });

                            },
                          ),
                          Text(
                              "All"
                          ),
                        ],
                      )
                  ),
                  Spacer(),
                  // Expanded(
                  //     flex: 2,
                  //     child: btnAddToCart
                  // ),

                  GestureDetector(
                      onTap: () {
                        setState(() async {
                          if (_ids.isEmpty)
                            return showSnackBar(context, "No item(s) selected.", true);
                          await _bloc.moveToCart(_ids);
                          _bloc.fetchWishListData();
                        });
                      },
                      child: Container(
                          alignment: Alignment.center,
                          height: 48,
                          width: 92,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              topLeft: Radius.circular(8),
                            ),
                            color: Colors.deepOrangeAccent,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_bag_outlined,
                                color: Colors.white,
                              ),
                              Text(
                                  'Add to Cart',
                                  style: TextStyle(
                                      fontSize: 8,
                                      color: Colors.white
                                  )
                              ),
                            ],
                          )
                      )
                  ),



                  SizedBox(
                      width: 132,
                      child: GestureDetector(
                        onTap: () {
                          if (_ids.isEmpty)
                            return showSnackBar(context, "No item(s) selected.", true);
                          else
                            _bloc.moveToCart(_ids, goToCart: true);

                          setState(() async {
                            await _bloc.fetchWishListData();
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 48,
                          color: Colors.deepOrangeAccent,
                          child: Text(
                              'Buy Now',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white
                              )
                          ),
                        ),
                      )
                  ),
                  // Expanded(
                  //     child: btnAddAll
                  // )
                ],
              ),
            )
          ),
        if(data.items?.isEmpty == true)
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _globalService.getString(Const.WISHLIST_NO_ITEM),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget wishListItem(WishListItem item) {

    var _content = InkWell(
      onTap: () => Navigator.of(context).pushNamed(
          ProductDetailsPage.routeName,
          arguments: ProductDetailsScreenArguments(
            id: item.productId, name: item.productName,
          )
      ),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Row(
          children: [
            SizedBox(
                width: 48,
                child: Row(
                  children: [
                    Checkbox(
                      checkColor: Colors.white,
                      shape: CircleBorder(),
                      value: _ids.contains(item.id),
                      onChanged: (bool e) {
                        setState(() {
                          if (e)
                            _ids.add(item.id);
                          else
                            _ids.remove(item.id);
                        });
                      },
                    ),
                  ],
                )
            ),
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: CpImage(
                url: item.picture.imageUrl,
                width: 80,
                fit: BoxFit.fitWidth,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(5, 0, 3, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 9,
                          child: Text(
                            item.productName,
                            style: Styles.productNameTextStyle(context),
                          ),
                        ),
                        //   Flexible(
                        //   flex: 1,
                        //   child: (editable /*&& item.allowItemEditing*/)
                        //       ? InkWell(
                        //           onTap: () => onClick({'action': 'remove'}),
                        //           child: Icon(Icons.close_outlined),
                        //         )
                        //       : SizedBox.shrink(),
                        // )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    // Text(
                    //   "${GlobalService().getString(Const.TOTAL)}: ${item.subTotal}\n" +
                    //       "${GlobalService().getString(Const.PRICE)}: ${item.unitPrice}",
                    //   style: Styles.productPriceTextStyle(context),
                    // ),
                    // if (item.sku?.isNotEmpty == true) sku,

                    // Text('${_globalService.getString(Const.PRICE)}: ${item.unitPrice ?? ''}'),
                    // Text('${_globalService.getString(Const.QUANTITY)}: ${item.quantity ?? ''}'),
                    // Text('${_globalService.getString(Const.TOTAL)}: ${item.subTotal ?? ''}'),
                    if (item.attributeInfo?.isNotEmpty == true)
                      HtmlWidget(
                        item.attributeInfo ?? '',
                      ),
                    // OutlinedButton(
                    //   onPressed: () {
                    //     _bloc.moveToCart([item.id]);
                    //   },
                    //   child: Text(_globalService
                    //       .getString(Const.PRODUCT_BTN_ADDTOCART),
                    //   ),
                    // ),


                    // if (item.attributeInfo?.isNotEmpty == true)
                    //   customAttributes,
                    // SizedBox(
                    //   height: 5,
                    // ),
                    Row(
                      children: [
                        // if (editable && (item.allowedQuantities ?? []).isEmpty)
                        //   quantityButton,
                        // if (editable && (item.allowedQuantities ?? []).isNotEmpty)
                        //   allowedQuantityDropdown,
                        Spacer(),
                        Text(
                          "${item.subTotal}",
                          style: Styles.productPriceTextStyle(context),
                        )
                      ],
                    ),
                    //
                    // if (warnings.isNotEmpty)
                    //   Padding(
                    //     padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    //     child: Text(
                    //       warnings,
                    //       style: TextStyle(color: Colors.red),
                    //     ),
                    //   ),
                  ],
                ),
              ),),
            // Flexible(
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Flexible(
            //             flex: 9,
            //             child: Text(
            //               item.productName ?? '',
            //               style: Styles.productNameTextStyle(context),
            //             ),
            //           ),
            //           Flexible(
            //             flex: 1,
            //             child: InkWell(
            //               onTap: () {
            //                 _bloc.removeItemFromWishlist(item.id);
            //               },
            //               child: Icon(Icons.close_outlined),
            //             ),
            //           ),
            //         ],
            //       ),
            //       Text('${_globalService.getString(Const.PRICE)}: ${item.unitPrice ?? ''}'),
            //       Text('${_globalService.getString(Const.QUANTITY)}: ${item.quantity ?? ''}'),
            //       Text('${_globalService.getString(Const.TOTAL)}: ${item.subTotal ?? ''}'),
            //       if (item.attributeInfo?.isNotEmpty == true)
            //         Html(
            //           data: item.attributeInfo ?? '',
            //           shrinkWrap: true,
            //           style: htmlNoPaddingStyle(fontSize: 15),
            //         ),
            //       OutlinedButton(
            //         onPressed: () {
            //           _bloc.moveToCart([item.id]);
            //         },
            //         child: Text(_globalService
            //             .getString(Const.PRODUCT_BTN_ADDTOCART),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );

    var slideWidget = Slidable(
      key: ValueKey(item.id),
      endActionPane: ActionPane(
        extentRatio: 0.20,
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (e) {
              _bloc.removeItemFromWishlist(item.id);
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: _content,
    );

    return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: slideWidget
    );
  }
}
