// lib/models/ticket.dart
import 'schedule.dart';

class Ticket {
  final String id;
  final String scheduleId;
  final String seatNumber;
  final String passengerName;
  final String passengerPhone;
  final String passengerEmail;
  final String departureStation;
  final String arrivalStation;
  final String departureTime;
  final String arrivalTime;
  final double price;
  final String status; // 'booked', 'cancelled', 'verified'
  final String? bookingCode;
  final String? createdAt;
  final String? updatedAt;
  final Schedule? schedule;

  const Ticket({
    required this.id,
    required this.scheduleId,
    required this.seatNumber,
    required this.passengerName,
    required this.passengerPhone,
    required this.passengerEmail,
    required this.departureStation,
    required this.arrivalStation,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
    required this.status,
    this.bookingCode,
    this.createdAt,
    this.updatedAt,
    this.schedule,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'] as String,
      scheduleId: json['schedule_id'] as String,
      seatNumber: json['seat_number'] as String,
      passengerName: json['passenger_name'] as String,
      passengerPhone: json['passenger_phone'] as String,
      passengerEmail: json['passenger_email'] as String,
      departureStation: json['departure_station'] as String,
      arrivalStation: json['arrival_station'] as String,
      departureTime: json['departure_time'] as String,
      arrivalTime: json['arrival_time'] as String,
      price: (json['price'] as num).toDouble(),
      status: json['status'] as String,
      bookingCode: json['bookingCode'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      schedule: json['schedule'] != null ? Schedule.fromJson(json['schedule']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'schedule_id': scheduleId,
      'seat_number': seatNumber,
      'passenger_name': passengerName,
      'passenger_phone': passengerPhone,
      'passenger_email': passengerEmail,
      'departure_station': departureStation,
      'arrival_station': arrivalStation,
      'departure_time': departureTime,
      'arrival_time': arrivalTime,
      'price': price,
      'status': status,
      'bookingCode': bookingCode,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'schedule': schedule?.toJson(),
    };
  }

  Ticket copyWith({
    String? id,
    String? scheduleId,
    String? seatNumber,
    String? passengerName,
    String? passengerPhone,
    String? passengerEmail,
    String? departureStation,
    String? arrivalStation,
    String? departureTime,
    String? arrivalTime,
    double? price,
    String? status,
    String? bookingCode,
    String? createdAt,
    String? updatedAt,
    Schedule? schedule,
  }) {
    return Ticket(
      id: id ?? this.id,
      scheduleId: scheduleId ?? this.scheduleId,
      seatNumber: seatNumber ?? this.seatNumber,
      passengerName: passengerName ?? this.passengerName,
      passengerPhone: passengerPhone ?? this.passengerPhone,
      passengerEmail: passengerEmail ?? this.passengerEmail,
      departureStation: departureStation ?? this.departureStation,
      arrivalStation: arrivalStation ?? this.arrivalStation,
      departureTime: departureTime ?? this.departureTime,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      price: price ?? this.price,
      status: status ?? this.status,
      bookingCode: bookingCode ?? this.bookingCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      schedule: schedule ?? this.schedule,
    );
  }
} 