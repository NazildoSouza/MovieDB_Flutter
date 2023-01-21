import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:moviedb_flutter/src/model/images.dart';
import 'package:moviedb_flutter/src/model/season.dart';
import 'package:moviedb_flutter/src/service/api_options.dart';

part 'episodeimages_event.dart';
part 'episodeimages_state.dart';

class EpisodeimagesBloc extends Bloc<EpisodeimagesEvent, EpisodeimagesState> {
  EpisodeimagesBloc() : super(EpisodeImagesLoading()) {
    on<EpisodeImagesEventStated>(_mapEpisodeImagesEventStartedToState);
  }

  final Dio _dio = Dio(kDioOptions);

  Future<void> _mapEpisodeImagesEventStartedToState(
      EpisodeImagesEventStated event, Emitter<EpisodeimagesState> emit) async {
    emit(EpisodeImagesLoading());
    try {
      final response = await _dio.get(
          '/tv/${event.serieId}/season/${event.seasonNumber}/episode/${event.episode.episodeNumber ?? 1}/images');
      List<Screenshot> images = List<Screenshot>.from(
          response.data["stills"].map((x) => Screenshot.fromJson(x)));

      event.episode.images = List<Screenshot>.from(images);

      emit(EpisodeImagesLoaded(
          (event.episode.images != null && event.episode.images!.length > 0)));
    } on DioError catch (error) {
      if (error.response != null) {
        emit(EpisodeImagesError(error.response?.data['status_message']));
      } else {
        emit(EpisodeImagesError('Erro de conexão, verifique sua internet!!'));
      }
    } on Exception catch (_) {
      emit(EpisodeImagesError('Erro desconhecido.'));
    }
  }
}
