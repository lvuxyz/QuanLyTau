abstract class SeatConfigState {}

class SeatConfigInitial extends SeatConfigState {}

class SeatConfigLoading extends SeatConfigState {}

class SeatConfigLoaded extends SeatConfigState {
  final List<dynamic> seatConfigs;

  SeatConfigLoaded({required this.seatConfigs});
}

class SeatConfigError extends SeatConfigState {
  final String message;

  SeatConfigError({required this.message});
} 