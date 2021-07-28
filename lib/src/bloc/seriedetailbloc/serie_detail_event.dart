part of 'serie_detail_bloc.dart';

abstract class SerieDetailEvent extends Equatable {
  const SerieDetailEvent();

  @override
  List<Object> get props => [];
}

class SerieDetailEventStated extends SerieDetailEvent {
  final int id;

  SerieDetailEventStated(this.id);

  @override
  List<Object> get props => [id];
}

class SeasonDetailEventStated extends SerieDetailEvent {
  const SeasonDetailEventStated(this.serieId, this.seasonNumber);

  final int serieId;
  final int seasonNumber;

  @override
  List<Object> get props => [serieId, seasonNumber];
}
