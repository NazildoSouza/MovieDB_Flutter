part of 'serie_detail_bloc.dart';

abstract class SerieDetailState extends Equatable {
  const SerieDetailState();

  @override
  List<Object> get props => [];
}

class SerieDetailLoading extends SerieDetailState {}

class SeasonDetailLoading extends SerieDetailState {}

class SeasonDetailError extends SerieDetailState {
  final String message;
  const SeasonDetailError(this.message);

  @override
  String toString() {
    return '''SeasonDetailError { error: $message }''';
  }

  @override
  List<Object> get props => [message];
}

class SerieDetailError extends SerieDetailState {
  final String message;
  const SerieDetailError(this.message);

  @override
  String toString() {
    return '''SerieDetailError { error: $message }''';
  }

  @override
  List<Object> get props => [message];
}

class SerieDetailLoaded extends SerieDetailState {
  const SerieDetailLoaded(this.detail);
  final SerieDetail detail;

  @override
  String toString() {
    return '''SerieDetailLoaded { detail: $detail }''';
  }

  @override
  List<Object> get props => [detail];
}

class SeasonDetailLoaded extends SerieDetailState {
  const SeasonDetailLoaded(this.seasonResponse);
  final SeasonResponse seasonResponse;

  @override
  String toString() {
    return '''SeasonDetailLoaded { seasonResponse: $seasonResponse }''';
  }

  @override
  List<Object> get props => [seasonResponse];
}
