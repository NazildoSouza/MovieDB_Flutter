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
  final String endPoint;

  const SerieEventAiringToday({required this.endPoint, required this.page});

  @override
  List<Object> get props => [endPoint, page];
}

class SerieEventOnAir extends SerieEvent {
  final int page;
  final String endPoint;

  const SerieEventOnAir({required this.endPoint, required this.page});

  @override
  List<Object> get props => [endPoint, page];
}

class SerieEventTopRated extends SerieEvent {
  final int page;
  final String endPoint;

  const SerieEventTopRated({required this.endPoint, required this.page});

  @override
  List<Object> get props => [endPoint, page];
}

class SerieEventPopular extends SerieEvent {
  final int page;
  final String endPoint;

  const SerieEventPopular({required this.endPoint, required this.page});

  @override
  List<Object> get props => [endPoint, page];
}
