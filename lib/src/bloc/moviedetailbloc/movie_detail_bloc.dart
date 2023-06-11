import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:moviedb_flutter/src/model/images.dart';
import 'package:moviedb_flutter/src/model/movie_detail.dart';
import 'package:moviedb_flutter/src/service/api_options.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  MovieDetailBloc() : super(MovieDetailLoading()) {
    on<MovieDetailEventStated>(_mapMovieEventStartedToState);
  }

  final Dio _dio = Dio(kDioOptionsMovieDetail);
  final Dio _dioImages = Dio(kDioOptionsMovieImages);

  Future<void> _mapMovieEventStartedToState(
      MovieDetailEventStated event, Emitter<MovieDetailState> emit) async {
    emit(MovieDetailLoading());
    try {
      final response = await _dio.get('/movie/${event.id}');
      MovieDetail movieDetail = MovieDetail.fromJson(response.data);

      final imagesResponse = await _dioImages.get('/movie/${event.id}/images');
      ImagesResponse imageResponse =
          ImagesResponse.fromJson(imagesResponse.data);

      movieDetail.movieImage = imageResponse;

      emit(MovieDetailLoaded(movieDetail));
    } on DioException catch (error) {
      if (error.response != null) {
        emit(MovieDetailError(error.response?.data['status_message']));
      } else {
        emit(MovieDetailError('Erro de conexão, verifique sua internet!!'));
      }
    } on Exception catch (_) {
      emit(MovieDetailError('Erro desconhecido.'));
    }
  }
}
