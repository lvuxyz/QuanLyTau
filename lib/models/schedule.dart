// lib/models/schedule.dart
import 'schedule_stop.dart';
import 'train.dart';

class Schedule {
  final String id;
  final String trainId;
  final String departureDate;
  final String departureTime;
  final String arrivalTime;
  final String departureStation;
  final String arrivalStation;
  final String status;
  final List<ScheduleStop>? stops;
  final Train? train;

  Schedule({
    required this.id,
    required this.trainId,
    required this.departureDate,
    required this.departureTime,
    required this.arrivalTime,
    required this.departureStation,
    required this.arrivalStation,
    required this.status,
    this.stops,
    this.train,
  });

  String get formattedDepartureDate {
    // Parse chuỗi ngày với định dạng từ server "YYYY-MM-DD"
    final date = DateTime.parse(departureDate);
    // Return dạng ngày/tháng/năm
    return '${date.day}/${date.month}/${date.year}';
  }

  factory Schedule.fromJson(Map<String, dynamic> json) {
    List<ScheduleStop>? stops;
    if (json['stops'] != null) {
      stops = (json['stops'] as List)
          .map((stop) => ScheduleStop.fromJson(stop))
          .toList();
    }

    Train? train;
    if (json['Train_Type'] != null) {
      train = Train(
        id: json['Train_ID'].toString(),
        trainType: json['Train_Type'] ?? '',
        trainOperator: json['Train_Operator'] ?? '',
        capacity: 0, // Default value as it might not be in this response
        status: 'ACTIVE', // Assuming active by default
        amenities: [],
      );
    }

    return Schedule(
      id: json['Schedule_ID'].toString(),
      trainId: json['Train_ID'].toString(),
      departureDate: json['Departure_Date'] ?? '',
      departureTime: json['Departure_Time'] ?? '',
      arrivalTime: json['Arrival_Time'] ?? '',
      departureStation: json['Departure_Station'] ?? '',
      arrivalStation: json['Arrival_Station'] ?? '',
      status: json['Schedule_Status'] ?? 'UNKNOWN',
      stops: stops,
      train: train,
    );
  }
}