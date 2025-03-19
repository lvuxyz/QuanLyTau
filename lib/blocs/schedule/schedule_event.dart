import 'package:equatable/equatable.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object> get props => [];
}

class LoadSchedules extends ScheduleEvent {}

class CreateSchedule extends ScheduleEvent {
  final Map<String, dynamic> scheduleData;

  const CreateSchedule({required this.scheduleData});

  @override
  List<Object> get props => [scheduleData];
}

class UpdateSchedule extends ScheduleEvent {
  final String scheduleId;
  final Map<String, dynamic> scheduleData;

  const UpdateSchedule({
    required this.scheduleId,
    required this.scheduleData,
  });

  @override
  List<Object> get props => [scheduleId, scheduleData];
}

class DeleteSchedule extends ScheduleEvent {
  final String scheduleId;

  const DeleteSchedule({required this.scheduleId});

  @override
  List<Object> get props => [scheduleId];
}

class CancelSchedule extends ScheduleEvent {
  final String scheduleId;

  const CancelSchedule({required this.scheduleId});

  @override
  List<Object> get props => [scheduleId];
} 