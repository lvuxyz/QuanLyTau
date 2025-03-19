// lib/models/schedule_stop.dart
class ScheduleStop {
  final String id;
  final String scheduleId;
  final String stationId;
  final String arrivalTime;
  final String departureTime;
  final int stopOrder;
  final String? stationName;
  final String? stationCode;
  final String? createdAt;
  final String? updatedAt;

  ScheduleStop({
    required this.id,
    required this.scheduleId,
    required this.stationId,
    required this.arrivalTime,
    required this.departureTime,
    required this.stopOrder,
    this.stationName,
    this.stationCode,
    this.createdAt,
    this.updatedAt,
  });

  factory ScheduleStop.fromJson(Map<String, dynamic> json) {
    return ScheduleStop(
      id: json['id'].toString(),
      scheduleId: json['scheduleId'].toString(),
      stationId: json['stationId'].toString(),
      arrivalTime: json['arrivalTime'],
      departureTime: json['departureTime'],
      stopOrder: json['stopOrder'] is String 
          ? int.tryParse(json['stopOrder']) ?? 0 
          : json['stopOrder'] ?? 0,
      stationName: json['stationName'],
      stationCode: json['stationCode'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'scheduleId': scheduleId,
      'stationId': stationId,
      'arrivalTime': arrivalTime,
      'departureTime': departureTime,
      'stopOrder': stopOrder,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };

    if (stationName != null) {
      data['stationName'] = stationName;
    }
    
    if (stationCode != null) {
      data['stationCode'] = stationCode;
    }

    return data;
  }

  ScheduleStop copyWith({
    String? id,
    String? scheduleId,
    String? stationId,
    String? arrivalTime,
    String? departureTime,
    int? stopOrder,
    String? stationName,
    String? stationCode,
    String? createdAt,
    String? updatedAt,
  }) {
    return ScheduleStop(
      id: id ?? this.id,
      scheduleId: scheduleId ?? this.scheduleId,
      stationId: stationId ?? this.stationId,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      departureTime: departureTime ?? this.departureTime,
      stopOrder: stopOrder ?? this.stopOrder,
      stationName: stationName ?? this.stationName,
      stationCode: stationCode ?? this.stationCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}