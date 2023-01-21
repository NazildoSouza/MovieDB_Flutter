import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:moviedb_flutter/src/model/search.dart';
import 'package:moviedb_flutter/src/service/api_options.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchQueryIsEmpty('Digite uma Busca.')) {
    on<SearchEventQuery>(_mapSearchEventState);
  }

  SearchResponse? searchResponse;
  String query = '';

  Future<void> _mapSearchEventState(
      SearchEventQuery event, Emitter<SearchState> emit) async {
    this.query = event.query;
    BaseOptions options = kDioOptionsSearch(this.query, event.page);

    if (event.page == 1) emit(SearchLoading());

    try {
      if (event.query.isNotEmpty) {
        final response = await Dio(options).get('/search/multi');
        var responseData = response.data;
        SearchResponse searchResponseTemp =
            SearchResponse.fromJson(responseData);

        if (event.page == 1) {
          searchResponse = null;

          searchResponse = searchResponseTemp;
          if (searchResponseTemp.results!.length > 0) {
            emit(SearchLoaded(searchResponse: searchResponse!));
          } else {
            emit(SearchQueryIsEmpty('Sem Resultados para \'${event.query}\''));
          }
        } else {
          searchResponse!.results!.addAll(searchResponseTemp.results!);
          searchResponse!.page = event.page;
          emit(SearchLoaded(searchResponse: searchResponse!));
        }
      } else {
        searchResponse = null;
        emit(SearchQueryIsEmpty('Digite uma Busca.'));
      }
    } on DioError catch (error) {
      if (error.response != null) {
        emit(SearchError(error.response?.data['status_message']));
      } else {
        emit(SearchError('Erro de conexão, verifique sua internet!!'));
      }
    } on Exception catch (_) {
      emit(SearchError('Erro desconhecido.'));
    }
  }
}
