import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

// Thêm trạng thái mới cho các đề xuất
class SearchSuggestions extends SearchState {
  final List<Map<String, dynamic>> suggestions;

  SearchSuggestions({required this.suggestions});

  @override
  List<Object> get props => [suggestions];
}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Map<String, dynamic>> results;
  final String query;

  SearchLoaded({required this.results, required this.query});

  // Computed properties
  int get resultCount => results.length;
  bool get hasMultipleResults => results.length > 1;

  @override
  List<Object> get props => [results, query];
}

class SearchEmpty extends SearchState {
  final String query;

  SearchEmpty({required this.query});

  @override
  List<Object> get props => [query];
}

class SearchError extends SearchState {
  final String errorMessage;

  SearchError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}