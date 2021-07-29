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
  EpisodeimagesBloc() : super(EpisodeImagesLoading());

  final Dio _dio = Dio(kDioOptions);

  @override
  Stream<EpisodeimagesState> mapEventToState(
    EpisodeimagesEvent event,
  ) async* {
    if (event is EpisodeImagesEventStated) {
      yield* _mapEpisodeImagesEventStartedToState(
          event.serieId, event.seasonNumber, event.episode);
    }
  }

  Stream<EpisodeimagesState> _mapEpisodeImagesEventStartedToState(
      int serieId, int seasonNumber, Episode episode) async* {
    yield EpisodeImagesLoading();
    try {
      final response = await _dio.get(
          '/tv/$serieId/season/$seasonNumber/episode/${episode.episodeNumber ?? 1}/images');
      List<Screenshot> images = List<Screenshot>.from(
          response.data["stills"].map((x) => Screenshot.fromJson(x)));

      episode.images = List<Screenshot>.from(images);

      yield EpisodeImagesLoaded(
          (episode.images != null && episode.images!.length > 0));
    } on DioError catch (error) {
      if (error.response != null) {
        yield EpisodeImagesError(error.response?.data['status_message']);
      } else {
        yield EpisodeImagesError('Erro de conexão, verifique sua internet!!');
      }
    } on Exception catch (_) {
      yield EpisodeImagesError('Erro desconhecido.');
    }
  }
}
