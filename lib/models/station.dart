// lib/models/station.dart
class Station {
  final String id;
  final String stationName;
  final String location;
  final int? numberOfLines;
  final String? facilities;
  final String? operatingHours;
  final String? contactInfo;

  Station({
    required this.id,
    required this.stationName,
    required this.location,
    this.numberOfLines,
    this.facilities,
    this.operatingHours,
    this.contactInfo,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['Station_ID']?.toString() ?? json['id']?.toString() ?? '',
      stationName: json['Station_Name'] ?? json['station_name'] ?? json['name'] ?? 'Không có tên',
      location: json['Location'] ?? json['location'] ?? 'Không có địa chỉ',
      numberOfLines: json['Number_of_Lines'] ?? json['number_of_lines'],
      facilities: json['Facilities'] ?? json['facilities'],
      operatingHours: json['Operating_Hours'] ?? json['operating_hours'],
      contactInfo: json['Contact_Info'] ?? json['contact_info'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'station_name': stationName,
      'location': location,
      'number_of_lines': numberOfLines,
      'facilities': facilities,
      'operating_hours': operatingHours,
      'contact_info': contactInfo,
    };
  }
}