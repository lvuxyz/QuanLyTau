// lib/blocs/home/home_event.dart
abstract class HomeEvent {}

class LoadHomeData extends HomeEvent {}

class RefreshHomeData extends HomeEvent {}

class SearchSchedulesEvent extends HomeEvent {
  final String? departureStation;
  final String? arrivalStation;
  final String? departureDate;

  SearchSchedulesEvent({
    this.departureStation,
    this.arrivalStation,
    this.departureDate,
  });
}