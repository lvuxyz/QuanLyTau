// lib/blocs/ticket/ticket_event.dart
abstract class TicketEvent {}

class LoadTickets extends TicketEvent {}

class RefreshTickets extends TicketEvent {}

class CancelTicket extends TicketEvent {
  final String ticketId;
  CancelTicket(this.ticketId);
}