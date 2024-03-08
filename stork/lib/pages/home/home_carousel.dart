import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:nopcart_flutter/customWidget/cached_image.dart';
import 'package:nopcart_flutter/customWidget/dot_indicator.dart';
import 'package:nopcart_flutter/model/HomeSliderResponse.dart';
import 'package:nopcart_flutter/pages/more/topic_screen.dart';
import 'package:nopcart_flutter/pages/product-list/product_list_screen.dart';
import 'package:nopcart_flutter/pages/product/product_details_screen.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/GetBy.dart';
import 'package:nopcart_flutter/utils/SliderType.dart';

class BannerSlider extends StatefulWidget {
  final HomeSliderData sliderData;
  final int slot;

  const BannerSlider(this.sliderData, {Key key, this.slot}) : super(key: key);

  @override
  _BannerSliderState createState() => _BannerSliderState(this.sliderData, this.slot);
}

class _BannerSliderState extends State<BannerSlider> {
  final HomeSliderData sliderData;
  final GlobalService _globalService = GlobalService();
  int _carouselIndex = 0;
  int slot = 0;

  _BannerSliderState(this.sliderData, this.slot);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            aspectRatio: 2.2831, // TODO make aspectRatio dynamic
            viewportFraction: 1.0,
            enableInfiniteScroll: true,
            autoPlay: _globalService.getAppLandingData().sliderAutoPlay,
            autoPlayInterval: Duration(
              seconds:
                  _globalService.getAppLandingData().sliderAutoPlayTimeout != null
                      ? _globalService.getAppLandingData().sliderAutoPlayTimeout * (slot + 1)
                      : 3  * (slot + 1),
            ),
            onPageChanged: (index, reason) {
              setState(() {
                _carouselIndex = index;
              });
            },
          ),
          items: sliderData.sliders.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () => onSliderImageClick(i),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: CpImage(
                      url: i.imageUrl,
                      fit: BoxFit.fitHeight,
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
              dotsCount: sliderData?.sliders?.length ?? 0,
              selectedIndex: _carouselIndex,
            ),
          ),
        ),
      ],
    );
  }

  onSliderImageClick(Sliders i) {
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
  }
}
