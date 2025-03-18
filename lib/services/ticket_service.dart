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

  // Get user tickets - Return mock data instead of API call
  Future<List<Ticket>> getUserTickets() async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 800));
    
    // Return mock data
    return [
      Ticket(
        id: "1",
        scheduleId: "SCH001",
        seatNumber: "A12",
        passengerName: "Nguyễn Văn A",
        passengerPhone: "0912345678",
        passengerEmail: "nguyenvana@example.com",
        departureStation: "Hà Nội",
        arrivalStation: "Đà Nẵng",
        departureTime: "08:00 - 12/05/2023",
        arrivalTime: "14:30 - 12/05/2023",
        price: 850000,
        status: "ACTIVE",
        bookingCode: "BK12345",
        createdAt: "2023-05-10T10:30:00Z",
      ),
      Ticket(
        id: "2",
        scheduleId: "SCH002",
        seatNumber: "B15",
        passengerName: "Trần Thị B",
        passengerPhone: "0923456789",
        passengerEmail: "tranthib@example.com",
        departureStation: "TP.HCM",
        arrivalStation: "Vũng Tàu",
        departureTime: "09:30 - 15/05/2023",
        arrivalTime: "11:45 - 15/05/2023",
        price: 350000,
        status: "COMPLETED",
        bookingCode: "BK12346",
        createdAt: "2023-05-13T09:15:00Z",
      ),
      Ticket(
        id: "3",
        scheduleId: "SCH003",
        seatNumber: "C22",
        passengerName: "Lê Văn C",
        passengerPhone: "0934567890",
        passengerEmail: "levanc@example.com",
        departureStation: "Đà Nẵng",
        arrivalStation: "Huế",
        departureTime: "14:00 - 20/05/2023",
        arrivalTime: "16:30 - 20/05/2023",
        price: 450000,
        status: "CANCELED",
        bookingCode: "BK12347",
        createdAt: "2023-05-18T13:20:00Z",
      ),
      Ticket(
        id: "4",
        scheduleId: "SCH004",
        seatNumber: "D10",
        passengerName: "Phạm Thị D",
        passengerPhone: "0945678901",
        passengerEmail: "phamthid@example.com",
        departureStation: "Hà Nội",
        arrivalStation: "Sapa",
        departureTime: "07:30 - 25/05/2023",
        arrivalTime: "13:45 - 25/05/2023",
        price: 950000,
        status: "ACTIVE",
        bookingCode: "BK12348",
        createdAt: "2023-05-22T08:10:00Z",
      ),
    ];
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

  // Get available seats - Return mock data
  Future<List<Map<String, dynamic>>> getAvailableSeats(String scheduleId) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 800));
    
    // Generate 40 seats with some random availability
    final List<Map<String, dynamic>> seats = [];
    for (int i = 1; i <= 40; i++) {
      final String seatNumber = '${String.fromCharCode(65 + (i-1) ~/ 10)}${(i-1) % 10 + 1}';
      // Make 70% of seats available randomly
      final bool isAvailable = i % 3 != 0; // Simple pattern: every 3rd seat is unavailable
      
      seats.add({
        'seatNumber': seatNumber,
        'available': isAvailable,
        'price': 350000 + (i % 3) * 50000,  // Vary price a bit
      });
    }
    
    return seats;
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

  // Book ticket - Return mock success response
  Future<Map<String, dynamic>> bookTicket(Map<String, dynamic> ticketData) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 1200));
    
    // Create a mock ticket from the input data
    final mockTicket = {
      'id': 'TK${DateTime.now().millisecondsSinceEpoch}',
      'schedule_id': ticketData['schedule_id'],
      'seat_number': ticketData['seat_number'],
      'passenger_name': ticketData['passenger_name'],
      'passenger_phone': ticketData['passenger_phone'],
      'passenger_email': ticketData['passenger_email'],
      'departure_station': 'Hà Nội',
      'arrival_station': 'TP.HCM',
      'departure_time': '10:00 - 30/05/2023',
      'arrival_time': '12:15 - 30/05/2023',
      'price': 750000,
      'status': 'ACTIVE',
      'bookingCode': 'BK${DateTime.now().millisecondsSinceEpoch % 10000}',
      'createdAt': DateTime.now().toIso8601String(),
    };
    
    return {
      'success': true,
      'message': 'Đặt vé thành công',
      'data': mockTicket,
    };
  }

  // Cancel ticket - Return mock success response
  Future<Map<String, dynamic>> cancelTicket(String ticketId) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 800));
    
    return {
      'success': true,
      'message': 'Hủy vé thành công',
      'data': {
        'id': ticketId,
        'status': 'CANCELED',
      }
    };
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