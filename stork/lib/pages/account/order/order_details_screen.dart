import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:nopcart_flutter/bloc/order_bloc.dart';
import 'package:nopcart_flutter/customWidget/CustomAppBar.dart';
import 'package:nopcart_flutter/customWidget/CustomButton.dart';
import 'package:nopcart_flutter/customWidget/error.dart';
import 'package:nopcart_flutter/customWidget/loading.dart';
import 'package:nopcart_flutter/customWidget/loading_dialog.dart';
import 'package:nopcart_flutter/customWidget/order_total_table.dart';
import 'package:nopcart_flutter/model/OrderDetailsResponse.dart';
import 'package:nopcart_flutter/model/ShoppingCartResponse.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/pages/account/cart/shopping_cart_screen.dart';
import 'package:nopcart_flutter/pages/checkout/checkout_webview.dart';
import 'package:nopcart_flutter/pages/product/product_details_screen.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/CheckoutConstants.dart';
import 'package:nopcart_flutter/utils/Const.dart';
import 'package:nopcart_flutter/utils/utility.dart';
import 'package:permission_handler/permission_handler.dart';

class OrderDetailsScreen extends StatefulWidget {
  static const routeName = '/order-details';
  final num orderId;

  const OrderDetailsScreen({Key key, this.orderId}) : super(key: key);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState(orderId: this.orderId);
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  GlobalService _globalService = GlobalService();
  OrderBloc _bloc;
  final num orderId;

  _OrderDetailsScreenState({this.orderId});

  @override
  void initState() {
    super.initState();
    _bloc = OrderBloc();
    _bloc.fetchOrderDetails(orderId);

    _bloc.reorderStream.listen((event) {
      if(event.status == Status.LOADING) {
        DialogBuilder(context).showLoader();
      } else if(event.status == Status.COMPLETED) {
        DialogBuilder(context).hideLoader();

        if(event.data) {
          // go to cart
          Navigator.of(context).pushNamedAndRemoveUntil(
            ShoppingCartScreen.routeName, (route) => route.isFirst,
          );
        }
      } else {
        DialogBuilder(context).hideLoader();
        if(event.message?.isNotEmpty == true)
          showSnackBar(context, event.message, true);
      }
    });

    _bloc.repostStream.listen((event) {
      if(event.status == Status.LOADING) {
        DialogBuilder(context).showLoader();
      } else {
        DialogBuilder(context).hideLoader();
        // print('--- ${event.data}');

        if(event.data ?? false == true) {
          // open web view
          Navigator.of(context).pushNamed(
            CheckoutWebView.routeName,
            arguments: CheckoutWebViewScreenData(
              action: CheckoutConstants.RetryPayment,
              screenTitle: _globalService.getString(Const.ONLINE_PAYMENT),
              orderId: orderId,
            ),
          ).then((value) {
            // refresh page contents
            _bloc.fetchOrderDetails(orderId);
          });
        }
      }
    });

    _bloc.fileDownloadStream.listen((event) {
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
  }

  @override
  void dispose() {
    super.dispose();
    _bloc?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
        title: Text(
          _globalService.getString(Const.TITLE_ORDER_DETAILS),
        ),
      ),
      body: StreamBuilder<ApiResponse<OrderDetailsResponse>>(
        stream: _bloc.orderDetailsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Loading(loadingMessage: snapshot.data.message);
                break;
              case Status.COMPLETED:

                return getRootWidget(snapshot.data.data.data);
                break;
              case Status.ERROR:
                return Error(
                  errorMessage: snapshot.data.message,
                  onRetryPressed: () => _bloc.fetchOrderDetails(orderId),
                );
                break;
            }
          }
          return SizedBox.shrink();
        },
      ),
      floatingActionButton: StreamBuilder<num>(
        initialData: -1,
        stream: _bloc.pdfLinkStream,
          builder: (context, snapshot) {
            return snapshot.data > -1
                ? FloatingActionButton(
                    onPressed: () async {
                      var status = await Permission.storage.status;
                      if (!status.isGranted) {
                        await Permission.storage.request().then((value) => {
                          if (value.isGranted) {_bloc.downloadPdfInvoice(orderId: snapshot.data)}
                        });
                      } else {
                        _bloc.downloadPdfInvoice(orderId: snapshot.data);
                      }
                    },
                    child: Icon(
                      Icons.picture_as_pdf_outlined,
                      color: Colors.black,
                    ),
                    backgroundColor: Colors.blueGrey[200],
                  )
                : SizedBox.shrink();
          }),
    );
  }

  Widget getRootWidget(OrderDetailsData confirmModel) {

    var orderInfoCard = Card(
      child: ListTile(
        leading: Icon(Icons.info_outline_rounded),
        title: Text('${_globalService.getString(Const.ORDER_NUMBER)} ${confirmModel.customOrderNumber}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${_globalService.getString(Const.ORDER_STATUS)}: ${confirmModel.orderStatus}'),
            Text('${_globalService.getString(Const.ORDER_DATE)}: ${getFormattedDate(confirmModel.createdOn)}'),
            Text('${_globalService.getString(Const.ORDER_TOTAL)}: ${confirmModel.orderTotal}'),
          ],
        ),
      ),
    );

    var billingAdrsCard = Card(
      child: ListTile(
        leading: Icon(Icons.location_pin),
        title: Text(_globalService.getString(Const.BILLING_ADDRESS_TAB)),
        subtitle: Text(getFormattedAddress(
            confirmModel.billingAddress)),
      ),
    );

    var shippingAdrsCard = Card(
      child: ListTile(
        leading: Icon(Icons.location_pin),
        title: Text(_globalService.getString(Const.SHIPPING_ADDRESS_TAB)),
        subtitle: Text(getFormattedAddress(
            confirmModel.shippingAddress)),
      ),
    );

    var storeAdrsCard = Card(
      child: ListTile(
        leading: Icon(Icons.pin_drop),
        title: Text(_globalService.getString(Const.PICK_UP_POINT_ADDRESS)),
        subtitle: Text(getFormattedAddress(
            confirmModel.pickupAddress)),
      ),
    );

    var shippingMethodCard = Card(
      child: ListTile(
        leading: Icon(Icons.local_shipping),
        title: Text(_globalService.getString(Const.SHIPPING_METHOD)),
        subtitle: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: '${confirmModel.shippingMethod}\n' ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .headline4.copyWith(
                    fontSize: 16
                  )),
              TextSpan(
                  text: confirmModel.shippingStatus ?? '',
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'LatoBold')),
            ],
          ),
        ),
      ),
    );

    var paymetnMethodCard = Card(
      child: ListTile(
        leading: Icon(Icons.payment_outlined),
        title: Text(_globalService.getString(Const.PAYMENT_METHOD)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${confirmModel.paymentMethod}\n${confirmModel.paymentMethodStatus}'),
            if(confirmModel.canRePostProcessPayment)
              OutlinedButton(
                onPressed: () {
                  _bloc.repostPayment(orderId);
                },
                child: Text(_globalService.getString(Const.ORDER_RETRY_PAYMENT)),
              ),
          ],
        ),
      ),
    );

    var shipmentCard = Card(
      child: ListTile(
        title: Text(_globalService.getString(Const.ORDER_SHIPMENT)),
        subtitle: ListView.builder(
          shrinkWrap: true,
          itemCount: confirmModel.shipments?.length ?? 0,
          itemBuilder: (context, index) {
            var item = confirmModel.shipments[index];
            return Padding(
              padding: EdgeInsets.only(top: 7.0),
              child: Text(
                  '${_globalService.getString(Const.ORDER_SHIPMENT_ID)} ${item.id}\n'
                  '${_globalService.getString(Const.SHIPMENT_TRACKING_NUMBER)}: ${item.trackingNumber}\n'
                  '${_globalService.getString(Const.ORDER_DATE_SHIPPED)}: '
                      '${getFormattedDate(item.shippedDate, format: 'MM/dd/yyyy hh:mm a')}\n'
                  '${_globalService.getString(Const.ORDER_DATE_DELIVERED)}: '
                      '${getFormattedDate(item.deliveryDate, format: 'MM/dd/yyyy hh:mm a')}'
              ),
            );
          },
        ),
      ),
    );

    var notesCard = Card(
      child: ListTile(
        title: Text(_globalService.getString(Const.ORDER_NOTES)),
        subtitle: ListView.builder(
          shrinkWrap: true,
          itemCount: confirmModel.orderNotes?.length ?? 0,
          itemBuilder: (context, index) {
            var item = confirmModel.orderNotes[index];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(item.note ?? ''),
              subtitle: Text(
                getFormattedDate(
                    DateTime.parse(item.createdOn ?? ''), format: 'MM/dd/yyyy hh:mm a',
                ),
              ),
              trailing: item?.hasDownload ?? false
                ? InkWell(
                    child: Icon(Icons.download_sharp),
                    onTap: () async {
                      var status = await Permission.storage.status;
                      if (!status.isGranted) {
                        await Permission.storage.request().then((value) => {
                          if (value.isGranted) {_bloc.downloadNotesAttachment(item.id)}
                        });
                      } else {
                        _bloc.downloadNotesAttachment(item.id);
                      }
                    }
                  )
                : null,
            );
          },
        ),
      ),
    );

    var cartItems = Card(
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: confirmModel.items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(confirmModel.items[index].productName ?? ''),
            subtitle: Text('${_globalService.getString(Const.PRICE)}: ${confirmModel.items[index].unitPrice}'),
            onTap: () =>
                Navigator.of(context).pushNamed(ProductDetailsPage.routeName,
                    arguments: ProductDetailsScreenArguments(
                      id: confirmModel.items[index].productId,
                      name: confirmModel.items[index].productName,
                    )),
          );
        },
      ),
    );

    var selectedAttributes = Card(
      child: ListTile(
        title: Text(_globalService.getString(Const.SELECTED_ATTRIBUTES)),
        subtitle: HtmlWidget(
          confirmModel.checkoutAttributeInfo  ?? '',
        ),
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      child: SingleChildScrollView(
        child: Column(
          children: [
            orderInfoCard,
            if (confirmModel.billingAddress!=null)
              billingAdrsCard,
            if (confirmModel.isShippable && !confirmModel.pickupInStore)
              shippingAdrsCard,
            if (confirmModel.pickupInStore)
              storeAdrsCard,
            shippingMethodCard,
            paymetnMethodCard,
            if (confirmModel.checkoutAttributeInfo?.isNotEmpty == true)
              selectedAttributes,
            if(confirmModel.shipments?.isNotEmpty == true)
              shipmentCard,
            if(confirmModel.orderNotes?.isNotEmpty == true)
              notesCard,
            cartItems,
            SizedBox(height: 10),
            OrderTotalTable(orderTotals: OrderTotals(
                displayTax: confirmModel.displayTax ?? false,
                displayTaxRates: confirmModel.displayTaxRates ?? false,
                giftCards: confirmModel.giftCards,
                hideShippingTotal: false,
                isEditable: false,
                orderTotal: confirmModel.orderTotal,
                orderTotalDiscount: confirmModel.orderTotalDiscount,
                paymentMethodAdditionalFee: confirmModel.paymentMethodAdditionalFee,
                redeemedRewardPoints: confirmModel.redeemedRewardPoints ?? 0,
                redeemedRewardPointsAmount: confirmModel.redeemedRewardPointsAmount,
                requiresShipping: false,
                selectedShippingMethod: confirmModel.shippingMethod,
                shipping: confirmModel.orderShipping,
                subTotal: confirmModel.orderSubtotal ?? "",
                subTotalDiscount: confirmModel.orderSubTotalDiscount,
                tax: confirmModel.tax,
                taxRates: confirmModel.taxRates,
                willEarnRewardPoints: null
            )),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    label: GlobalService().getString(Const.ORDER_REORDER).toUpperCase(),
                    onClick: () {
                      _bloc.reorder(orderId);
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OrderDetailsScreenArguments {
  num orderId;

  OrderDetailsScreenArguments({
    @required this.orderId,
  });
}
