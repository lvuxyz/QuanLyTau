// lib/models/schedule_stop.dart
class ScheduleStop {
  final String stopId;
  final String scheduleId;
  final String stationId;
  final String stationName;
  final String? location;
  final String arrivalTime;
  final String departureTime;
  final int stopOrder;
  final String? platformNumber;

  ScheduleStop({
    required this.stopId,
    required this.scheduleId,
    required this.stationId,
    required this.stationName,
    this.location,
    required this.arrivalTime,
    required this.departureTime,
    required this.stopOrder,
    this.platformNumber,
  });

  factory ScheduleStop.fromJson(Map<String, dynamic> json) {
    return ScheduleStop(
      stopId: json['Stop_ID'].toString(),
      scheduleId: json['Schedule_ID'].toString(),
      stationId: json['Station_ID'].toString(),
      stationName: json['Station_Name'] ?? '',
      location: json['Location'],
      arrivalTime: json['Arrival_Time'] ?? '',
      departureTime: json['Departure_Time'] ?? '',
      stopOrder: json['Stop_Order'] ?? 0,
      platformNumber: json['Platform_Number'],
    );
  }
}