import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:moviedb_flutter/src/model/serie.dart';
import 'package:moviedb_flutter/src/service/api_options.dart';

part 'serie_event.dart';
part 'serie_state.dart';

class SerieBloc extends Bloc<SerieEvent, SerieState> {
  SerieBloc() : super(SerieLoading()) {
    on<SerieEventAiringToday>(_mapSerieEventAiringToday);
    on<SerieEventOnAir>(_mapSerieEventOnAir);
    on<SerieEventTopRated>(_mapSerieEventTopRated);
    on<SerieEventPopular>(_mapSerieEventPopular);
    on<SerieEventGenre>(_mapGenreEventState);
  }

  final Dio _dio = Dio(kDioOptions);
  SerieResponse? serieResponse;
  int genreId = 0;

  // @override
  // Stream<SerieState> mapEventToState(
  //   SerieEvent event,
  // ) async* {
  //   if (event is SerieEventAiringToday) {
  //     yield* _mapSerieEventState('airing_today', event.page);
  //   } else if (event is SerieEventOnAir) {
  //     yield* _mapSerieEventState('on_the_air', event.page);
  //   } else if (event is SerieEventTopRated) {
  //     yield* _mapSerieEventState('top_rated', event.page);
  //   } else if (event is SerieEventPopular) {
  //     yield* _mapSerieEventState('popular', event.page);
  //   } else if (event is SerieEventGenre) {
  //     yield* _mapGenreEventState(event.genreId, event.page);
  //   }
  // }

  Future<void> _mapSerieEventAiringToday(
      SerieEventAiringToday event, Emitter<SerieState> emit) async {
    try {
      final response =
          await _dio.get('/tv/${event.endPoint}?page=${event.page}');
      var responseData = response.data;
      SerieResponse serieResponseTemp = SerieResponse.fromJson(responseData);

      if (event.page == 1) {
        serieResponse = serieResponseTemp;
        emit(SerieLoaded(serieResponse: serieResponse!));
      } else {
        serieResponse!.results!.addAll(serieResponseTemp.results!);
        serieResponse!.page = event.page;
        emit(SerieLoaded(serieResponse: serieResponse!));
      }
    } on DioException catch (error) {
      if (error.response != null) {
        emit(SerieError(error.response?.data['status_message']));
      } else {
        emit(SerieError('Erro de conexão, verifique sua internet!!'));
      }
    } on Exception catch (_) {
      emit(SerieError('Erro desconhecido.'));
    }
  }

  Future<void> _mapSerieEventOnAir(
      SerieEventOnAir event, Emitter<SerieState> emit) async {
    try {
      final response =
          await _dio.get('/tv/${event.endPoint}?page=${event.page}');
      var responseData = response.data;
      SerieResponse serieResponseTemp = SerieResponse.fromJson(responseData);

      if (event.page == 1) {
        serieResponse = serieResponseTemp;
        emit(SerieLoaded(serieResponse: serieResponse!));
      } else {
        serieResponse!.results!.addAll(serieResponseTemp.results!);
        serieResponse!.page = event.page;
        emit(SerieLoaded(serieResponse: serieResponse!));
      }
    } on DioException catch (error) {
      if (error.response != null) {
        emit(SerieError(error.response?.data['status_message']));
      } else {
        emit(SerieError('Erro de conexão, verifique sua internet!!'));
      }
    } on Exception catch (_) {
      emit(SerieError('Erro desconhecido.'));
    }
  }

  Future<void> _mapSerieEventTopRated(
      SerieEventTopRated event, Emitter<SerieState> emit) async {
    try {
      final response =
          await _dio.get('/tv/${event.endPoint}?page=${event.page}');
      var responseData = response.data;
      SerieResponse serieResponseTemp = SerieResponse.fromJson(responseData);

      if (event.page == 1) {
        serieResponse = serieResponseTemp;
        emit(SerieLoaded(serieResponse: serieResponse!));
      } else {
        serieResponse!.results!.addAll(serieResponseTemp.results!);
        serieResponse!.page = event.page;
        emit(SerieLoaded(serieResponse: serieResponse!));
      }
    } on DioException catch (error) {
      if (error.response != null) {
        emit(SerieError(error.response?.data['status_message']));
      } else {
        emit(SerieError('Erro de conexão, verifique sua internet!!'));
      }
    } on Exception catch (_) {
      emit(SerieError('Erro desconhecido.'));
    }
  }

  Future<void> _mapSerieEventPopular(
      SerieEventPopular event, Emitter<SerieState> emit) async {
    try {
      final response =
          await _dio.get('/tv/${event.endPoint}?page=${event.page}');
      var responseData = response.data;
      SerieResponse serieResponseTemp = SerieResponse.fromJson(responseData);

      if (event.page == 1) {
        serieResponse = serieResponseTemp;
        emit(SerieLoaded(serieResponse: serieResponse!));
      } else {
        serieResponse!.results!.addAll(serieResponseTemp.results!);
        serieResponse!.page = event.page;
        emit(SerieLoaded(serieResponse: serieResponse!));
      }
    } on DioException catch (error) {
      if (error.response != null) {
        emit(SerieError(error.response?.data['status_message']));
      } else {
        emit(SerieError('Erro de conexão, verifique sua internet!!'));
      }
    } on Exception catch (_) {
      emit(SerieError('Erro desconhecido.'));
    }
  }

  Future<void> _mapGenreEventState(
      SerieEventGenre event, Emitter<SerieState> emit) async {
    if (this.genreId != event.genreId) {
      emit(SerieLoading());
      serieResponse = null;
    }

    try {
      final response = await _dio
          .get('/discover/tv?with_genres=${event.genreId}&page=${event.page}');
      var responseData = response.data;
      SerieResponse movieResponseTemp = SerieResponse.fromJson(responseData);
      if (serieResponse == null && event.page == 1) {
        this.genreId = event.genreId;
        serieResponse = movieResponseTemp;
        emit(SerieLoaded(serieResponse: serieResponse!));
      } else {
        serieResponse!.results!.addAll(movieResponseTemp.results!);
        serieResponse!.page = event.page;
        emit(SerieLoaded(serieResponse: serieResponse!));
      }
    } on DioException catch (error) {
      if (error.response != null) {
        emit(SerieError(error.response?.data['status_message']));
      } else {
        emit(SerieError('Erro de conexão, verifique sua internet!!'));
      }
    } on Exception catch (_) {
      emit(SerieError('Erro desconhecido.'));
    }
  }
}
