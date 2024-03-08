import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nopcart_flutter/bloc/product_box_bloc.dart';
import 'package:nopcart_flutter/customWidget/cached_image.dart';
import 'package:nopcart_flutter/customWidget/loading_dialog.dart';
import 'package:nopcart_flutter/customWidget/triangle_clipper.dart';
import 'package:nopcart_flutter/model/ProductSummary.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/pages/product/product_details_screen.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/AppConstants.dart';
import 'package:nopcart_flutter/utils/Const.dart';
import 'package:nopcart_flutter/utils/utility.dart';

class HorizontalProductBox extends StatelessWidget {
  final ProductSummary productData;
  final bool location;
  final String _new = GlobalService().getString(Const.RIBBON_NEW);
  final bool wideProduct;

  HorizontalProductBox(this.productData, {this.location = false, this.wideProduct = false});

  void addToCartOrWishList(BuildContext context, bool isCart) async {

    DialogBuilder(context).showLoader();
    var response = await ProductBoxBloc().addToCart(productData.id, isCart);
    DialogBuilder(context).hideLoader();

    if(response.status == Status.COMPLETED) {
      GlobalService().updateCartCount(response.data?.data?.totalShoppingCartProducts ?? 0);
      GlobalService().updateWishListCount(response.data?.data?.totalWishListProducts ?? 0);

      if(response?.data?.data?.redirectToDetailsPage == true) {
        Navigator.of(context).pushNamed(
            ProductDetailsPage.routeName,
            arguments: ProductDetailsScreenArguments(
              id: productData.id, name: productData.name,
            )
        );
      } else {
        showSnackBar(
          context,
          isCart
              ? GlobalService().getString(Const.PRODUCT_ADDED_TO_CART)
              : GlobalService().getString(Const.PRODUCT_ADDED_TO_WISHLIST),
          false,
        );
      }
    } else if(response.status == Status.ERROR) {
      if(response.message.isNotEmpty)
        showSnackBar(context, response.message, true);
    }
  }

  @override
  Widget build(BuildContext context) {

    final _thumbnail = Container(
      height: wideProduct ? 85 : AppConstants.productBoxThumbnailSize,
      width: wideProduct ? 85 : double.maxFinite,
      color: Colors.grey[100],
      child: CpImage(
        url: productData.defaultPictureModel.imageUrl,
        // height: AppConstants.productBoxThumbnailSize,
      ),
    );

    final imageBox = ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
      child: productData.markAsNew == true
          ? Banner(
              message: _new,
              location: BannerLocation.topStart,
              color: Colors.green,
              child: _thumbnail,
            )
          : _thumbnail,
    );

    final btnWishlist = GestureDetector(
      onTap: () {
        addToCartOrWishList(context, false);
      },
      child: Container(
        width: 20,
        height: 20,
        child: Icon(
          Icons.favorite_border,
          color: Colors.blue,
          size: 26,
        ),
      ),
    );

    final btnCart = GestureDetector(
      onTap: () {
        addToCartOrWishList(context, true);
      },
      child: Container(
        width: 30,
        height: 30,
        child: Icon(
          Icons.shopping_bag_outlined,
          color: Colors.blue,
        ),
      ),
    );

    final productName = Text(
      '${productData.name}\n',
      style: Theme.of(context).textTheme.subtitle2.copyWith(
          color: Colors.blue,
          fontSize: 12,
          fontWeight: FontWeight.bold
      ),
      strutStyle: StrutStyle(
        forceStrutHeight: true,
        height: 1.2,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );

    final ratingBar = RatingBar.builder(
      ignoreGestures: true,
      itemSize: 12,
      initialRating:
      productData?.reviewOverviewModel?.ratingSum?.toDouble() ?? 0,
      direction: Axis.horizontal,
      itemCount: 5,
      itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (_) {},
    );


    if (wideProduct)
      return Container(
        width: 200,
        child: InkWell(
            borderRadius: BorderRadius.circular(15.0),
            onTap: () => Navigator.pushNamed(
              context,
              ProductDetailsPage.routeName,
              arguments: ProductDetailsScreenArguments(
                id: productData.id,
                name: productData.name,
              ),
            ),
            child: Row(
              children: [
                imageBox,
                Container(width: 4,),
                SizedBox(
                    width: 80,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${productData.name}',
                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                              color: Colors.blue,
                              fontSize: 10,
                              fontWeight: FontWeight.bold
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        Container(
                          height: 16,
                        ),

                        ...((){
                          List<Widget> widgets = [];

                          if (productData.customProperties.productMinMax != null
                              && productData.customProperties.productMinMax.minValue > 0
                              && productData.customProperties.productMinMax.maxValue > 0
                              && productData.customProperties.productMinMax.minValue != productData.customProperties.productMinMax.maxValue) {

                            widgets.add(
                              Text(
                                '${(productData.customProperties.productMinMax.min)} ~ ${(productData.customProperties.productMinMax.max)}',
                                style: Theme.of(context).textTheme.subtitle2.copyWith(
                                    color: Colors.orange.shade700,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              )
                            );
                          }
                          else {
                            if (productData.productPrice.price != null)
                              widgets.add(
                                Text(
                                  productData.productPrice.price ?? '',
                                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                                      color: Colors.orange.shade700,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                              );

                            if (productData.productPrice.oldPrice != null)
                              widgets.add(
                                Text(
                                  productData.productPrice.oldPrice ?? '',
                                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                                    color: Colors.grey,
                                    fontSize: 10,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                              );
                          }

                          return widgets;
                        }()),
                      ],
                    )
                )
              ],
            )
        ),
      );

    return Container(
      width: 150,
      height: 300,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 3,
        margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
        child: InkWell(
          borderRadius: BorderRadius.circular(15.0),
          onTap: () => Navigator.pushNamed(
            context,
            ProductDetailsPage.routeName,
            arguments: ProductDetailsScreenArguments(
              id: productData.id,
              name: productData.name,
            ),
          ),
          child: Stack(
            children: [

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                imageBox,
                  Padding(
                  padding: EdgeInsets.all(5),
                  child: productName,
                ),
                if (productData.customProperties.address != null && productData.customProperties.address.stateProvinceName != null)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.blue, size: 8,),
                        Text(productData.customProperties.address.stateProvinceName ?? '', style: TextStyle(fontSize: 8),)
                      ],
                    ),
                  ),

                if (productData.customProperties.productMinMax != null
                    && productData.customProperties.productMinMax.minRewardPoints > 0
                    && productData.customProperties.productMinMax.maxRewardPoints > 0
                    && productData.customProperties.productMinMax.minRewardPoints != productData.customProperties.productMinMax.maxRewardPoints)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Text(
                      'Earn ${(productData.customProperties.productMinMax.minRewardPoints)} ~ ${(productData.customProperties.productMinMax.maxRewardPoints)} Storkbucks',
                      style: TextStyle(fontSize: 10, color: Colors.orange.shade700),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                else if (productData.customProperties.rewardPoints != null && productData.customProperties.rewardPoints > 0)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Text('Earn ${productData.customProperties.rewardPoints} Storkbucks', style: TextStyle(fontSize: 10, color: Colors.orange.shade700),),
                  ),

                // ratingBar,

                ...((){
                  List<Widget> widgets = [];

                  // print(productData.customProperties.productMinMax);

                  if (productData.customProperties.productMinMax != null
                      && productData.customProperties.productMinMax.minValue > 0
                      && productData.customProperties.productMinMax.maxValue > 0
                      && productData.customProperties.productMinMax.minValue != productData.customProperties.productMinMax.maxValue) {
                    widgets.add(
                      Padding(
                        padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0),
                        child: Text(
                          '${(productData.customProperties.productMinMax.min)} ~ ${(productData.customProperties.productMinMax.max)}',
                          style: TextStyle(
                              color: Colors.orange.shade700,
                              fontSize: 12,
                              fontWeight: FontWeight.bold
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    );
                  }
                  else {
                    if (productData.productPrice.price != null)
                      widgets.add(
                        Padding(
                          padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0),
                          child: Text(
                            productData.productPrice.price ?? '',
                            style: TextStyle(
                                color: Colors.orange.shade700,
                                fontSize: 12,
                                fontWeight: FontWeight.bold
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );

                    if (productData.productPrice.oldPrice != null)
                      widgets.add(
                        Padding(
                          padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0),
                          child: Text(
                            productData.productPrice.oldPrice ?? '',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                              decoration: TextDecoration.lineThrough,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                  }

                  return widgets;
                }()),
              ],
            ),

              if (productData.productPrice.oldPrice != null)
                Positioned.directional(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Column(
                      children: [
                        Container(
                          height: 17,
                          width: 26,
                          color: Colors.red,
                          padding: EdgeInsets.only(top: 4),
                        ),
                        ClipPath(
                          clipper: TriangleClipper(),
                          child: Container(
                            color: Colors.red,
                            height: 8,
                            width: 26,
                          ),
                        )
                      ],
                    ),
                  ),
                ),

              if (productData.productPrice.oldPrice != null)
                Positioned.directional(
                    textDirection: TextDirection.rtl,
                    top: 2,
                    end: 12,
                    child: SizedBox(
                      width: 18,
                      child: Column(
                        children: [
                          Text(
                            '${(((productData.productPrice.oldPriceValue - productData.productPrice.priceValue)/productData.productPrice.oldPriceValue) * 100).ceil()}%',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 8,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            'OFF',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 8,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    )
                ),

            if(productData?.productPrice?.disableWishlistButton == false)
              Positioned(
                top: 6,
                right: 12,
                child: btnWishlist,
              ),
            if(productData?.productPrice?.disableBuyButton == false)
              Positioned(
                bottom: 10,
                right: 10,
                child: btnCart,
              )
            ],
          ),
        ),
      ),
    );
  }
}

