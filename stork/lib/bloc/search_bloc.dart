import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:nopcart_flutter/bloc/base_bloc.dart';
import 'package:nopcart_flutter/model/SearchResponse.dart';
import 'package:nopcart_flutter/model/SearchSuggestionResponse.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';
import 'package:nopcart_flutter/repository/SearchRepository.dart';

class SearchBloc extends BaseBloc {
  SearchRepository _searchRepository;
  StreamController _scSearch, _scAdvSearch;

  StreamSink<ApiResponse<SearchResponse>> get searchSink => _scSearch.sink;
  Stream<ApiResponse<SearchResponse>> get searchStream => _scSearch.stream;

  StreamSink<ApiResponse<SearchData>> get advSearchSink => _scAdvSearch.sink;
  Stream<ApiResponse<SearchData>> get advSearchStream => _scAdvSearch.stream;

  SearchData advSearchModel;

  String searchQuery = '';
  int searchPageNumber = 0;
  String orderBy;
  String price;
  String specs;
  String ms;

  SearchBloc() {
    _searchRepository = SearchRepository();
    _scSearch = StreamController<ApiResponse<SearchResponse>>();
    _scAdvSearch = StreamController<ApiResponse<SearchData>>();
  }

  @override
  dispose() {
    _scSearch.close();
    _scAdvSearch.close();
  }

  searchProduct() async {
    searchSink.add(ApiResponse.loading());

    try {
      Map<String, String> queryParams = {
        'q': searchQuery,
        'PageNumber': searchPageNumber.toString(),
        'PageSize': kIsWeb ? '24' : '9',
        'orderby': orderBy,
        'price': price,
        'specs': specs,
        'ms': ms,
      };

      print(kIsWeb);
      print(queryParams['PageSize']);

      if(advSearchModel?.advSearchSelected == true) {
        queryParams['advs'] = advSearchModel.advSearchSelected.toString();
        queryParams['sid'] = advSearchModel.searchInDescription.toString();
        queryParams['isc'] = advSearchModel.searchInSubcategory.toString();
        queryParams['cid'] = advSearchModel.categoryId.toString();
        queryParams['mid'] = advSearchModel.manufacturerId.toString();
        queryParams['vid'] = advSearchModel.vendorId.toString();
      }
      SearchResponse response =
          await _searchRepository.searchProduct(queryParams);
      if(searchQuery.isEmpty) {
        advSearchModel = response.data;
        advSearchSink.add(ApiResponse.completed(response.data));
      }
      searchSink.add(ApiResponse.completed(response));
    } catch (e) {
      searchSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<List<SearchSuggestionData>> fetchSuggestions(String query) async {
    try {
      SearchSuggestionResponse response = await
        _searchRepository.fetchSuggestions(query);

      return response?.data ?? [];
    } catch (e) {
      // print(e.toString());
      return [];
    }
  }
}
