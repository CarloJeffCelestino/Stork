
import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';
import 'package:nopcart_flutter/bloc/home_bloc.dart';
import 'package:nopcart_flutter/bloc/product_details_bloc.dart';
import 'package:nopcart_flutter/customWidget/CustomAppBar.dart';
import 'package:nopcart_flutter/customWidget/CustomButton.dart';
import 'package:nopcart_flutter/customWidget/CustomDropdown.dart';
import 'package:nopcart_flutter/customWidget/RoundButton.dart';
import 'package:nopcart_flutter/customWidget/SpecificationAttributeItem.dart';
import 'package:nopcart_flutter/customWidget/cached_image.dart';
import 'package:nopcart_flutter/customWidget/dot_indicator.dart';
import 'package:nopcart_flutter/customWidget/error.dart';
import 'package:nopcart_flutter/customWidget/estimate_shipping.dart';
import 'package:nopcart_flutter/customWidget/home/horizontal_product_box_slider.dart';
import 'package:nopcart_flutter/customWidget/loading.dart';
import 'package:nopcart_flutter/customWidget/loading_dialog.dart';
import 'package:nopcart_flutter/model/AvailableOption.dart';
import 'package:nopcart_flutter/model/CustomProperties.dart';
import 'package:nopcart_flutter/model/ProductDetailsResponse.dart';
import 'package:nopcart_flutter/model/ProductSummary.dart';
import 'package:nopcart_flutter/model/home/NearbyProductsResponse.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/pages/account/cart/shopping_cart_screen.dart';
import 'package:nopcart_flutter/pages/account/review/product_review_screen.dart';
import 'package:nopcart_flutter/pages/app_bar_cart.dart';
import 'package:nopcart_flutter/pages/app_bar_wallet.dart';
import 'package:nopcart_flutter/pages/more/barcode_scanner_screen.dart';
import 'package:nopcart_flutter/pages/product-list/product_list_screen.dart';
import 'package:nopcart_flutter/pages/product/item_group_product.dart';
import 'package:nopcart_flutter/pages/product/zoomable_image_screen.dart';
import 'package:nopcart_flutter/pages/search/search_screen.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/AppConstants.dart';
import 'package:nopcart_flutter/utils/ButtonShape.dart';
import 'package:nopcart_flutter/utils/Const.dart';
import 'package:nopcart_flutter/utils/CustomAttributeManager.dart';
import 'package:nopcart_flutter/utils/GetBy.dart';
import 'package:nopcart_flutter/utils/ValidationMixin.dart';
import 'package:nopcart_flutter/utils/extensions.dart';
import 'package:nopcart_flutter/utils/shared_pref.dart';
import 'package:nopcart_flutter/utils/styles.dart';
import 'package:nopcart_flutter/utils/utility.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sprintf/sprintf.dart';
import 'package:nopcart_flutter/utils/render_html_interface.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductDetailsPage extends StatefulWidget {
  static const routeName = '/productDetails';
  final String productName;
  final num productId;
  final ProductDetails productDetails;

  ProductDetailsPage({Key key, this.productId, this.productName, this.productDetails})
      : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState(
      productId: productId,
      productName: productName,
      productDetails: this.productDetails,
  );
}

class _ProductDetailsPageState extends State<ProductDetailsPage> with ValidationMixin{
  GlobalService _globalService = GlobalService();
  ProductDetailsBloc _bloc;
  HomeBloc _blocHome;
  ProductDetailsScreenArguments args;
  CustomAttributeManager attributeManager;

  final _giftCardFormKey = GlobalKey<FormState>();
  final _rentalFormKey = GlobalKey<FormState>();

  final String productName;
  final num productId;
  final ProductDetails productDetails;
  ScrollController scrollController = ScrollController();

  GlobalKey productsNearMeKey = GlobalKey();
  GlobalKey detailsKey = GlobalKey();
  GlobalKey suggestedKey = GlobalKey();

  _ProductDetailsPageState({this.productId, this.productName, this.productDetails});

  var showContext;
  var hideContext;

  double _shortDescriptionHeight = 100;
  double _fullDescriptionHeight = 600;

  @override
  void initState() {
    super.initState();

    _bloc = ProductDetailsBloc();
    _blocHome = HomeBloc();

    if(this.productDetails == null) {
      _bloc.fetchProductDetails(productId);
    } else {
      _bloc.setAssociatedProduct(this.productDetails);
    }

    _bloc.fetchRelatedProducts(productId);
    _bloc.fetchCrossSellProducts(productId);

    _bloc.addToCartStream.listen((event) {
      if (event.status == Status.ERROR) {
        showSnackBar(context, event.message, true);
      } else if (event.status == Status.COMPLETED) {
        showSnackBar(context, event.data?.message ?? '', false);

        setState(() {
          _globalService.updateCartCount(event.data?.data?.totalShoppingCartProducts ?? 0);
          _globalService.updateWishListCount(event.data?.data?.totalWishListProducts ?? 0);
        });
      }
    });

    _bloc.loaderStream.listen((showLoader) {

      if (showLoader == true) {
        showContext = context;

        DialogBuilder(context).showLoader();
      } else {

        if(ModalRoute.of(context)?.isCurrent ?? false)
          log('I AM ON TOP');

        DialogBuilder(context).hideLoader();
      }
    });

    _bloc.redirectToCartStream.listen((redirect) {
      if (redirect)
        Navigator.of(context).pushNamed(ShoppingCartScreen.routeName);
    });

    _bloc.fileUploadStream.listen((event) {
      if (event.status == Status.COMPLETED) {
        DialogBuilder(context).hideLoader();

        attributeManager?.addUploadedFileGuid(
          event.data.attributedId, event.data.downloadGuid
        );

      } else if (event.status == Status.ERROR) {
        DialogBuilder(context).hideLoader();
        showSnackBar(context, event.message, true);
      } else if (event.status == Status.LOADING) {
        DialogBuilder(context).showLoader();
      }
    });

    _bloc.sampleDownloadStream.listen((event) {
      if (event.status == Status.COMPLETED) {
        DialogBuilder(context).hideLoader();

        if(event.data.file != null) {
          showSnackBar(context, _globalService.getString(Const.FILE_DOWNLOADED), false);
        } else if(event.data.jsonResponse.data.downloadUrl != null) {
          launchUrl(event.data.jsonResponse.data.downloadUrl);
        }

      } else if (event.status == Status.ERROR) {
        DialogBuilder(context).hideLoader();
        showSnackBar(context, event.message, true);
      } else if (event.status == Status.LOADING) {
        DialogBuilder(context).showLoader();
      }
    });

    _bloc.subStatusStream.listen((event) {
      if (event.status == Status.COMPLETED) {
        DialogBuilder(context).hideLoader();
        showSubscriptionPopup(event.data.alreadySubscribed, event.data.productId);
      } else if (event.status == Status.ERROR) {
        DialogBuilder(context).hideLoader();
        showSnackBar(context, event.message, true);
      } else if (event.status == Status.LOADING) {
        DialogBuilder(context).showLoader();
      }
    });

    _bloc.changeStatusStream.listen((event) {
      if (event.status == Status.COMPLETED) {
        DialogBuilder(context).hideLoader();
        showSnackBar(context, event.data, false);
      } else if (event.status == Status.ERROR) {
        DialogBuilder(context).hideLoader();
        showSnackBar(context, event.message, true);
      } else if (event.status == Status.LOADING) {
        DialogBuilder(context).showLoader();
      }
    });

    _blocHome.fetchNearbyProducts();

    attributeManager = CustomAttributeManager(
      context: context,
      onClick: (priceAdjNeeded) {
        setState(() {
          _bloc.postSelectedAttributes(
            productId,
            attributeManager.getSelectedAttributes(AppConstants.productAttributePrefix),
          );
        });
      },
      onFileSelected: (file, attributeId) {
        setState(() {
          _bloc.uploadFile(file.path, attributeId);
        });
      },
    );
  }

  void updateHeight(String key, double height) {
    setState((){
      if (key == 'fullDescription')
        _fullDescriptionHeight = height;
      else if (key == 'shortDescription')
        _shortDescriptionHeight = height;
    });
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // Future.delayed(Duration.zero, () {
    //   DialogBuilder(context).showLoader();
    //
    //   Future.delayed(Duration(milliseconds: 1000), () {
    //     DialogBuilder(context).hideLoader();
    //   });
    // });
    var content = StreamBuilder<ApiResponse<ProductDetails>>(
      stream: _bloc.prodDetailsStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return Loading(loadingMessage: snapshot.data.message);
              break;
            case Status.COMPLETED:
              return getProductDetailsWidget(snapshot.data.data);
              break;
            case Status.ERROR:
              return Error(
                errorMessage: snapshot.data.message,
                onRetryPressed: () => _bloc.fetchProductDetails(productId),
              );
              break;
          }
        }
        return SizedBox.shrink();
      },
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        title: StreamBuilder<String>(
          initialData: productName,
          stream: _bloc.titleStream,
          builder: (context, snapshot) {
            if(snapshot.hasData)
              return Text(
                  snapshot.data,
                  style: TextStyle(
                    color: Colors.white
                  ),
              );
            else
              return Text(
                  productName,
                  style: TextStyle(
                  color: Colors.white
              ),
              );
          },
        ),
        centerTitle: false,
        actions: [
          AppBarCart(color: Colors.white),
          AppBarWallet(color: Colors.white),
        ],
        bottom: AppBar(
          backgroundColor: Colors.blue,
          toolbarHeight: 48,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Column(
            children: [
              SizedBox(
                height: 38,
                child: TextField(
                  decoration: InputDecoration(
                      hintText: _globalService.getString(Const.TITLE_SEARCH),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            BarcodeScannerScreen.routeName,
                          );
                        },
                      )
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                    if (value.isNotEmpty && value.length > 2) {
                      Navigator.of(context).pushNamed(
                          SearchScreen.routeName,
                          arguments: SearchScreenArguments(
                              search: value
                          )
                      );
                    } else {
                      showSnackBar(
                          context,
                          _globalService.getStringWithNumber(Const.SEARCH_QUERY_LENGTH, 3),
                          false);
                    }
                  },
                ),
              ),
            ],
          ),

        ),
      ),

      body: content,
    );
  }

  Widget getProductDetailsWidget(ProductDetails data) {
    var divider = Divider(color: Colors.grey[600]);
    var titleStyle = Theme.of(context)
        .textTheme
        .bodyText2
        .copyWith(
        fontSize: 14,
        height: 2);

    var productCarousel = Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 300,
            aspectRatio: 1,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              setState(() {
                _bloc.carouselIndex = index;
              });
            },
          ),
          carouselController: _bloc.sliderCtrl,
          items: data.pictureModels.map((model) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(
                      context,
                      ZoomableImageScreen.routeName,
                      arguments: ZoomableImageScreenArguments(
                        pictureModel: data.pictureModels,
                        currentIndex: data.pictureModels.indexOf(model),
                      ),
                    ),
                    child: CpImage(
                      url: model.fullSizeImageUrl,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        Positioned.fill(
          bottom: 3,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: DotIndicator(
              dotsCount: data?.pictureModels?.length ?? 0,
              selectedIndex: _bloc.carouselIndex,
            ),
          ),
        ),

      ],
    );

    var productName = Text(
      data.name,
      style: Theme.of(context)
          .textTheme
          .bodyText2
          .copyWith(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 18
      ),
    );
    var renderHtml = RenderHtml();
    var shortDescription = !kIsWeb
    ? renderHtml.renderValue(
        key: 'shortDescription',
        html: data.shortDescription ?? '<div></div>',
    )
    : Stack(
      children: [
        Container(
          height: _shortDescriptionHeight,
          child: renderHtml.renderValue(
              key: 'shortDescription',
              html: '<div style="overflow:hidden">${data.shortDescription ?? ''}</div>',
              function: updateHeight
          ),
        ),
        PointerInterceptor(
          intercepting: false,
          child: Material(
            color: Colors.transparent,
            child: SizedBox(
              height: _shortDescriptionHeight,
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ),
      ],
    );

    print(data.fullDescription);
    var fullDescription = Padding(
      key: detailsKey,
      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          divider,
          Text(_globalService.getString(Const.PRODUCT_DESCRIPTION), style: titleStyle),
          SizedBox(height: 10),
          !kIsWeb
              ? renderHtml.renderValue(
            key: 'fullDescription',
            html: data.fullDescription ?? '<div></div>',
          )
          : Stack(
            children: [
              Container(
                height: _fullDescriptionHeight,
                child: renderHtml.renderValue(
                    key: 'fullDescription',
                    html: '<div style="overflow:hidden">${data.fullDescription ?? ''}</div>',
                    function: updateHeight
                ),
              ),
              PointerInterceptor(
                intercepting: false,
                child: Material(
                  color: Colors.transparent,
                  child: SizedBox(
                    height: _fullDescriptionHeight,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              ),
            ],
          ),
          divider,
        ],
      ),
    );

    // Product price section
    var manualPriceEntry = TextFormField(
      keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
      autofocus: false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return _globalService.getStringWithNumberStr(Const.IS_REQUIRED, '');
        }
        return null;
      },
      onChanged: (value) => data.addToCart.customerEnteredPrice = num.tryParse(value) ?? 0,
      initialValue: data.addToCart.customerEnteredPrice.toString() ?? '0',
      textInputAction: TextInputAction.done,
      decoration: inputDecor(data.addToCart.customerEnteredPriceRange ?? '', true),
    );

    var availability = Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if((data.stockAvailability ?? '').isNotEmpty)
              Row(
                children: [
                  Text(_globalService.getString(Const.PRODUCT_AVAILABILITY), style: titleStyle),
                  Text(': ', style: titleStyle),
                  Text(data.stockAvailability, style: titleStyle.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold
                  ),)
                ],
              ),
            if (data.isFreeShipping)
              SizedBox(height: 5),
            if (data.isFreeShipping)
              Row(
                children: [
                  Icon(Icons.local_shipping_sharp),
                  SizedBox(width: 10),
                  Text(_globalService.getString(Const.PRODUCT_FREE_SHIPPING)),
                ],
              ),
            if(data.deliveryDate != null && data.deliveryDate?.isNotEmpty == true)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Text('${_globalService.getString(Const.PRODUCT_DELIVERY_DATE)}', style: titleStyle),
                    Text(': ', style: titleStyle),
                    Text(data.deliveryDate),
                  ],
                ),
              ),
            // back in stock subscription button
            if(data.displayBackInStockSubscription == true)
              OutlinedButton(
                  onPressed: () {
                    SessionData().isLoggedIn().then((loggedIn) {
                      if(loggedIn) {
                        _bloc.getSubscriptionStatus(data.id);
                      } else {
                        showSnackBar(
                            context,
                            _globalService.getString(Const.BACK_IN_STOCK_ONLY_REGISTERED),
                            true
                        );
                      }
                    });
                  },
                  child: Text(_globalService.getString(Const.BACK_IN_STOCK_NOTIFY_ME_WHEN_AVAILABLE))
              ),
          ],
        ),
    );

    var allowedQuantityDropdown = CustomDropdown<AvailableOption>(
      onChanged: (value) {
        setState(() {
          _bloc.selectedQuantity = value;
        });
      },
      preSelectedItem: _bloc.selectedQuantity,
      items: data.addToCart?.allowedQuantities
          ?.map<DropdownMenuItem<AvailableOption>>((e) =>
          DropdownMenuItem<AvailableOption>(
              value: e, child: Text(e.text)))
          ?.toList() ??
          List.empty(),
    );
    var btnEstimateShipping = Row(
      children: [
        Text('Estimate:'),
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: OutlinedButton(
            onPressed: () {
              var formValues = attributeManager.getSelectedAttributes(AppConstants.productAttributePrefix); formValues.addAll(_bloc.getProductFormValues(data));
              showDialog(
                context: context,
                builder: (_) => EstimateShippingDialog(
                  data.productEstimateShipping, true, _bloc.selectedShippingMethod, formValues: formValues,
                ),
              ).then((selectedMethod) {
                if (selectedMethod != null && selectedMethod.toString().isNotEmpty) {
                  _bloc.selectedShippingMethod = selectedMethod;
                }
              });
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(null),
              side: MaterialStateProperty.all(BorderSide.none),
            ),
            child: SizedBox(
              height: 30,
              child: Center(
                child: Text(
                  'Shipping Fee',
                ),
              ),
            ),

          ),
        ),
      ],
    );

    var quantityBox = Row(
      children: [
        Flexible(
          flex: 6,
          child: Text(_globalService.getString(Const.PRODUCT_QUANTITY), style: titleStyle),
        ),
        SizedBox(width: 10),
        Flexible(
          flex: 12,
          child: SizedBox(
            height: 42,
            child: TextField(
              readOnly: true,
              keyboardType: TextInputType.number,
              autofocus: false,
              onChanged: (value) {
                setState(() {
                  data.addToCart.enteredQuantity = int.parse(value);
                });
              },
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.center,
              decoration: new InputDecoration(
                hintStyle: TextStyle(fontSize: 18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24), // border color Color(0xFFD4D3DA)
                ),
                contentPadding: EdgeInsets.zero,
                hintText: (data.addToCart.enteredQuantity ?? 1)
                    .toString(),
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        Flexible(
          flex: 3,
          child: RoundButton(
            onClick: () {
              setState(() {
                if (data.addToCart.enteredQuantity <= 1) {
                  showSnackBar(
                      context,
                      _globalService
                          .getString(Const.PRODUCT_QUANTITY_POSITIVE),
                      true);
                } else {
                  data.addToCart.enteredQuantity--;
                }
              });
            },
            radius: 45,
            icon: Icon(
              Icons.remove,
              size: 18.0,
            ),
          ),
        ),
        SizedBox(width: 5),
        Flexible(
          flex: 3,
          child: RoundButton(
            onClick: () {
              setState(() {
                data.addToCart.enteredQuantity++;
              });
            },
            radius: 45,
            icon: Icon(
              Icons.add,
              size: 18.0,
            ),
          ),
        ),
      ],
    );

    var ratingAndReview = InkWell(
      onTap: () {
        if(data?.productReviewOverview?.allowCustomerReviews == true) {
          Navigator.of(context).pushNamed(
            ProductReviewScreen.routeName,
            arguments: ProductReviewScreenArguments(id: data.id),
          );
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
            child: RatingBar.builder(
              ignoreGestures: true,
              itemSize: 15,
              initialRating: data.productReviewOverview.ratingSum.toDouble(),
              direction: Axis.horizontal,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 1),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (_) {},
            ),
          ),
          SizedBox(width: 10),
          Text('${data.productReviewOverview.totalReviews} ${_globalService.getString(Const.TITLE_REVIEW)}'),
        ],
      ),
    );

    var btnSampleDownload = data.hasSampleDownload
        ? OutlinedButton.icon(
            icon: Icon(Icons.download_sharp),
            label: Text(_globalService.getString(Const.PRODUCT_SAMPLE_DOWNLOAD)),
            onPressed: () async {
              var status = await Permission.storage.status;
              if (!status.isGranted) {
                await Permission.storage.request().then((value) => {
                      if (value.isGranted) {_bloc.downloadSample(productId)}
                    });
              } else {
                _bloc.downloadSample(productId);
              }
            },
          )
        : SizedBox.shrink();

    var productTags = Padding(
      padding: EdgeInsets.fromLTRB(0, 2, 0, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_globalService.getString(Const.PRODUCT_TAG), style: titleStyle),
          SizedBox(height: 10),
          SizedBox(
            height: 30,
            child: ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: data.productTags.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
                  child: InkWell(
                    onTap: () => Navigator.of(context).pushNamed(
                        ProductListScreen.routeName,
                        arguments: ProductListScreenArguments(
                            name: data.productTags[index].name,
                            id: data.productTags[index].id,
                            type: GetBy.TAG)),
                    child: Chip(
                      label: Text(data.productTags[index].name + ' (${data.productTags[index].productCount})'),
                      padding: EdgeInsets.fromLTRB(3, 0, 3, 3),
                      elevation: 1,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );


    var productManufacturers = Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(_globalService.getString(Const.PRODUCT_MANUFACTURER), style: titleStyle),
              Text(': ', style: titleStyle),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  children: data.productManufacturers.mapIndexed((i, e) => TextSpan(
                    children: [
                      if (i > 0)
                        TextSpan(
                          text: ', ',
                          style: titleStyle.copyWith(
                              color: Colors.black
                          ),
                        ),
                      TextSpan(
                          text: e.name,
                          style: titleStyle.copyWith(
                            color: Theme.of(context).primaryColor
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.of(context).pushNamed(
                                ProductListScreen.routeName,
                                arguments: ProductListScreenArguments(
                                    name: e.name,
                                    id: e.id,
                                    type: GetBy.MANUFACTURER))
                      )
                    ],
                  )).toList()
                ),
              )
            ],
          ),

          // SizedBox(
          //   height: 30,
          //   child: ListView.builder(
          //     physics: ClampingScrollPhysics(),
          //     shrinkWrap: true,
          //     scrollDirection: Axis.horizontal,
          //     itemCount: data.productManufacturers.length,
          //     itemBuilder: (BuildContext context, int index) {
          //       return Padding(
          //         padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
          //         child: InkWell(
          //           onTap: () => Navigator.of(context).pushNamed(
          //             ProductListScreen.routeName,
          //             arguments: ProductListScreenArguments(
          //                 name: data.productManufacturers[index].name,
          //                 id: data.productManufacturers[index].id,
          //                 type: GetBy.MANUFACTURER)),
          //           child: Chip(
          //             label: Text(data.productManufacturers[index].name),
          //             padding: EdgeInsets.fromLTRB(3, 0, 3, 3),
          //             elevation: 1,
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );

    var productVendorW = Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(_globalService.getString(Const.PRODUCT_VENDOR), style: titleStyle),
              Text(': ', style: titleStyle),
              RichText(
                text: TextSpan(
                    text: data.vendorModel.name,
                    style: titleStyle.copyWith(
                        color: Theme.of(context).primaryColor
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Navigator.of(context).pushNamed(
                          ProductListScreen.routeName,
                          arguments: ProductListScreenArguments(
                              name: data.vendorModel.name,
                              id: data.vendorModel.id,
                              type: GetBy.VENDOR))
                ),
              )
            ],
          ),

        ],
      ),
    );

    // Padding(
    //   padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Text(_globalService.getString(Const.PRODUCT_VENDOR), style: titleStyle),
    //       SizedBox(height: 10),
    //       Padding(
    //         padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
    //         child: InkWell(
    //           onTap: () => Navigator.of(context).pushNamed(
    //               ProductListScreen.routeName,
    //               arguments: ProductListScreenArguments(
    //                   name: data.vendorModel.name,
    //                   id: data.vendorModel.id,
    //                   type: GetBy.VENDOR)),
    //           child: Chip(
    //             label: Text(data.vendorModel.name ?? ""),
    //             padding: EdgeInsets.fromLTRB(3, 0, 3, 3),
    //             elevation: 1,
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );



    openVariations({int type}) {
      showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                topLeft: Radius.circular(12),
              )
          ),
          isScrollControlled: true,
          builder: (BuildContext bc) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter _setState) {
                var quantityButton = Container(
                  child: Row(
                    children: [
                      // RoundButton(radius: 35, icon: icon, onClick: onClick)
                      SizedBox(
                        width: 16,
                        child: IconButton(
                          padding: new EdgeInsets.all(0.0),
                          onPressed: () {
                            setState(() {
                              _setState(() {
                                data.addToCart.enteredQuantity--;
                              });
                            });
                          },
                          icon: Icon(
                            Icons.remove,
                            size: 16,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('${data.addToCart.enteredQuantity}', style: TextStyle(fontSize: 16)),
                      ),
                      SizedBox(
                        width: 16,
                        child: IconButton(
                          padding: new EdgeInsets.all(0.0),
                          onPressed: () {
                            setState(() {
                              _setState(() {
                                data.addToCart.enteredQuantity++;
                              });
                            });
                          },
                          icon: Icon(
                            Icons.add,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                );

                var productCard = Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(4),
                    child: Row(
                      children: [
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: CpImage(
                              url: data.pictureModels.first.imageUrl,
                              width: 80,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(5, 0, 3, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(height: 22),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 9,
                                      child: Text(
                                        data.name,
                                        style: Styles.productNameTextStyle(context),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 9,
                                      child: getProductPrice(data.productPrice, 20, data.customProperties.productMinMax),
                                    ),
                                  ],
                                ),
                                Row(
                                    children: [
                                      if(data.addToCart.allowedQuantities?.isNotEmpty == false && data.productType != 10
                                          && (data.displayBackInStockSubscription ?? false) == false)
                                        quantityButton,
                                      if(data.addToCart.allowedQuantities?.isNotEmpty == true)
                                        ...[
                                          Text(
                                            _globalService.getString(Const.PRODUCT_QUANTITY),
                                            style: titleStyle,
                                          ),
                                          allowedQuantityDropdown,
                                          Spacer(),
                                        ],
                                    ]
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );

                return Wrap(
                  children: [
                    Column(
                      children: [
                        Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(vertical: 12),
                            child: productCard
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32),
                            child: SizedBox(
                              height: 250,
                              child: SingleChildScrollView(
                                child: attributeManager.populateCustomAttributes(data.productAttributes, disabledAttributeIds: _bloc.disabledAttributeIds),
                              ),
                            )
                        ),
                        GestureDetector(
                          onTap: () {
                            if (type == null)
                              Navigator.of(context).pop();
                            else
                              _addToCartClick(data, cartType: 1, redirectToCart: type == 1 ? true : false);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 48,
                            color: Colors.deepOrangeAccent,
                            child: Text(
                                'Done',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white
                                )
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                );
              }
            );
          });
    }

    var btnHome = GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        color: Colors.blue,
        height: 48,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
                Icons.home_outlined,
                color: Colors.white
            ),
            Text(
                'Home',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10
                )
            )
          ],
        ),
      ),
    );

    var btnAddToCart = GestureDetector(
      onTap: () {
        if (data.productAttributes.isNotEmpty)
          openVariations(type: 2);
        else
          _addToCartClick(data, cartType: 1, redirectToCart: false);
      },
      child: Container(
        color: Colors.blue,
        height: 48,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.white
            ),
            Text(
                data.addToCart?.availableForPreOrder == true
                    ? _globalService.getString(Const.CART_PRE_ORDER)
                    : _globalService.getString(Const.PRODUCT_BTN_ADDTOCART),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10
                )
            )
          ],
        ),
      ),
    );

     var btnBuyNow = GestureDetector(
      onTap: () {
        setState((){
          if (data.productAttributes.isNotEmpty)
            openVariations(type: 1);
          else
          _addToCartClick(data, cartType: 1, redirectToCart: true);
        });

      },
      child: Container(
        alignment: Alignment.center,
        height: 48,
        color: Colors.deepOrangeAccent,
        child: Text(
            data.addToCart?.isRental == true
                ? _globalService.getString(Const.PRODUCT_BTN_RENT_NOW)
                : _globalService.getString(Const.PRODUCT_BTN_BUY_NOW),
            style: TextStyle(
                fontSize: 18,
                color: Colors.white
            )
        ),
      ),
    );





    var productSku = Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(_globalService.getString(Const.SKU), style: titleStyle),
          SizedBox(width: 10),
          Text(data.sku ?? ''),
        ],
      ),
    );

    var productManufacturerPartNumber = Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${_globalService.getString(Const.PRODUCT_MANUFACTURER_PART_NUM)}', style: titleStyle),
          SizedBox(height: 10),
          Text(data.manufacturerPartNumber ?? ''),
        ],
      ),
    );

    var productGtin = Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${_globalService.getString(Const.SKU)}', style: titleStyle),
          SizedBox(height: 10),
          Text(data.gtin ?? ''),
        ],
      ),
    );

    var giftCartSection = Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_globalService.getString(Const.GIFT_CARD), style: titleStyle),
          SizedBox(height: 10),
          Form(
            key: _giftCardFormKey,
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.name,
                  autofocus: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return _globalService.getString(Const.PRODUCT_GIFT_CARD_SENDER);
                    }
                    return null;
                  },
                  onChanged: (value) => data.giftCard.senderName = value,
                  initialValue: data.giftCard.senderName,
                  textInputAction: TextInputAction.next,
                  decoration: inputDecor(Const.PRODUCT_GIFT_CARD_SENDER, true),
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  autofocus: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return _globalService.getString(Const.PRODUCT_GIFT_CARD_SENDER_EMAIL);
                    }
                    return null;
                  },
                  onChanged: (value) => data.giftCard.senderEmail = value,
                  initialValue: data.giftCard.senderEmail,
                  textInputAction: TextInputAction.next,
                  decoration: inputDecor(Const.PRODUCT_GIFT_CARD_SENDER_EMAIL, true),
                ),
                TextFormField(
                  keyboardType: TextInputType.name,
                  autofocus: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return _globalService.getString(Const.PRODUCT_GIFT_CARD_RECIPIENT);
                    }
                    return null;
                  },
                  onChanged: (value) => data.giftCard.recipientName = value,
                  initialValue: data.giftCard.recipientName,
                  textInputAction: TextInputAction.next,
                  decoration: inputDecor(Const.PRODUCT_GIFT_CARD_RECIPIENT, true),
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  autofocus: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return _globalService.getString(Const.PRODUCT_GIFT_CARD_RECIPIENT_EMAIL);
                    }
                    return null;
                  },
                  onChanged: (value) => data.giftCard.recipientEmail = value,
                  initialValue: data.giftCard.recipientEmail,
                  textInputAction: TextInputAction.next,
                  decoration: inputDecor(Const.PRODUCT_GIFT_CARD_RECIPIENT_EMAIL, true),
                ),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  minLines: 1,
                  autofocus: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return _globalService.getString(Const.PRODUCT_GIFT_CARD_MESSAGE);
                    }
                    return null;
                  },
                  onChanged: (value) => data.giftCard.message = value,
                  initialValue: data.giftCard.message,
                  textInputAction: TextInputAction.newline,
                  decoration: inputDecor(Const.PRODUCT_GIFT_CARD_MESSAGE, true),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    // Rental start & end date
    // TODO form validation for rental product
    var rentalSection = Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_globalService.getString(Const.PRODUCT_RENT),
              style: titleStyle),
          Form(
            key: _rentalFormKey,
            child: Column(
              children: [
                TextFormField(
                  key: UniqueKey(),
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  readOnly: true,
                  initialValue: _bloc.rentalStartDate != null
                      ? DateFormat('MM/dd/yyyy').format(_bloc.rentalStartDate)
                      : '',
                  validator: (value) {
                    if (data?.isRental == true && (value == null || value.isEmpty)) {
                      return _globalService.getStringWithNumberStr(Const.IS_REQUIRED, '');
                    }
                    return null;
                  },
                  onTap: () => _selectDate(true),
                  textInputAction: TextInputAction.next,
                  decoration: inputDecor(Const.PRODUCT_RENTAL_START, true),
                ),
                TextFormField(
                  key: UniqueKey(),
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  readOnly: true,
                  initialValue: _bloc.rentalEndDate != null
                      ? DateFormat('MM/dd/yyyy').format(_bloc.rentalEndDate)
                      : '',
                  validator: (value) {
                    if (data?.isRental == true && (value == null || value.isEmpty)) {
                      return _globalService.getStringWithNumberStr(Const.IS_REQUIRED, '');
                    }
                    return null;
                  },
                  onTap: () => _selectDate(false),
                  textInputAction: TextInputAction.done,
                  decoration: inputDecor(Const.PRODUCT_RENTAL_END, true),
                )
              ],
            )
          ),
          SizedBox(height: 10),
        ],
      ),
    );

    // Estimate shipping
    // var btnEstimateShipping = OutlinedButton(
    //   onPressed: () {
    //
    //     var formValues = attributeManager.getSelectedAttributes(AppConstants.productAttributePrefix);
    //     formValues.addAll(_bloc.getProductFormValues(data));
    //
    //     showDialog(
    //       context: context,
    //       builder: (_) => EstimateShippingDialog(
    //         data.productEstimateShipping, true, _bloc.selectedShippingMethod, formValues: formValues,
    //       ),
    //     ).then((selectedMethod) {
    //       if (selectedMethod != null && selectedMethod.toString().isNotEmpty) {
    //         _bloc.selectedShippingMethod = selectedMethod;
    //       }
    //     });
    //   },
    //   child: Text(_globalService.getString(Const.CART_ESTIMATE_SHIPPING_BTN)),
    // );


    var contentBody = SingleChildScrollView(
      controller: scrollController,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: 32,),
          productCarousel,
          Padding(
            padding: EdgeInsets.only(left: 40, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: productName,
                    ),
                    Spacer(),
                    if(!data.addToCart.disableWishlistButton)
                      IconButton(
                        onPressed: () => _addToCartClick(data, cartType: AppConstants.typeWishList, redirectToCart: false),
                        icon: Icon(
                          Icons.favorite_border,
                          color: Theme.of(context).primaryColor,
                          size: 26,
                        ),
                      ),
                    Container(
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () async {
                                if (kIsWeb) {
                                  await Clipboard.setData(ClipboardData(text: _globalService.getString(Const.WEB_VERSION) + '?product=${data.id}'));
                                  Fluttertoast.showToast(
                                      msg: 'Link copied!',
                                      webShowClose: true,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      webPosition: 'center',
                                      webBgColor: 'linear-gradient(to right, ${'#${Colors.blue.value.toRadixString(16).substring(2, Colors.blue.value.toRadixString(16).length)}'}, ${'#${Colors.blue.value.toRadixString(16).substring(2, Colors.blue.value.toRadixString(16).length)}'})',
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                }
                                else
                                  Share.share(
                                    sprintf(_globalService.getString(Const.SHARE_PRODUCT_PAGE), [_globalService.getString(Const.WEB_VERSION) + '?product=${data.id}']),
                                    subject: data.name,
                                  );
                              },
                              icon: Icon(
                                Icons.share,
                                color: Theme.of(context).primaryColor,
                                size: 26,
                              ),
                            )
                          ],
                        )
                      // child: Row(
                      //   children: [
                      //     IconButton(
                      //       onPressed: () {
                      //         Share.share(
                      //           _globalService.getString(Const.WEB_VERSION) + '?product=${data.id}',
                      //           subject: data.name,
                      //         );
                      //       },
                      //       icon: Icon(
                      //         Icons.share,
                      //         color: Theme.of(context).primaryColor,
                      //         size: 26,
                      //       ),
                      //     )
                      //   ],
                      // ),

                    )
                  ],
                ),
                SizedBox(height: 10),

                if (!data.productPrice.hidePrices && !data.addToCart.customerEntersPrice
                    && data.productType != 10) // if not group product
                  getProductPrice(data.productPrice, 20, data.customProperties.productMinMax),
                if(data.addToCart.customerEntersPrice)
                  manualPriceEntry,
                if(data.tierPrices?.isNotEmpty == true)
                  getTierPriceTable(data.tierPrices),

                SizedBox(height: 12),

                if (data.customProperties.productMinMax != null
                    && data.customProperties.productMinMax.minRewardPoints > 0
                    && data.customProperties.productMinMax.maxRewardPoints > 0
                    && data.customProperties.productMinMax.minRewardPoints != data.customProperties.productMinMax.maxRewardPoints)
                  Text.rich(
                    TextSpan(
                        children: [
                          TextSpan(
                            text: 'Earn ${(data.customProperties.productMinMax.minRewardPoints)} ~ ${(data.customProperties.productMinMax.maxRewardPoints)} Storkbucks',
                            style: TextStyle(fontSize: 14, color: Colors.orange.shade700),
                          ),
                        ]
                    ),
                  )
                else if (data.customProperties.rewardPoints != null && data.customProperties.rewardPoints > 0)
                  Text('Earn ${data.customProperties.rewardPoints} Storkbucks', style: TextStyle(fontSize: 14, color: Colors.orange.shade700),),
                availability,
                // ratingAndReview,
                if (data.productManufacturers.isNotEmpty)
                  productManufacturers,

                if (data.customProperties.address != null && data.customProperties.address.stateProvinceName != null)
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("Location", style: titleStyle),
                            Text(': ', style: titleStyle),
                            Icon(Icons.location_on, color: Colors.blue, size: 16),
                            Text(data.customProperties.address.stateProvinceName ?? '', style: titleStyle.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),)
                          ],
                        ),
                      ],
                    ),
                  ),

                if (data.vendorModel != null && data.showVendor)
                  productVendorW,
                if(data.productEstimateShipping?.enabled == true)
                btnEstimateShipping,
                btnSampleDownload,
                if(data.addToCart.allowedQuantities?.isNotEmpty == false && data.productType != 10
                    && (data.displayBackInStockSubscription ?? false) == false)
                  quantityBox,
                if(data.addToCart.allowedQuantities?.isNotEmpty == true)
                  ...[
                    Text(
                      _globalService.getString(Const.PRODUCT_QUANTITY),
                      style: titleStyle,
                    ),
                    allowedQuantityDropdown,
                  ],
                // if(data.showSku&& data.sku?.isNotEmpty == true)
                //   productSku,
                // if(data.showManufacturerPartNumber)
                //   productManufacturerPartNumber,
                // if(data.showGtin)
                //   productGtin,
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 40, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data.productAttributes.isNotEmpty)
                  GestureDetector(
                    onTap: () => openVariations(),
                    child: Container(
                      height: 52,
                      margin: EdgeInsets.symmetric(vertical: 12),
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 26),
                            child: Row(
                              children: const [
                                Text(
                                  'Variations',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                Spacer(),
                                Icon(Icons.arrow_right),
                              ],
                            ),
                          )
                      ),
                    ),
                  ),

                // if(data.productSpecificationModel?.groups?.safeFirst()?.attributes?.isNotEmpty == true)
                //   populateSpecificationAttributes(data.productSpecificationModel?.groups),

                SizedBox(height: 10),

                if(data.productSpecificationModel?.groups?.safeFirstWhere((element) => element.name == 'Stork.ph')?.attributes?.safeFirstWhere((element) => element.values.safeFirst()?.valueRaw == 'Installment') != null)
                  Container(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Installment Estimates:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            '₱${(data.productPrice.priceValue / 3).toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} / month for 3 months',
                          ),
                          Text(
                            '₱${(data.productPrice.priceValue / 6).toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} / month for 6 months',
                          ),
                          Text(
                            '₱${(data.productPrice.priceValue / 12).toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} / month for 12 months',
                          ),
                        ],
                      )
                  ),

                SizedBox(height: 10),
                shortDescription,
                if(data.fullDescription?.isNotEmpty == true)
                  fullDescription,
                if(data.productType == 10 && data.associatedProducts?.isNotEmpty == true)
                  ...[
                    Text(
                      _globalService.getString(Const.PRODUCT_GROUPED_PRODUCT),
                      style: titleStyle,
                    ),
                    SizedBox(height: 5),
                    populateAssociatedProducts(data.associatedProducts),
                  ],
                if (data.productTags.isNotEmpty)
                  productTags,

                if(data.giftCard?.isGiftCard == true)
                  giftCartSection,
                if(data.isRental == true)
                  rentalSection,
                SizedBox(height: 32),
              ],
            ),
          ),
          StreamBuilder<ApiResponse<List<ProductSummary>>>(
            key: suggestedKey,
            stream: _bloc.relatedProductStream,
            builder: (context, snapshot) {
              if (snapshot.hasData
                  && snapshot.data.status == Status.COMPLETED
                  && snapshot.data.data?.isNotEmpty == true
              ) {
                return HorizontalSlider(
                    'Suggested Products', false, false, [], snapshot.data.data
                );
              }
              return SizedBox.shrink();
            },
          ),

          StreamBuilder<ApiResponse<NearbyProductsResponse>>(
              key: productsNearMeKey,
              stream: _blocHome.nearbyProductsStream,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data.status == Status.COMPLETED) {
                  if (snapshot.data.data?.data?.isNotEmpty == true) {
                    return HorizontalSlider(
                      'Products Near Me',
                      false,
                      false,
                      [],
                      snapshot.data.data.data,);
                  } else {
                    return SizedBox.shrink();
                  }
                }
                return SizedBox.shrink();
              }),



          // StreamBuilder<ApiResponse<List<ProductSummary>>>(
          //   stream: _bloc.crossSellStream,
          //   builder: (context, snapshot) {
          //     if (snapshot.hasData
          //         && snapshot.data.status == Status.COMPLETED
          //         && snapshot.data.data?.isNotEmpty == true
          //     ) {
          //       return HorizontalSlider(
          //           _globalService.getString(Const.PRODUCT_ALSO_PURCHASED), false, false, [], snapshot.data.data
          //       );
          //     }
          //     return SizedBox.shrink();
          //   },
          // ),
          if (!data.addToCart.disableBuyButton && data.productType != 10)
            SizedBox(height: 60), // margin for button
        ],
      ),
    );
    return Stack(
      children: [
        _globalService.centerWidgets(contentBody),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            color: Colors.grey.shade200,
            padding: EdgeInsets.only(left: 40, right: 24),
            height: 32,
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                      onPressed: () {
                        scrollController.animateTo(
                            (productsNearMeKey.currentContext.findRenderObject() as RenderBox).localToGlobal(Offset.zero).dy,
                            duration: Duration(seconds: 1),
                            curve: Curves.easeIn
                        );
                      },
                      child: Text(
                        'Products Near Me',
                        style: TextStyle(
                            color: Colors.orange.shade700,
                            fontWeight: FontWeight.normal,
                            fontSize: 12
                        ),
                      )
                  ),
                ),
                Expanded(
                  child: TextButton(
                      onPressed: () {
                        scrollController.animateTo(
                            (detailsKey.currentContext.findRenderObject() as RenderBox).localToGlobal(Offset.zero).dy,
                            duration: Duration(seconds: 1),
                            curve: Curves.easeIn
                        );
                      },
                      child: Text(
                        'Details',
                        style: TextStyle(
                            color: Colors.orange.shade700,
                            fontWeight: FontWeight.normal,
                            fontSize: 12
                        ),
                      )
                  ),
                ),
                Expanded(
                  child: TextButton(
                      onPressed: () {
                        scrollController.animateTo(
                            (suggestedKey.currentContext.findRenderObject() as RenderBox).localToGlobal(Offset.zero).dy,
                            duration: Duration(seconds: 1),
                            curve: Curves.easeIn
                        );
                      },
                      child: Text(
                        'Suggested Products',
                        style: TextStyle(
                            color: Colors.orange.shade700,
                            fontWeight: FontWeight.normal,
                            fontSize: 12
                        ),
                      )
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!data.addToCart.disableBuyButton && data.productType != 10)
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(children: [
              Expanded(
                  flex: 2,
                  child: btnHome
              ),
              Expanded(
                  flex: 2,
                  child: btnAddToCart
              ),
              if(data.addToCart?.availableForPreOrder == false)
                Expanded(
                  flex: 8,
                  child: btnBuyNow
                ),
            ],),
          )
      ],
    );
  }

  Future<void> _selectDate(bool isRentalStart) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: isRentalStart ? DateTime.now() : (_bloc.rentalStartDate ?? DateTime.now()),
      firstDate: isRentalStart ? DateTime.now() : (_bloc.rentalStartDate ?? DateTime.now()),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );

    if (pickedDate != null) {
      setState(() {
        if (isRentalStart)
          _bloc.rentalStartDate = pickedDate;
        else
          _bloc.rentalEndDate = pickedDate;
      });
    }
  }

  void _addToCartClick(ProductDetails data, {@required num cartType, @required bool redirectToCart}) {
    removeFocusFromInputField(context);

    String errMsg = attributeManager.checkRequiredAttributes(data.productAttributes);
    if(errMsg.isNotEmpty) {
      showSnackBar(context, errMsg, true);
    } else {
      if (data.giftCard?.isGiftCard == true && _giftCardFormKey.currentState.validate()) {
        _giftCardFormKey.currentState.save();
        _bloc.addToCart(data.id, cartType, data, attributeManager.getSelectedAttributes(AppConstants.productAttributePrefix));
      } if (data?.isRental == true && _rentalFormKey.currentState.validate()) {
        _rentalFormKey.currentState.save();
        _bloc.addToCart(data.id, cartType, data,
            attributeManager.getSelectedAttributes(AppConstants.productAttributePrefix));
      } else {
        if (data.giftCard?.isGiftCard == false)
          _bloc.addToCart(data.id, cartType, data, attributeManager.getSelectedAttributes(AppConstants.productAttributePrefix));
      }
      _bloc.redirectToCart = redirectToCart;
    }
  }

  getProductPrice(ProductPrice productPrice, double fontSize, ProductMinMax productMinMax) {
    var priceText = '';
    if(productPrice.callForPrice)
      priceText = _globalService.getString(Const.PRODUCT_CALL_FOR_PRICE);
    else if(productPrice.isRental)
      priceText = productPrice?.rentalPrice ?? '';
    else
      priceText = productPrice?.priceWithDiscount ?? productPrice?.price ?? '';

    var oldPriceText = '';

    if(productPrice?.priceWithDiscount != null && productPrice?.price != null)
      oldPriceText = productPrice?.price ?? '';
    else if(productPrice?.priceWithDiscount == null && productPrice?.oldPrice != null)
      oldPriceText = productPrice?.oldPrice ?? '';

    if (productMinMax != null
        && productMinMax.minValue > 0
        && productMinMax.maxValue > 0
        && productMinMax.minValue != productMinMax.maxValue)
      return Text.rich(
        TextSpan(
            children: [
              TextSpan(
                text: '${(productMinMax.min)} ~ ${(productMinMax.max)}',
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                    color: Colors.orange.shade700,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ]
        ),
      );

    return Text.rich(
      TextSpan(
          children: [
            TextSpan(
              text: priceText,
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                  color: Colors.orange.shade700,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            TextSpan(text: '\n'),
            TextSpan(
              text: oldPriceText,
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                  color: Colors.grey,
                  fontSize: 14,
                  decoration: TextDecoration.lineThrough
              ),
            ),
          ]
      ),
    );
  }

  getTierPriceTable(List<TierPrice> tierPrices) {
    if(tierPrices.isEmpty)
      return SizedBox.shrink();

    var titleStyle = Theme.of(context).textTheme.subtitle1.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        );

    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Table(
        border: TableBorder.all(color: Colors.black),
        children: [
          TableRow(
            children: [
              Padding(
                  padding: EdgeInsets.all(3),
                  child: Text(_globalService.getString(Const.PRODUCT_TIER_PRICE_QUANTITY),
                      style: titleStyle)),
              for (var i = 0; i < tierPrices.length; i++)
                Padding(
                    padding: EdgeInsets.all(3),
                    child: Text('${tierPrices[i].quantity}+')),
            ],
          ),
          TableRow(
            children: [
              Padding(
                  padding: EdgeInsets.all(3),
                  child: Text(_globalService.getString(Const.PRODUCT_TIER_PRICE_PRICE),
                      style: titleStyle)),
              for (var i = 0; i < tierPrices.length; i++)
                Padding(
                    padding: EdgeInsets.all(3),
                    child: Text('${tierPrices[i].price}')),
            ],
          ),
        ],
      ),
    );
  }

  populateSpecificationAttributes(List<Group> groups) =>
    ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: [
        for(int i=0; i<groups.length; i++)
          for(int j=0; j < groups[i].attributes?.length ?? 0; j++)
            SpecificationAttributeItem(attribute: groups[i].attributes[j])
      ],
    );

  populateAssociatedProducts(List<ProductDetails> associatedProducts) {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: associatedProducts.length,
      itemBuilder: (context, index) {
        var data = associatedProducts[index];
        return ItemGroupProduct(
          item: data,
          price: !data.productPrice.hidePrices && !data.addToCart.customerEntersPrice
              ? getProductPrice(data.productPrice, 17, data.customProperties.productMinMax)
              : SizedBox.shrink(),
          onClick: (cartType) {
            _addToCartClick(data, cartType: cartType, redirectToCart: false);
          },
        );
      },
    );
  }

  void showSubscriptionPopup(bool isSubscribed, num productId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            _globalService.getString(isSubscribed
                ? Const.BACK_IN_STOCK_POPUP_TITLE_ALREADY_SUBSCRIBED
                : Const.BACK_IN_STOCK_POPUP_TITLE),
            style: Theme.of(context).textTheme.bodyText2,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _bloc.changeSubscriptionStatus(productId);
              },
              child: Text(_globalService.getString(isSubscribed
                  ? Const.BACK_IN_STOCK_UNSUBSCRIBED
                  : Const.BACK_IN_STOCK_NOTIFY_ME)),
            ),
          ],
        );
      },
    );
  }
}

class ProductDetailsScreenArguments {
  String name;
  num id;
  ProductDetails productDetails;

  ProductDetailsScreenArguments({
    @required this.id,
    @required this.name,
    this.productDetails,
  });
}
