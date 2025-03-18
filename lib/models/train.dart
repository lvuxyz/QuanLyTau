class Train {
  final String id;
  final String trainType;
  final String trainOperator;
  final int capacity;
  final String status;
  final List<dynamic>? amenities;
  final String? lastMaintenanceDate;
  final String? route;
  final String? imageUrl;

  Train({
    required this.id,
    required this.trainType,
    required this.trainOperator,
    required this.capacity,
    required this.status,
    this.amenities,
    this.lastMaintenanceDate,
    this.route,
    this.imageUrl,
  });

  factory Train.fromJson(Map<String, dynamic> json) {
    List<dynamic>? amenitiesList;
    if (json['amenities'] != null) {
      if (json['amenities'] is List) {
        amenitiesList = json['amenities'];
      } else if (json['amenities'] is String) {
        amenitiesList = json['amenities'].split(',').map((e) => e.trim()).toList();
      }
    }

    return Train(
      id: json['id'].toString(),
      trainType: json['name'] ?? json['trainType'] ?? 'Unknown',
      trainOperator: json['operator'] ?? json['trainOperator'] ?? 'Unknown',
      capacity: json['capacity'] is String
          ? int.tryParse(json['capacity']) ?? 0
          : json['capacity'] ?? 0,
      status: json['status'] ?? 'active',
      amenities: amenitiesList,
      lastMaintenanceDate: json['lastMaintenanceDate'],
      route: json['route'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'name': trainType,
      'operator': trainOperator,
      'capacity': capacity,
      'status': status,
    };

    if (amenities != null) {
      data['amenities'] = amenities;
    }

    if (lastMaintenanceDate != null) {
      data['lastMaintenanceDate'] = lastMaintenanceDate;
    }

    if (route != null) {
      data['route'] = route;
    }

    if (imageUrl != null) {
      data['imageUrl'] = imageUrl;
    }

    return data;
  }

  Train copyWith({
    String? id,
    String? trainType,
    String? trainOperator,
    int? capacity,
    String? status,
    List<dynamic>? amenities,
    String? lastMaintenanceDate,
    String? route,
    String? imageUrl,
  }) {
    return Train(
      id: id ?? this.id,
      trainType: trainType ?? this.trainType,
      trainOperator: trainOperator ?? this.trainOperator,
      capacity: capacity ?? this.capacity,
      status: status ?? this.status,
      amenities: amenities ?? this.amenities,
      lastMaintenanceDate: lastMaintenanceDate ?? this.lastMaintenanceDate,
      route: route ?? this.route,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}