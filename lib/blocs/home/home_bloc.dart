import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../models/train.dart';
import '../../models/schedule.dart';
import '../../models/station.dart';
import '../../services/train_service.dart';
import '../../services/station_service.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  static const String _cacheKey = 'home_data_cache';
  static const Duration _cacheDuration = Duration(minutes: 30);
  static DateTime? _lastCacheTime;

  final TrainService _trainService = TrainService();
  final StationService _stationService = StationService();

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
            trains: cachedData['trains'] as List<Map<String, dynamic>>,
            schedules: cachedData['schedules'] as List<Map<String, dynamic>>,
            stations: cachedData['stations'] as List<Map<String, dynamic>>,
          ));
        }

        // If cache is too old or doesn't exist, load new data
        if (_lastCacheTime == null ||
            DateTime.now().difference(_lastCacheTime!) > _cacheDuration ||
            cachedData == null) {

          // Load trains
          final List<Train> trains = await _trainService.getTrains();

          // Get current date for schedules
          final now = DateTime.now();
          final fromDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

          // Calculate date 7 days ahead
          final nextWeek = now.add(Duration(days: 7));
          final toDate = '${nextWeek.year}-${nextWeek.month.toString().padLeft(2, '0')}-${nextWeek.day.toString().padLeft(2, '0')}';

          // Load upcoming schedules
          final List<Schedule> schedules = await _trainService.getSchedules(
              fromDate: fromDate,
              toDate: toDate,
              status: 'ACTIVE'
          );

          // Load stations
          final List<Station> stations = await _stationService.getStations();

          // Encode train data for caching
          final List<Map<String, dynamic>> trainsJson = trains.take(5).map((train) => {
            'id': train.id,
            'name': train.trainType,
            'status': train.status,
            'operator': train.trainOperator,
          }).toList();

          // Encode schedule data for caching
          final List<Map<String, dynamic>> schedulesJson = schedules.take(10).map((schedule) => {
            'id': schedule.id,
            'trainId': schedule.trainId,
            'trainType': schedule.train?.trainType ?? 'Unknown',
            'departureDate': schedule.departureDate,
            'departureTime': schedule.departureTime,
            'arrivalTime': schedule.arrivalTime,
            'departureStation': schedule.departureStation,
            'arrivalStation': schedule.arrivalStation,
            'status': schedule.status,
          }).toList();

          // Encode station data for caching
          final List<Map<String, dynamic>> stationsJson = stations.take(5).map((station) => {
            'id': station.id,
            'name': station.stationName,
            'location': station.location,
            'numberOfLines': station.numberOfLines,
          }).toList();

          // Cache new data
          _cacheHomeData(trainsJson, schedulesJson, stationsJson);

          emit(HomeLoaded(
            trains: trainsJson,
            schedules: schedulesJson,
            stations: stationsJson,
          ));
        }
      } catch (e) {
        print('Error loading home data: $e');
        emit(HomeError('Unable to load data. Please try again later.'));
      }
    });

    on<RefreshHomeData>((event, emit) async {
      try {
        // Load data from APIs
        final List<Train> trains = await _trainService.getTrains();

        // Get current date for schedules
        final now = DateTime.now();
        final fromDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

        // Calculate date 7 days ahead
        final nextWeek = now.add(Duration(days: 7));
        final toDate = '${nextWeek.year}-${nextWeek.month.toString().padLeft(2, '0')}-${nextWeek.day.toString().padLeft(2, '0')}';

        // Load upcoming schedules
        final List<Schedule> schedules = await _trainService.getSchedules(
            fromDate: fromDate,
            toDate: toDate,
            status: 'ACTIVE'
        );

        // Load stations
        final List<Station> stations = await _stationService.getStations();

        // Encode train data for caching
        final List<Map<String, dynamic>> trainsJson = trains.take(5).map((train) => {
          'id': train.id,
          'name': train.trainType,
          'status': train.status,
          'operator': train.trainOperator,
        }).toList();

        // Encode schedule data for caching
        final List<Map<String, dynamic>> schedulesJson = schedules.take(10).map((schedule) => {
          'id': schedule.id,
          'trainId': schedule.trainId,
          'trainType': schedule.train?.trainType ?? 'Unknown',
          'departureDate': schedule.departureDate,
          'departureTime': schedule.departureTime,
          'arrivalTime': schedule.arrivalTime,
          'departureStation': schedule.departureStation,
          'arrivalStation': schedule.arrivalStation,
          'status': schedule.status,
        }).toList();

        // Encode station data for caching
        final List<Map<String, dynamic>> stationsJson = stations.take(5).map((station) => {
          'id': station.id,
          'name': station.stationName,
          'location': station.location,
          'numberOfLines': station.numberOfLines,
        }).toList();

        // Cache new data
        _cacheHomeData(trainsJson, schedulesJson, stationsJson);

        emit(HomeLoaded(
          trains: trainsJson,
          schedules: schedulesJson,
          stations: stationsJson,
        ));
      } catch (e) {
        // If refresh fails, keep current state if it's HomeLoaded
        if (state is HomeLoaded) {
          emit(state);
        } else {
          emit(HomeError('Unable to refresh data. Please try again later.'));
        }
      }
    });
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
            'trains': List<Map<String, dynamic>>.from(cachedData['trains']),
            'schedules': List<Map<String, dynamic>>.from(cachedData['schedules']),
            'stations': List<Map<String, dynamic>>.from(cachedData['stations']),
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
      List<Map<String, dynamic>> trains,
      List<Map<String, dynamic>> schedules,
      List<Map<String, dynamic>> stations
      ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now();
      _lastCacheTime = now;

      final cacheData = {
        'timestamp': now.millisecondsSinceEpoch,
        'trains': trains,
        'schedules': schedules,
        'stations': stations,
      };

      await prefs.setString(_cacheKey, json.encode(cacheData));
    } catch (e) {
      print('Error caching data: $e');
    }
  }
}