import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/schedule_service.dart';
import 'schedule_event.dart';
import 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final ScheduleService _scheduleService;

  ScheduleBloc(this._scheduleService) : super(ScheduleInitial()) {
    on<LoadSchedules>(_onLoadSchedules);
    on<CreateSchedule>(_onCreateSchedule);
    on<UpdateSchedule>(_onUpdateSchedule);
    on<DeleteSchedule>(_onDeleteSchedule);
    on<CancelSchedule>(_onCancelSchedule);
  }

  Future<void> _onLoadSchedules(
    LoadSchedules event,
    Emitter<ScheduleState> emit,
  ) async {
    try {
      emit(ScheduleLoading());
      final schedules = await _scheduleService.getSchedules();
      emit(ScheduleLoaded(schedules));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

  Future<void> _onCreateSchedule(
    CreateSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    try {
      emit(ScheduleLoading());
      await _scheduleService.createSchedule(event.scheduleData);
      final schedules = await _scheduleService.getSchedules();
      emit(ScheduleLoaded(schedules));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

  Future<void> _onUpdateSchedule(
    UpdateSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    try {
      emit(ScheduleLoading());
      await _scheduleService.updateSchedule(event.scheduleId, event.scheduleData);
      final schedules = await _scheduleService.getSchedules();
      emit(ScheduleLoaded(schedules));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

  Future<void> _onDeleteSchedule(
    DeleteSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    try {
      emit(ScheduleLoading());
      await _scheduleService.deleteSchedule(event.scheduleId);
      final schedules = await _scheduleService.getSchedules();
      emit(ScheduleLoaded(schedules));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

  Future<void> _onCancelSchedule(
    CancelSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    try {
      emit(ScheduleLoading());
      await _scheduleService.cancelSchedule(event.scheduleId);
      final schedules = await _scheduleService.getSchedules();
      emit(ScheduleLoaded(schedules));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }
} 