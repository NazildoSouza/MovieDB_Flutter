part of 'genre_bloc.dart';

abstract class GenreEvent extends Equatable {
  const GenreEvent();

  @override
  List<Object> get props => [];
}

class GenreMovieEventStarted extends GenreEvent {
  const GenreMovieEventStarted();

  @override
  List<Object> get props => [];
}

class GenreSerieEventStarted extends GenreEvent {
  const GenreSerieEventStarted();

  @override
  List<Object> get props => [];
}
