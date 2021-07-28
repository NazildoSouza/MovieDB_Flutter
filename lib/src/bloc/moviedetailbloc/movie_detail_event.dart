part of 'movie_detail_bloc.dart';

abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();

  @override
  List<Object> get props => [];
}

class MovieDetailEventStated extends MovieDetailEvent {
  final int id;

  MovieDetailEventStated(this.id);

  @override
  List<Object> get props => [id];
}
