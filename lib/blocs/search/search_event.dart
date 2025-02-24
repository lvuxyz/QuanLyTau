abstract class SearchEvent {}

class PerformSearch extends SearchEvent {
  final String query;

  PerformSearch({required this.query});
}

class ClearSearch extends SearchEvent {}