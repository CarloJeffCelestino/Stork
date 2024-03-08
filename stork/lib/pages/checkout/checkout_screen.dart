import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nopcart_flutter/bloc/cart_bloc.dart';
import 'package:nopcart_flutter/bloc/checkout_bloc.dart';
import 'package:nopcart_flutter/customWidget/CustomAppBar.dart';
import 'package:nopcart_flutter/customWidget/error.dart';
import 'package:nopcart_flutter/customWidget/loading.dart';
import 'package:nopcart_flutter/customWidget/loading_dialog.dart';
import 'package:nopcart_flutter/model/GetBillingAddressResponse.dart';
import 'package:nopcart_flutter/model/SaveBillingResponse.dart';
import 'package:nopcart_flutter/model/ShoppingCartResponse.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/pages/account/cart/CartListItem.dart';
import 'package:nopcart_flutter/pages/account/order/order_details_screen.dart';
import 'package:nopcart_flutter/pages/checkout/checkout_webview.dart';
import 'package:nopcart_flutter/pages/checkout/step_checkout_address.dart';
import 'package:nopcart_flutter/pages/checkout/step_confirm_order.dart';
import 'package:nopcart_flutter/pages/checkout/step_payment_methd.dart';
import 'package:nopcart_flutter/pages/checkout/step_shipping_methd.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/CheckoutConstants.dart';
import 'package:nopcart_flutter/utils/Const.dart';
import 'package:nopcart_flutter/utils/nop_cart_icons.dart';
import 'package:nopcart_flutter/utils/styles.dart';
import 'package:nopcart_flutter/utils/utility.dart';

class CheckoutScreen extends StatefulWidget {
  static const routeName = '/checkout';
  final bool useRewardPoints;
  const CheckoutScreen({Key key, this.useRewardPoints}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState(useRewardPoints: useRewardPoints);
}

class _CheckoutScreenState extends State<CheckoutScreen> {

  final bool useRewardPoints;

  GlobalService _globalService = GlobalService();
  CheckoutBloc _bloc;
  Widget currentWidget;
  CartBloc _blocCart;
  ApiResponse<CheckoutPostResponse> _event;
  PaymentMethodModel _paymentMethodModel;
  GetBillingData _getBillingData;

  _CheckoutScreenState({this.useRewardPoints});

  var isSelected = [true, false, false, false];

  @override
  void initState() {
    super.initState();
    _bloc = CheckoutBloc();
    _blocCart = CartBloc();
    _blocCart.fetchCartData();

    _blocCart.loaderStream.listen((showLoader) {
      if (showLoader == true) {
        DialogBuilder(context).showLoader();
      } else {
        DialogBuilder(context).hideLoader();
      }
    });

    _bloc.fetchBillingAddress();

    _bloc.getBillingStream.listen((event) {
      switch (event.status) {
        case Status.LOADING:
          currentWidget = Loading(loadingMessage: event.message);
          break;
        case Status.COMPLETED:
          _getBillingData = _getBillingData ?? event.data.data;
          currentWidget = StepCheckoutAddress(UniqueKey(), _bloc, billingData: event.data.data, shippingAddress: null);
          break;
        case Status.ERROR:
          currentWidget =  Error(
            errorMessage: event.message,
            onRetryPressed: () => _bloc.fetchBillingAddress(),
          );
          break;
      }

      setState(() {});
    });

    _bloc.checkoutPostStream.listen((event) {
      _event = event;

      if (event.data?.data?.paymentMethodModel != null)
        if (event.data?.data?.paymentMethodModel?.paymentMethods?.toList()?.length > 0)
          _paymentMethodModel = event.data?.data?.paymentMethodModel;

        print('test: ' + (event.data?.data?.confirmModel?.cart?.orderReviewData?.paymentMethod ?? 'no payment method'));

          if (event.status == Status.COMPLETED) {
        DialogBuilder(context).hideLoader();
        // print(event.data?.data?.paymentMethodModel.paymentMethods.toList().map((e) => e.name));
        setState(() {
          switch(event.data?.data?.nextStep ?? 0) {
            case CheckoutConstants.ShippingAddress:
              print('step: ' + 'address');
              currentWidget = StepCheckoutAddress(UniqueKey(), _bloc, shippingAddress: event.data?.data?.shippingAddressModel, billingData: null);
              break;
            case CheckoutConstants.ShippingMethod:
              print('step: ' + 'shipping method');

              currentWidget = StepShippingMethod(_bloc, shippingMethodModel: event.data?.data?.shippingMethodModel);
              break;
            case CheckoutConstants.PaymentMethod:
              print('step: ' + 'payment method');

              if (event.data?.data?.paymentMethodModel != null)
                event.data?.data?.paymentMethodModel.useRewardPoints = useRewardPoints;
              currentWidget = StepPaymentMethod(_bloc, paymentMethodModel: event.data?.data?.paymentMethodModel);
              break;
            case CheckoutConstants.PaymentInfo:
              Navigator.of(context).pushNamed(
                CheckoutWebView.routeName,
                arguments: CheckoutWebViewScreenData(
                  action: CheckoutConstants.PaymentInfo,
                  screenTitle: _bloc.selectedPaymentMethod?.name,
                ),
              ).then((nextStep) {
                int nextStepInt = int.tryParse(nextStep) ?? 0;

                if(nextStepInt == 0) {
                  // nextStep 0 in payment info means server can't identify the customer from the WebView. This is backend bug.
                  showSnackBar(context, _globalService.getString(Const.COMMON_SOMETHING_WENT_WRONG), true);
                } else {
                  _bloc.gotoNextStep(nextStepInt);
                }
              });
              break;
            case CheckoutConstants.ConfirmOrder:
              currentWidget =  StepConfirmOrder(_bloc, confirmModel: event.data?.data?.confirmModel, paymentMethodModel: _paymentMethodModel, getBillingData: _getBillingData);
              break;
            case CheckoutConstants.RedirectToGateway:
              Navigator.of(context).pushNamed(
                  CheckoutWebView.routeName,
                  arguments: CheckoutWebViewScreenData(
                    action: CheckoutConstants.RedirectToGateway,
                    screenTitle: _globalService.getString(Const.ONLINE_PAYMENT),
                    customerId: event.data.data.customerId,
                    checkoutGuid: event.data.data.webGuid
                  ),
              ).then((orderId) {
                if(orderId!=null && orderId as int > 0) {
                  _bloc.orderId = orderId;
                  _bloc.gotoNextStep(CheckoutConstants.LeaveCheckout);
                } else {
                  _bloc.gotoNextStep(CheckoutConstants.Completed);
                }
              });
              break;
            case CheckoutConstants.Completed:
              _bloc.orderComplete();
              break;
            case CheckoutConstants.LeaveCheckout:
              _globalService.updateCartCount(0);

              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return orderCompleteDialog(_bloc.orderId);
                  },
              );
              break;
            default:
              showSnackBar(context, 'Next step unknown', true);
              break;
          }
        });

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
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isSelected[0] = _bloc.currentStep == CheckoutConstants.BillingAddress || _bloc.currentStep == CheckoutConstants.ShippingAddress;
    isSelected[1] = _bloc.currentStep == CheckoutConstants.ShippingMethod;
    isSelected[2] = _bloc.currentStep == CheckoutConstants.PaymentMethod;
    isSelected[3] = _bloc.currentStep == CheckoutConstants.ConfirmOrder;

    var toggleBtnWidth = MediaQuery.of(context).size.width / 4;

    var topButtons = Material(
      elevation: 5,
      child: ToggleButtons(
        children: [
          SizedBox(
            width: toggleBtnWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 5),
                Icon(NopCart.ic_address),
                Text(_globalService.getString(Const.ADDRESS_TAB), textAlign: TextAlign.center),
                SizedBox(height: 5),
              ],
            ),
          ),
          SizedBox(
            width: toggleBtnWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 5),
                Icon(NopCart.ic_shipping, size: 22),
                SizedBox(height: 2),
                Text(_globalService.getString(Const.SHIPPING_TAB), textAlign: TextAlign.center),
                SizedBox(height: 5),
              ],
            ),
          ),
          SizedBox(
            width: toggleBtnWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 5),
                Icon(NopCart.ic_payment, size: 22),
                SizedBox(height: 2),
                Text(_globalService.getString(Const.PAYMENT_TAB), textAlign: TextAlign.center),
                SizedBox(height: 5),
              ],
            ),
          ),
          SizedBox(
            width: toggleBtnWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 5),
                Icon(NopCart.ic_confirm_order),
                Text(_globalService.getString(Const.CONFIRM_TAB), textAlign: TextAlign.center),
                SizedBox(height: 5),
              ],
            ),
          ),
        ],
        onPressed: (int index) {
          var intendedStep = 0;

          if (index == 0) intendedStep = CheckoutConstants.BillingAddress;
          else if(index == 1) intendedStep = CheckoutConstants.ShippingMethod;
          else if(index == 2) intendedStep = CheckoutConstants.PaymentMethod;
          else if(index == 3) intendedStep = CheckoutConstants.ConfirmOrder;

          if(intendedStep > _bloc.currentStep) {
            showSnackBar(context, _globalService.getString(Const.PLEASE_COMPLETE_PREVIOUS_STEP), true);
          } else if(intendedStep < _bloc.currentStep) {
            // debugprint('Loading step  $intendedStep...');

            // TODO handle manual tab click
          }
        },
        isSelected: isSelected,
        textStyle: TextStyle(fontSize: 15),
        color: Styles.textColor(context),
        selectedColor: Theme.of(context).primaryColor,
        fillColor: isDarkThemeEnabled(context) ? Colors.grey[800] : Colors.grey[100],
        renderBorder: false,
      )
    );

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
        title: Text(_globalService.getString(Const.CHECKOUT)),
      ),
      body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [

                  // topButtons,
                  currentWidget ?? SizedBox.shrink(),
                  // Visibility(
                  //   child: currentWidget ?? SizedBox.shrink(),
                  //   visible: _event != null ? [5].contains(_event.data?.data?.nextStep) ? true : false  : false,
                  // ),

                  Container(
                    height: 64,
                  )
                ],
              ),
            ),

            if(_event != null ? _event.data?.data?.confirmModel?.orderTotals?.orderTotal != null ? true : false : false)
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 64,
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
                    padding: EdgeInsets.only(left: 12),
                    child: Row(
                      children: [
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          child: Column(
                              children: [
                                RichText(
                                  textAlign: TextAlign.right,
                                  text: TextSpan(
                                      children: [
                                        TextSpan(
                                            text: 'Total Payment\n',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold
                                            )

                                        ),
                                        TextSpan(
                                            text: _event.data?.data?.confirmModel.orderTotals.orderTotal,
                                            style: TextStyle(
                                              color: Colors.orange.shade700,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18
                                            )
                                        )
                                      ]
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
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(18.0),
                                          bottomLeft: Radius.circular(18.0),
                                      ),
                                    ),
                                  )
                              ),
                              onPressed: () {
                                _bloc.confirmOrder();
                              },
                              child: Container(
                                  height: 64,
                                  width: 128,
                                  margin: EdgeInsets.symmetric(horizontal: 12),
                                  child: Center(
                                    child: Text(
                                      _globalService.getString(Const.CHECKOUT),
                                      style: TextStyle(
                                          color: Colors.white
                                      ),
                                    ),
                                  )
                              )
                          )
                      ],
                    ),
                  ),
                ),
            ),
          ],
        ),
      );
  }

  Widget orderCompleteDialog(num orderId) {
    return WillPopScope(
        child: AlertDialog(
          title: Text(_globalService.getString(Const.THANK_YOU)),
          content: Text(_globalService.getString(Const.ORDER_PROCESSED) +
              (orderId > 0
                  ? '\n${_globalService.getString(Const.ORDER_NUMBER)}: ${_bloc.orderNumber}'
                  : '')),
          actions: [
            if(orderId > 0)
              TextButton(
                onPressed: () {
                  // clear stack and go to order details page
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    OrderDetailsScreen.routeName,
                        (route) => route.isFirst,
                    arguments: OrderDetailsScreenArguments(orderId: orderId),
                  );
                },
                child: Text(_globalService.getString(Const.TITLE_ORDER_DETAILS)),
              ),

            TextButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text(_globalService.getString(Const.CONTINUE)),
            ),
          ],
        ),
        onWillPop: () async {
          return false;
        },
    );
  }
}

class CheckoutScreenArguments {
  bool useRewardPoints;

  CheckoutScreenArguments({@required this.useRewardPoints});
}