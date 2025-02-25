import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Map<String, dynamic>> recentShips;
  final List<Map<String, dynamic>> promotions;

  HomeLoaded({
    required this.recentShips,
    required this.promotions,
  });

  // Computed properties for efficiency
  int get shipCount => recentShips.length;
  int get promotionCount => promotions.length;
  bool get hasShips => recentShips.isNotEmpty;
  bool get hasPromotions => promotions.isNotEmpty;

  @override
  List<Object> get props => [recentShips, promotions];
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);

  @override
  List<Object> get props => [message];
}