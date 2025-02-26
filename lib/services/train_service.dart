// lib/services/train_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/train.dart';
import '../models/station.dart';
import '../models/schedule.dart';
import 'dart:io' show Platform;

class TrainService {
  bool get isAndroid => Platform.isAndroid;

  String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://192.19.14.24:3000/api/v1';
    } else {
      return 'http://localhost:3000/api/v1';
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Map<String, String> _getHeaders([bool needsAuth = true]) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    return headers;
  }

  // Helper method to update auth header if needed
  Future<Map<String, String>> _getAuthHeaders() async {
    final headers = _getHeaders();
    final token = await _getToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // Lấy danh sách tàu
  Future<List<Train>> getTrains() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/trains/list'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success'] && jsonData['data'] != null) {
          return (jsonData['data'] as List)
              .map((item) => Train.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      }
      throw Exception('Không thể lấy dữ liệu tàu');
    } catch (e) {
      print('Lỗi khi lấy danh sách tàu: $e');
      // Trả về danh sách trống trong trường hợp lỗi
      return [];
    }
  }

  // Lấy danh sách ga
  Future<List<Station>> getStations() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/railway/stations'),
        headers: _getHeaders(false), // Không cần xác thực cho API này
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success'] && jsonData['data'] != null) {
          final stationsData = jsonData['data']['stations'];
          return (stationsData as List)
              .map((item) => Station.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      }
      throw Exception('Không thể lấy dữ liệu ga');
    } catch (e) {
      print('Lỗi khi lấy danh sách ga: $e');
      return [];
    }
  }

  // Lấy danh sách lịch trình
  Future<List<Schedule>> getSchedules({
    String? trainId,
    String? departureStation,
    String? arrivalStation,
    String? fromDate,
    String? toDate,
    String? status,
  }) async {
    try {
      // Xây dựng query parameters
      final queryParams = <String, String>{};
      if (trainId != null) queryParams['train_id'] = trainId;
      if (departureStation != null) queryParams['departure_station'] = departureStation;
      if (arrivalStation != null) queryParams['arrival_station'] = arrivalStation;
      if (fromDate != null) queryParams['from_date'] = fromDate;
      if (toDate != null) queryParams['to_date'] = toDate;
      if (status != null) queryParams['status'] = status;

      final uri = Uri.parse('$baseUrl/schedules').replace(queryParameters: queryParams);
      final response = await http.get(
        uri,
        headers: _getHeaders(false), // Không cần xác thực cho API này
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success'] && jsonData['data'] != null) {
          return (jsonData['data'] as List)
              .map((item) => Schedule.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      }
      throw Exception('Không thể lấy dữ liệu lịch trình');
    } catch (e) {
      print('Lỗi khi lấy danh sách lịch trình: $e');
      return [];
    }
  }
}