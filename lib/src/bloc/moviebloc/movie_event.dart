part of 'movie_bloc.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object> get props => [];
}

class MovieEventStarted extends MovieEvent {
  final int page;
  final String endPoint;

  const MovieEventStarted({required this.endPoint, required this.page});

  @override
  List<Object> get props => [endPoint, page];
}

class MovieEventGenre extends MovieEvent {
  final int genreId;
  final int page;

  const MovieEventGenre(this.genreId, this.page);

  @override
  List<Object> get props => [genreId, page];
}

class MovieEventNowPlaying extends MovieEvent {
  final int page;
  final String endPoint;

  const MovieEventNowPlaying({required this.endPoint, required this.page});

  @override
  List<Object> get props => [endPoint, page];
}

class MovieEventUpcoming extends MovieEvent {
  final int page;
  final String endPoint;

  const MovieEventUpcoming({required this.endPoint, required this.page});

  @override
  List<Object> get props => [endPoint, page];
}

class MovieEventTopRated extends MovieEvent {
  final int page;
  final String endPoint;

  const MovieEventTopRated({required this.endPoint, required this.page});

  @override
  List<Object> get props => [endPoint, page];
}

class MovieEventPopular extends MovieEvent {
  final int page;
  final String endPoint;

  const MovieEventPopular({required this.endPoint, required this.page});

  @override
  List<Object> get props => [endPoint, page];
}
