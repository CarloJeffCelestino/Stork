import 'dart:io';

import 'package:badges/badges.dart' as customBadge;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nopcart_flutter/bloc/auth_bloc.dart';
import 'package:nopcart_flutter/bloc/order_bloc.dart';
import 'package:nopcart_flutter/bloc/reward_point_bloc.dart';
import 'package:nopcart_flutter/customWidget/home/reward_point_header.dart';
import 'package:nopcart_flutter/customWidget/loading_dialog.dart';
import 'package:nopcart_flutter/model/OrderHistoryResponse.dart';
import 'package:nopcart_flutter/model/RewardPointResponse.dart';
import 'package:nopcart_flutter/model/UserLoginResponse.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/pages/account/address/address_list_screen.dart';
import 'package:nopcart_flutter/pages/account/rewardPoint/item_reward_point.dart';
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
import 'package:nopcart_flutter/customWidget/error.dart';
import 'package:url_launcher/url_launcher.dart' as urlLaunch;
import '../../customWidget/loading.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  GlobalService _globalService = GlobalService();
  // AuthBloc _bloc;
  OrderBloc _blocOrder;
  RewardPointBloc _blocRewardPoint;
  ScrollController _rewardPointScrollController = new ScrollController();
  bool isLoggedIn;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() {
    // _bloc = AuthBloc();
    _blocOrder = OrderBloc();
    _blocRewardPoint = RewardPointBloc();

    _blocOrder.fetchOrderHistory();
    _blocRewardPoint.fetchRewardPointDetails();

    // _bloc.logoutResponseStream.listen((event) {
    //   if (event.status == Status.COMPLETED) {
    //     // clear session & goto home
    //     DialogBuilder(context).hideLoader();
    //     SessionData().clearUserSession().then((value) =>
    //         Navigator.of(context).pushNamedAndRemoveUntil('/', (r) => false));
    //   } else if (event.status == Status.ERROR) {
    //     DialogBuilder(context).hideLoader();
    //     showSnackBar(context, event.message, true);
    //   } else if (event.status == Status.LOADING) {
    //     DialogBuilder(context).showLoader();
    //   }
    // });
    _blocRewardPoint.loaderStream.listen((event) {
      if(event.status == Status.LOADING) {
        DialogBuilder(context).showLoader();
      } else if(event.status == Status.COMPLETED) {
        DialogBuilder(context).hideLoader();
      } else {
        DialogBuilder(context).hideLoader();
        if(event.message?.isNotEmpty == true)
          showSnackBar(context, event.message, true);
      }
    });

    _rewardPointScrollController.addListener(() {
      if (_rewardPointScrollController.position.pixels >= _rewardPointScrollController.position.maxScrollExtent && !_rewardPointScrollController.position.outOfRange) {
        _blocRewardPoint.fetchRewardPointDetails();
      }
    });


  }

  @override
  void dispose() {
    // _bloc.dispose();
    _blocOrder.dispose();
    _blocRewardPoint.dispose();
    super.dispose();
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

  Widget streamBody(AsyncSnapshot<ApiResponse<OrderHistoryResponse>> _orderHistory, AsyncSnapshot<ApiResponse<RewardPointData>> _rewardPoint) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(
              left: 28,
              right: 28,
              top: 32,
              bottom: 18,
          ),
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: GestureDetector(
            onTap: () => goto(OrderHistoryScreen.routeName, args: OrderHistoryScreenArguments()),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text('My Orders', style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                Spacer(),
                Text('View All Orders', style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12
                )),
                Icon(Icons.chevron_right_outlined, size: 12, color: Colors.grey,)
              ],
            ),
          ),
        ),

        Container(
            margin: EdgeInsets.only(bottom: 16),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              customBadge.Badge(
                                position: customBadge.BadgePosition.topEnd(top: 4, end: -15),
                                badgeContent: Text(
                                  _orderHistory?.data.data != null
                                  ? (_orderHistory?.data.data.data.orders.where((e) => ["Pending"].contains(e.paymentStatus)).length ?? 0).toString()
                                  : "",
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Theme.of(context).appBarTheme.titleTextStyle.color),
                                ),
                                badgeColor: Theme.of(context).primaryColor,
                                child: IconButton(
                                    onPressed: () => goto(OrderHistoryScreen.routeName, args: OrderHistoryScreenArguments(isPending: true)),
                                    icon: Icon(Icons.account_balance_wallet, color: Colors.blue,)),
                              ),

                              Text('Unpaid', style: TextStyle(fontSize: 12),)
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [

                              customBadge.Badge(
                                position: customBadge.BadgePosition.topEnd(top: 4, end: -15),
                                badgeContent: Text(
                                  _orderHistory?.data.data != null
                                  ? (_orderHistory?.data.data.data.orders.where((e) => ["NotYetShipped"].contains(e.shippingStatus)).length ?? 0).toString()
                                  : '',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Theme.of(context).appBarTheme.titleTextStyle.color),
                                ),
                                badgeColor: Theme.of(context).primaryColor,
                                child: IconButton(
                                    onPressed: () => goto(OrderHistoryScreen.routeName, args: OrderHistoryScreenArguments(toShip: true)),
                                    icon: Icon(Icons.shopping_bag, color: Colors.blue)
                                ),
                              ),

                              Text('To Ship', style: TextStyle(fontSize: 12),)
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              customBadge.Badge(
                                position: customBadge.BadgePosition.topEnd(top: 4, end: -15),
                                badgeContent: Text(
                                  _orderHistory?.data.data != null
                                  ? (_orderHistory?.data.data.data.orders.where((e) => ["PartiallyShipped", "Shipped"].contains(e.shippingStatus)).length ?? 0).toString()
                                  : '',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Theme.of(context).appBarTheme.titleTextStyle.color),
                                ),
                                badgeColor: Theme.of(context).primaryColor,
                                child: IconButton(
                                    onPressed: () => goto(OrderHistoryScreen.routeName, args: OrderHistoryScreenArguments(toDeliver: true)),
                                    icon: Icon(Icons.local_shipping, color: Colors.blue)
                                ),
                              ),
                              Text('To Deliver', style: TextStyle(fontSize: 12),)
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              customBadge.Badge(
                                position: customBadge.BadgePosition.topEnd(top: 4, end: -15),
                                badgeContent: Text(
                                  _orderHistory?.data.data != null
                                  ? (_orderHistory?.data.data.data.orders.where((e) => ["Delivered"].contains(e.shippingStatus)).length ?? 0).toString()
                                  : '',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Theme.of(context).appBarTheme.titleTextStyle.color),
                                ),
                                badgeColor: Theme.of(context).primaryColor,
                                child: IconButton(
                                    onPressed: () => goto(OrderHistoryScreen.routeName, args: OrderHistoryScreenArguments(toRate: true)),
                                    icon: Icon(Icons.star, color: Colors.blue)
                                ),
                              ),
                              Text('To Rate', style: TextStyle(fontSize: 12),)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
        ),

        RewardPointHeader(_rewardPoint?.data?.data?.rewardPointsBalance),

        Container(height: 15,),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Card(
              elevation: 0,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Services',),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    final Uri params = Uri(
                                        scheme: 'mailto',
                                        path: 'support@stork.ph',
                                        queryParameters: {
                                          'subject': '',
                                          'body': ''
                                        }
                                    );

                                    await urlLaunch.launchUrl(params);

                                  },
                                  icon: Icon(Icons.headset_mic_rounded, color: Colors.blue,)
                              ),
                              Text('Support', style: TextStyle(fontSize: 12),)
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    showSnackBar(context, "Soon!", false);
                                  },
                                  icon: Icon(Icons.note, color: Colors.blue)
                              ),
                              Text('Survey Center', textAlign: TextAlign.center, style: TextStyle(fontSize: 12),)
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    goto(OrderHistoryScreen.routeName, args: OrderHistoryScreenArguments());
                                  },
                                  icon: Icon(Icons.history_edu, color: Colors.blue)
                              ),
                              Text('Transaction History', textAlign: TextAlign.center, style: TextStyle(fontSize: 12),)
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              IconButton(icon: Icon(Icons.free_cancellation, color: Colors.blue)),
                              Text('Returns & Cancellations', textAlign: TextAlign.center, style: TextStyle(fontSize: 12),)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
          ),
        ),

        Container(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Card(
              elevation: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                        'Storkbucks Transactions',
                        style: TextStyle(
                          color: Colors.orange.shade700,
                        )
                    ),
                  ),
                  
                  if(_rewardPoint?.data?.data?.rewardPoints?.isEmpty == true)
                    Center(
                      child: Text(_globalService.getString(Const.REWARD_NO_HISTORY)),
                    ),

                  if(_rewardPoint?.data?.data?.rewardPoints?.isEmpty == false)
                    Container(
                      child: ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        controller: _rewardPointScrollController,
                        itemCount: _rewardPoint?.data?.data?.rewardPoints.length,
                        itemBuilder: (context, index) {
                          return ItemRewardPoint(item: _rewardPoint?.data?.data?.rewardPoints[index]);
                        },
                      ),
                    )
                ],
              ),
            ),
          )
        ),


      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var title = Text(_globalService.getString(Const.ACCOUNT_LOGOUT_CONFIRM));
    // var actions = [
    //   TextButton(
    //       onPressed: () {
    //         Navigator.pop(context);
    //       },
    //       child: Text(_globalService.getString(Const.COMMON_NO))),
    //   TextButton(
    //       onPressed: () {
    //         // logout api call
    //         Navigator.pop(context);
    //         _bloc.performLogout();
    //       },
    //       child: Text(_globalService.getString(Const.COMMON_YES))),
    // ];
    //
    // final confirmLogoutDialog = Platform.isIOS
    //     ? CupertinoAlertDialog(title: title, actions: actions)
    //     : AlertDialog(title: title, actions: actions);

    var streams = StreamBuilder<ApiResponse<OrderHistoryResponse>>(
      stream: _blocOrder.orderHistoryStream,
      builder: (context, snapshot) {
        if (snapshot.hasData)
              return StreamBuilder<ApiResponse<RewardPointData>>(
                stream: _blocRewardPoint.rewardPointStream,
                  builder: (context2, snapshot2) {
                    if (snapshot2.hasData)
                      return streamBody(snapshot, snapshot2);

                    return SizedBox.shrink();
                  }
              );
        return SizedBox.shrink();
      },
    );

    var iconColor = Theme.of(context).primaryColor;
    
    var content = RefreshIndicator(
        onRefresh: () async {
          setState(() {
            getData();
          });
        },
        child: SingleChildScrollView(
          child: streams,
        )
    );
    return Scaffold(
        body: _globalService.centerWidgets(content)
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
