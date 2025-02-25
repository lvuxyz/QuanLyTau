// lib/blocs/ticket/ticket_state.dart
abstract class TicketState {}

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
}

class TicketError extends TicketState {
  final String message;
  TicketError(this.message);
}


