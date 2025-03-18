import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/station.dart';
import 'dart:io' show Platform;
import 'api_service.dart';

class StationService extends ApiService {
  static const String _baseEndpoint = 'railway/stations';

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

  // Get all stations
  Future<List<Station>> getStations() async {
    try {
      // Simulate API delay
      await Future.delayed(Duration(milliseconds: 800));
      
      // Return mock data instead of API call
      return [
        Station(
          id: "1",
          stationName: "Ga Hà Nội",
          location: "120 Lê Duẩn, Hà Nội",
          code: "HAN",
          numberOfLines: 5,
          facilities: "Wifi, Nhà hàng, Phòng chờ VIP",
          operatingHours: "04:00 - 22:00",
          contactInfo: "024 3825 3949",
        ),
        Station(
          id: "2",
          stationName: "Ga Đà Nẵng",
          location: "200 Hải Phòng, Đà Nẵng",
          code: "DAN",
          numberOfLines: 3,
          facilities: "Wifi, Quầy ăn nhanh",
          operatingHours: "05:00 - 21:00",
          contactInfo: "0236 3823 070",
        ),
        Station(
          id: "3",
          stationName: "Ga Sài Gòn",
          location: "1 Nguyễn Thông, Quận 3, TP.HCM",
          code: "SGN",
          numberOfLines: 6,
          facilities: "Wifi, Nhà hàng, Phòng chờ VIP, Dịch vụ hành lý",
          operatingHours: "04:30 - 23:00",
          contactInfo: "028 3846 6091",
        ),
        Station(
          id: "4",
          stationName: "Ga Huế",
          location: "2 Bùi Thị Xuân, Huế",
          code: "HUE",
          numberOfLines: 2,
          facilities: "Wifi, Quầy ăn nhanh",
          operatingHours: "05:30 - 20:00",
          contactInfo: "0234 3822 175",
        ),
        Station(
          id: "5",
          stationName: "Ga Nha Trang",
          location: "17 Thái Nguyên, Nha Trang",
          code: "NTR",
          numberOfLines: 2,
          facilities: "Wifi, Quầy cafe",
          operatingHours: "05:00 - 21:30",
          contactInfo: "0258 3822 113",
        ),
      ];
    } catch (e) {
      print('Error getting stations: $e');
      return [];
    }
  }

  // Get a specific station by ID
  Future<Station?> getStationById(String id) async {
    try {
      final result = await get('$_baseEndpoint/$id');
      
      if (result['success'] == true && result['data'] != null) {
        return Station.fromJson(result['data'] as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting station by ID: $e');
      return null;
    }
  }

  // Create a new station
  Future<Map<String, dynamic>> createStation(Map<String, dynamic> stationData) async {
    try {
      final result = await post(_baseEndpoint, stationData);
      print('Create Station Response: $result'); // Debug log
      return result;
    } catch (e) {
      print('Error creating station: $e');
      return {
        'success': false,
        'message': 'Không thể tạo ga. Lỗi: $e'
      };
    }
  }

  // Update a station
  Future<Map<String, dynamic>> updateStation(String id, Map<String, dynamic> stationData) async {
    try {
      final result = await put('$_baseEndpoint/$id', stationData);
      print('Update Station Response: $result'); // Debug log
      return result;
    } catch (e) {
      print('Error updating station: $e');
      return {
        'success': false,
        'message': 'Không thể cập nhật ga. Lỗi: $e'
      };
    }
  }

  // Delete a station
  Future<Map<String, dynamic>> deleteStation(String id) async {
    try {
      final result = await delete('$_baseEndpoint/$id');
      print('Delete Station Response: $result'); // Debug log
      return result;
    } catch (e) {
      print('Error deleting station: $e');
      return {
        'success': false,
        'message': 'Không thể xóa ga. Lỗi: $e'
      };
    }
  }

  // Search stations
  Future<List<Station>> searchStations(String keyword) async {
    try {
      final result = await get('$_baseEndpoint/search?q=$keyword');
      print('Search Stations Response: $result'); // Debug log

      if (result['success'] == true && result['data'] != null) {
        return (result['data'] as List)
            .map((item) => Station.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error searching stations: $e');
      return [];
    }
  }

  // Get all railway stations
  Future<Map<String, dynamic>> getAllRailwayStations() async {
    return await get('railway/stations');
  }

  // Create a railway station
  Future<Map<String, dynamic>> createRailwayStation(Map<String, dynamic> stationData) async {
    return await post('railway/stations', stationData);
  }

  // Update a railway station
  Future<Map<String, dynamic>> updateRailwayStation(String id, Map<String, dynamic> stationData) async {
    return await put('railway/stations/$id', stationData);
  }

  // Delete a railway station
  Future<Map<String, dynamic>> deleteRailwayStation(String id) async {
    return await delete('railway/stations/$id');
  }
}