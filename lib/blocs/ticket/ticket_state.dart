import 'package:equatable/equatable.dart';
import '../../models/ticket.dart';

abstract class TicketState extends Equatable {
  const TicketState();

  @override
  List<Object> get props => [];
}

class TicketInitial extends TicketState {}

class TicketLoading extends TicketState {}

class TicketError extends TicketState {
  final String message;

  const TicketError(this.message);

  @override
  List<Object> get props => [message];
}

class AvailableSeatsLoaded extends TicketState {
  final List<Map<String, dynamic>> seats;

  const AvailableSeatsLoaded(this.seats);

  @override
  List<Object> get props => [seats];
}

class UserTicketsLoaded extends TicketState {
  final List<Ticket> tickets;

  const UserTicketsLoaded(this.tickets);

  @override
  List<Object> get props => [tickets];
}

class TicketBooked extends TicketState {
  final Ticket ticket;

  const TicketBooked(this.ticket);

  @override
  List<Object> get props => [ticket];
}

class TicketCancelled extends TicketState {
  final String ticketId;

  const TicketCancelled(this.ticketId);

  @override
  List<Object> get props => [ticketId];
}

class TicketLoaded extends TicketState {
  final List<Map<String, dynamic>> bookedTickets;
  final List<Map<String, dynamic>> completedTickets;
  final List<Map<String, dynamic>> canceledTickets;

  const TicketLoaded({
    required this.bookedTickets,
    required this.completedTickets,
    required this.canceledTickets,
  });

  @override
  List<Object> get props => [bookedTickets, completedTickets, canceledTickets];
}