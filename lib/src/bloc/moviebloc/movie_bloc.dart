import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:moviedb_flutter/src/model/movie.dart';
import 'package:moviedb_flutter/src/service/api_options.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  MovieBloc() : super(MovieLoading()) {
    on<MovieEventStarted>(_mapMovieEventStarted);
    on<MovieEventGenre>(_mapGenreEventState);
    on<MovieEventNowPlaying>(_mapMovieEventNowPlaying);
    on<MovieEventUpcoming>(_mapMovieEventUpcoming);
    on<MovieEventTopRated>(_mapMovieEventTopRated);
    on<MovieEventPopular>(_mapMovieEventPopular);
  }

  final Dio _dio = Dio(kDioOptions);
  MovieResponse? movieResponse;
  int genreId = 0;

  Future<void> _mapMovieEventStarted(
      MovieEventStarted event, Emitter<MovieState> emit) async {
    try {
      final response =
          await _dio.get('/movie/${event.endPoint}?page=${event.page}');
      var responseData = response.data;
      MovieResponse movieResponseTemp = MovieResponse.fromJson(responseData);

      if (event.page == 1) {
        movieResponse = movieResponseTemp;
        emit(MovieLoaded(movieResponse: movieResponse!));
      } else {
        movieResponse!.results!.addAll(movieResponseTemp.results!);
        movieResponse!.page = event.page;
        emit(MovieLoaded(movieResponse: movieResponse!));
      }
    } on DioException catch (error) {
      if (error.response != null) {
        emit(MovieError(error.response?.data['status_message']));
      } else {
        emit(MovieError('Erro de conexão, verifique sua internet!!'));
      }
    } on Exception catch (_) {
      emit(MovieError('Erro desconhecido.'));
    }
  }

  Future<void> _mapMovieEventNowPlaying(
      MovieEventNowPlaying event, Emitter<MovieState> emit) async {
    try {
      final response =
          await _dio.get('/movie/${event.endPoint}?page=${event.page}');
      var responseData = response.data;
      MovieResponse movieResponseTemp = MovieResponse.fromJson(responseData);

      if (event.page == 1) {
        movieResponse = movieResponseTemp;
        emit(MovieLoaded(movieResponse: movieResponse!));
      } else {
        movieResponse!.results!.addAll(movieResponseTemp.results!);
        movieResponse!.page = event.page;
        emit(MovieLoaded(movieResponse: movieResponse!));
      }
    } on DioException catch (error) {
      if (error.response != null) {
        emit(MovieError(error.response?.data['status_message']));
      } else {
        emit(MovieError('Erro de conexão, verifique sua internet!!'));
      }
    } on Exception catch (_) {
      emit(MovieError('Erro desconhecido.'));
    }
  }

  Future<void> _mapMovieEventUpcoming(
      MovieEventUpcoming event, Emitter<MovieState> emit) async {
    try {
      final response =
          await _dio.get('/movie/${event.endPoint}?page=${event.page}');
      var responseData = response.data;
      MovieResponse movieResponseTemp = MovieResponse.fromJson(responseData);

      if (event.page == 1) {
        movieResponse = movieResponseTemp;
        emit(MovieLoaded(movieResponse: movieResponse!));
      } else {
        movieResponse!.results!.addAll(movieResponseTemp.results!);
        movieResponse!.page = event.page;
        emit(MovieLoaded(movieResponse: movieResponse!));
      }
    } on DioException catch (error) {
      if (error.response != null) {
        emit(MovieError(error.response?.data['status_message']));
      } else {
        emit(MovieError('Erro de conexão, verifique sua internet!!'));
      }
    } on Exception catch (_) {
      emit(MovieError('Erro desconhecido.'));
    }
  }

  Future<void> _mapMovieEventTopRated(
      MovieEventTopRated event, Emitter<MovieState> emit) async {
    try {
      final response =
          await _dio.get('/movie/${event.endPoint}?page=${event.page}');
      var responseData = response.data;
      MovieResponse movieResponseTemp = MovieResponse.fromJson(responseData);

      if (event.page == 1) {
        movieResponse = movieResponseTemp;
        emit(MovieLoaded(movieResponse: movieResponse!));
      } else {
        movieResponse!.results!.addAll(movieResponseTemp.results!);
        movieResponse!.page = event.page;
        emit(MovieLoaded(movieResponse: movieResponse!));
      }
    } on DioException catch (error) {
      if (error.response != null) {
        emit(MovieError(error.response?.data['status_message']));
      } else {
        emit(MovieError('Erro de conexão, verifique sua internet!!'));
      }
    } on Exception catch (_) {
      emit(MovieError('Erro desconhecido.'));
    }
  }

  Future<void> _mapMovieEventPopular(
      MovieEventPopular event, Emitter<MovieState> emit) async {
    try {
      final response =
          await _dio.get('/movie/${event.endPoint}?page=${event.page}');
      var responseData = response.data;
      MovieResponse movieResponseTemp = MovieResponse.fromJson(responseData);

      if (event.page == 1) {
        movieResponse = movieResponseTemp;
        emit(MovieLoaded(movieResponse: movieResponse!));
      } else {
        movieResponse!.results!.addAll(movieResponseTemp.results!);
        movieResponse!.page = event.page;
        emit(MovieLoaded(movieResponse: movieResponse!));
      }
    } on DioException catch (error) {
      if (error.response != null) {
        emit(MovieError(error.response?.data['status_message']));
      } else {
        emit(MovieError('Erro de conexão, verifique sua internet!!'));
      }
    } on Exception catch (_) {
      emit(MovieError('Erro desconhecido.'));
    }
  }

  Future<void> _mapGenreEventState(
      MovieEventGenre event, Emitter<MovieState> emit) async {
    if (this.genreId != event.genreId) {
      emit(MovieLoading());
      movieResponse = null;
    }

    try {
      final response = await _dio.get(
          '/discover/movie?with_genres=${event.genreId}&page=${event.page}');
      var responseData = response.data;
      MovieResponse movieResponseTemp = MovieResponse.fromJson(responseData);
      if (movieResponse == null && event.page == 1) {
        this.genreId = event.genreId;
        movieResponse = movieResponseTemp;
        emit(MovieLoaded(movieResponse: movieResponse!));
      } else {
        movieResponse!.results!.addAll(movieResponseTemp.results!);
        movieResponse!.page = event.page;
        emit(MovieLoaded(movieResponse: movieResponse!));
      }
    } on DioException catch (error) {
      if (error.response != null) {
        emit(MovieError(error.response?.data['status_message']));
      } else {
        emit(MovieError('Erro de conexão, verifique sua internet!!'));
      }
    } on Exception catch (_) {
      emit(MovieError('Erro desconhecido.'));
    }
  }
}
