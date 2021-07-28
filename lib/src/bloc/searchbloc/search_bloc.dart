import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:moviedb_flutter/src/model/search.dart';
import 'package:moviedb_flutter/src/service/api_options.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchQueryIsEmpty('Digite uma Busca.'));

  SearchResponse? searchResponse;
  String query = '';

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SearchEventQuery) {
      yield* _mapSearchEventState(event.query, event.page);
    }
  }

  Stream<SearchState> _mapSearchEventState(String query, int page) async* {
    this.query = query;
    BaseOptions options = kDioOptionsSearch(this.query, page);

    if (page == 1) yield SearchLoading();

    try {
      if (query.isNotEmpty) {
        final response = await Dio(options).get('/search/multi');
        var responseData = response.data;
        SearchResponse searchResponseTemp =
            SearchResponse.fromJson(responseData);

        if (page == 1) {
          searchResponse = null;

          searchResponse = searchResponseTemp;
          if (searchResponseTemp.results!.length > 0) {
            yield SearchLoaded(searchResponse: searchResponse!);
          } else {
            yield SearchQueryIsEmpty('Sem Resultados para \'$query\'');
          }
        } else {
          searchResponse!.results!.addAll(searchResponseTemp.results!);
          searchResponse!.page = page;
          yield SearchLoaded(searchResponse: searchResponse!);
        }
      } else {
        searchResponse = null;
        yield SearchQueryIsEmpty('Digite uma Busca.');
      }
    } on DioError catch (error) {
      if (error.response != null) {
        yield SearchError(error.response?.data['status_message']);
      } else {
        yield SearchError('Erro de conexão, verifique sua internet!!');
      }
    } on Exception catch (_) {
      yield SearchError('Erro desconhecido.');
    }
  }
}
