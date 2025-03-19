abstract class SeatConfigEvent {}

class LoadSeatConfigs extends SeatConfigEvent {}

class LoadTrainSeatConfig extends SeatConfigEvent {
  final String trainId;

  LoadTrainSeatConfig({required this.trainId});
}

class CreateSeatConfig extends SeatConfigEvent {
  final Map<String, dynamic> configData;

  CreateSeatConfig({required this.configData});
}

class UpdateSeatConfig extends SeatConfigEvent {
  final String configId;
  final Map<String, dynamic> configData;

  UpdateSeatConfig({required this.configId, required this.configData});
}

class DeleteSeatConfig extends SeatConfigEvent {
  final String configId;

  DeleteSeatConfig({required this.configId});
} 