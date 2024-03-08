
flimport 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nopcart_flutter/ScopedModelWrapper.dart';
import 'package:nopcart_flutter/pages/account/config_screen.dart';
import 'package:nopcart_flutter/pages/account/login_webview.dart';
import 'package:nopcart_flutter/pages/account/subscription_screen.dart';
import 'package:nopcart_flutter/pages/FcmHandler.dart';
import 'package:nopcart_flutter/pages/account/new_products_screen.dart';
import 'package:nopcart_flutter/pages/account/returnRequest/ReturnRequestScreen.dart';
import 'package:nopcart_flutter/pages/account/address/add_edit_address_screen.dart';
import 'package:nopcart_flutter/pages/account/address/address_list_screen.dart';
import 'package:nopcart_flutter/pages/account/cart/shopping_cart_screen.dart';
import 'package:nopcart_flutter/pages/account/change_password_screen.dart';
import 'package:nopcart_flutter/pages/account/downloadableProduct/downloadable_product_screen.dart';
import 'package:nopcart_flutter/pages/account/forgot_password_screen.dart';
import 'package:nopcart_flutter/pages/account/login_screen.dart';
import 'package:nopcart_flutter/pages/account/order/order_history_screen.dart';
import 'package:nopcart_flutter/pages/account/returnRequest/return_request_history_screen.dart';
import 'package:nopcart_flutter/pages/account/review/customer_review_screen.dart';
import 'package:nopcart_flutter/pages/account/review/product_review_screen.dart';
import 'package:nopcart_flutter/pages/account/registration_sceen.dart';
import 'package:nopcart_flutter/pages/account/rewardPoint/reward_point_screen.dart';
import 'package:nopcart_flutter/pages/account/wishlist_screen.dart';
import 'package:nopcart_flutter/pages/checkout/checkout_screen.dart';
import 'package:nopcart_flutter/pages/checkout/checkout_webview.dart';
import 'package:nopcart_flutter/pages/home/all_manufacturers_screen.dart';
import 'package:nopcart_flutter/pages/home/home_screen.dart';
import 'package:nopcart_flutter/pages/more/barcode_scanner_screen.dart';
import 'package:nopcart_flutter/pages/more/contact_us_screen.dart';
import 'package:nopcart_flutter/pages/more/contact_vendor_screen.dart';
import 'package:nopcart_flutter/pages/more/settings_screen.dart';
import 'package:nopcart_flutter/pages/more/topic_screen.dart';
import 'package:nopcart_flutter/pages/more/vendor_list_screen.dart';
import 'package:nopcart_flutter/pages/product/product_details_screen.dart';
import 'package:nopcart_flutter/pages/product/zoomable_image_screen.dart';
import 'package:nopcart_flutter/pages/search/search_screen.dart';
import 'package:nopcart_flutter/pages/splash.dart';
import 'package:nopcart_flutter/pages/tabs-screen/error_screen.dart';
import 'package:nopcart_flutter/pages/tabs-screen/tabs_screen.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/styles.dart';
import 'package:scoped_model/scoped_model.dart';

import 'pages/account/order/order_details_screen.dart';
import 'pages/product-list/product_list_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(ScopeModelWrapper());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(builder: (context, child, model) {

      var category = Uri.base.queryParameters['category'];
      var product = Uri.base.queryParameters['product'];

      return MaterialApp(
        navigatorKey: GlobalService().navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Stork.ph',
        theme: Styles.lightTheme(model),
        // NOTE: Add dark theme
        // darkTheme: Styles.darkTheme(model),
        // themeMode: model.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
        themeMode: ThemeMode.light,
        builder: (context, child) {
          return Directionality(
            textDirection: model.appLandingData?.rtl == true ? TextDirection.rtl : TextDirection.ltr,
            child: SafeArea(top: false, left: false, right: false,
                child: child
            ),
          );
        },
        scrollBehavior: MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus, PointerDeviceKind.unknown},
        ),
        routes: {
          '/': (context) => Splash(),
          TabsScreen.routeName: (context) => FcmHandler(child: TabsScreen(productId: product ?? '', categoryId: category ?? '',)),
          HomeScreen.routeName: (context) => HomeScreen(categories: []),
          LoginScreen.routeName: (context) => LoginScreen(),
          ChangePasswordScreen.routeName: (context) => ChangePasswordScreen(),
          ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
          ShoppingCartScreen.routeName: (context) => ShoppingCartScreen(),
          // CheckoutScreen.routeName: (context) => CheckoutScreen(),
          CheckoutWebView.routeName: (context) => CheckoutWebView(),
          LoginWebView.routeName: (context) => LoginWebView(),
          SettingsScreen.routeName: (context) => SettingsScreen(),
          WishListScreen.routeName: (context) => WishListScreen(),
          AddressListScreen.routeName: (context) => AddressListScreen(),
          RewardPointScreen.routeName: (context) => RewardPointScreen(),
          ContactUsScreen.routeName: (context) => ContactUsScreen(),
          BarcodeScannerScreen.routeName: (context) => BarcodeScannerScreen(),
          CustomerReviewScreen.routeName: (context) => CustomerReviewScreen(),
          DownloadableProductScreen.routeName: (context) => DownloadableProductScreen(),
          VendorListScreen.routeName: (context) => VendorListScreen(),
          ReturnRequestHistoryScreen.routeName: (context) => ReturnRequestHistoryScreen(),
          NewProductsScreen.routeName: (context) => NewProductsScreen(),
          SubscriptionScreen.routeName: (context) => SubscriptionScreen(),
          ConfigScreen.routeName: (context) => ConfigScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == ProductDetailsPage.routeName) {
            final ProductDetailsScreenArguments args =
                settings.arguments as ProductDetailsScreenArguments;

            return MaterialPageRoute(
              builder: (context) {
                return ProductDetailsPage(
                  productName: args.name,
                  productId: args.id,
                  productDetails: args.productDetails,
                );
              },
            );
          }

          if (settings.name == CheckoutScreen.routeName) {
            final CheckoutScreenArguments args =
            settings.arguments as CheckoutScreenArguments;

            return MaterialPageRoute(
              builder: (context) {
                return CheckoutScreen(
                  useRewardPoints: args.useRewardPoints,
                );
              },
            );
          }

          else if (settings.name == ProductListScreen.routeName) {
            final ProductListScreenArguments args =
                settings.arguments as ProductListScreenArguments;

            return MaterialPageRoute(
              builder: (context) {
                return ProductListScreen(args.type, args.name, args.id);
              },
            );
          }

          else if (settings.name == ZoomableImageScreen.routeName) {
            final ZoomableImageScreenArguments args =
            settings.arguments as ZoomableImageScreenArguments;

            return MaterialPageRoute(
              builder: (context) {
                return ZoomableImageScreen(
                  pictureModel: args.pictureModel,
                  currentIndex: args.currentIndex,
                );
              },
            );
          }

          else if (settings.name == OrderHistoryScreen.routeName) {
            final OrderHistoryScreenArguments args =
            settings.arguments as OrderHistoryScreenArguments;

            return MaterialPageRoute(
              builder: (context) {
                return OrderHistoryScreen(
                  isPending: args.isPending,
                  toShip: args.toShip,
                  toDeliver: args.toDeliver,
                  toRate: args.toRate,
                );
              },
            );
          }

          else if (settings.name == ProductReviewScreen.routeName) {
            final ProductReviewScreenArguments args =
            settings.arguments as ProductReviewScreenArguments;

            return MaterialPageRoute(
              builder: (context) {
                return ProductReviewScreen(
                  productId: args.id,
                );
              },
            );
          }

          else if (settings.name == OrderDetailsScreen.routeName) {
            final OrderDetailsScreenArguments args =
            settings.arguments as OrderDetailsScreenArguments;

            return MaterialPageRoute(
              builder: (context) {
                return OrderDetailsScreen(
                  orderId: args.orderId,
                );
              },
            );
          }

          else if (settings.name == TopicScreen.routeName) {
            final TopicScreenArguments args =
            settings.arguments as TopicScreenArguments;

            return MaterialPageRoute(
              builder: (context) {
                return TopicScreen(
                  screenArgument: args,
                );
              },
            );
          }

          else if (settings.name == RegistrationScreen.routeName) {
            final RegistrationScreenArguments args =
            settings.arguments as RegistrationScreenArguments;

            return MaterialPageRoute(
              builder: (context) {
                return RegistrationScreen(
                  screenArgument: args,
                );
              },
            );
          }

          else if (settings.name == AddOrEditAddressScreen.routeName) {
            final AddOrEditAddressScreenArgs args =
            settings.arguments as AddOrEditAddressScreenArgs;

            return MaterialPageRoute(
              builder: (context) {
                return AddOrEditAddressScreen(
                  args: args,
                );
              },
            );
          }

          else if (settings.name == ReturnRequestScreen.routeName) {
            final ReturnRequestScreenArgs args =
            settings.arguments as ReturnRequestScreenArgs;

            return MaterialPageRoute(
              builder: (context) {
                return ReturnRequestScreen(
                  args: args,
                );
              },
            );
          }

          else if (settings.name == ContactVendorScreen.routeName) {
            final ContactVendorScreenArgs args =
            settings.arguments as ContactVendorScreenArgs;

            return MaterialPageRoute(
              builder: (context) {
                return ContactVendorScreen(
                  args: args,
                );
              },
            );
          }

          else if (settings.name == AllManufacturersScreen.routeName) {
            final AllManufacturersScreenArgs args =
            settings.arguments as AllManufacturersScreenArgs;

            return MaterialPageRoute(
              builder: (context) {
                return AllManufacturersScreen(
                  args: args,
                );
              },
            );
          }

          else if (settings.name == ErrorScreen.routeName) {
            final ErrorScreenArguments args =
            settings.arguments as ErrorScreenArguments;

            return MaterialPageRoute(
              builder: (context) {
                return ErrorScreen(
                  screenArgument: args,
                );
              },
            );
          }

          else if (settings.name == SearchScreen.routeName) {
            final SearchScreenArguments args =
            settings.arguments as SearchScreenArguments;

            return MaterialPageRoute(
              builder: (context) {
                return SearchScreen(args);
              },
            );
          }

          assert(false, 'Need to implement ${settings.name}');
          return null;
        },
      );
    });
  }
}
