import 'package:flutter/material.dart';
import 'package:nopcart_flutter/bloc/cart_bloc.dart';
import 'package:nopcart_flutter/bloc/reward_point_bloc.dart';
import 'package:nopcart_flutter/customWidget/error.dart';
import 'package:nopcart_flutter/customWidget/estimate_shipping.dart';
import 'package:nopcart_flutter/customWidget/loading.dart';
import 'package:nopcart_flutter/customWidget/loading_dialog.dart';
import 'package:nopcart_flutter/model/RewardPointResponse.dart';
import 'package:nopcart_flutter/model/ShoppingCartResponse.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/pages/account/cart/CartListItem.dart';
import 'package:nopcart_flutter/pages/account/login_screen.dart';
import 'package:nopcart_flutter/pages/account/registration_sceen.dart';
import 'package:nopcart_flutter/pages/checkout/checkout_screen.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/Const.dart';
import 'package:nopcart_flutter/utils/CustomAttributeManager.dart';
import 'package:nopcart_flutter/utils/utility.dart';

class ShoppingCartScreen extends StatefulWidget {
  static const routeName = '/cart';

  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  GlobalService _globalService = GlobalService();
  CartBloc _bloc;
  CustomAttributeManager attributeManager;
  RewardPointBloc _blocRewardPoint;

  bool _useRewardPoints = false;

  @override
  void initState() {
    super.initState();
    _bloc = CartBloc();
    _blocRewardPoint = RewardPointBloc();

    _blocRewardPoint.fetchRewardPointDetails();
    _bloc.fetchCartData();

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

    _bloc.loaderStream.listen((showLoader) {
      if (showLoader == true) {
        DialogBuilder(context).showLoader();
      } else {
        DialogBuilder(context).hideLoader();
      }
    });

    _bloc.launchCheckoutStream.listen((goToCheckout) {
      if (goToCheckout) {
        if(_globalService.isLoggedIn()) {
          Navigator.of(context).pushNamed(CheckoutScreen.routeName,
              arguments: CheckoutScreenArguments(
                  useRewardPoints: _useRewardPoints));
        } else {
          showCheckoutDialog();
        }
      }
    });

    _bloc.errorMsgStream.listen((message) {
      showSnackBar(context, message, false);
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

    attributeManager = CustomAttributeManager(
      context: context,
      onClick: (priceAdjNeeded) {
        // updating UI to show selected attribute values
        setState(() {
          if (priceAdjNeeded) {
            var checkoutAttrs =
            attributeManager.getSelectedAttributes('checkout_attribute');
            _bloc.postCheckoutAttributes(checkoutAttrs, false);
          }
        });
      },
      onFileSelected: (file, attributeId) {
        _bloc.uploadFile(file.path, attributeId);
      },
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    _blocRewardPoint.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          _globalService.getString(Const.SHOPPING_CART_TITLE),
        ),
      ),
      body: StreamBuilder<ApiResponse<ShoppingCartResponse>>(
        stream: _bloc.cartStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Loading(loadingMessage: snapshot.data.message);
                break;
              case Status.COMPLETED:
                return getCartDetailsWidget(snapshot.data.data);
                break;
              case Status.ERROR:
                _globalService.updateCartCount(0);
                return Error(
                  errorMessage: snapshot.data.message,
                  onRetryPressed: () => _bloc.fetchCartData(),
                );
                break;
            }
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget getCartDetailsWidget(ShoppingCartResponse data) {


    CartData cartData = data.data;

    // print('<> items in cart ${cartData.cart.items.length}');
    // update global cart counter
    var totalItems = 0;
    cartData?.cart?.items?.forEach((element) {
      totalItems += (element?.quantity ?? 0);
    });
    _globalService.updateCartCount(totalItems);

    if (cartData.cart.items.isEmpty)
      return Container(
        child: Center(
          child: Text(_globalService.getString(Const.CART_EMPTY)),
        ),
      );


    var cartItems = ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: cartData.cart.items.length,
      itemBuilder: (context, index) {

        return CartListItem(
          item: cartData.cart.items[index],
          onClick: (map) {
            final cartItem = cartData.cart.items[index];
            switch (map['action']) {
              case 'plus':
                _bloc.updateItemQuantity(cartItem, cartItem.quantity + 1);
                break;

              case 'minus':
                _bloc.updateItemQuantity(cartItem, cartItem.quantity -1);
                break;

              case 'setQuantity':
                _bloc.updateItemQuantity(cartItem, num.tryParse(map['quantity']) ?? 1);
                break;

              case 'remove':
                _bloc.removeItemFromCart(cartData.cart.items[index].id);
                break;
            }
          },
          editable: true,
        );
      },
    );

    var giftCardBox = Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              keyboardType: TextInputType.text,
              autofocus: false,
              onChanged: (value) => _bloc.enteredGiftCardCode = value,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  hintText: _globalService.getString(Const.ENTER_GIFT_CARD),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: TextButton(
                    onPressed: () {
                      removeFocusFromInputField(context);

                      if(_bloc.enteredCouponCode.isNotEmpty)
                        _bloc.applyDiscountCoupon(_bloc.enteredCouponCode);
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(18.0),
                                bottomRight: Radius.circular(18.0),
                              ),
                            )
                        )
                    ),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                          _globalService.getString(Const.ADD_GIFT_CARD).toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          )),
                    ),
                  )
              ),
            ),
          ),

          if (data.data?.orderTotals?.giftCards?.isNotEmpty == true)
            SizedBox(height: 10),
          if (data.data?.orderTotals?.giftCards?.isNotEmpty == true)
            SizedBox(
              height: 30,
              child: ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: data.data?.orderTotals?.giftCards?.length,
                itemBuilder: (context, index) {
                  var item = data.data?.orderTotals?.giftCards[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3),
                    child: Chip(
                      label: Text(_globalService.getStringWithNumber(Const.ENTERED_COUPON_CODE, int.tryParse(item.couponCode))),
                      deleteIcon: Icon(Icons.cancel_rounded),
                      deleteIconColor: Colors.red,
                      onDeleted: () {
                        _bloc.removeGiftCard(item);
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );

    var couponCodeBox = Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              keyboardType: TextInputType.text,
              autofocus: false,
              onChanged: (value) => _bloc.enteredCouponCode = value,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  hintText: _globalService.getString(Const.ENTER_YOUR_COUPON),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: TextButton(
                    onPressed: () {
                      removeFocusFromInputField(context);

                      if(_bloc.enteredCouponCode.isNotEmpty)
                        _bloc.applyDiscountCoupon(_bloc.enteredCouponCode);
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(18.0),
                                bottomRight: Radius.circular(18.0),
                              ),
                            )
                        )
                    ),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                          _globalService
                              .getString(Const.APPLY_COUPON)
                              .toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          )),
                    ),
                  )
              ),
            ),
          ),

          if (data.data?.cart?.discountBox?.appliedDiscountsWithCodes?.isNotEmpty == true)
            SizedBox(height: 10),
          if (data.data?.cart?.discountBox?.appliedDiscountsWithCodes?.isNotEmpty == true)
            SizedBox(
              height: 30,
              child: ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: data
                    .data?.cart?.discountBox?.appliedDiscountsWithCodes?.length,
                itemBuilder: (context, index) {
                  var item = data
                      .data?.cart?.discountBox?.appliedDiscountsWithCodes[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3),
                    child: Chip(
                      label: Text(item.couponCode),
                      deleteIcon: Icon(Icons.cancel_rounded),
                      deleteIconColor: Colors.red,
                      onDeleted: () {
                        _bloc.removeDiscountCoupon(item);
                      },
                    ),
                  );
                },
              ),
            )
        ],
      ),
    );


    var rewardPoints = cartData.cart.items.map<num>((e) => e.customProperties.rewardPoints ?? 0).reduce((value, element) => value + element);

    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(7, 5, 7, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                cartItems,
                attributeManager
                    .populateCustomAttributes(data.data.cart.checkoutAttributes),
                OutlinedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return EstimateShippingDialog(
                          cartData.estimateShipping,
                          false,
                          _bloc.selectedShippingMethod,
                        );
                      },
                    ).then((selectedMethod) {
                      if (selectedMethod != null && selectedMethod.toString().isNotEmpty) {
                        _bloc.selectedShippingMethod = selectedMethod;
                      }
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.transparent,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    side:  BorderSide(
                      color: Colors.blue, // Set the border color to blue
                      width: 1, // Set the border width to 2 pixels
                    ),

                  ),

                  child: Text(
                    _globalService.getString(Const.CART_ESTIMATE_SHIPPING_BTN).toUpperCase(),
                    style: TextStyle(
                      color: Colors.blueAccent, // Add underline to indicate the button is clickable
                      decorationColor: Colors.blueAccent,
                      decorationThickness: 1.5,
                    ),
                  ),
                ),


                if (cartData.cart.discountBox.display) couponCodeBox,
                if (cartData.cart.giftCardBox.display) giftCardBox,
                if (cartData.estimateShipping?.enabled == true)

                // OrderTotalTable(orderTotals: data.data.orderTotals),
                  if(_bloc.warningMsg.isNotEmpty)
                    Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                      child: Text(
                        _bloc.warningMsg,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                // Padding for checkout button
                if(_bloc.warningMsg.isEmpty && data.data.cart?.hideCheckoutButton != true)
                  SizedBox(height: 60),
              ],
            ),
          ),
        ),
        if(_bloc.warningMsg.isEmpty)
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 96,
                child: Column(
                  children: [
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [

                            StreamBuilder<ApiResponse<RewardPointData>>(
                                stream: _blocRewardPoint.rewardPointStream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData)
                                    return SizedBox(
                                      width: MediaQuery.of(context).size.width / 1.25,
                                      child: Text(
                                        'Use my Storkbucks, ${(snapshot?.data?.data?.rewardPointsBalance ?? 0)} available for this order.',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.orange.shade700,
                                        ),
                                      ),
                                    );

                                  return SizedBox.shrink();
                                }
                            ),

                            Spacer(),

                            Checkbox(
                              checkColor: Colors.white,
                              shape: CircleBorder(),
                              value: _useRewardPoints,
                              onChanged: (bool e) {
                                setState(() {
                                  _useRewardPoints = e;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),



                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.30),
                            spreadRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    RichText(
                                      textAlign: TextAlign.right,
                                      text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text: '${_globalService.getString(Const.SUB_TOTAL)} ',
                                                style: TextStyle(
                                                    color: Colors.black
                                                )

                                            ),
                                            TextSpan(
                                                text: '${data.data.orderTotals.subTotal}',
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                )
                                            )
                                          ]
                                      ),
                                    ),
                                    if (rewardPoints > 0)
                                      Padding(
                                        padding: EdgeInsets.all(1),
                                        child: RichText(
                                          textAlign: TextAlign.right,
                                          text: TextSpan(
                                              children: [
                                                TextSpan(
                                                    text: 'You will earn: ${rewardPoints} Storkbucks',
                                                    style: TextStyle(
                                                        color: Colors.orange.shade700,
                                                        fontSize: 12
                                                    )

                                                ),
                                              ]
                                          ),
                                        ),
                                      )

                                  ]
                              ),
                            ),

                            TextButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.orange.shade700),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                      ),
                                    )
                                ),
                                onPressed: () {
                                  if (_globalService.isLoggedIn() ||
                                      _globalService
                                          .getAppLandingData()
                                          ?.anonymousCheckoutAllowed ==
                                          true) {
                                    // user allowed to go to checkout
                                    String errMsg = attributeManager.checkRequiredAttributes(
                                        data.data.cart.checkoutAttributes);
                                    if (errMsg.isNotEmpty) {
                                      showSnackBar(context, errMsg, true);
                                    } else {
                                      // post checkout attributes before going to Checkout screen
                                      var checkoutAttrs = attributeManager
                                          .getSelectedAttributes('checkout_attribute');
                                      _bloc.postCheckoutAttributes(checkoutAttrs, true);
                                    }
                                  } else {
                                    // go to login
                                    Navigator.of(context).pushNamed(LoginScreen.routeName);
                                  }
                                },
                                child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 12),
                                    child: Text(
                                      _globalService.getString(Const.CHECKOUT),
                                      style: TextStyle(
                                          color: Colors.white
                                      ),
                                    )
                                )
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )

          ),
      ],
    );
  }

  showCheckoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(_globalService.getString(Const.CHECKOUT_AS_GUEST_TITLE)),
          ),
          content: Wrap(
            children: [Column(
              children: [
                Text(
                  _globalService.getString(Const.REGISTER_AND_SAVE_TIME),
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  _globalService.getString(Const.CREATE_ACCOUNT_LONG_TEXT),
                  textAlign: TextAlign.justify,
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                OutlinedButton(
                  child: Text(_globalService.getString(Const.CHECKOUT_AS_GUEST)),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(
                        CheckoutScreen.routeName,
                        arguments: CheckoutScreenArguments(
                            useRewardPoints: _useRewardPoints)
                    );
                  },
                ),
                OutlinedButton(
                  child: Text(_globalService.getString(Const.REGISTER_BUTTON)),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(
                        RegistrationScreen.routeName,
                        arguments: RegistrationScreenArguments(
                            getCustomerInfo: false));
                  },
                ),
                SizedBox(height: 10),
                Text(
                  _globalService.getString(Const.RETURNING_CUSTOMER),
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                OutlinedButton(
                  child: Text(_globalService.getString(Const.LOGIN_LOGIN_BTN)),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
                  },
                ),
              ],
            ),],
          ),
        );
      },
    );
  }
}
