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
  SerieDetailBloc() : super(SerieDetailLoading()) {
    on<SerieDetailEventStated>(_mapMovieEventStartedToState);
    on<SeasonDetailEventStated>(_mapSeasonEventStartedToState);
  }

  final Dio _dio = Dio(kDioOptionsMovieDetail);
  final Dio _dioImages = Dio(kDioOptionsMovieImages);

  Future<void> _mapMovieEventStartedToState(
      SerieDetailEventStated event, Emitter<SerieDetailState> emit) async {
    emit(SerieDetailLoading());
    try {
      final response = await _dio.get('/tv/${event.id}');
      SerieDetail serieDetail = SerieDetail.fromJson(response.data);

      final imagesResponse = await _dioImages.get('/tv/${event.id}/images');
      ImagesResponse imageResponse =
          ImagesResponse.fromJson(imagesResponse.data);

      serieDetail.serieImage = imageResponse;

      emit(SerieDetailLoaded(serieDetail));
    } on DioError catch (error) {
      if (error.response != null) {
        emit(SerieDetailError(error.response?.data['status_message']));
      } else {
        emit(SerieDetailError('Erro de conexão, verifique sua internet!!'));
      }
    } on Exception catch (_) {
      emit(SerieDetailError('Erro desconhecido.'));
    }
  }

  Future<void> _mapSeasonEventStartedToState(
      SeasonDetailEventStated event, Emitter<SerieDetailState> emit) async {
    emit(SeasonDetailLoading());
    try {
      final response =
          await _dio.get('/tv/${event.serieId}/season/${event.seasonNumber}');
      SeasonResponse seasonResponse = SeasonResponse.fromJson(response.data);
      emit(SeasonDetailLoaded(seasonResponse));
    } on DioError catch (error) {
      if (error.response != null) {
        emit(SeasonDetailError(error.response?.data['status_message']));
      } else {
        emit(SeasonDetailError('Erro de conexão, verifique sua internet!!'));
      }
    } on Exception catch (error) {
      print(error.toString());
      emit(SeasonDetailError('Erro desconhecido.'));
    }
  }
}
