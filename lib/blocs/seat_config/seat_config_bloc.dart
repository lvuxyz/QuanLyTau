import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/seat_config_service.dart';
import 'seat_config_event.dart';
import 'seat_config_state.dart';

class SeatConfigBloc extends Bloc<SeatConfigEvent, SeatConfigState> {
  final SeatConfigService _seatConfigService;

  SeatConfigBloc({
    required SeatConfigService seatConfigService,
  })  : _seatConfigService = seatConfigService,
        super(SeatConfigInitial()) {
    on<LoadSeatConfigs>(_onLoadSeatConfigs);
    on<LoadTrainSeatConfig>(_onLoadTrainSeatConfig);
    on<CreateSeatConfig>(_onCreateSeatConfig);
    on<UpdateSeatConfig>(_onUpdateSeatConfig);
    on<DeleteSeatConfig>(_onDeleteSeatConfig);
  }

  Future<void> _onLoadSeatConfigs(
    LoadSeatConfigs event,
    Emitter<SeatConfigState> emit,
  ) async {
    emit(SeatConfigLoading());
    try {
      final result = await _seatConfigService.getAllSeatConfigs();
      if (result['success'] == true) {
        emit(SeatConfigLoaded(seatConfigs: result['data']));
      } else {
        emit(SeatConfigError(message: result['message']));
      }
    } catch (e) {
      emit(SeatConfigError(message: e.toString()));
    }
  }

  Future<void> _onLoadTrainSeatConfig(
    LoadTrainSeatConfig event,
    Emitter<SeatConfigState> emit,
  ) async {
    emit(SeatConfigLoading());
    try {
      final result = await _seatConfigService.getSeatConfigByTrain(event.trainId);
      if (result['success'] == true) {
        emit(SeatConfigLoaded(seatConfigs: [result['data']]));
      } else {
        emit(SeatConfigError(message: result['message']));
      }
    } catch (e) {
      emit(SeatConfigError(message: e.toString()));
    }
  }

  Future<void> _onCreateSeatConfig(
    CreateSeatConfig event,
    Emitter<SeatConfigState> emit,
  ) async {
    try {
      final result = await _seatConfigService.createSeatConfig(event.configData);
      if (result['success'] == true) {
        add(LoadSeatConfigs());
      } else {
        emit(SeatConfigError(message: result['message']));
      }
    } catch (e) {
      emit(SeatConfigError(message: e.toString()));
    }
  }

  Future<void> _onUpdateSeatConfig(
    UpdateSeatConfig event,
    Emitter<SeatConfigState> emit,
  ) async {
    try {
      final result = await _seatConfigService.updateSeatConfig(event.configId, event.configData);
      if (result['success'] == true) {
        add(LoadSeatConfigs());
      } else {
        emit(SeatConfigError(message: result['message']));
      }
    } catch (e) {
      emit(SeatConfigError(message: e.toString()));
    }
  }

  Future<void> _onDeleteSeatConfig(
    DeleteSeatConfig event,
    Emitter<SeatConfigState> emit,
  ) async {
    try {
      final result = await _seatConfigService.deleteSeatConfig(event.configId);
      if (result['success'] == true) {
        add(LoadSeatConfigs());
      } else {
        emit(SeatConfigError(message: result['message']));
      }
    } catch (e) {
      emit(SeatConfigError(message: e.toString()));
    }
  }
} 