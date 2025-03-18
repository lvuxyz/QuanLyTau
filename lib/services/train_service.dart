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
      // Simulate API delay
      await Future.delayed(Duration(milliseconds: 800));
      
      // Return mock data
      return [
        Train(
          id: "1",
          trainType: "PASSENGER",
          trainOperator: "Vietnam Railways",
          capacity: 320,
          status: "ACTIVE",
          route: "Hà Nội - TP.HCM",
          amenities: ["WiFi", "Food Service", "Air Conditioning"],
          lastMaintenanceDate: "2023-04-15",
        ),
        Train(
          id: "2",
          trainType: "PASSENGER",
          trainOperator: "Vietnam Railways",
          capacity: 320,
          status: "ACTIVE",
          route: "TP.HCM - Hà Nội",
          amenities: ["WiFi", "Food Service", "Air Conditioning"],
          lastMaintenanceDate: "2023-04-10",
        ),
        Train(
          id: "3",
          trainType: "PASSENGER",
          trainOperator: "Vietnam Railways",
          capacity: 280,
          status: "ACTIVE",
          route: "Hà Nội - Đà Nẵng",
          amenities: ["WiFi", "Air Conditioning"],
          lastMaintenanceDate: "2023-04-20",
        ),
        Train(
          id: "4",
          trainType: "PASSENGER",
          trainOperator: "Vietnam Railways",
          capacity: 280,
          status: "ACTIVE",
          route: "Đà Nẵng - Hà Nội",
          amenities: ["WiFi", "Air Conditioning"],
          lastMaintenanceDate: "2023-04-25",
        ),
        Train(
          id: "5",
          trainType: "EXPRESS",
          trainOperator: "Vietnam Railways",
          capacity: 240,
          status: "ACTIVE",
          route: "Hà Nội - TP.HCM",
          amenities: ["WiFi", "Premium Food Service", "Air Conditioning", "Power Outlets"],
          lastMaintenanceDate: "2023-05-05",
        ),
      ];
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
      // Simulate API delay
      await Future.delayed(Duration(milliseconds: 800));
      
      // Return mock schedules
      return [
        Schedule(
          id: "1",
          trainId: "1",
          trainName: "SE1",
          departureStation: "Ga Hà Nội",
          arrivalStation: "Ga Sài Gòn",
          departureTime: "08:00",
          arrivalTime: "18:30",
          departureDate: "2023-05-20",
          price: 1200000,
          status: "ACTIVE",
        ),
        Schedule(
          id: "2",
          trainId: "2",
          trainName: "SE2",
          departureStation: "Ga Sài Gòn",
          arrivalStation: "Ga Hà Nội",
          departureTime: "20:00",
          arrivalTime: "06:30",
          departureDate: "2023-05-20",
          price: 1200000,
          status: "ACTIVE",
        ),
        Schedule(
          id: "3",
          trainId: "3",
          trainName: "SE3",
          departureStation: "Ga Hà Nội",
          arrivalStation: "Ga Đà Nẵng",
          departureTime: "09:30",
          arrivalTime: "15:45",
          departureDate: "2023-05-21",
          price: 750000,
          status: "ACTIVE",
        ),
        Schedule(
          id: "4",
          trainId: "4",
          trainName: "SE4",
          departureStation: "Ga Đà Nẵng",
          arrivalStation: "Ga Hà Nội",
          departureTime: "08:00",
          arrivalTime: "14:15",
          departureDate: "2023-05-22",
          price: 750000,
          status: "ACTIVE",
        ),
        Schedule(
          id: "5",
          trainId: "5",
          trainName: "SE5",
          departureStation: "Ga Hà Nội",
          arrivalStation: "Ga Sài Gòn",
          departureTime: "17:30",
          arrivalTime: "03:15",
          departureDate: "2023-05-23",
          price: 1450000,
          status: "ACTIVE",
        ),
      ];
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