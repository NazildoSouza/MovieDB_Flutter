import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:moviedb_flutter/src/model/genres.dart';
import 'package:moviedb_flutter/src/service/api_options.dart';

part 'genre_event.dart';
part 'genre_state.dart';

class GenreBloc extends Bloc<GenreEvent, GenreState> {
  GenreBloc() : super(GenreLoading());

  final Dio _dio = Dio(kDioOptions);

  @override
  Stream<GenreState> mapEventToState(
    GenreEvent event,
  ) async* {
    if (event is GenreMovieEventStarted) {
      yield* _mapMovieEventStateToState();
    } else if (event is GenreSerieEventStarted) {
      yield* _mapSerieEventStateToState();
    }
  }

  Stream<GenreState> _mapMovieEventStateToState() async* {
    yield GenreLoading();
    try {
      final response = await _dio.get('/genre/movie/list');
      var genres = response.data['genres'] as List;
      List<Genre> genreList = genres.map((g) => Genre.fromJson(g)).toList();

      yield GenreLoaded(genreList);
    } on DioError catch (error) {
      if (error.response != null) {
        yield GenreError(error.response?.data['status_message']);
      } else {
        yield GenreError('Erro de conexão, verifique sua internet!!');
      }
    } on Exception catch (_) {
      yield GenreError('Erro desconhecido.');
    }
  }

  Stream<GenreState> _mapSerieEventStateToState() async* {
    yield GenreLoading();
    try {
      final response = await _dio.get('/genre/tv/list');
      var genres = response.data['genres'] as List;
      List<Genre> genreList = genres.map((g) => Genre.fromJson(g)).toList();

      yield GenreLoaded(genreList);
    } on DioError catch (error) {
      if (error.response != null) {
        yield GenreError(error.response?.data['status_message']);
      } else {
        yield GenreError('Erro de conexão, verifique sua internet!!');
      }
    } on Exception catch (_) {
      yield GenreError('Erro desconhecido.');
    }
  }
}
