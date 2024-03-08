import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nopcart_flutter/bloc/subscription_bloc.dart';
import 'package:nopcart_flutter/customWidget/CustomAppBar.dart';
import 'package:nopcart_flutter/customWidget/CustomButton.dart';
import 'package:nopcart_flutter/customWidget/NoDataText.dart';
import 'package:nopcart_flutter/customWidget/error.dart';
import 'package:nopcart_flutter/customWidget/loading.dart';
import 'package:nopcart_flutter/model/SubscriptionListResponse.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/ButtonShape.dart';
import 'package:nopcart_flutter/utils/Const.dart';

/// Back In Stock Subscription
class SubscriptionScreen extends StatefulWidget {
  static const routeName = '/biss-screen';
  const SubscriptionScreen({Key key}) : super(key: key);

  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  GlobalService _globalService = GlobalService();
  SubscriptionBloc _bloc;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _bloc = SubscriptionBloc();
    _bloc.fetchSubscriptionList();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange) {
        // debugprint('calling next page');
        _bloc.fetchSubscriptionList();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _bloc?.dispose();
    _scrollController.removeListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
        title: Text(_globalService.getString(Const.ACCOUNT_BACK_IN_STOCK_SUBSCRIPTION)),
      ),
      body: StreamBuilder<ApiResponse<SubscriptionListData>>(
        stream: _bloc.subscriptionListStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Loading(loadingMessage: snapshot.data.message);
                break;
              case Status.COMPLETED:
                return rootWidget(snapshot.data.data);
                break;
              case Status.ERROR:
                return Error(
                  errorMessage: snapshot.data.message,
                  onRetryPressed: () => _bloc.fetchSubscriptionList(),
                );
                break;
            }
          }
          return SizedBox.shrink();
        }
      ),
    );
  }

  Widget rootWidget(SubscriptionListData data) {
    var progressLoader = Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
        ],
      ),
    );

    var btnUnsubscribe = Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
                label: _globalService
                    .getString(Const.BACK_IN_STOCK_DELETE_SELECTED)
                    .toUpperCase(),
                shape: ButtonShape.RoundedTop,
                onClick: () => _bloc.unsubscribeSelected(),
            ),
          )
        ],
      ),
    );

    return Column(
      children: [
        if ((data?.subscriptions?.isNotEmpty ?? false) == true)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            child: Text(
              _globalService.getString(Const.BACK_IN_STOCK_DESCRIPTION),
            ),
          ),

        Expanded(child: Stack(
          children: [
            ListView.builder(
              controller: _scrollController,
              itemCount: data?.subscriptions?.length ?? 0,
              itemBuilder: (context, index) {
                return listItem(data.subscriptions[0]);
              },
            ),

            if ((data?.subscriptions?.isEmpty ?? true) == true)
              NoDataText(_globalService.getString(Const.BACK_IN_STOCK_NO_SUBSCRIPTION)),

            StreamBuilder<ApiResponse<String>>(
              stream: _bloc.loaderStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if(snapshot.data.status == Status.LOADING)
                    return progressLoader;
                  else
                    return SizedBox.shrink();
                }
                return SizedBox.shrink();
              },
            ),
          ],
        )),

        if ((data?.subscriptions?.isNotEmpty ?? false) == true)
          btnUnsubscribe,
      ],
    );
  }

  Widget listItem(Subscription subscription) {
    return Card(
      child: CheckboxListTile(
        title: Text(subscription.productName ?? ''),
        value: _bloc.isSelected(subscription.id),
        onChanged: (isChecked) {
          setState(() {
            _bloc.setSelectionStatus(subscription.id, isChecked);
          });
        },
      ),
    );
  }
}
