// lib/blocs/home/home_event.dart
abstract class HomeEvent {}

class LoadHomeData extends HomeEvent {}

class RefreshHomeData extends HomeEvent {}

class SearchSchedulesEvent extends HomeEvent {
  final String? departurePort;
  final String? arrivalPort;
  final String? departureDate;

  SearchSchedulesEvent({
    this.departurePort,
    this.arrivalPort,
    this.departureDate,
  });
}