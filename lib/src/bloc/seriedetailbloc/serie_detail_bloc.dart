import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:moviedb_flutter/src/model/images.dart';
import 'package:moviedb_flutter/src/model/season.dart';
import 'package:moviedb_flutter/src/model/serie_detail.dart';
import 'package:moviedb_flutter/src/service/api_options.dart';

part 'serie_detail_event.dart';
part 'serie_detail_state.dart';

class SerieDetailBloc extends Bloc<SerieDetailEvent, SerieDetailState> {
  SerieDetailBloc() : super(SerieDetailLoading());

  final Dio _dio = Dio(kDioOptionsMovieDetail);
  final Dio _dioImages = Dio(kDioOptionsMovieImages);

  @override
  Stream<SerieDetailState> mapEventToState(
    SerieDetailEvent event,
  ) async* {
    if (event is SerieDetailEventStated) {
      yield* _mapMovieEventStartedToState(event.id);
    } else if (event is SeasonDetailEventStated) {
      yield* _mapSeasonEventStartedToState(event.serieId, event.seasonNumber);
    }
  }

  Stream<SerieDetailState> _mapMovieEventStartedToState(int id) async* {
    yield SerieDetailLoading();
    try {
      final response = await _dio.get('/tv/$id');
      SerieDetail serieDetail = SerieDetail.fromJson(response.data);

      final imagesResponse = await _dioImages.get('/tv/$id/images');
      ImagesResponse imageResponse =
          ImagesResponse.fromJson(imagesResponse.data);

      serieDetail.serieImage = imageResponse;

      yield SerieDetailLoaded(serieDetail);
    } on DioError catch (error) {
      if (error.response != null) {
        yield SerieDetailError(error.response?.data['status_message']);
      } else {
        yield SerieDetailError('Erro de conexão, verifique sua internet!!');
      }
    } on Exception catch (_) {
      yield SerieDetailError('Erro desconhecido.');
    }
  }

  Stream<SerieDetailState> _mapSeasonEventStartedToState(
      int serieId, int seasonNumber) async* {
    yield SeasonDetailLoading();
    try {
      final response = await _dio.get('/tv/$serieId/season/$seasonNumber');
      SeasonResponse seasonResponse = SeasonResponse.fromJson(response.data);
      yield SeasonDetailLoaded(seasonResponse);
    } on DioError catch (error) {
      if (error.response != null) {
        yield SeasonDetailError(error.response?.data['status_message']);
      } else {
        yield SeasonDetailError('Erro de conexão, verifique sua internet!!');
      }
    } on Exception catch (error) {
      print(error.toString());
      yield SeasonDetailError('Erro desconhecido.');
    }
  }
}
