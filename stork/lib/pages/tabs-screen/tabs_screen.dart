import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:nopcart_flutter/bloc/category_tree/category_tree_bloc.dart';
import 'package:nopcart_flutter/bloc/search_bloc.dart';
import 'package:nopcart_flutter/customWidget/CustomAppBar.dart';
import 'package:nopcart_flutter/customWidget/cached_image.dart';
import 'package:nopcart_flutter/customWidget/category_tree.dart';
import 'package:nopcart_flutter/customWidget/home/horizontal_categories.dart';
import 'package:nopcart_flutter/model/SearchResponse.dart';
import 'package:nopcart_flutter/model/UserLoginResponse.dart';
import 'package:nopcart_flutter/model/category_tree/CategoryTreeResponse.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/pages/account/account_screen.dart';
import 'package:nopcart_flutter/pages/account/config_screen.dart';
import 'package:nopcart_flutter/pages/account/login_screen.dart';
import 'package:nopcart_flutter/pages/account/wishlist_screen.dart';
import 'package:nopcart_flutter/pages/app_bar_cart.dart';
import 'package:nopcart_flutter/pages/app_bar_wallet.dart';
import 'package:nopcart_flutter/pages/categories/categories_screen.dart';
import 'package:nopcart_flutter/pages/feeds_screen.dart';
import 'package:nopcart_flutter/pages/home/home_screen.dart';
import 'package:nopcart_flutter/pages/more/barcode_scanner_screen.dart';
import 'package:nopcart_flutter/pages/more/more_screen.dart';
import 'package:nopcart_flutter/pages/product-list/product_list_screen.dart';
import 'package:nopcart_flutter/pages/product/product_details_screen.dart';
import 'package:nopcart_flutter/pages/search/search_screen.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/Const.dart';
import 'package:nopcart_flutter/utils/nop_cart_icons.dart';
import 'package:nopcart_flutter/utils/shared_pref.dart';
import 'package:nopcart_flutter/utils/utility.dart';

import '../../model/SearchSuggestionResponse.dart';
import '../../utils/GetBy.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/tabs-screen';

  final String productId;
  final String categoryId;

  const TabsScreen({Key key, this.productId, this.categoryId}) : super(key: key);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  Widget actionBar = Container();
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;
  GlobalService _globalService = GlobalService();
  ListQueue<int> _navigationQueue = ListQueue(0);
  TextEditingController editingController = TextEditingController();
  SearchResponse searchResponse;

  CategoryTreeBloc _bloc;
  SearchBloc _blocSearch;
  bool promoLaunched = false;


  ApiResponse<CategoryTreeResponse> snapshot;
  var loaded = false;

  @override
  void initState() {
    super.initState();
    actionBar = Container();

    _blocSearch = SearchBloc();

    _blocSearch.searchQuery = editingController.text;
    _blocSearch.searchPageNumber = 1;
    _blocSearch.orderBy = '';
    _blocSearch.price = '';
    _blocSearch.specs = '';
    _blocSearch.ms = '';

    _blocSearch.searchStream.listen((event) {
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
    _blocSearch.searchProduct();

    _pages = [
      {
        'page': HomeScreen(categories: []),
        'title': 'Home',
      },
      {
        'page': WishListScreen(),
        'title': 'Wishlist',
      },
      {
        'page': Container(),
        'title': 'Menu',
      },
      {
        'page': FeedsScreen(),
        'title': 'Feeds',
      },
      {
        'page': AccountScreen(),
        'title': 'Account',
      },
    ];

    _bloc = CategoryTreeBloc();
    _bloc.fetchCategoryTree();

    _bloc.categoryTreeStream.listen((event) {
      // print(event);
      if (event.status == Status.COMPLETED) {
        setState(() {
          snapshot = event;
          loaded = true;
          actionBar = HorizontalCategories(categories: snapshot?.data?.data ?? []);
          _pages = [
            {
              'page': HomeScreen(categories: snapshot?.data?.data ?? []),
              'title': 'Home',
            },
            {
              'page': WishListScreen(),
              'title': 'Wishlist',
            },
            {
              'page': CategoriesScreen(snapshot),
              'title': 'Menu',
            },
            {
              'page': FeedsScreen(),
              'title': 'Feeds',
            },
            {
              'page': AccountScreen(),
              'title': 'Account',
            },
          ];
        });
      }
    });
  }

  void _selectPage(int index) {
    if(_selectedPageIndex == index)
      return;

    if (index == 4 && !_globalService.isLoggedIn()) {
      Navigator.pushNamed(context, LoginScreen.routeName);
      return;
    }

    setState(() {
      _navigationQueue.removeWhere((element) => element == index);
      _navigationQueue.addLast(index);
      _selectedPageIndex = index;
    });
  }
  void performSearch(String query) {
    if (query.isNotEmpty && query.length > 2) {
      _blocSearch.searchQuery = query;
      _blocSearch.searchPageNumber = 1;
      _blocSearch.orderBy = '';
      _blocSearch.price = '';
      _blocSearch.specs = '';
      _blocSearch.ms = '';

      _blocSearch.searchProduct();
    } else {
      showSnackBar(
          context,
          _globalService.getStringWithNumber(Const.SEARCH_QUERY_LENGTH, 3),
          false);
    }
  }


  @override
  Widget build(BuildContext context) {
    setState(() {
      if (!promoLaunched) {
        Future.delayed(Duration.zero, () {
          promoLaunched = true;

          if (widget.productId.isNotEmpty) {
            Navigator.of(context).pushNamed(
                ProductDetailsPage.routeName,
                arguments: ProductDetailsScreenArguments(
                    id: int.parse(widget.productId),
                    name: 'Promotion'
                )
            );
          }
          if (widget.categoryId.isNotEmpty)
            Navigator.of(context).pushNamed(
                ProductListScreen.routeName,
                arguments: ProductListScreenArguments(
                    id: int.parse(widget.categoryId),
                    type: GetBy.CATEGORY,
                    name: 'Promotion'
                )
            );
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _selectedPageIndex == 0 ? Colors.white : Colors.blue,
        title: _selectedPageIndex == 0
            ? SizedBox(
                height: 40,
                child: Image.asset(
                  'assets/app_logo.png',
                  fit: BoxFit.fill,
                ),
              )
            : Text(
                _pages[_selectedPageIndex]['title'],
                style: Theme.of(context).appBarTheme.titleTextStyle,
              ),
        centerTitle: false,
        leading: _selectedPageIndex != 0
            ? InkWell(
                onTap: () {
                  setState(() {
                    _selectedPageIndex = 0;
                  });
                },
                child: Icon(Icons.arrow_back),
              )
            : null,
        leadingWidth: _selectedPageIndex == 0 ? 0 : null,
        actions: [0, 1].contains(_selectedPageIndex)
            ? [
            AppBarCart(color: _selectedPageIndex == 1 ? Colors.white : Colors.black),
            AppBarWallet(color: _selectedPageIndex == 1 ? Colors.white : Colors.black),
          ]
          : null,
        bottom: _selectedPageIndex == 0
          ? AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 100,
          automaticallyImplyLeading: false,
          title: Column(
            children: [
              SizedBox(
                height:50,
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
                      onSubmitted: (value) {
                        if (value.isNotEmpty && value.length > 2) {
                          Navigator.of(context).pushNamed(
                              SearchScreen.routeName,
                              arguments: SearchScreenArguments(
                                  search: value
                              )
                          );
                        } else {
                          showSnackBar(
                              context,
                              _globalService.getStringWithNumber(Const.SEARCH_QUERY_LENGTH, 3),
                              false);
                        }
                      },
                    ),
                    hideOnEmpty: true,
                    debounceDuration: Duration(milliseconds: 350),
                    suggestionsCallback: (pattern) async {
                      if(pattern.length < 3) return [];
                      return await _blocSearch.fetchSuggestions(pattern);
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
                )
              ),
              actionBar,
            ],
          ),
        )
        : _selectedPageIndex == 4
        ? AppBar(
          toolbarHeight: 50,
          title: Row(
            children: [
              FutureBuilder<CustomerInfo>(
                future: SessionData().getCustomerInfo(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person_outline),
                        ),

                          Container(
                            width: 10,
                          ),
                          Text(snapshot.data.username ?? snapshot.data.email,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                  fontSize: 16,
                                  color: Colors.white,
                                  letterSpacing: 1.2)),
                      ],
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
              Spacer(),
              IconButton(onPressed: () {
                Navigator.pushNamed(context, ConfigScreen.routeName);
              }, icon: Icon(Icons.settings_outlined))
            ],
          ),
        )
        : null,
      ),
      // drawer: _selectedPageIndex == 0
      //     ? Drawer(
      //         child: Column(
      //           children: [
      //             Container(
      //               alignment: Alignment.bottomCenter,
      //               padding: EdgeInsets.only(bottom: 15.0),
      //               color: isDarkThemeEnabled(context) ? Colors.grey[800] : Colors.grey[300],
      //               height: MediaQuery.of(context).orientation == Orientation.portrait ? 105.0 : 57.0,
      //               child: Text(
      //                 '${_globalService.getString(Const.HOME_NAV_CATEGORY)}',
      //                 style: TextStyle(
      //                   fontSize: 20,
      //                   fontWeight: FontWeight.bold,
      //                 ),
      //               ),
      //             ),
      //             if (loaded) CategoryTree(snapshot),
      //           ],
      //         ),
      //       )
      //     : null,
      body: Container(
        constraints: BoxConstraints(maxWidth: 5000),
        child: WillPopScope(
          onWillPop: () async {
            if(_navigationQueue.isNotEmpty) {
              _navigationQueue.removeLast();
              int position = _navigationQueue.isEmpty ? 0 : _navigationQueue.last;
              _selectPage(position);
            }
            return _navigationQueue.isEmpty;
          },
          child: IndexedStack(
            index: _selectedPageIndex,
            children: _pages.map<Widget>((e) => e['page']).toList(),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(_selectedPageIndex == 0 ? Icons.home : Icons.home_outlined),
            label: _pages[0]['title'],
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                Icon(_selectedPageIndex == 1 ? Icons.favorite : Icons.favorite_outline),
              ],
            ),
            label: _pages[1]['title'],
          ),
          BottomNavigationBarItem(
            icon: Icon(
                _selectedPageIndex == 2 ? Icons.menu_outlined : Icons.menu_outlined,
            ),
            label: _pages[2]['title'],
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedPageIndex == 3 ? Icons.notifications : Icons.notifications_outlined),
            label: _pages[3]['title'],
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedPageIndex == 4 ? Icons.person : Icons.person_outlined),
            label: _pages[4]['title'],

          ),
        ],
      ),
    );
  }
}