import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nopcart_flutter/bloc/auth_bloc.dart';
import 'package:nopcart_flutter/customWidget/loading_dialog.dart';
import 'package:nopcart_flutter/model/UserLoginResponse.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/pages/account/address/address_list_screen.dart';
import 'package:nopcart_flutter/pages/account/subscription_screen.dart';
import 'package:nopcart_flutter/pages/account/cart/shopping_cart_screen.dart';
import 'package:nopcart_flutter/pages/account/downloadableProduct/downloadable_product_screen.dart';
import 'package:nopcart_flutter/pages/account/login_screen.dart';
import 'package:nopcart_flutter/pages/account/new_products_screen.dart';
import 'package:nopcart_flutter/pages/account/order/order_history_screen.dart';
import 'package:nopcart_flutter/pages/account/registration_sceen.dart';
import 'package:nopcart_flutter/pages/account/returnRequest/return_request_history_screen.dart';
import 'package:nopcart_flutter/pages/account/review/customer_review_screen.dart';
import 'package:nopcart_flutter/pages/account/rewardPoint/reward_point_screen.dart';
import 'package:nopcart_flutter/pages/account/wishlist_screen.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/Const.dart';
import 'package:nopcart_flutter/utils/nop_cart_icons.dart';
import 'package:nopcart_flutter/utils/shared_pref.dart';
import 'package:nopcart_flutter/utils/utility.dart';

class ConfigScreen extends StatefulWidget {
  static const routeName = 'setting';
  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  GlobalService _globalService = GlobalService();
  AuthBloc _bloc;
  bool isLoggedIn;

  @override
  void initState() {
    _bloc = AuthBloc();
    super.initState();

    _bloc.logoutResponseStream.listen((event) {
      if (event.status == Status.COMPLETED) {
        // clear session & goto home
        DialogBuilder(context).hideLoader();
        SessionData().clearUserSession().then((value) =>
            Navigator.of(context).pushNamedAndRemoveUntil('/', (r) => false));
      } else if (event.status == Status.ERROR) {
        DialogBuilder(context).hideLoader();
        showSnackBar(context, event.message, true);
      } else if (event.status == Status.LOADING) {
        DialogBuilder(context).showLoader();
      }
    });
  }

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var title = Text(_globalService.getString(Const.ACCOUNT_LOGOUT_CONFIRM));
    var actions = [
      TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(_globalService.getString(Const.COMMON_NO))),
      TextButton(
          onPressed: () {
            // logout api call
            Navigator.pop(context);
            _bloc.performLogout();
          },
          child: Text(_globalService.getString(Const.COMMON_YES))),
    ];

    final confirmLogoutDialog = defaultTargetPlatform == TargetPlatform.iOS
        ? CupertinoAlertDialog(title: title, actions: actions)
        : AlertDialog(title: title, actions: actions);

    var iconColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Account'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: Column(
            children: [
              FutureBuilder<CustomerInfo>(
                future: SessionData().getCustomerInfo(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    String fullName =
                    '${snapshot.data.firstName ?? ''} ${snapshot.data.lastName ?? ''}'
                        .trim();
                    String email = snapshot.data.email ?? '';

                    if (fullName.isEmpty && email.isEmpty)
                      return SizedBox.shrink();

                    return Column(
                      children: [
                        // if (fullName.isNotEmpty)
                        //   Padding(
                        //     padding: EdgeInsets.fromLTRB(0, 15, 0, 5),
                        //     child: Text(fullName,
                        //         style: Theme.of(context)
                        //             .textTheme
                        //             .bodyText2
                        //             .copyWith(
                        //             fontSize: 22,
                        //             fontWeight: FontWeight.bold,
                        //             letterSpacing: 1.2)),
                        //   ),
                        // if (email.isNotEmpty)
                        //   Padding(
                        //     padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        //     child: Text(email,
                        //         style: Theme.of(context)
                        //             .textTheme
                        //             .bodyText2
                        //             .copyWith(
                        //           fontSize: 16,
                        //           fontWeight: FontWeight.bold,
                        //         )),
                        //   ),
                        // Divider()
                      ],
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
              getItem(
                _globalService.getString(Const.ACCOUNT_INFO),
                NopCart.ic_account,
                    () => goto(RegistrationScreen.routeName,
                    loginRequired: true,
                    args: RegistrationScreenArguments(getCustomerInfo: true)),
              ),
              getItem(
                _globalService.getString(Const.ACCOUNT_CUSTOMER_ADDRESS),
                Icons.location_city_outlined,
                    () => goto(AddressListScreen.routeName),
              ),
              StreamBuilder<int>(
                initialData: _globalService.getWishListCount,
                stream: _globalService.wishlistCountStream,
                builder: (context, snapshot) {
                  return getItem(
                    _globalService.getString(Const.ACCOUNT_WISHLIST),
                    Icons.favorite_border_outlined,
                        () => goto(WishListScreen.routeName, loginRequired: false),
                    trailing: (snapshot?.data ?? 0) > 0
                        ? CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      maxRadius: 10,
                      child: Text(
                        _globalService.getWishListCount.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    )
                        : null,
                  );
                },
              ),
              getItem(
                _globalService.getString(Const.ACCOUNT_ORDERS),
                Icons.account_balance_wallet_outlined,
                    () => goto(OrderHistoryScreen.routeName, args: OrderHistoryScreenArguments()),
              ),
              if(_globalService.getAppLandingData().hasReturnRequests)
                getItem(
                  _globalService.getString(Const.ACCOUNT_RETURN_REQUESTS),
                  Icons.keyboard_return_rounded,
                      () => goto(ReturnRequestHistoryScreen.routeName),
                ),
              if(!_globalService.getAppLandingData().hideDownloadableProducts)
                getItem(
                  _globalService.getString(Const.ACCOUNT_DOWNLOADABLE_PRODUCTS),
                  Icons.download_outlined,
                      () => goto(DownloadableProductScreen.routeName),
                ),
              StreamBuilder<int>(
                initialData: _globalService.getCartCount,
                stream: _globalService.cartCountStream,
                builder: (context, snapshot) {
                  return getItem(
                      _globalService.getString(Const.SHOPPING_CART_TITLE),
                      NopCart.ic_cart,
                          () => goto(ShoppingCartScreen.routeName,
                          loginRequired: false),
                      trailing: (snapshot?.data ?? 0) > 0
                          ? CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        maxRadius: 10,
                        child: Text(
                          snapshot.data.toString(),
                          style:
                          TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      )
                          : null);
                },
              ),
              if (_globalService.getAppLandingData().rewardPointsEnabled == null ||
                  _globalService.getAppLandingData().rewardPointsEnabled == true)
                getItem(
                  _globalService.getString(Const.ACCOUNT_REWARD_POINT),
                  Icons.new_releases_outlined,
                      () => goto(RewardPointScreen.routeName),
                ),
              if (_globalService.getAppLandingData().showProductReviewsTabOnAccountPage == null ||
                  _globalService.getAppLandingData().showProductReviewsTabOnAccountPage == true)
                getItem(
                  _globalService.getString(Const.ACCOUNT_MY_REVIEW),
                  Icons.text_rotation_none_outlined,
                      () => goto(CustomerReviewScreen.routeName),
                ),
              if(!_globalService.getAppLandingData().hideBackInStockSubscriptionsTab)
                getItem(
                  _globalService
                      .getString(Const.ACCOUNT_BACK_IN_STOCK_SUBSCRIPTION),
                  Icons.subscriptions_outlined,
                      () => goto(SubscriptionScreen.routeName),
                ),
              if(_globalService.getAppLandingData().newProductsEnabled)
                getItem(
                  _globalService.getString(Const.ACCOUNT_NEW_PRODUCTS),
                  Icons.fiber_new_outlined,
                      () => goto(NewProductsScreen.routeName, loginRequired: false),
                ),
              FutureBuilder(
                future: SessionData().isLoggedIn(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    isLoggedIn = snapshot.data;

                    return Card(
                      child: InkWell(
                        child: ListTile(
                          leading: isLoggedIn
                              ? Icon(Icons.logout, color: iconColor)
                              : Icon(Icons.login, color: iconColor),
                          title: isLoggedIn
                              ? Text(
                              _globalService.getString(Const.ACCOUNT_LOGOUT))
                              : Text(
                              _globalService.getString(Const.ACCOUNT_LOGIN)),
                        ),
                        onTap: () {
                          if (isLoggedIn) {
                            // Confirm logout dialog
                            showDialog(
                                context: context,
                                builder: (_) => confirmLogoutDialog);
                          } else {
                            goto(LoginScreen.routeName, loginRequired: false);
                          }
                        },
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getItem(String title, IconData icon, onClick, {Widget trailing}) {
    var iconColor = Theme.of(context).primaryColor;

    return Card(
      child: InkWell(
        child: ListTile(
          leading: Icon(icon, color: iconColor),
          title: Text(title),
          trailing: trailing ?? SizedBox.shrink(),
        ),
        onTap: () => onClick(),
      ),
    );
  }

  goto(String routeName, {bool loginRequired = true, dynamic args}) {
    if(loginRequired && !_globalService.isLoggedIn()) {
      Navigator.pushNamed(context, LoginScreen.routeName);
    } else {
      Navigator.pushNamed(context, routeName, arguments: args).then((value) {
        if(routeName == RegistrationScreen.routeName) {
          setState(() {
            // to refresh name & email section
          });
        }
      });
    }
  }
}
