import 'train.dart';

class Schedule {
  final String id;
  final String trainId;
  final String trainName;
  final String departureStation;
  final String arrivalStation;
  final String departureTime;
  final String arrivalTime;
  final String departureDate;
  final double price;
  final String status;
  final Train? train;

  Schedule({
    required this.id,
    required this.trainId,
    required this.trainName,
    required this.departureStation,
    required this.arrivalStation,
    required this.departureTime,
    required this.arrivalTime,
    required this.departureDate,
    required this.price,
    required this.status,
    this.train,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'] as String,
      trainId: json['train_id'] as String,
      trainName: json['train_name'] as String,
      departureStation: json['departure_station'] as String,
      arrivalStation: json['arrival_station'] as String,
      departureTime: json['departure_time'] as String,
      arrivalTime: json['arrival_time'] as String,
      departureDate: json['departure_date'] as String,
      price: (json['price'] as num).toDouble(),
      status: json['status'] as String,
      train: json['train'] != null ? Train.fromJson(json['train']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'train_id': trainId,
      'train_name': trainName,
      'departure_station': departureStation,
      'arrival_station': arrivalStation,
      'departure_time': departureTime,
      'arrival_time': arrivalTime,
      'departure_date': departureDate,
      'price': price,
      'status': status,
      'train': train?.toJson(),
    };
  }

  Schedule copyWith({
    String? id,
    String? trainId,
    String? trainName,
    String? departureStation,
    String? arrivalStation,
    String? departureTime,
    String? arrivalTime,
    String? departureDate,
    double? price,
    String? status,
    Train? train,
  }) {
    return Schedule(
      id: id ?? this.id,
      trainId: trainId ?? this.trainId,
      trainName: trainName ?? this.trainName,
      departureStation: departureStation ?? this.departureStation,
      arrivalStation: arrivalStation ?? this.arrivalStation,
      departureTime: departureTime ?? this.departureTime,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      departureDate: departureDate ?? this.departureDate,
      price: price ?? this.price,
      status: status ?? this.status,
      train: train ?? this.train,
    );
  }
}