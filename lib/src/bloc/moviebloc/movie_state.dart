part of 'movie_bloc.dart';

abstract class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object> get props => [];
}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  const MovieLoaded({required this.movieResponse});

  final MovieResponse movieResponse;

  @override
  String toString() {
    return '''MovieLoaded { movieResponse: $movieResponse, page: ${movieResponse.page}, results: ${movieResponse.results?.length} }''';
  }

  @override
  List<Object> get props => [movieResponse];
}

class MovieError extends MovieState {
  final String message;
  const MovieError(this.message);

  @override
  String toString() {
    return '''MovieError { error: $message }''';
  }

  @override
  List<Object> get props => [message];
}
