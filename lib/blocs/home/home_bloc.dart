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
        // Try to load cached data first for instant UI rendering
        final cachedData = await _getCachedHomeData();
        if (cachedData != null) {
          emit(HomeLoaded(
            recentShips: cachedData['recentShips'],
            promotions: cachedData['promotions'],
          ));
        }

        // If cache is old or doesn't exist, fetch fresh data
        if (_lastCacheTime == null ||
            DateTime.now().difference(_lastCacheTime!) > _cacheDuration ||
            cachedData == null) {

          // In a real app, this would be an API call
          await Future.delayed(Duration(milliseconds: 300));

          final recentShips = [
            {'id': '1', 'name': 'Tàu A', 'status': 'Đang hoạt động', 'imageUrl': 'https://example.com/ship1.jpg'},
            {'id': '2', 'name': 'Tàu B', 'status': 'Bảo trì', 'imageUrl': 'https://example.com/ship2.jpg'},
          ];

          final promotions = [
            {'id': '1', 'title': 'Khuyến mãi tháng 6', 'discount': '20%', 'imageUrl': 'https://example.com/promo1.jpg'},
            {'id': '2', 'title': 'Ưu đãi đặc biệt', 'discount': '15%', 'imageUrl': 'https://example.com/promo2.jpg'},
          ];

          // Cache the new data
          _cacheHomeData(recentShips, promotions);

          emit(HomeLoaded(
            recentShips: recentShips,
            promotions: promotions,
          ));
        }
      } catch (e) {
        emit(HomeError('Không thể tải dữ liệu. Vui lòng thử lại sau.'));
      }
    });

    on<RefreshHomeData>((event, emit) async {
      final currentState = state;
      if (currentState is HomeLoaded) {
        // Keep current data visible while refreshing
        try {
          // In a real app, this would be an API call
          await Future.delayed(Duration(milliseconds: 800));

          final recentShips = [
            {'id': '1', 'name': 'Tàu A', 'status': 'Đang hoạt động', 'imageUrl': 'https://example.com/ship1.jpg'},
            {'id': '2', 'name': 'Tàu B', 'status': 'Bảo trì', 'imageUrl': 'https://example.com/ship2.jpg'},
            {'id': '3', 'name': 'Tàu C', 'status': 'Đang hoạt động', 'imageUrl': 'https://example.com/ship3.jpg'},
          ];

          final promotions = [
            {'id': '1', 'title': 'Khuyến mãi tháng 6', 'discount': '20%', 'imageUrl': 'https://example.com/promo1.jpg'},
            {'id': '2', 'title': 'Ưu đãi đặc biệt', 'discount': '15%', 'imageUrl': 'https://example.com/promo2.jpg'},
          ];

          // Cache the new data
          _cacheHomeData(recentShips, promotions);

          emit(HomeLoaded(
            recentShips: recentShips,
            promotions: promotions,
          ));
        } catch (e) {
          // If refresh fails, keep showing existing data
          emit(currentState);
        }
      }
    });

    on<SearchShips>((event, emit) async {
      // Keep this implementation as is or enhance as needed
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
            'recentShips': List<Map<String, dynamic>>.from(cachedData['recentShips']),
            'promotions': List<Map<String, dynamic>>.from(cachedData['promotions']),
          };
        }
      }
      return null;
    } catch (e) {
      // If there's any error reading cache, return null and fetch fresh data
      return null;
    }
  }

  Future<void> _cacheHomeData(List<Map<String, dynamic>> ships, List<Map<String, dynamic>> promotions) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now();
      _lastCacheTime = now;

      final cacheData = {
        'timestamp': now.millisecondsSinceEpoch,
        'recentShips': ships,
        'promotions': promotions,
      };

      await prefs.setString(_cacheKey, json.encode(cacheData));
    } catch (e) {
      // Silent failure if caching doesn't work
    }
  }
}