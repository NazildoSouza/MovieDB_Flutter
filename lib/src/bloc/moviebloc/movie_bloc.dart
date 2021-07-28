import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:moviedb_flutter/src/model/movie.dart';
import 'package:moviedb_flutter/src/service/api_options.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  MovieBloc() : super(MovieLoading());

  final Dio _dio = Dio(kDioOptions);
  MovieResponse? movieResponse;
  int genreId = 0;

  @override
  Stream<MovieState> mapEventToState(
    MovieEvent event,
  ) async* {
    if (event is MovieEventStarted) {
      yield* _mapMovieEventState('now_playing', event.page);
    } else if (event is MovieEventGenre) {
      yield* _mapGenreEventState(event.genreId, event.page);
    } else if (event is MovieEventNowPlaying) {
      yield* _mapMovieEventState('now_playing', event.page);
    } else if (event is MovieEventUpcoming) {
      yield* _mapMovieEventState('upcoming', event.page);
    } else if (event is MovieEventTopRated) {
      yield* _mapMovieEventState('top_rated', event.page);
    } else if (event is MovieEventPopular) {
      yield* _mapMovieEventState('popular', event.page);
    }
  }

  Stream<MovieState> _mapMovieEventState(String endPoint, int page) async* {
    try {
      final response = await _dio.get('/movie/$endPoint?page=$page');
      var responseData = response.data;
      MovieResponse movieResponseTemp = MovieResponse.fromJson(responseData);

      if (page == 1) {
        movieResponse = movieResponseTemp;
        yield MovieLoaded(movieResponse: movieResponse!);
      } else {
        movieResponse!.results!.addAll(movieResponseTemp.results!);
        movieResponse!.page = page;
        yield MovieLoaded(movieResponse: movieResponse!);
      }
    } on DioError catch (error) {
      if (error.response != null) {
        yield MovieError(error.response?.data['status_message']);
      } else {
        yield MovieError('Erro de conexão, verifique sua internet!!');
      }
    } on Exception catch (_) {
      yield MovieError('Erro desconhecido.');
    }
  }

  Stream<MovieState> _mapGenreEventState(int genreId, int page) async* {
    if (this.genreId != genreId) {
      yield MovieLoading();
      movieResponse = null;
    }

    try {
      final response =
          await _dio.get('/discover/movie?with_genres=$genreId&page=$page');
      var responseData = response.data;
      MovieResponse movieResponseTemp = MovieResponse.fromJson(responseData);
      if (movieResponse == null && page == 1) {
        this.genreId = genreId;
        movieResponse = movieResponseTemp;
        yield MovieLoaded(movieResponse: movieResponse!);
      } else {
        movieResponse!.results!.addAll(movieResponseTemp.results!);
        movieResponse!.page = page;
        yield MovieLoaded(movieResponse: movieResponse!);
      }
    } on DioError catch (error) {
      if (error.response != null) {
        yield MovieError(error.response?.data['status_message']);
      } else {
        yield MovieError('Erro de conexão, verifique sua internet!!');
      }
    } on Exception catch (_) {
      yield MovieError('Erro desconhecido.');
    }
  }
}
