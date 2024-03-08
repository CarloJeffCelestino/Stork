import 'package:flutter/material.dart';
import 'package:nopcart_flutter/bloc/order_bloc.dart';
import 'package:nopcart_flutter/customWidget/CustomAppBar.dart';
import 'package:nopcart_flutter/customWidget/loading.dart';
import 'package:nopcart_flutter/customWidget/error.dart';
import 'package:nopcart_flutter/model/OrderHistoryResponse.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/pages/account/returnRequest/ReturnRequestScreen.dart';
import 'package:nopcart_flutter/pages/account/order/order_details_screen.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/Const.dart';
import 'package:nopcart_flutter/utils/utility.dart';

class OrderHistoryScreen extends StatefulWidget {
  static const routeName = '/order-history';
  final bool isPending;
  final bool toShip;
  final bool toDeliver;
  final bool toRate;

  const OrderHistoryScreen({Key key, this.isPending = false, this.toShip = false, this.toDeliver = false, this.toRate = false})
      : super(key: key);

  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  GlobalService _globalService = GlobalService();
  OrderBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = OrderBloc();
    _bloc.fetchOrderHistory(isPending: widget.isPending, toShip: widget.toShip, toDeliver: widget.toDeliver, toRate: widget.toRate);
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
          _globalService.getString(Const.ACCOUNT_ORDERS),
        ),
      ),
      body: StreamBuilder<ApiResponse<OrderHistoryResponse>>(
        stream: _bloc.orderHistoryStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Loading(loadingMessage: snapshot.data.message);
                break;
              case Status.COMPLETED:
                return rootWidget(snapshot.data?.data?.data?.orders ?? []);
                break;
              case Status.ERROR:
                return Error(
                  errorMessage: snapshot.data.message,
                  onRetryPressed: () => _bloc.fetchOrderHistory(isPending: widget.isPending, toShip: widget.toShip, toDeliver: widget.toDeliver, toRate: widget.toRate),
                );
                break;
            }
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget rootWidget(List<Order> orderList) {
    return Stack(
      children: [
        ListView.builder(
          itemCount: orderList.length,
          itemBuilder: (context, index) {
            return listItem(orderList[index]);
          },
        ),
        if(orderList.isEmpty)
          Align(
            alignment: Alignment.center,
            child: Text(_globalService.getString(Const.COMMON_NO_DATA)),
          ),
      ],
    );
  }

  Widget listItem(Order item) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          OrderDetailsScreen.routeName,
          arguments: OrderDetailsScreenArguments(
            orderId: item.id,
          ),
        );
      },
      child: ListTile(
        leading: Icon(Icons.credit_card_outlined),
        title: Text('${_globalService.getString(Const.ORDER_NUMBER)} ${item.customOrderNumber}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${_globalService.getString(Const.ORDER_STATUS)}: ${item.orderStatus}'),
            Text('${_globalService.getString(Const.ORDER_DATE)}: ${getFormattedDate(item.createdOn)}'),
            Text('${_globalService.getString(Const.ORDER_TOTAL)}: ${item.orderTotal}'),
            Text('${_globalService.getString(Const.ORDER_SHIPPING_STATUS)}: ${item.shippingStatus}'),
            if(item.isReturnRequestAllowed)
              OutlinedButton(
                onPressed: () => Navigator.of(context)
                    .pushNamed(ReturnRequestScreen.routeName,
                        arguments: ReturnRequestScreenArgs(item.id))
                    .then((value) {
                  if (value == true) {
                    _bloc.fetchOrderHistory(isPending: widget.isPending, toShip: widget.toShip, toDeliver: widget.toDeliver, toRate: widget.toRate);
                  }
                }),
                child: Text(_globalService.getString(Const.ORDER_RETURN_ITEMS)),
              ),
            Divider(),
          ],
        ),
        trailing: Icon(Icons.keyboard_arrow_right_outlined),
      ),
    );
  }
}



class OrderHistoryScreenArguments {
  bool isPending;
  bool toShip;
  bool toDeliver;
  bool toRate;

  OrderHistoryScreenArguments({
    this.isPending = false,
    this.toShip = false,
    this.toDeliver = false,
    this.toRate = false,
  });
}