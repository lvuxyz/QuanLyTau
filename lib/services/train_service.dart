import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/train.dart';
import '../models/station.dart';
import '../models/schedule.dart';
import 'dart:io' show Platform;
import 'api_service.dart';

class TrainService extends ApiService {
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

  // Get all trains
  Future<List<Train>> getTrains() async {
    try {
      final result = await get('trains');

      if (result['success'] == true && result['data'] != null) {
        return (result['data'] as List)
            .map((item) => Train.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error getting trains: $e');
      return [];
    }
  }

  // Add a new train
  Future<Map<String, dynamic>> addTrain(Map<String, dynamic> trainData) async {
    return await post('trains', trainData);
  }

  // Update a train
  Future<Map<String, dynamic>> updateTrain(String id, Map<String, dynamic> trainData) async {
    return await put('trains/$id', trainData);
  }

  // Delete a train
  Future<Map<String, dynamic>> deleteTrain(String id) async {
    return await delete('trains/$id');
  }

  // Get a specific train by ID
  Future<Map<String, dynamic>> getTrainById(String id) async {
    return await get('trains/$id');
  }

  // Get schedules for a specific train
  Future<Map<String, dynamic>> getTrainSchedules(String trainId) async {
    return await get('trains/$trainId/schedules');
  }

  // Get stations
  Future<List<Station>> getStations() async {
    try {
      final result = await get('stations');

      if (result['success'] == true && result['data'] != null) {
        return (result['data'] as List)
            .map((item) => Station.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error getting stations: $e');
      return [];
    }
  }

  // Get schedules
  Future<List<Schedule>> getSchedules({
    String? trainId,
    String? departureStation,
    String? arrivalStation,
    String? fromDate,
    String? toDate,
    String? status,
  }) async {
    try {
      // Build query parameters
      final queryParams = <String, String>{};
      if (trainId != null) queryParams['train_id'] = trainId;
      if (departureStation != null) queryParams['departure_station'] = departureStation;
      if (arrivalStation != null) queryParams['arrival_station'] = arrivalStation;
      if (fromDate != null) queryParams['from_date'] = fromDate;
      if (toDate != null) queryParams['to_date'] = toDate;
      if (status != null) queryParams['status'] = status;

      String endpoint = 'schedules';
      if (queryParams.isNotEmpty) {
        final queryString = queryParams.entries
            .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
            .join('&');
        endpoint = '$endpoint?$queryString';
      }

      final result = await get(endpoint);

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

  Future<Map<String, dynamic>> getAllTrains() async {
    return await get('trains');
  }

  Future<Map<String, dynamic>> getTrainSeats(String trainId) async {
    return await get('trains/$trainId/seats');
  }
}