abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Map<String, dynamic>> results;
  final String query;

  SearchLoaded({required this.results, required this.query});
}

class SearchEmpty extends SearchState {
  final String query;

  SearchEmpty({required this.query});
}

class SearchError extends SearchState {
  final String errorMessage;

  SearchError({required this.errorMessage});
}