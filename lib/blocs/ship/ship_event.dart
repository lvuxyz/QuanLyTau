abstract class ShipEvent {}

class LoadShips extends ShipEvent {}

class AddShip extends ShipEvent {
  final Map<String, dynamic> shipData;

  AddShip(this.shipData);
}

class UpdateShip extends ShipEvent {
  final String id;
  final Map<String, dynamic> shipData;

  UpdateShip(this.id, this.shipData);
}

class DeleteShip extends ShipEvent {
  final String id;

  DeleteShip(this.id);
}