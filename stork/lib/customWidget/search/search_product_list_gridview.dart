import 'package:flutter/material.dart';
import 'package:nopcart_flutter/bloc/search_bloc.dart';
import 'package:nopcart_flutter/customWidget/loading.dart';
import 'package:nopcart_flutter/customWidget/product%20box/product_box.dart';
import 'package:nopcart_flutter/model/ProductSummary.dart';
import 'package:nopcart_flutter/model/SearchResponse.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';

class SearchProductListGridView extends StatefulWidget {
  final SearchResponse productList;
  final String query;
  final String orderBy;
  final String price;
  final String specs;
  final String ms;

  SearchProductListGridView(this.productList, this.query, this.orderBy,
      this.price, this.specs, this.ms);

  @override
  _SearchProductListGridViewState createState() =>
      _SearchProductListGridViewState();
}

class _SearchProductListGridViewState extends State<SearchProductListGridView> {
  List<ProductSummary> productArray = [];
  ScrollController _scrollController = new ScrollController();
  SearchBloc _bloc = SearchBloc();
  int currentPage;
  int totalPages;
  bool loading = false;

  @override
  void dispose() {
    super.dispose();

    _bloc.dispose();
    _scrollController.removeListener(() {});
  }

  @override
  void initState() {
    super.initState();

    _bloc.searchQuery = widget.query;
    _bloc.orderBy = widget.orderBy;
    _bloc.price = widget.price;
    _bloc.specs = widget.specs;
    _bloc.ms = widget.ms;

    currentPage = widget.productList.data.catalogProductsModel.pageNumber + 1;
    totalPages = widget.productList.data.catalogProductsModel.totalPages;
    productArray.addAll(widget.productList.data.catalogProductsModel.products);

    _bloc.searchStream.listen((event) {
      if (event.status == Status.LOADING) {
        setState(() {
          loading = true;
        });
      }

      if (event.status == Status.COMPLETED) {
        setState(() {
          loading = false;
          if (currentPage != 1) {
            productArray.addAll(event.data.data.catalogProductsModel.products);
          }
        });
        // print('Length ${productArray.length}');

        currentPage++;
        // Disabling infinite scrolling and disposing bloc when last page is reached
        if (currentPage > totalPages) {
          _bloc.dispose();
          _scrollController.removeListener(() {});
        }
      }
    });

    _scrollController.addListener(() {
      // Listening while at the bottom of the page
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange &&
          currentPage <= totalPages) {
        _bloc.searchPageNumber = currentPage;

        _bloc.searchProduct();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GridView.builder(
        controller: _scrollController,
        itemBuilder: (context, index) {
          return ProductBox(productArray[index]);
        },
        itemCount: productArray.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (MediaQuery.of(context).size.width / 230).round() > 4 ? 4 : (MediaQuery.of(context).size.width / 230).round(),
          childAspectRatio: 175 / 300,
          mainAxisExtent: 230,),
        scrollDirection: Axis.vertical,
      ),
      if (loading)
        Loading(
          loadingMessage: '',
        ),
    ]);
  }
}
