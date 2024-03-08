import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nopcart_flutter/bloc/home_bloc.dart';
import 'package:nopcart_flutter/customWidget/home/horizontal_categories.dart';
import 'package:nopcart_flutter/customWidget/home/horizontal_manufacturer_slider.dart';
import 'package:nopcart_flutter/customWidget/home/horizontal_product_box_slider.dart';
import 'package:nopcart_flutter/customWidget/loading.dart';
import 'package:nopcart_flutter/model/HomeSliderResponse.dart';
import 'package:nopcart_flutter/model/category_tree/CategoryTreeResponse.dart';
import 'package:nopcart_flutter/model/home/BestSellerProductResponse.dart';
import 'package:nopcart_flutter/model/home/CategoriesWithProductsResponse.dart';
import 'package:nopcart_flutter/model/home/FeaturedProductResponse.dart';
import 'package:nopcart_flutter/model/home/ManufacturersResponse.dart';
import 'package:nopcart_flutter/model/home/NearbyProductsResponse.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/pages/more/topic_screen.dart';
import 'package:nopcart_flutter/pages/product-list/product_list_screen.dart';
import 'package:nopcart_flutter/pages/product/product_details_screen.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/Const.dart';
import 'package:nopcart_flutter/utils/GetBy.dart';
import 'package:nopcart_flutter/utils/SliderType.dart';
import 'package:popup_banner/popup_banner.dart';

import 'home_carousel.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  final List<CategoryTreeResponseData> categories;

  const HomeScreen({Key key, @required this.categories}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalService _globalService = GlobalService();
  HomeBloc _bloc;
  bool _popupShown = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() {
    _bloc = HomeBloc();
    if (_globalService.getAppLandingData().showHomepageSlider != null && _globalService.getAppLandingData().showHomepageSlider) {
      _bloc.fetchHomeBanners();
    }

    if (_globalService.getAppLandingData().showFeaturedProducts != null && _globalService.getAppLandingData().showFeaturedProducts) {
      _bloc.getFeaturedProducts();
    }

    if (_globalService.getAppLandingData().showBestsellersOnHomepage != null && _globalService.getAppLandingData().showBestsellersOnHomepage) {
      _bloc.fetchBestSellerProducts();
    }

    if (_globalService.getAppLandingData().showHomepageCategoryProducts != null && _globalService.getAppLandingData().showHomepageCategoryProducts) {
      _bloc.fetchCategoriesWithProducts();
    }

    if (_globalService.getAppLandingData().showManufacturers != null && _globalService.getAppLandingData().showManufacturers) {
      _bloc.fetchManufacturers();
    }

    _bloc.fetchNearbyProducts();

  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  onPopupImageClick(Sliders i) {
    Navigator.of(context).pop();

    Future.delayed(Duration.zero, () {
      switch(i.sliderType) {
        case SliderType.CATEGORY: {
          Navigator.of(context).pushNamed(
              ProductListScreen.routeName,
              arguments: ProductListScreenArguments(
                id: i.entityId,
                name: '',
                type: GetBy.CATEGORY,
              )
          );
        }
        break;
        case SliderType.MANUFACTURER: {
          Navigator.of(context).pushNamed(
              ProductListScreen.routeName,
              arguments: ProductListScreenArguments(
                id: i.entityId,
                name: '',
                type: GetBy.MANUFACTURER,
              )
          );
        }
        break;
        case SliderType.VENDOR: {
          Navigator.of(context).pushNamed(
              ProductListScreen.routeName,
              arguments: ProductListScreenArguments(
                id: i.entityId,
                name: '',
                type: GetBy.VENDOR,
              )
          );
        }
        break;
        case SliderType.PRODUCT: {
          Navigator.of(context).pushNamed(
              ProductDetailsPage.routeName,
              arguments: ProductDetailsScreenArguments(
                id: i.entityId,
                name: '',
              )
          );
        }
        break;
        case SliderType.TOPIC: {
          Navigator.of(context).pushNamed(
              TopicScreen.routeName,
              arguments: TopicScreenArguments(
                  topicId: i.entityId
              )
          );
        }
        break;
      }
    });


  }

  void showPopup(Sliders sliders) {
    _popupShown = true;

    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.75),
        pageBuilder: (BuildContext context, _, __) {
          return Material(
            type: MaterialType.transparency,
            color: Colors.transparent,
            child: SafeArea(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: CachedNetworkImage(
                      imageUrl: sliders.imageUrl,
                      fit: BoxFit.contain,
                      height: MediaQuery.of(context).size.height,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 12,
                    child: GestureDetector(
                      onTap: Navigator.of(context).pop,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.close, color: Colors.red),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            getData();
          });
        },
        child: SingleChildScrollView(
          child: _globalService.centerWidgets(
              Column(
                children: [
                  // Slider banner
                  StreamBuilder<ApiResponse<HomeSliderResponse>>(
                    stream: _bloc.sliderStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        switch (snapshot.data.status) {
                          case Status.LOADING:
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Loading(loadingMessage: snapshot.data.message),
                            );
                            break;
                          case Status.COMPLETED:
                            List<List<Sliders>> sliders = [];
                            var grouped = groupBy(snapshot.data.data.data.sliders, (e) {
                              var tmp = e as Sliders;
                              return '${(tmp.displayOrder / 5).ceil()}';
                            });

                            grouped.forEach((key, value) {
                              // print('[DEBUG]' + key);
                              key == '0' ? (
                                  !_popupShown ? Future.delayed(Duration.zero, () => showPopup(value.first)) : null
                              ) : sliders.add(value);
                            });

                            return Column(
                                children: sliders.map((e) => BannerSlider(
                                    HomeSliderData(
                                        isEnabled: snapshot.data.data.data.isEnabled,
                                        sliders: e
                                    ),
                                    slot: sliders.indexOf(e)
                                )).toList()
                            );
                            break;
                          case Status.ERROR:
                            return SizedBox.shrink();
                            break;
                        }
                      }
                      return SizedBox.shrink();
                    },
                  ),

                  SizedBox(height: 5),

                  StreamBuilder<ApiResponse<BestSellerProductResponse>>(
                      stream: _bloc.bestSellerProdStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data.status == Status.COMPLETED) {
                          if(snapshot.data.data?.data?.isNotEmpty == true) {
                            return HorizontalSlider(
                                '${_globalService.getString(Const.HOME_BESTSELLER)}',
                                false,
                                false,
                                [],
                                snapshot.data.data.data);
                          } else {
                            return SizedBox.shrink();
                          }
                        }
                        return SizedBox.shrink();
                      }),

                  // Featured products
                  StreamBuilder<ApiResponse<FeaturedProductResponse>>(
                      stream: _bloc.featuredProdStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data.status == Status.COMPLETED) {
                          if (snapshot.data.data?.data?.isNotEmpty == true) {
                            return HorizontalSlider(
                              '${_globalService.getString(Const.HOME_FEATURED_PRODUCT)}',
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

                  // Categories with products
                  StreamBuilder<ApiResponse<CategoriesWithProductsResponse>>(
                      stream: _bloc.categoriesWithProdStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData &&
                            snapshot.data.status == Status.COMPLETED)
                          return Column(
                            children: [
                              ...snapshot.data.data.data.map<Widget>((e) {
                                return HorizontalSlider(
                                  e.name,
                                  e.products.isEmpty ? false : true, true,
                                  e.subCategories,
                                  e.products,
                                  categoryId: e.id,
                                  image: e.fullSizeImageUrl,
                                  endDateTimeUtc: e.endDateTimeUtc,
                                  wideProduct: e.endDateTimeUtc != null ? true : false,);
                              }).toList(),
                            ],
                          );
                        return SizedBox.shrink();
                      }),

                  StreamBuilder<ApiResponse<NearbyProductsResponse>>(
                      stream: _bloc.nearbyProductsStream,
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

                  // Manufacturers slider
                  StreamBuilder<ApiResponse<ManufacturersResponse>>(
                      stream: _bloc.manufacturersStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data.status == Status.COMPLETED) {
                          if(snapshot.data.data?.data?.isNotEmpty == true) {
                            return HorizontalManufacturerSlider(
                                'Top Brands',
                                snapshot.data.data.data);
                          } else {
                            return SizedBox.shrink();
                          }
                        }
                        return SizedBox.shrink();
                      }),
                ],
              )
          ),
        ),
      )
    );
  }
}
