import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:moviedb_flutter/src/model/genres.dart';
import 'package:moviedb_flutter/src/service/api_options.dart';

part 'genre_event.dart';
part 'genre_state.dart';

class GenreBloc extends Bloc<GenreEvent, GenreState> {
  GenreBloc() : super(GenreLoading()) {
    on<GenreMovieEventStarted>(_mapMovieEventStateToState);
    on<GenreSerieEventStarted>(_mapSerieEventStateToState);
  }

  final Dio _dio = Dio(kDioOptions);

  Future<void> _mapMovieEventStateToState(
      GenreMovieEventStarted event, Emitter<GenreState> emit) async {
    emit(GenreLoading());
    try {
      final response = await _dio.get('/genre/movie/list');
      var genres = response.data['genres'] as List;
      List<Genre> genreList = genres.map((g) => Genre.fromJson(g)).toList();

      emit(GenreLoaded(genreList));
    } on DioError catch (error) {
      if (error.response != null) {
        emit(GenreError(error.response?.data['status_message']));
      } else {
        emit(GenreError('Erro de conexão, verifique sua internet!!'));
      }
    } on Exception catch (_) {
      emit(GenreError('Erro desconhecido.'));
    }
  }

  Future<void> _mapSerieEventStateToState(
      GenreSerieEventStarted event, Emitter<GenreState> emit) async {
    emit(GenreLoading());
    try {
      final response = await _dio.get('/genre/tv/list');
      var genres = response.data['genres'] as List;
      List<Genre> genreList = genres.map((g) => Genre.fromJson(g)).toList();

      emit(GenreLoaded(genreList));
    } on DioError catch (error) {
      if (error.response != null) {
        emit(GenreError(error.response?.data['status_message']));
      } else {
        emit(GenreError('Erro de conexão, verifique sua internet!!'));
      }
    } on Exception catch (_) {
      emit(GenreError('Erro desconhecido.'));
    }
  }
}
