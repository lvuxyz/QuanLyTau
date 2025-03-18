// lib/blocs/ticket/ticket_event.dart
import 'package:equatable/equatable.dart';

abstract class TicketEvent extends Equatable {
  const TicketEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserTickets extends TicketEvent {}

class RefreshUserTickets extends TicketEvent {}

class LoadTickets extends TicketEvent {}

class RefreshTickets extends TicketEvent {}

class LoadAvailableSeats extends TicketEvent {
  final String scheduleId;

  const LoadAvailableSeats(this.scheduleId);

  @override
  List<Object?> get props => [scheduleId];
}

class BookTicket extends TicketEvent {
  final Map<String, dynamic> ticketData;

  const BookTicket({required this.ticketData});

  @override
  List<Object?> get props => [ticketData];
}

class CancelTicket extends TicketEvent {
  final String ticketId;

  const CancelTicket({required this.ticketId});

  @override
  List<Object?> get props => [ticketId];
}