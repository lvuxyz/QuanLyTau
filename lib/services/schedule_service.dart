import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;
import 'api_service.dart';
import '../models/schedule.dart';

class ScheduleService extends ApiService {
  static const String _baseEndpoint = 'railway/schedules';

  bool get isAndroid => Platform.isAndroid;

  String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://192.168.2.37:3000/api/v1'; // Use the actual IP address of your computer on the WiFi network
    } else {
      return 'http://localhost:3000/api/v1'; // For iOS or Web
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<Map<String, String>> get _authHeaders async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Get all schedules
  Future<List<Schedule>> getSchedules() async {
    try {
      final result = await get(_baseEndpoint);
      print('Get Schedules Response: $result');

      if (result['success'] == true && result['data'] != null) {
        return (result['data'] as List)
            .map((item) => Schedule.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error getting schedules: $e');
      return [];
    }
  }

  // Get schedule by ID
  Future<Schedule?> getScheduleById(String id) async {
    try {
      final result = await get('$_baseEndpoint/$id');
      print('Get Schedule By ID Response: $result');

      if (result['success'] == true && result['data'] != null) {
        return Schedule.fromJson(result['data'] as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting schedule by ID: $e');
      return null;
    }
  }

  // Create schedule
  Future<Map<String, dynamic>> createSchedule(Map<String, dynamic> scheduleData) async {
    try {
      final result = await post(_baseEndpoint, scheduleData);
      print('Create Schedule Response: $result');
      return result;
    } catch (e) {
      print('Error creating schedule: $e');
      return {
        'success': false,
        'message': 'Không thể tạo lịch trình. Lỗi: $e'
      };
    }
  }

  // Update schedule
  Future<Map<String, dynamic>> updateSchedule(String id, Map<String, dynamic> scheduleData) async {
    try {
      final result = await put('$_baseEndpoint/$id', scheduleData);
      print('Update Schedule Response: $result');
      return result;
    } catch (e) {
      print('Error updating schedule: $e');
      return {
        'success': false,
        'message': 'Không thể cập nhật lịch trình. Lỗi: $e'
      };
    }
  }

  // Delete schedule
  Future<Map<String, dynamic>> deleteSchedule(String id) async {
    try {
      final result = await delete('$_baseEndpoint/$id');
      print('Delete Schedule Response: $result');
      return result;
    } catch (e) {
      print('Error deleting schedule: $e');
      return {
        'success': false,
        'message': 'Không thể xóa lịch trình. Lỗi: $e'
      };
    }
  }

  // Search schedules
  Future<List<Schedule>> searchSchedules({
    String? trainId,
    String? departureStation,
    String? arrivalStation,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (trainId != null) queryParams['train_id'] = trainId;
      if (departureStation != null) queryParams['departure_station'] = departureStation;
      if (arrivalStation != null) queryParams['arrival_station'] = arrivalStation;
      if (fromDate != null) queryParams['from_date'] = fromDate.toIso8601String();
      if (toDate != null) queryParams['to_date'] = toDate.toIso8601String();

      final queryString = queryParams.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
          .join('&');

      final result = await get('$_baseEndpoint/search?$queryString');
      print('Search Schedules Response: $result');

      if (result['success'] == true && result['data'] != null) {
        return (result['data'] as List)
            .map((item) => Schedule.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error searching schedules: $e');
      return [];
    }
  }

  // Get schedules by train
  Future<List<Schedule>> getSchedulesByTrain(String trainId) async {
    try {
      final result = await get('$_baseEndpoint/train/$trainId');
      print('Get Schedules By Train Response: $result');

      if (result['success'] == true && result['data'] != null) {
        return (result['data'] as List)
            .map((item) => Schedule.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error getting schedules by train: $e');
      return [];
    }
  }

  // Get schedules by station
  Future<List<Schedule>> getSchedulesByStation(String stationId) async {
    try {
      final result = await get('$_baseEndpoint/station/$stationId');
      print('Get Schedules By Station Response: $result');

      if (result['success'] == true && result['data'] != null) {
        return (result['data'] as List)
            .map((item) => Schedule.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error getting schedules by station: $e');
      return [];
    }
  }

  // Cancel schedule
  Future<Map<String, dynamic>> cancelSchedule(String id) async {
    try {
      final result = await put('$_baseEndpoint/$id/cancel', {});
      print('Cancel Schedule Response: $result');
      return result;
    } catch (e) {
      print('Error canceling schedule: $e');
      return {
        'success': false,
        'message': 'Không thể hủy lịch trình. Lỗi: $e'
      };
    }
  }

  String _handleErrorResponse(http.Response response) {
    try {
      final errorData = json.decode(response.body);
      return errorData['message'] ?? 'Unknown error';
    } catch (e) {
      return 'Server error (Error code: ${response.statusCode})';
    }
  }
} 