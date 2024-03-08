import 'package:flutter/material.dart';
import 'package:nopcart_flutter/bloc/new_product_bloc.dart';
import 'package:nopcart_flutter/customWidget/CustomAppBar.dart';
import 'package:nopcart_flutter/customWidget/error.dart';
import 'package:nopcart_flutter/customWidget/loading.dart';
import 'package:nopcart_flutter/customWidget/product%20box/product_box.dart';
import 'package:nopcart_flutter/model/ProductSummary.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/Const.dart';

class NewProductsScreen extends StatefulWidget {
  static const routeName = '/new-product-screen';
  const NewProductsScreen({Key key}) : super(key: key);

  @override
  _NewProductsScreenState createState() => _NewProductsScreenState();
}

class _NewProductsScreenState extends State<NewProductsScreen> {
  GlobalService _globalService = GlobalService();
  NewProductBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = NewProductBloc();
    _bloc.fetchNewProducts();
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
        title: Text(_globalService.getString(Const.ACCOUNT_NEW_PRODUCTS)),
      ),
      body: StreamBuilder<ApiResponse<List<ProductSummary>>>(
        stream: _bloc.productStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Loading(loadingMessage: snapshot.data.message);
                break;
              case Status.COMPLETED:
                return rootWidget(snapshot.data.data ?? []);
                break;
              case Status.ERROR:
                return Error(
                  errorMessage: snapshot.data.message,
                  onRetryPressed: () => _bloc.fetchNewProducts(),
                );
                break;
            }
          }
          return SizedBox.shrink();
        }
      ),
    );
  }

  Widget rootWidget(List<ProductSummary> list) {
    return Stack(
      children: [
        GridView.builder(
          // controller: _scrollController,
          itemBuilder: (context, index) {
            return ProductBox(list[index]);
          },
          itemCount: list.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (MediaQuery.of(context).size.width / 230).round() > 4 ? 4 : (MediaQuery.of(context).size.width / 230).round(),
            childAspectRatio: 175 / 300,
            mainAxisExtent: 230,),
          scrollDirection: Axis.vertical,
        ),
        if(list.isEmpty)
          Align(
            alignment: Alignment.center,
            child: Text(_globalService.getString(Const.COMMON_NO_DATA)),
          ),
      ],
    );
  }
}
