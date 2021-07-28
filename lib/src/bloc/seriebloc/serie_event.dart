part of 'serie_bloc.dart';

abstract class SerieEvent extends Equatable {
  const SerieEvent();

  @override
  List<Object> get props => [];
}

class SerieEventGenre extends SerieEvent {
  final int genreId;
  final int page;

  const SerieEventGenre(this.genreId, this.page);

  @override
  List<Object> get props => [genreId, page];
}

class SerieEventAiringToday extends SerieEvent {
  final int page;

  const SerieEventAiringToday(this.page);

  @override
  List<Object> get props => [page];
}

class SerieEventOnAir extends SerieEvent {
  final int page;

  const SerieEventOnAir(this.page);

  @override
  List<Object> get props => [page];
}

class SerieEventTopRated extends SerieEvent {
  final int page;

  const SerieEventTopRated(this.page);

  @override
  List<Object> get props => [page];
}

class SerieEventPopular extends SerieEvent {
  final int page;

  const SerieEventPopular(this.page);

  @override
  List<Object> get props => [page];
}
