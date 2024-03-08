import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nopcart_flutter/bloc/review_bloc.dart';
import 'package:nopcart_flutter/customWidget/CustomAppBar.dart';
import 'package:nopcart_flutter/customWidget/CustomButton.dart';
import 'package:nopcart_flutter/customWidget/error.dart';
import 'package:nopcart_flutter/customWidget/loading.dart';
import 'package:nopcart_flutter/customWidget/loading_dialog.dart';
import 'package:nopcart_flutter/model/ProductReviewResponse.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/ButtonShape.dart';
import 'package:nopcart_flutter/utils/Const.dart';
import 'package:nopcart_flutter/utils/ValidationMixin.dart';
import 'package:nopcart_flutter/utils/utility.dart';

class ProductReviewScreen extends StatefulWidget {
  static const routeName = '/product-review';
  final num productId;

  const ProductReviewScreen({Key key, this.productId}) : super(key: key);

  @override
  _ProductReviewScreenState createState() =>
      _ProductReviewScreenState(productId: productId);
}

class _ProductReviewScreenState extends State<ProductReviewScreen>
  with ValidationMixin {
  ReviewBloc _bloc;
  GlobalService _globalService = GlobalService();
  final num productId;
  final _formKey = GlobalKey<FormState>();

  _ProductReviewScreenState({this.productId});

  @override
  void initState() {
    super.initState();
    _bloc = ReviewBloc();
    _bloc.fetchProductReviews(productId);

    _bloc.loaderStream.listen((event) {
      if(event.status == Status.LOADING) {
        DialogBuilder(context).showLoader();
      } else if(event.status == Status.COMPLETED) {
        DialogBuilder(context).hideLoader();

        if(event.data?.isNotEmpty == true) {
          showSnackBar(context, event.data, false);
        }
      } else {
        DialogBuilder(context).hideLoader();
        if(event.message?.isNotEmpty == true)
          showSnackBar(context, event.message, true);
      }
    });

    _bloc.helpfulnessStream.listen((event) {
      if(event.status == Status.LOADING) {
        DialogBuilder(context).showLoader();
      } else if(event.status == Status.COMPLETED) {
        DialogBuilder(context).hideLoader();
      } else if(event.status == Status.ERROR) {
        DialogBuilder(context).hideLoader();
        showSnackBar(context, event.message, true);
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
        title: Text(_globalService.getString(Const.TITLE_REVIEW)),
      ),
      body: Center(
        child: StreamBuilder<ApiResponse<ProductReviewData>>(
          stream: _bloc.prodReviewStream,
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
                    onRetryPressed: () => _bloc.fetchProductReviews(productId),
                  );
                  break;
              }
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget rootWidget(ProductReviewData data) {

    var btnAddReview = Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        children: [Expanded(child: CustomButton(
          label: _globalService
              .getString(Const.REVIEW_WRITE)
              .toUpperCase(),
          shape: ButtonShape.RoundedTop,
          onClick: () => showAddReviewDialog(data.addProductReview),
        ))
        ],
      ),
    );

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

    return Stack(
      children: [
        ListView.builder(
          itemCount: (data?.items?.length ?? 0) + 1,
          itemBuilder: (context, index) {
            if (index < data.items?.length ?? 0) {
              return reviewListItem(data.items[index]);
            } else {
              return SizedBox(height: 50);
            }
          },
        ),

        if (data?.addProductReview?.canCurrentCustomerLeaveReview == true)
          btnAddReview,

        if ((data?.items?.isEmpty ?? true) == true)
          noDataText,
      ],
    );
  }

  Widget reviewListItem(ProductReviewItem item) {
    return Card(
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Text('${item.customerName}  ${item.writtenOnStr}'),
            Row(
              children: [
                Text(_globalService.getString(Const.REVIEW_HELPFUL)),
                SizedBox(width: 15),
                InkWell(child: Icon(Icons.thumb_up_alt_outlined), onTap: () {
                  _bloc.postHelpfulness(item.helpfulness.productReviewId, isHelpful: true);
                }),
                SizedBox(width: 15),
                InkWell(child: Icon(Icons.thumb_down_alt_outlined), onTap: () {
                  _bloc.postHelpfulness(item.helpfulness.productReviewId, isHelpful: false);
                }),
                SizedBox(width: 15),
                Text('${item.helpfulness.helpfulYesTotal}/${item.helpfulness.helpfulNoTotal}'),
              ],
            )
          ],
        ),
      ),
    );
  }

  showAddReviewDialog(AddProductReview formData) {

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          insetPadding: EdgeInsets.symmetric(horizontal: 15),
          content: Wrap(
            children: [
              Form(
                key: _formKey,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.name,
                        autofocus: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return _globalService.getString(Const.REVIEW_TITLE_REQ);
                          }
                          return null;
                        },
                        onChanged: (value) => formData.title = value,
                        initialValue: formData.title ?? '',
                        textInputAction: TextInputAction.next,
                        decoration: inputDecor(Const.REVIEW_TITLE, true),
                      ),

                      TextFormField(
                        keyboardType: TextInputType.multiline,
                        autofocus: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return _globalService.getString(Const.REVIEW_TEXT_REQ);
                          }
                          return null;
                        },
                        minLines: 3,
                        maxLines: 3,
                        onChanged: (value) => formData.reviewText = value,
                        initialValue: formData.reviewText ?? '',
                        decoration: inputDecor(Const.REVIEW_TEXT, true),
                      ),

                      SizedBox(height: 15),
                      Text(_globalService.getString(Const.REVIEW_RATING)),
                      Divider(color: Colors.grey[700]),
                      RatingBar.builder(
                        ignoreGestures: false,
                        itemSize: 16,
                        initialRating: formData.rating.toDouble(),
                        direction: Axis.horizontal,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 1.5),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (value) {
                          formData.rating = value.round();
                        },
                      ),
                      SizedBox(height: 15),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: TextButton(
                            onPressed: () {
                              if(_formKey.currentState.validate()) {
                                Navigator.of(context).pop();
                                _bloc.postReview(productId, formData);
                              }
                            },
                            child: Text(GlobalService()
                                .getString(Const.REVIEW_SUBMIT_BTN)
                                .toUpperCase(),
                            ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class ProductReviewScreenArguments {
  num id;

  ProductReviewScreenArguments({
    @required this.id,
  });
}
