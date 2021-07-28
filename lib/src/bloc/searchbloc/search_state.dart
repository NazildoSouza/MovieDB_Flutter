part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchLoading extends SearchState {}

class SearchQueryIsEmpty extends SearchState {
  final String message;

  const SearchQueryIsEmpty(this.message);

  @override
  String toString() {
    return '''SearchQueryIsEmpty { message: $message }''';
  }

  @override
  List<Object> get props => [message];
}

class SearchLoaded extends SearchState {
  const SearchLoaded({required this.searchResponse});

  final SearchResponse searchResponse;

  @override
  String toString() {
    return '''SearchLoaded { movieResponse: $searchResponse, page: ${searchResponse.page}, results: ${searchResponse.results?.length} }''';
  }

  @override
  List<Object> get props => [searchResponse];
}

class SearchError extends SearchState {
  final String message;
  const SearchError(this.message);

  @override
  String toString() {
    return '''SearchError { error: $message }''';
  }

  @override
  List<Object> get props => [message];
}
