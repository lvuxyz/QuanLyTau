// lib/models/ship.dart
class Ship {
  final String id;
  final String name;
  final String type;
  final int capacity;
  final String status;
  final String route;
  final String? imageUrl;
  final String? createdAt;
  final String? updatedAt;

  Ship({
    required this.id,
    required this.name,
    required this.type,
    required this.capacity,
    required this.status,
    required this.route,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory Ship.fromJson(Map<String, dynamic> json) {
    return Ship(
      id: json['id'].toString(),
      name: json['name'],
      type: json['type'],
      capacity: json['capacity'] is String 
          ? int.tryParse(json['capacity']) ?? 0 
          : json['capacity'] ?? 0,
      status: json['status'] ?? 'Đang hoạt động',
      route: json['route'],
      imageUrl: json['imageUrl'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'capacity': capacity,
      'status': status,
      'route': route,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  Ship copyWith({
    String? id,
    String? name,
    String? type,
    int? capacity,
    String? status,
    String? route,
    String? imageUrl,
    String? createdAt,
    String? updatedAt,
  }) {
    return Ship(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      capacity: capacity ?? this.capacity,
      status: status ?? this.status,
      route: route ?? this.route,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 