part of 'episodeimages_bloc.dart';

abstract class EpisodeimagesEvent extends Equatable {
  const EpisodeimagesEvent();

  @override
  List<Object> get props => [];
}

class EpisodeImagesEventStated extends EpisodeimagesEvent {
  const EpisodeImagesEventStated(this.serieId, this.seasonNumber, this.episode);

  final int serieId;
  final int seasonNumber;
  final Episode episode;

  @override
  List<Object> get props => [serieId, seasonNumber, episode];
}
