import 'package:flutter/material.dart';
import 'package:nopcart_flutter/bloc/product_list/product_list_bloc.dart';
import 'package:nopcart_flutter/customWidget/cached_image.dart';
import 'package:nopcart_flutter/customWidget/product%20box/product_box.dart';
import 'package:nopcart_flutter/model/ProductSummary.dart';
import 'package:nopcart_flutter/model/product_list/ProductListResponse.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';

class ProductListGridView extends StatefulWidget {
  final String type;
  final int id;
  final ProductListResponse productList;
  final String orderBy;
  final String price;
  final String specs;
  final String ms;
  final String bannerUrl;

  ProductListGridView(this.type, this.id, this.productList, this.orderBy,
      this.price, this.specs, this.ms, this.bannerUrl,);

  @override
  _ProductListGridViewState createState() => _ProductListGridViewState();
}

class _ProductListGridViewState extends State<ProductListGridView> {
  List<ProductSummary> productArray = [];
  ScrollController _scrollController = new ScrollController();
  ProductListBloc _bloc = ProductListBloc();
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

    currentPage = widget.productList.data.catalogProductsModel.pageNumber + 1;
    totalPages = widget.productList.data.catalogProductsModel.totalPages;
    productArray.addAll([...widget.productList.data.featuredProducts, ...widget.productList.data.catalogProductsModel.products]);

    _bloc.prodListStream.listen((event) {
      if (event.status == Status.LOADING) {
        setState(() {
          loading = true;
        });
      }

      if (event.status == Status.COMPLETED) {
        setState(() {
          loading = false;
          if (currentPage != 1) {
            productArray.addAll([...event.data.data.featuredProducts, ...event.data.data.catalogProductsModel.products]);
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
        _bloc.type = widget.type;
        _bloc.categoryId = widget.id;
        _bloc.pageNumber = currentPage;
        _bloc.orderBy = widget.orderBy;
        _bloc.price = widget.price;
        _bloc.specs = widget.specs;
        _bloc.ms = widget.ms;
        _bloc.fetchProductList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        if(widget.bannerUrl?.isNotEmpty == true)
          SliverToBoxAdapter(
            child: CpImage(
              url: widget.bannerUrl,
              landscapePlaceholder: true,
            ),
          ),
        SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) => ProductBox(productArray[index]),
            childCount: productArray.length,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (MediaQuery.of(context).size.width / 230).round() > 4 ? 4 : (MediaQuery.of(context).size.width / 230).round(),
            childAspectRatio: 175 / 300,
            mainAxisExtent: 230,
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: 40,
            child: Center(
              child: loading
                  ? CircularProgressIndicator.adaptive(strokeWidth: 2.0)
                  : SizedBox(height: 40.0),
            ),
          ),
        ),
      ],
    );
  }
}
