import 'package:equatable/equatable.dart';

abstract class ShipState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ShipInitial extends ShipState {}

class ShipLoading extends ShipState {}

class ShipsLoaded extends ShipState {
  final List<Map<String, dynamic>> ships;

  ShipsLoaded(this.ships);

  @override
  List<Object?> get props => [ships];
}

class ShipOperationSuccess extends ShipState {
  final String message;

  ShipOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ShipOperationFailure extends ShipState {
  final String error;

  ShipOperationFailure(this.error);

  @override
  List<Object?> get props => [error];
}
