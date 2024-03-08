import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nopcart_flutter/bloc/review_bloc.dart';
import 'package:nopcart_flutter/customWidget/CustomAppBar.dart';
import 'package:nopcart_flutter/customWidget/error.dart';
import 'package:nopcart_flutter/customWidget/loading.dart';
import 'package:nopcart_flutter/model/CustomerReviewResponse.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/pages/product/product_details_screen.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/Const.dart';

class CustomerReviewScreen extends StatefulWidget {
  static const routeName = '/customer-review';

  const CustomerReviewScreen({Key key}) : super(key: key);

  @override
  _CustomerReviewScreenState createState() => _CustomerReviewScreenState();
}

class _CustomerReviewScreenState extends State<CustomerReviewScreen> {
  ReviewBloc _bloc;
  GlobalService _globalService = GlobalService();
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _bloc = ReviewBloc();
    _bloc.fetchCustomerReviews();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange) {
        // debugprint('calling next page');
        _bloc.fetchCustomerReviews();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(() {});
    _bloc?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
        title: Text(_globalService.getString(Const.ACCOUNT_MY_REVIEW)),
      ),
      body: StreamBuilder<ApiResponse<CustomerReviewData>>(
        stream: _bloc.customerReviewStream,
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
                  onRetryPressed: () => _bloc.fetchCustomerReviews(),
                );
                break;
            }
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget rootWidget(CustomerReviewData data) {

    var noDataText = Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _globalService.getString(Const.COMMON_NO_DATA),
          ),
        ],
      ),
    );

    var progressLoader = Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
        ],
      ),
    );

    return Stack(
      children: [
        ListView.builder(
          controller: _scrollController,
          itemCount: data?.productReviews?.length ?? 0,
          itemBuilder: (context, index) {
            return listItem(data.productReviews[index]);
          },
        ),

        if ((data?.productReviews?.isEmpty ?? true) == true)
          noDataText,

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
    );
  }

  listItem(ProductReview item) {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.pushNamed(
            context,
            ProductDetailsPage.routeName,
            arguments: ProductDetailsScreenArguments(
              id: item.productId,
              name: item.productName,
            ),
          );
        },
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.productName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            SizedBox(height: 10),
            Text(item.title, style: TextStyle(fontWeight: FontWeight.bold),),
            Text(item.reviewText),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: RatingBar.builder(
                ignoreGestures: true,
                itemSize: 12,
                initialRating:
                item.rating.toDouble(),
                direction: Axis.horizontal,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 1.5),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (_) {},
              ),
            ),
            SizedBox(height: 10),
            Text('${_globalService.getString(Const.REVIEW_DATE)} ${item.writtenOnStr}'),
          ],
        ),
      ),
    );
  }
}
