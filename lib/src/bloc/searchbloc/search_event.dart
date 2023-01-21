part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchEventStarded extends Equatable {
  final String message;

  const SearchEventStarded(this.message);

  @override
  List<Object> get props => [message];
}

class SearchEventQuery extends SearchEvent {
  final String query;
  final int page;

  const SearchEventQuery(this.query, this.page);

  @override
  List<Object> get props => [query, page];
}

class SearchEventQueryIsEmpty extends SearchEvent {
  final String message;

  const SearchEventQueryIsEmpty(this.message);

  @override
  List<Object> get props => [message];
}
