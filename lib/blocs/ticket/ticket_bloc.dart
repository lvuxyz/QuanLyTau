import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'ticket_event.dart';
import 'ticket_state.dart';
import '../../services/ticket_service.dart';
import '../../models/ticket.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  final TicketService _ticketService;

  // Static cache for ticket data
  static Map<String, dynamic>? _ticketCache;
  static DateTime? _lastCacheTime;
  static const _cacheDuration = Duration(minutes: 5);
  static const String _cacheKey = 'ticket_data_cache';

  TicketBloc(this._ticketService) : super(TicketInitial()) {
    on<LoadUserTickets>((event, emit) async {
      emit(TicketLoading());
      try {
        final tickets = await _ticketService.getUserTickets();
        emit(UserTicketsLoaded(tickets));
      } catch (e) {
        emit(TicketError(e.toString()));
      }
    });

    on<RefreshUserTickets>((event, emit) async {
      try {
        emit(TicketLoading());
        final tickets = await _ticketService.getUserTickets();
        emit(UserTicketsLoaded(tickets));
      } catch (e) {
        emit(TicketError(e.toString()));
      }
    });

    on<LoadAvailableSeats>((event, emit) async {
      try {
        emit(TicketLoading());
        final seats = await _ticketService.getAvailableSeats(event.scheduleId);
        emit(AvailableSeatsLoaded(seats));
      } catch (e) {
        emit(TicketError(e.toString()));
      }
    });

    on<BookTicket>((event, emit) async {
      try {
        emit(TicketLoading());
        final result = await _ticketService.bookTicket(event.ticketData);
        if (result['success'] == true && result['data'] != null) {
          final ticket = Ticket.fromJson(result['data']);
          emit(TicketBooked(ticket));
        } else {
          emit(TicketError(result['message'] ?? 'Không thể đặt vé'));
        }
      } catch (e) {
        emit(TicketError(e.toString()));
      }
    });

    on<CancelTicket>((event, emit) async {
      try {
        emit(TicketLoading());
        final result = await _ticketService.cancelTicket(event.ticketId);
        if (result['success'] == true) {
          emit(TicketCancelled(event.ticketId));
          // Reload user tickets after cancellation
          final tickets = await _ticketService.getUserTickets();
          emit(UserTicketsLoaded(tickets));
        } else {
          emit(TicketError(result['message'] ?? 'Không thể hủy vé'));
        }
      } catch (e) {
        emit(TicketError(e.toString()));
      }
    });
  }

  // Use compute for data processing in separate isolate to avoid UI jank
  Future<Map<String, List<Map<String, dynamic>>>> _fetchTickets() async {
    // Simulate API call
    await Future.delayed(Duration(milliseconds: 800));

    // In a real app, this would be processed in background using compute()
    return {
      'booked': [
        {'id': '1', 'name': 'Tàu Cao Tốc A', 'time': '09:30', 'location': 'Vũng Tàu', 'status': 'đã đặt'},
        {'id': '2', 'name': 'Tàu Cao Tốc B', 'time': '10:45', 'location': 'Côn Đảo', 'status': 'đã đặt'},
        {'id': '3', 'name': 'Tàu Khách C', 'time': '12:15', 'location': 'Phú Quốc', 'status': 'đã đặt'},
        {'id': '4', 'name': 'Tàu Du Lịch D', 'time': '14:30', 'location': 'Nha Trang', 'status': 'đã đặt'},
      ],
      'completed': [
        {'id': '5', 'name': 'Tàu Cao Tốc A', 'time': '08:00', 'location': 'Vũng Tàu', 'status': 'đã hoàn thành'},
        {'id': '6', 'name': 'Tàu Cao Tốc B', 'time': '09:15', 'location': 'Côn Đảo', 'status': 'đã hoàn thành'},
        {'id': '7', 'name': 'Tàu Khách C', 'time': '11:30', 'location': 'Phú Quốc', 'status': 'đã hoàn thành'},
        {'id': '8', 'name': 'Tàu Du Lịch D', 'time': '13:45', 'location': 'Nha Trang', 'status': 'đã hoàn thành'},
      ],
      'canceled': [
        {'id': '9', 'name': 'Tàu Cao Tốc A', 'time': '07:45', 'location': 'Vũng Tàu', 'status': 'đã hủy'},
        {'id': '10', 'name': 'Tàu Cao Tốc B', 'time': '10:15', 'location': 'Côn Đảo', 'status': 'đã hủy'},
        {'id': '11', 'name': 'Tàu Khách C', 'time': '13:00', 'location': 'Phú Quốc', 'status': 'đã hủy'},
        {'id': '12', 'name': 'Tàu Du Lịch D', 'time': '15:30', 'location': 'Nha Trang', 'status': 'đã hủy'},
      ],
    };
  }

  Future<Map<String, List<Map<String, dynamic>>>?> _loadCachedTickets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? cachedDataString = prefs.getString(_cacheKey);

      if (cachedDataString != null) {
        final cachedData = json.decode(cachedDataString);
        final cacheTime = DateTime.fromMillisecondsSinceEpoch(cachedData['timestamp']);

        // Check if cache is still valid
        if (DateTime.now().difference(cacheTime) <= _cacheDuration) {
          return {
            'booked': List<Map<String, dynamic>>.from(cachedData['booked']),
            'completed': List<Map<String, dynamic>>.from(cachedData['completed']),
            'canceled': List<Map<String, dynamic>>.from(cachedData['canceled']),
          };
        }
      }
      return null;
    } catch (e) {
      // If there's any error reading cache, return null
      return null;
    }
  }

  Future<void> _saveTicketCache(Map<String, List<Map<String, dynamic>>> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final cacheData = {
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'booked': data['booked'],
        'completed': data['completed'],
        'canceled': data['canceled'],
      };

      await prefs.setString(_cacheKey, json.encode(cacheData));
    } catch (e) {
      // Silent failure
    }
  }

  void _updateTicketCaches(Map<String, List<Map<String, dynamic>>> data) {
    // Update memory cache
    _ticketCache = {
      'booked': data['booked'],
      'completed': data['completed'],
      'canceled': data['canceled'],
    };
    _lastCacheTime = DateTime.now();

    // Update persistent cache in background
    _saveTicketCache(data);
  }

  void _refreshTicketCacheInBackground() async {
    try {
      final data = await _fetchTickets();
      _updateTicketCaches(data);
    } catch (e) {
      // Silent refresh failure
    }
  }
}