// lib/services/station_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/station.dart';
import 'dart:io' show Platform;

class StationService {
  String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://192.19.14.24:3000/api/v1';
    } else {
      return 'http://localhost:3000/api/v1';
    }
  }

  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  // Lấy danh sách ga
  Future<List<Station>> getStations() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/railway/stations'),
        headers: _getHeaders(),
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

  // Lấy chi tiết ga
  Future<Station?> getStationById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/railway/stations/$id'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success'] && jsonData['data'] != null) {
          return Station.fromJson(jsonData['data']);
        }
      }
      return null;
    } catch (e) {
      print('Lỗi khi lấy chi tiết ga: $e');
      return null;
    }
  }
}