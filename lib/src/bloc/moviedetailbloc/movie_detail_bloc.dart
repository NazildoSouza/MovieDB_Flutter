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
  MovieDetailBloc() : super(MovieDetailLoading());

  final Dio _dio = Dio(kDioOptionsMovieDetail);
  final Dio _dioImages = Dio(kDioOptionsMovieImages);

  @override
  Stream<MovieDetailState> mapEventToState(
    MovieDetailEvent event,
  ) async* {
    if (event is MovieDetailEventStated) {
      yield* _mapMovieEventStartedToState(event.id);
    }
  }

  Stream<MovieDetailState> _mapMovieEventStartedToState(int id) async* {
    yield MovieDetailLoading();
    try {
      final response = await _dio.get('/movie/$id');
      MovieDetail movieDetail = MovieDetail.fromJson(response.data);

      final imagesResponse = await _dioImages.get('/movie/$id/images');
      ImagesResponse imageResponse =
          ImagesResponse.fromJson(imagesResponse.data);

      movieDetail.movieImage = imageResponse;

      yield MovieDetailLoaded(movieDetail);
    } on DioError catch (error) {
      if (error.response != null) {
        yield MovieDetailError(error.response?.data['status_message']);
      } else {
        yield MovieDetailError('Erro de conexão, verifique sua internet!!');
      }
    } on Exception catch (_) {
      yield MovieDetailError('Erro desconhecido.');
    }
  }
}
