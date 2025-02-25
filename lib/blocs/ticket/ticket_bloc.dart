import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'ticket_event.dart';
import 'ticket_state.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  // Static cache for ticket data
  static Map<String, dynamic>? _ticketCache;
  static DateTime? _lastCacheTime;
  static const _cacheDuration = Duration(minutes: 5);
  static const String _cacheKey = 'ticket_data_cache';

  TicketBloc() : super(TicketInitial()) {
    on<LoadTickets>((event, emit) async {
      emit(TicketLoading());
      try {
        // Check if memory cache is available and fresh
        if (_ticketCache != null &&
            _lastCacheTime != null &&
            DateTime.now().difference(_lastCacheTime!) < _cacheDuration) {

          // Use memory cached data for instant rendering
          emit(TicketLoaded(
            bookedTickets: _ticketCache!['booked'] as List<Map<String, dynamic>>,
            completedTickets: _ticketCache!['completed'] as List<Map<String, dynamic>>,
            canceledTickets: _ticketCache!['canceled'] as List<Map<String, dynamic>>,
          ));

          // Refresh cache in background without blocking UI
          _refreshTicketCacheInBackground();
          return;
        }

        // Try persistent cache
        final persistentCache = await _loadCachedTickets();
        if (persistentCache != null) {
          _ticketCache = persistentCache;
          _lastCacheTime = DateTime.now(); // Reset timer for memory cache

          emit(TicketLoaded(
            bookedTickets: persistentCache['booked'] as List<Map<String, dynamic>>,
            completedTickets: persistentCache['completed'] as List<Map<String, dynamic>>,
            canceledTickets: persistentCache['canceled'] as List<Map<String, dynamic>>,
          ));

          // Refresh cache in background
          _refreshTicketCacheInBackground();
          return;
        }

        // No cache or expired cache, fetch new data
        final data = await _fetchTickets();

        // Update caches
        _updateTicketCaches(data);

        emit(TicketLoaded(
          bookedTickets: data['booked'] as List<Map<String, dynamic>>,
          completedTickets: data['completed'] as List<Map<String, dynamic>>,
          canceledTickets: data['canceled'] as List<Map<String, dynamic>>,
        ));
      } catch (e) {
        emit(TicketError('Không thể tải danh sách vé. Vui lòng thử lại sau.'));
      }
    });

    on<RefreshTickets>((event, emit) async {
      final currentState = state;
      if (currentState is TicketLoaded) {
        // Keep current data visible while refreshing
        try {
          // Fetch new data
          final data = await _fetchTickets();

          // Update caches
          _updateTicketCaches(data);

          emit(TicketLoaded(
            bookedTickets: data['booked'] as List<Map<String, dynamic>>,
            completedTickets: data['completed'] as List<Map<String, dynamic>>,
            canceledTickets: data['canceled'] as List<Map<String, dynamic>>,
          ));
        } catch (e) {
          // On error, keep showing existing data
          emit(currentState);
        }
      }
    });

    on<CancelTicket>((event, emit) async {
      final currentState = state;
      if (currentState is TicketLoaded) {
        emit(TicketLoading());
        try {
          // Optimistic update - apply change immediately for responsive UI
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

            // Update UI immediately
            final newState = TicketLoaded(
              bookedTickets: bookedTickets,
              completedTickets: currentState.completedTickets,
              canceledTickets: canceledTickets,
            );

            emit(newState);

            // In a real app, make API call here to persist changes
            await Future.delayed(Duration(milliseconds: 300));

            // Update caches with new state
            _updateTicketCaches({
              'booked': bookedTickets,
              'completed': currentState.completedTickets,
              'canceled': canceledTickets,
            });
          } else {
            emit(currentState);
          }
        } catch (e) {
          emit(TicketError('Không thể hủy vé. Vui lòng thử lại sau.'));
        }
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