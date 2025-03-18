import 'package:equatable/equatable.dart';
import '../../models/ship.dart';

abstract class ShipEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadShips extends ShipEvent {}

class AddShip extends ShipEvent {
  final Ship ship;

  AddShip(this.ship);

  @override
  List<Object> get props => [ship];
}

class UpdateShip extends ShipEvent {
  final String id;
  final Ship ship;

  UpdateShip(this.id, this.ship);

  @override
  List<Object> get props => [id, ship];
}

class DeleteShip extends ShipEvent {
  final String id;

  DeleteShip(this.id);

  @override
  List<Object> get props => [id];
}

class SearchShips extends ShipEvent {
  final String query;

  SearchShips(this.query);

  @override
  List<Object> get props => [query];
}