class Station {
  final String id;
  final String stationName;
  final String location;
  final int? numberOfLines;
  final String? facilities;
  final String? operatingHours;
  final String? contactInfo;
  final String? code;
  final String? imageUrl;

  Station({
    required this.id,
    required this.stationName,
    required this.location,
    this.numberOfLines,
    this.facilities,
    this.operatingHours,
    this.contactInfo,
    this.code,
    this.imageUrl,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['id'].toString(),
      stationName: json['name'] ?? json['stationName'] ?? 'Unknown',
      location: json['city'] ?? json['location'] ?? 'Unknown',
      numberOfLines: json['numberOfLines'] is String
          ? int.tryParse(json['numberOfLines']) ?? 0
          : json['numberOfLines'],
      facilities: json['facilities'],
      operatingHours: json['operatingHours'],
      contactInfo: json['contactInfo'],
      code: json['code'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'name': stationName,
      'location': location,
    };

    if (numberOfLines != null) {
      data['numberOfLines'] = numberOfLines;
    }

    if (facilities != null) {
      data['facilities'] = facilities;
    }

    if (operatingHours != null) {
      data['operatingHours'] = operatingHours;
    }

    if (contactInfo != null) {
      data['contactInfo'] = contactInfo;
    }

    if (code != null) {
      data['code'] = code;
    }

    if (imageUrl != null) {
      data['imageUrl'] = imageUrl;
    }

    return data;
  }
}