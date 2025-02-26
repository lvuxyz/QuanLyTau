// lib/blocs/home/home_state.dart
import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Map<String, dynamic>> trains;
  final List<Map<String, dynamic>> schedules;
  final List<Map<String, dynamic>> stations;

  HomeLoaded({
    required this.trains,
    required this.schedules,
    required this.stations,
  });

  // Computed properties
  int get trainCount => trains.length;
  int get scheduleCount => schedules.length;
  int get stationCount => stations.length;
  bool get hasTrains => trains.isNotEmpty;
  bool get hasSchedules => schedules.isNotEmpty;
  bool get hasStations => stations.isNotEmpty;

  @override
  List<Object> get props => [trains, schedules, stations];
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);

  @override
  List<Object> get props => [message];
}