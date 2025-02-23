// lib/blocs/home/home_event.dart
abstract class HomeEvent {}

class LoadHomeData extends HomeEvent {}

class RefreshHomeData extends HomeEvent {}

class SearchShips extends HomeEvent {
  final String query;
  SearchShips(this.query);
}