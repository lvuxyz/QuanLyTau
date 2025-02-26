import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  static const String _cacheKey = 'home_data_cache';
  static const Duration _cacheDuration = Duration(minutes: 30);
  static DateTime? _lastCacheTime;

  HomeBloc() : super(HomeInitial()) {
    on<LoadHomeData>((event, emit) async {
      if (state is! HomeLoading) {
        emit(HomeLoading());
      }

      try {
        // Try to load data from cache first
        final cachedData = await _getCachedHomeData();
        if (cachedData != null) {
          emit(HomeLoaded(
            ships: cachedData['ships'] as List<Map<String, dynamic>>,
            schedules: cachedData['schedules'] as List<Map<String, dynamic>>,
            ports: cachedData['ports'] as List<Map<String, dynamic>>,
          ));
        }

        // If cache is too old or doesn't exist, load new data
        if (_lastCacheTime == null ||
            DateTime.now().difference(_lastCacheTime!) > _cacheDuration ||
            cachedData == null) {

          // Load ship data
          final List<Map<String, dynamic>> ships = await _fetchShips();

          // Get current date for schedules
          final now = DateTime.now();
          final fromDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

          // Calculate date 7 days ahead
          final nextWeek = now.add(const Duration(days: 7));
          final toDate = '${nextWeek.year}-${nextWeek.month.toString().padLeft(2, '0')}-${nextWeek.day.toString().padLeft(2, '0')}';

          // Get upcoming schedules
          final List<Map<String, dynamic>> schedules = await _fetchSchedules(
              fromDate: fromDate,
              toDate: toDate,
              status: 'ACTIVE'
          );

          // Get list of ports
          final List<Map<String, dynamic>> ports = await _fetchPorts();

          // Update cache
          _cacheHomeData(ships, schedules, ports);

          emit(HomeLoaded(
            ships: ships,
            schedules: schedules,
            ports: ports,
          ));
        }
      } catch (e) {
        emit(HomeError('Failed to load data. Please try again later.'));
      }
    });

    on<RefreshHomeData>((event, emit) async {
      try {
        // Load data from API
        final List<Map<String, dynamic>> ships = await _fetchShips();

        // Get current date for schedules
        final now = DateTime.now();
        final fromDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

        // Calculate date 7 days ahead
        final nextWeek = now.add(const Duration(days: 7));
        final toDate = '${nextWeek.year}-${nextWeek.month.toString().padLeft(2, '0')}-${nextWeek.day.toString().padLeft(2, '0')}';

        // Get upcoming schedules
        final List<Map<String, dynamic>> schedules = await _fetchSchedules(
            fromDate: fromDate,
            toDate: toDate,
            status: 'ACTIVE'
        );

        // Get list of ports
        final List<Map<String, dynamic>> ports = await _fetchPorts();

        // Update cache
        _cacheHomeData(ships, schedules, ports);

        emit(HomeLoaded(
          ships: ships,
          schedules: schedules,
          ports: ports,
        ));
      } catch (e) {
        // If refresh fails, keep current state
        if (state is HomeLoaded) {
          emit(state);
        } else {
          emit(HomeError('Failed to refresh data. Please try again later.'));
        }
      }
    });
  }

  // Fetch ships (Mock data for now)
  Future<List<Map<String, dynamic>>> _fetchShips() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    return [
      {
        'id': '1',
        'name': 'Cargo Ship Alpha',
        'status': 'ACTIVE',
        'operator': 'Maritime Logistics Inc.',
      },
      {
        'id': '2',
        'name': 'Tanker Beta',
        'status': 'MAINTENANCE',
        'operator': 'Ocean Shipping Co.',
      },
      {
        'id': '3',
        'name': 'Container Ship Gamma',
        'status': 'ACTIVE',
        'operator': 'Global Transport Ltd.',
      },
      {
        'id': '4',
        'name': 'Bulk Carrier Delta',
        'status': 'OUT_OF_SERVICE',
        'operator': 'Coastal Shipping Services',
      },
    ];
  }

  // Fetch schedules (Mock data for now)
  Future<List<Map<String, dynamic>>> _fetchSchedules({
    String? fromDate,
    String? toDate,
    String? status,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    return [
      {
        'id': '101',
        'shipId': '1',
        'shipType': 'Cargo Ship Alpha',
        'departureDate': '2023-11-10',
        'departureTime': '09:30',
        'arrivalTime': '18:45',
        'departurePort': 'Singapore Port',
        'arrivalPort': 'Hong Kong Port',
        'status': 'ACTIVE',
      },
      {
        'id': '102',
        'shipId': '3',
        'shipType': 'Container Ship Gamma',
        'departureDate': '2023-11-12',
        'departureTime': '07:15',
        'arrivalTime': '16:30',
        'departurePort': 'Busan Port',
        'arrivalPort': 'Tokyo Port',
        'status': 'PENDING',
      },
      {
        'id': '103',
        'shipId': '1',
        'shipType': 'Cargo Ship Alpha',
        'departureDate': '2023-11-15',
        'departureTime': '14:00',
        'arrivalTime': '08:30',
        'departurePort': 'Hong Kong Port',
        'arrivalPort': 'Shanghai Port',
        'status': 'ACTIVE',
      },
    ];
  }

  // Fetch ports (Mock data for now)
  Future<List<Map<String, dynamic>>> _fetchPorts() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    return [
      {
        'id': '201',
        'name': 'Singapore Port',
        'location': 'Singapore',
        'shipCount': 12,
      },
      {
        'id': '202',
        'name': 'Hong Kong Port',
        'location': 'Hong Kong, China',
        'shipCount': 8,
      },
      {
        'id': '203',
        'name': 'Busan Port',
        'location': 'Busan, South Korea',
        'shipCount': 10,
      },
      {
        'id': '204',
        'name': 'Tokyo Port',
        'location': 'Tokyo, Japan',
        'shipCount': 7,
      },
      {
        'id': '205',
        'name': 'Shanghai Port',
        'location': 'Shanghai, China',
        'shipCount': 15,
      },
    ];
  }

  Future<Map<String, dynamic>?> _getCachedHomeData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? cachedDataString = prefs.getString(_cacheKey);

      if (cachedDataString != null) {
        final cachedData = json.decode(cachedDataString);
        final cacheTime = DateTime.fromMillisecondsSinceEpoch(cachedData['timestamp']);
        _lastCacheTime = cacheTime;

        // Check if cache is still valid
        if (DateTime.now().difference(cacheTime) <= _cacheDuration) {
          return {
            'ships': List<Map<String, dynamic>>.from(cachedData['ships']),
            'schedules': List<Map<String, dynamic>>.from(cachedData['schedules']),
            'ports': List<Map<String, dynamic>>.from(cachedData['ports']),
          };
        }
      }
      return null;
    } catch (e) {
      // If there's an error reading cache, return null and load new data
      return null;
    }
  }

  Future<void> _cacheHomeData(
      List<Map<String, dynamic>> ships,
      List<Map<String, dynamic>> schedules,
      List<Map<String, dynamic>> ports
      ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now();
      _lastCacheTime = now;

      final cacheData = {
        'timestamp': now.millisecondsSinceEpoch,
        'ships': ships,
        'schedules': schedules,
        'ports': ports,
      };

      await prefs.setString(_cacheKey, json.encode(cacheData));
    } catch (e) {
      print('Error saving cache: $e');
    }
  }
}