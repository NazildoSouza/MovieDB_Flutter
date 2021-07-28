import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:moviedb_flutter/src/model/serie.dart';
import 'package:moviedb_flutter/src/service/api_options.dart';

part 'serie_event.dart';
part 'serie_state.dart';

class SerieBloc extends Bloc<SerieEvent, SerieState> {
  SerieBloc() : super(SerieLoading());

  final Dio _dio = Dio(kDioOptions);
  SerieResponse? serieResponse;
  int genreId = 0;

  @override
  Stream<SerieState> mapEventToState(
    SerieEvent event,
  ) async* {
    if (event is SerieEventAiringToday) {
      yield* _mapSerieEventState('airing_today', event.page);
    } else if (event is SerieEventOnAir) {
      yield* _mapSerieEventState('on_the_air', event.page);
    } else if (event is SerieEventTopRated) {
      yield* _mapSerieEventState('top_rated', event.page);
    } else if (event is SerieEventPopular) {
      yield* _mapSerieEventState('popular', event.page);
    } else if (event is SerieEventGenre) {
      yield* _mapGenreEventState(event.genreId, event.page);
    }
  }

  Stream<SerieState> _mapSerieEventState(String endPoint, int page) async* {
    try {
      final response = await _dio.get('/tv/$endPoint?page=$page');
      var responseData = response.data;
      SerieResponse serieResponseTemp = SerieResponse.fromJson(responseData);

      if (page == 1) {
        serieResponse = serieResponseTemp;
        yield SerieLoaded(serieResponse: serieResponse!);
      } else {
        serieResponse!.results!.addAll(serieResponseTemp.results!);
        serieResponse!.page = page;
        yield SerieLoaded(serieResponse: serieResponse!);
      }
    } on DioError catch (error) {
      if (error.response != null) {
        yield SerieError(error.response?.data['status_message']);
      } else {
        yield SerieError('Erro de conexão, verifique sua internet!!');
      }
    } on Exception catch (_) {
      yield SerieError('Erro desconhecido.');
    }
  }

  Stream<SerieState> _mapGenreEventState(int genreId, int page) async* {
    if (this.genreId != genreId) {
      yield SerieLoading();
      serieResponse = null;
    }

    try {
      final response =
          await _dio.get('/discover/tv?with_genres=$genreId&page=$page');
      var responseData = response.data;
      SerieResponse movieResponseTemp = SerieResponse.fromJson(responseData);
      if (serieResponse == null && page == 1) {
        this.genreId = genreId;
        serieResponse = movieResponseTemp;
        yield SerieLoaded(serieResponse: serieResponse!);
      } else {
        serieResponse!.results!.addAll(movieResponseTemp.results!);
        serieResponse!.page = page;
        yield SerieLoaded(serieResponse: serieResponse!);
      }
    } on DioError catch (error) {
      if (error.response != null) {
        yield SerieError(error.response?.data['status_message']);
      } else {
        yield SerieError('Erro de conexão, verifique sua internet!!');
      }
    } on Exception catch (_) {
      yield SerieError('Erro desconhecido.');
    }
  }
}
