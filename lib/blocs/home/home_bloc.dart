// lib/blocs/home/home_bloc.dart
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
        // Thử tải dữ liệu từ cache trước
        final cachedData = await _getCachedHomeData();
        if (cachedData != null) {
          emit(HomeLoaded(
            trains: cachedData['trains'] as List<Map<String, dynamic>>,
            schedules: cachedData['schedules'] as List<Map<String, dynamic>>,
            stations: cachedData['stations'] as List<Map<String, dynamic>>,
          ));
        }

        // Nếu cache quá cũ hoặc không tồn tại, tải dữ liệu mới
        if (_lastCacheTime == null ||
            DateTime.now().difference(_lastCacheTime!) > _cacheDuration ||
            cachedData == null) {

          // Tải dữ liệu tàu
          final List<Train> trains = await _trainService.getTrains();

          // Lấy ngày hiện tại cho lịch trình
          final now = DateTime.now();
          final fromDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

          // Tính ngày sau 7 ngày
          final nextWeek = now.add(Duration(days: 7));
          final toDate = '${nextWeek.year}-${nextWeek.month.toString().padLeft(2, '0')}-${nextWeek.day.toString().padLeft(2, '0')}';

          // Lấy lịch trình sắp tới
          final List<Schedule> schedules = await _trainService.getSchedules(
              fromDate: fromDate,
              toDate: toDate,
              status: 'ACTIVE'
          );

          // Lấy danh sách ga
          final List<Station> stations = await _stationService.getStations();

          // Mã hóa dữ liệu train để lưu cache
          final List<Map<String, dynamic>> trainsJson = trains.take(5).map((train) => {
            'id': train.id,
            'name': train.trainType,
            'status': train.status,
            'operator': train.trainOperator,
          }).toList();

          // Mã hóa dữ liệu schedule để lưu cache
          final List<Map<String, dynamic>> schedulesJson = schedules.take(10).map((schedule) => {
            'id': schedule.id,
            'trainId': schedule.trainId,
            'trainType': schedule.train?.trainType ?? 'Tàu chưa xác định',
            'departureDate': schedule.departureDate,
            'departureTime': schedule.departureTime,
            'arrivalTime': schedule.arrivalTime,
            'departureStation': schedule.departureStation,
            'arrivalStation': schedule.arrivalStation,
            'status': schedule.status,
          }).toList();

          // Mã hóa dữ liệu station để lưu cache
          final List<Map<String, dynamic>> stationsJson = stations.take(5).map((station) => {
            'id': station.id,
            'name': station.stationName,
            'location': station.location,
            'numberOfLines': station.numberOfLines,
          }).toList();

          // Lưu cache dữ liệu mới
          _cacheHomeData(trainsJson, schedulesJson, stationsJson);

          emit(HomeLoaded(
            trains: trainsJson,
            schedules: schedulesJson,
            stations: stationsJson,
          ));
        }
      } catch (e) {
        print('Lỗi tải dữ liệu trang chủ: $e');
        emit(HomeError('Không thể tải dữ liệu. Vui lòng thử lại sau.'));
      }
    });

    on<RefreshHomeData>((event, emit) async {
      try {
        // Tải dữ liệu từ API
        final List<Train> trains = await _trainService.getTrains();

        // Lấy ngày hiện tại cho lịch trình
        final now = DateTime.now();
        final fromDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

        // Tính ngày sau 7 ngày
        final nextWeek = now.add(Duration(days: 7));
        final toDate = '${nextWeek.year}-${nextWeek.month.toString().padLeft(2, '0')}-${nextWeek.day.toString().padLeft(2, '0')}';

        // Lấy lịch trình sắp tới
        final List<Schedule> schedules = await _trainService.getSchedules(
            fromDate: fromDate,
            toDate: toDate,
            status: 'ACTIVE'
        );

        // Lấy danh sách ga
        final List<Station> stations = await _stationService.getStations();

        // Mã hóa dữ liệu train để lưu cache
        final List<Map<String, dynamic>> trainsJson = trains.take(5).map((train) => {
          'id': train.id,
          'name': train.trainType,
          'status': train.status,
          'operator': train.trainOperator,
        }).toList();

        // Mã hóa dữ liệu schedule để lưu cache
        final List<Map<String, dynamic>> schedulesJson = schedules.take(10).map((schedule) => {
          'id': schedule.id,
          'trainId': schedule.trainId,
          'trainType': schedule.train?.trainType ?? 'Tàu chưa xác định',
          'departureDate': schedule.departureDate,
          'departureTime': schedule.departureTime,
          'arrivalTime': schedule.arrivalTime,
          'departureStation': schedule.departureStation,
          'arrivalStation': schedule.arrivalStation,
          'status': schedule.status,
        }).toList();

        // Mã hóa dữ liệu station để lưu cache
        final List<Map<String, dynamic>> stationsJson = stations.take(5).map((station) => {
          'id': station.id,
          'name': station.stationName,
          'location': station.location,
          'numberOfLines': station.numberOfLines,
        }).toList();

        // Lưu cache dữ liệu mới
        _cacheHomeData(trainsJson, schedulesJson, stationsJson);

        emit(HomeLoaded(
          trains: trainsJson,
          schedules: schedulesJson,
          stations: stationsJson,
        ));
      } catch (e) {
        // Nếu refresh thất bại, giữ lại trạng thái hiện tại
        if (state is HomeLoaded) {
          emit(state);
        } else {
          emit(HomeError('Không thể làm mới dữ liệu. Vui lòng thử lại sau.'));
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

        // Kiểm tra xem cache còn hợp lệ không
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
      // Nếu có lỗi khi đọc cache, trả về null và tải dữ liệu mới
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
      print('Lỗi khi lưu cache: $e');
    }
  }
}