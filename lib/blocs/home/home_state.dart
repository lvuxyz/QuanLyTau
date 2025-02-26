// lib/blocs/home/home_state.dart
import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Map<String, dynamic>> ships;
  final List<Map<String, dynamic>> schedules;
  final List<Map<String, dynamic>> ports;

  HomeLoaded({
    required this.ships,
    required this.schedules,
    required this.ports,
  });

  // Computed properties
  int get shipCount => ships.length;
  int get scheduleCount => schedules.length;
  int get portCount => ports.length;
  bool get hasShips => ships.isNotEmpty;
  bool get hasSchedules => schedules.isNotEmpty;
  bool get hasPorts => ports.isNotEmpty;

  @override
  List<Object> get props => [ships, schedules, ports];
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);

  @override
  List<Object> get props => [message];
}