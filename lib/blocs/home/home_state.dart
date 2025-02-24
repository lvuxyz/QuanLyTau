// lib/blocs/home/home_state.dart
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Map<String, dynamic>> recentShips;
  final List<Map<String, dynamic>> promotions;

  HomeLoaded({
    required this.recentShips,
    required this.promotions,
  });
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}