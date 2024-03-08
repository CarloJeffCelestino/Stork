import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:nopcart_flutter/bloc/search_bloc.dart';
import 'package:nopcart_flutter/customWidget/AdvSearchBottomSheet.dart';
import 'package:nopcart_flutter/customWidget/CustomAppBar.dart';
import 'package:nopcart_flutter/customWidget/loading.dart';
import 'package:nopcart_flutter/customWidget/search/search_filter.dart';
import 'package:nopcart_flutter/customWidget/search/search_product_list_gridview.dart';
import 'package:nopcart_flutter/model/SearchResponse.dart';
import 'package:nopcart_flutter/model/SearchSuggestionResponse.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/pages/app_bar_cart.dart';
import 'package:nopcart_flutter/pages/app_bar_wallet.dart';
import 'package:nopcart_flutter/pages/more/barcode_scanner_screen.dart';
import 'package:nopcart_flutter/pages/product/product_details_screen.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/Const.dart';
import 'package:nopcart_flutter/utils/styles.dart';
import 'package:nopcart_flutter/utils/utility.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';
  final SearchScreenArguments screenArgument;

  SearchScreen(this.screenArgument);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController editingController = TextEditingController();
  SearchResponse searchResponse;
  GlobalService _globalService = GlobalService();
  SearchBloc _bloc;
  var loaded = false;
  String orderBy;

  @override
  void initState() {
    super.initState();

    editingController.text = widget.screenArgument.search;

    _bloc = SearchBloc();

    _bloc.searchQuery = editingController.text;
    _bloc.searchPageNumber = 1;
    _bloc.orderBy = '';
    _bloc.price = '';
    _bloc.specs = '';
    _bloc.ms = '';

    _bloc.searchStream.listen((event) {
      setState(() {
        loaded = false;
      });

      if (event.status == Status.COMPLETED) {
        setState(() {
          searchResponse = event.data;
          loaded = true;
        });

      }
    });

    // Get advanced search model
    _bloc.searchProduct();
  }

  @override
  void dispose() {
    super.dispose();
    _bloc?.dispose();
  }

  refetchProductList() {
    _bloc.searchPageNumber = 1;
    _bloc.orderBy = orderBy;

    _bloc.searchProduct();
  }

  bool hasFilterOption() {
    if (loaded &&
        ((searchResponse
                    .data.catalogProductsModel.specificationFilter.enabled &&
                searchResponse.data.catalogProductsModel.specificationFilter
                        .attributes.length >
                    0) ||
            (searchResponse
                    .data.catalogProductsModel.manufacturerFilter.enabled &&
                searchResponse.data.catalogProductsModel.manufacturerFilter
                        .manufacturers.length >
                    0) ||
            (searchResponse
                .data.catalogProductsModel.priceRangeFilter.enabled)) &&
        searchResponse.data.catalogProductsModel.products.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  bool hasSortOption() {
    if (loaded &&
        searchResponse.data.catalogProductsModel.allowProductSorting &&
        searchResponse.data.catalogProductsModel.allowProductSorting &&
        searchResponse.data.catalogProductsModel.products.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  openFilterOptions() {
    showDialog(
        context: context,
        builder: (BuildContext bc) {
          return SearchFilter(searchResponse.data.catalogProductsModel, _bloc);
        });
  }

  openSortOptions() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: ListView.builder(
                itemCount: searchResponse
                    .data.catalogProductsModel.availableSortOptions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      // Close bottom modal sheet
                      Navigator.pop(context);
                      // Reload data with selected sort options
                      orderBy = searchResponse.data.catalogProductsModel
                          .availableSortOptions[index].value;
                      refetchProductList();
                    },
                    title: Text(
                      searchResponse.data.catalogProductsModel
                          .availableSortOptions[index].text,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: searchResponse.data.catalogProductsModel
                            .availableSortOptions[index].selected
                            ? Theme.of(context).primaryColor
                            : Styles.textColor(context),
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                    ),
                  );
                }),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: Text(
          'Search',
        ),
        centerTitle: false,
        actions: [
          AppBarCart(color: Colors.white),
          AppBarWallet(color: Colors.white),
        ],
        bottom: AppBar(
          backgroundColor: Colors.blue,
          toolbarHeight: 60,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Column(
            children: [
              SizedBox(
                height: 50,
                child: SingleChildScrollView(
                  child: TypeAheadFormField<SearchSuggestionData>(
                    textFieldConfiguration: TextFieldConfiguration(
                      autofocus: false,
                      controller: editingController,
                      textInputAction: TextInputAction.search,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: _globalService.getString(Const.TITLE_SEARCH),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.camera_alt),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              BarcodeScannerScreen.routeName,
                            );
                          },
                        )
                      ),
                      onSubmitted: (value) => performSearch(value),
                    ),
                    hideOnEmpty: true,
                    debounceDuration: Duration(milliseconds: 350),
                    suggestionsCallback: (pattern) async {
                      if(pattern.length < 3) return [];
                      return await _bloc.fetchSuggestions(pattern);
                    },
                    itemBuilder: (context, suggestion) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(suggestion.label ?? ''),
                      );
                    },
                    noItemsFoundBuilder: (_) => SizedBox.shrink(),
                    hideOnLoading: false,
                    onSuggestionSelected: (suggestion) {
                      Navigator.pushNamed(
                        context,
                        ProductDetailsPage.routeName,
                        arguments: ProductDetailsScreenArguments(
                          id: suggestion.productId,
                          name: suggestion.label,
                        ),
                      );
                    },
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              StreamBuilder<ApiResponse<SearchData>>(
                  stream: _bloc.advSearchStream,
                  builder: (context, snapshot) {
                    if(snapshot.hasData && snapshot.data.status == Status.COMPLETED)
                      return OutlinedButton.icon(
                        icon: _bloc.advSearchModel.advSearchSelected
                            ? Icon(Icons.check_sharp) : SizedBox.shrink(),
                        onPressed: () => showAdvSearchOptions(),
                        label: Text(_globalService.getString(Const.ADVANCED_SEARCH)),
                      );
                    return SizedBox.shrink();
                  }
              ),
              if (hasFilterOption() || hasSortOption())
                Material(
                  elevation: 4,
                  child: Container(
                    height: 40,
                    child: Row(
                      children: [
                        if (hasFilterOption())
                          Flexible(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                openFilterOptions();
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('${_globalService.getString(Const.FILTER)}'),
                                    Spacer(),
                                    Icon(
                                      Icons.filter_alt_rounded,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        SizedBox(
                          width: .5,
                          child: Container(
                            color: Colors.grey,
                          ),
                        ),
                        if (hasSortOption())
                          Flexible(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                openSortOptions();
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        '${_globalService.getString(Const.CATALOG_ORDER_BY)}'),
                                    Spacer(),
                                    Icon(
                                      Icons.sort,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

              if (loaded &&
                  searchResponse.data.catalogProductsModel.products.length > 0)
                Expanded(
                  child: _globalService.centerWidgets(SearchProductListGridView(
                      searchResponse,
                      _bloc.searchQuery,
                      orderBy,
                      _bloc.price,
                      _bloc.specs,
                      _bloc.ms),
                  )),
            ],
          ),
          if (loaded && _bloc.searchQuery.isNotEmpty &&
              searchResponse.data.catalogProductsModel.products.length == 0)
            Center(
              child: Text(searchResponse.data.catalogProductsModel.noResultMessage ?? ''),
            ),
          if (!loaded)
            Loading(
              loadingMessage: '',
            ),
        ]
      )
    );
  }

  void performSearch(String query) {
    if (query.isNotEmpty && query.length > 2) {
      _bloc.searchQuery = query;
      _bloc.searchPageNumber = 1;
      _bloc.orderBy = '';
      _bloc.price = '';
      _bloc.specs = '';
      _bloc.ms = '';

      _bloc.searchProduct();
    } else {
      showSnackBar(
          context,
          _globalService.getStringWithNumber(Const.SEARCH_QUERY_LENGTH, 3),
          false);
    }
  }

  void showAdvSearchOptions() {
    removeFocusFromInputField(context);
    var model = _bloc.advSearchModel;
    var isAvdSearchEnabled = _bloc.advSearchModel.advSearchSelected;

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return AdvSearchBottomSheet(model);
        }
    ).whenComplete(() {
      // update advanced search button icon
      if(_bloc.advSearchModel.advSearchSelected != isAvdSearchEnabled)
        setState(() {});
    });
  }
}

class SearchScreenArguments {
  String search;

  SearchScreenArguments({this.search});
}

