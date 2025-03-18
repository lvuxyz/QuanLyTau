import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;
import 'api_service.dart';
import '../models/ticket.dart';

class TicketService extends ApiService {
  static const String _baseEndpoint = 'railway/tickets';

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

  // Get all tickets
  Future<List<Ticket>> getTickets() async {
    try {
      final result = await get(_baseEndpoint);
      print('Get Tickets Response: $result');

      if (result['success'] == true && result['data'] != null) {
        return (result['data'] as List)
            .map((item) => Ticket.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error getting tickets: $e');
      return [];
    }
  }

  // Get ticket by ID
  Future<Ticket?> getTicketById(String id) async {
    try {
      final result = await get('$_baseEndpoint/$id');
      print('Get Ticket By ID Response: $result');

      if (result['success'] == true && result['data'] != null) {
        return Ticket.fromJson(result['data'] as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting ticket by ID: $e');
      return null;
    }
  }

  // Book ticket
  Future<Map<String, dynamic>> bookTicket(Map<String, dynamic> ticketData) async {
    try {
      final result = await post('$_baseEndpoint/book', ticketData);
      print('Book Ticket Response: $result');
      return result;
    } catch (e) {
      print('Error booking ticket: $e');
      return {
        'success': false,
        'message': 'Không thể đặt vé. Lỗi: $e'
      };
    }
  }

  // Cancel ticket
  Future<Map<String, dynamic>> cancelTicket(String id) async {
    try {
      final result = await put('$_baseEndpoint/$id/cancel', {});
      print('Cancel Ticket Response: $result');
      return result;
    } catch (e) {
      print('Error canceling ticket: $e');
      return {
        'success': false,
        'message': 'Không thể hủy vé. Lỗi: $e'
      };
    }
  }

  // Get user tickets
  Future<List<Ticket>> getUserTickets() async {
    try {
      final result = await get('$_baseEndpoint/my-tickets');
      print('Get User Tickets Response: $result');

      if (result['success'] == true && result['data'] != null) {
        return (result['data'] as List)
            .map((item) => Ticket.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error getting user tickets: $e');
      return [];
    }
  }

  // Verify ticket
  Future<Map<String, dynamic>> verifyTicket(String id) async {
    try {
      final result = await put('$_baseEndpoint/$id/verify', {});
      print('Verify Ticket Response: $result');
      return result;
    } catch (e) {
      print('Error verifying ticket: $e');
      return {
        'success': false,
        'message': 'Không thể xác thực vé. Lỗi: $e'
      };
    }
  }

  // Get tickets by schedule
  Future<List<Ticket>> getTicketsBySchedule(String scheduleId) async {
    try {
      final result = await get('$_baseEndpoint/schedule/$scheduleId');
      print('Get Tickets By Schedule Response: $result');

      if (result['success'] == true && result['data'] != null) {
        return (result['data'] as List)
            .map((item) => Ticket.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error getting tickets by schedule: $e');
      return [];
    }
  }

  // Get available seats
  Future<List<Map<String, dynamic>>> getAvailableSeats(String scheduleId) async {
    try {
      final result = await get('$_baseEndpoint/schedule/$scheduleId/available-seats');
      print('Get Available Seats Response: $result');

      if (result['success'] == true && result['data'] != null) {
        return List<Map<String, dynamic>>.from(result['data']);
      }
      return [];
    } catch (e) {
      print('Error getting available seats: $e');
      return [];
    }
  }

  // Update ticket
  Future<Map<String, dynamic>> updateTicket(String id, Map<String, dynamic> ticketData) async {
    try {
      final result = await put('$_baseEndpoint/$id', ticketData);
      print('Update Ticket Response: $result');
      return result;
    } catch (e) {
      print('Error updating ticket: $e');
      return {
        'success': false,
        'message': 'Không thể cập nhật vé. Lỗi: $e'
      };
    }
  }

  // Delete ticket (Admin only)
  Future<Map<String, dynamic>> deleteTicket(String id) async {
    try {
      final result = await delete('$_baseEndpoint/$id');
      print('Delete Ticket Response: $result');
      return result;
    } catch (e) {
      print('Error deleting ticket: $e');
      return {
        'success': false,
        'message': 'Không thể xóa vé. Lỗi: $e'
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