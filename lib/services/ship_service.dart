import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;
import '../models/ship.dart';
import 'api_service.dart';

class ShipService extends ApiService {
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

  // Get all ships
  Future<Map<String, dynamic>> getShips() async {
    final result = await get('ships');
    
    if (result['success'] == true && result['data'] != null) {
      try {
        final List<dynamic> shipData = result['data'];
        final ships = shipData.map((item) => Ship.fromJson(item)).toList();
        return {
          'success': true,
          'data': ships,
          'message': result['message'] ?? 'Ships fetched successfully'
        };
      } catch (e) {
        return {
          'success': false,
          'message': 'Error parsing ship data: $e'
        };
      }
    }
    return result;
  }

  // Add a new ship
  Future<Map<String, dynamic>> addShip(Ship ship) async {
    return await post('ships', ship.toJson());
  }

  // Update a ship
  Future<Map<String, dynamic>> updateShip(String id, Ship ship) async {
    return await put('ships/$id', ship.toJson());
  }

  // Delete a ship
  Future<Map<String, dynamic>> deleteShip(String id) async {
    return await delete('ships/$id');
  }

  // Get a specific ship by ID
  Future<Map<String, dynamic>> getShipById(String id) async {
    final result = await get('ships/$id');
    
    if (result['success'] == true && result['data'] != null) {
      try {
        final Ship ship = Ship.fromJson(result['data']);
        return {
          'success': true,
          'data': ship,
          'message': result['message'] ?? 'Ship fetched successfully'
        };
      } catch (e) {
        return {
          'success': false,
          'message': 'Error parsing ship data: $e'
        };
      }
    }
    return result;
  }

  // Search ships by name, type, or route
  Future<Map<String, dynamic>> searchShips(String query) async {
    final result = await get('ships/search?q=$query');
    
    if (result['success'] == true && result['data'] != null) {
      try {
        final List<dynamic> shipData = result['data'];
        final ships = shipData.map((item) => Ship.fromJson(item)).toList();
        return {
          'success': true,
          'data': ships,
          'message': result['message'] ?? 'Ships searched successfully'
        };
      } catch (e) {
        return {
          'success': false,
          'message': 'Error parsing ship data: $e'
        };
      }
    }
    return result;
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