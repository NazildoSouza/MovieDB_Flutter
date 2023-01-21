part of 'serie_bloc.dart';

abstract class SerieState extends Equatable {
  const SerieState();

  @override
  List<Object> get props => [];
}

class SerieLoading extends SerieState {}

class SerieLoaded extends SerieState {
  const SerieLoaded({required this.serieResponse});

  final SerieResponse serieResponse;

  @override
  String toString() {
    return '''SerieLoaded { serieResponse: $serieResponse,  page: ${serieResponse.page}, results: ${serieResponse.results?.length} }''';
  }

  @override
  List<Object> get props => [serieResponse];
}

class SerieError extends SerieState {
  final String message;
  const SerieError(this.message);

  @override
  String toString() {
    return '''SerieError { error: $message }''';
  }

  @override
  List<Object> get props => [message];
}
