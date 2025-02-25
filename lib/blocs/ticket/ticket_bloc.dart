
// lib/blocs/ticket/ticket_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'ticket_event.dart';
import 'ticket_state.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  TicketBloc() : super(TicketInitial()) {
    on<LoadTickets>((event, emit) async {
      emit(TicketLoading());
      try {
        // Simulate API call to fetch tickets
        await Future.delayed(Duration(seconds: 1));

        // Mock data for demonstration
        final bookedTickets = [
          {'id': '1', 'name': 'Demo tên tàu', 'time': '09:30', 'location': 'Vũng Tàu', 'status': 'đã đặt'},
          {'id': '2', 'name': 'Demo tên tàu', 'time': '10:45', 'location': 'Côn Đảo', 'status': 'đã đặt'},
          {'id': '3', 'name': 'Demo tên tàu', 'time': '12:15', 'location': 'Phú Quốc', 'status': 'đã đặt'},
          {'id': '4', 'name': 'Demo tên tàu', 'time': '14:30', 'location': 'Nha Trang', 'status': 'đã đặt'},
        ];

        final completedTickets = [
          {'id': '5', 'name': 'Demo tên tàu', 'time': '08:00', 'location': 'Vũng Tàu', 'status': 'đã hoàn thành'},
          {'id': '6', 'name': 'Demo tên tàu', 'time': '09:15', 'location': 'Côn Đảo', 'status': 'đã hoàn thành'},
          {'id': '7', 'name': 'Demo tên tàu', 'time': '11:30', 'location': 'Phú Quốc', 'status': 'đã hoàn thành'},
          {'id': '8', 'name': 'Demo tên tàu', 'time': '13:45', 'location': 'Nha Trang', 'status': 'đã hoàn thành'},
        ];

        final canceledTickets = [
          {'id': '9', 'name': 'Demo tên tàu', 'time': '07:45', 'location': 'Vũng Tàu', 'status': 'đã hủy'},
          {'id': '10', 'name': 'Demo tên tàu', 'time': '10:15', 'location': 'Côn Đảo', 'status': 'đã hủy'},
          {'id': '11', 'name': 'Demo tên tàu', 'time': '13:00', 'location': 'Phú Quốc', 'status': 'đã hủy'},
          {'id': '12', 'name': 'Demo tên tàu', 'time': '15:30', 'location': 'Nha Trang', 'status': 'đã hủy'},
        ];

        emit(TicketLoaded(
          bookedTickets: bookedTickets,
          completedTickets: completedTickets,
          canceledTickets: canceledTickets,
        ));
      } catch (e) {
        emit(TicketError('Không thể tải danh sách vé. Vui lòng thử lại sau.'));
      }
    });

    on<RefreshTickets>((event, emit) async {
      final currentState = state;
      if (currentState is TicketLoaded) {
        emit(TicketLoading());
        try {
          // Simulate API refresh
          await Future.delayed(Duration(seconds: 1));
          emit(currentState);
        } catch (e) {
          emit(TicketError('Không thể làm mới danh sách vé. Vui lòng thử lại sau.'));
        }
      }
    });

    on<CancelTicket>((event, emit) async {
      final currentState = state;
      if (currentState is TicketLoaded) {
        emit(TicketLoading());
        try {
          // Simulate API call to cancel ticket
          await Future.delayed(Duration(seconds: 1));

          // Find the ticket to cancel
          final bookedTickets = List<Map<String, dynamic>>.from(currentState.bookedTickets);
          final ticketIndex = bookedTickets.indexWhere((ticket) => ticket['id'] == event.ticketId);

          if (ticketIndex != -1) {
            final canceledTicket = Map<String, dynamic>.from(bookedTickets[ticketIndex]);
            canceledTicket['status'] = 'đã hủy';

            // Remove from booked list
            bookedTickets.removeAt(ticketIndex);

            // Add to canceled list
            final canceledTickets = List<Map<String, dynamic>>.from(currentState.canceledTickets);
            canceledTickets.add(canceledTicket);

            emit(TicketLoaded(
              bookedTickets: bookedTickets,
              completedTickets: currentState.completedTickets,
              canceledTickets: canceledTickets,
            ));
          } else {
            emit(currentState);
          }
        } catch (e) {
          emit(TicketError('Không thể hủy vé. Vui lòng thử lại sau.'));
        }
      }
    });
  }
}