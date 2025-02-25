import 'package:equatable/equatable.dart';

abstract class TicketState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TicketInitial extends TicketState {}

class TicketLoading extends TicketState {}

class TicketLoaded extends TicketState {
  final List<Map<String, dynamic>> bookedTickets;
  final List<Map<String, dynamic>> completedTickets;
  final List<Map<String, dynamic>> canceledTickets;

  TicketLoaded({
    required this.bookedTickets,
    required this.completedTickets,
    required this.canceledTickets,
  });

  // Computed properties to avoid recalculations in UI
  int get totalTicketCount => bookedTickets.length + completedTickets.length + canceledTickets.length;
  int get bookedCount => bookedTickets.length;
  int get completedCount => completedTickets.length;
  int get canceledCount => canceledTickets.length;
  bool get hasBookedTickets => bookedTickets.isNotEmpty;
  bool get hasCompletedTickets => completedTickets.isNotEmpty;
  bool get hasCanceledTickets => canceledTickets.isNotEmpty;
  bool get hasAnyTickets => hasBookedTickets || hasCompletedTickets || hasCanceledTickets;

  @override
  List<Object> get props => [bookedTickets, completedTickets, canceledTickets];
}

class TicketError extends TicketState {
  final String message;
  TicketError(this.message);

  @override
  List<Object> get props => [message];
}