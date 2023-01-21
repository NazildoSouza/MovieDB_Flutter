part of 'genre_bloc.dart';

abstract class GenreState extends Equatable {
  const GenreState();

  @override
  List<Object> get props => [];
}

class GenreLoading extends GenreState {}

class GenreLoaded extends GenreState {
  final List<Genre> genreList;
  const GenreLoaded(this.genreList);

  @override
  String toString() {
    return '''GenreLoaded { genreList: ${genreList.length} }''';
  }

  @override
  List<Object> get props => [genreList];
}

class GenreError extends GenreState {
  final String message;
  const GenreError(this.message);

  @override
  String toString() {
    return '''GenreError { error: $message }''';
  }

  @override
  List<Object> get props => [message];
}
