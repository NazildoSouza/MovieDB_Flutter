part of 'movie_bloc.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object> get props => [];
}

class MovieEventStarted extends MovieEvent {
  final int page;

  const MovieEventStarted(this.page);

  @override
  List<Object> get props => [page];
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

  const MovieEventNowPlaying(this.page);

  @override
  List<Object> get props => [page];
}

class MovieEventUpcoming extends MovieEvent {
  final int page;

  const MovieEventUpcoming(this.page);

  @override
  List<Object> get props => [page];
}

class MovieEventTopRated extends MovieEvent {
  final int page;

  const MovieEventTopRated(this.page);

  @override
  List<Object> get props => [page];
}

class MovieEventPopular extends MovieEvent {
  final int page;

  const MovieEventPopular(this.page);

  @override
  List<Object> get props => [page];
}
