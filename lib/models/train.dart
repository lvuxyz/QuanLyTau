// lib/models/train.dart
import 'dart:convert';

class Train {
  final String id;
  final String trainType;
  final String trainOperator;
  final int capacity;
  final String status;
  final List<String> amenities;
  final String maintenanceSchedule;
  final String? lastMaintenanceDate;
  final String? imageUrl;

  Train({
    required this.id,
    required this.trainType,
    required this.trainOperator,
    required this.capacity,
    required this.status,
    required this.amenities,
    this.maintenanceSchedule = '',
    this.lastMaintenanceDate,
    this.imageUrl,
  });

  factory Train.fromJson(Map<String, dynamic> json) {
    List<String> parseAmenities(dynamic amenitiesData) {
      if (amenitiesData is String) {
        try {
          final decoded = jsonDecode(amenitiesData);
          if (decoded is List) {
            return decoded.map((item) => item.toString()).toList();
          }
        } catch (e) {
          return [amenitiesData];
        }
      } else if (amenitiesData is List) {
        return amenitiesData.map((item) => item.toString()).toList();
      }
      return [];
    }

    return Train(
      id: json['Train_ID'].toString(),
      trainType: json['Train_Type'] ?? '',
      trainOperator: json['Train_Operator'] ?? '',
      capacity: json['Capacity'] ?? 0,
      status: json['Status'] ?? 'Unknown',
      amenities: parseAmenities(json['Amenities']),
      maintenanceSchedule: json['Maintenance_Schedule'] ?? '',
      lastMaintenanceDate: json['Last_Maintenance_Date'],
      imageUrl: json['imageUrl'],
    );
  }
}