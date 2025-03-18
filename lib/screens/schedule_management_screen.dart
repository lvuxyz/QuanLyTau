// lib/screens/schedule_management_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/schedule/schedule_bloc.dart';
import '../blocs/schedule/schedule_event.dart';
import '../blocs/schedule/schedule_state.dart';
import '../models/schedule.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_message.dart';

class ScheduleManagementScreen extends StatelessWidget {
  const ScheduleManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Lịch trình'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddScheduleDialog(context),
          ),
        ],
      ),
      body: BlocBuilder<ScheduleBloc, ScheduleState>(
        builder: (context, state) {
          if (state is ScheduleInitial) {
            context.read<ScheduleBloc>().add(LoadSchedules());
            return const LoadingIndicator();
          }

          if (state is ScheduleLoading) {
            return const LoadingIndicator();
          }

          if (state is ScheduleError) {
            return ErrorMessage(message: state.message);
          }

          if (state is ScheduleLoaded) {
            return ListView.builder(
              itemCount: state.schedules.length,
              itemBuilder: (context, index) {
                final schedule = state.schedules[index];
                return _buildScheduleCard(context, schedule);
              },
            );
          }

          return const LoadingIndicator();
        },
      ),
    );
  }

  Widget _buildScheduleCard(BuildContext context, Schedule schedule) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text('${schedule.departureStation} → ${schedule.arrivalStation}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tàu: ${schedule.trainName}'),
            Text('Khởi hành: ${schedule.departureTime}'),
            Text('Đến: ${schedule.arrivalTime}'),
            Text('Trạng thái: ${schedule.status}'),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Sửa'),
                contentPadding: EdgeInsets.zero,
              ),
              onTap: () => _showEditScheduleDialog(context, schedule),
            ),
            PopupMenuItem(
              child: ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Hủy'),
                contentPadding: EdgeInsets.zero,
              ),
              onTap: () => _showCancelScheduleDialog(context, schedule),
            ),
            PopupMenuItem(
              child: ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Xóa'),
                contentPadding: EdgeInsets.zero,
              ),
              onTap: () => _showDeleteScheduleDialog(context, schedule),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddScheduleDialog(BuildContext context) {
    final trainController = TextEditingController();
    final departureStationController = TextEditingController();
    final arrivalStationController = TextEditingController();
    final departureDateController = TextEditingController();
    final departureTimeController = TextEditingController();
    final arrivalDateController = TextEditingController();
    final arrivalTimeController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm Lịch trình'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: trainController,
                decoration: const InputDecoration(labelText: 'Tàu'),
              ),
              TextField(
                controller: departureStationController,
                decoration: const InputDecoration(labelText: 'Ga đi'),
              ),
              TextField(
                controller: arrivalStationController,
                decoration: const InputDecoration(labelText: 'Ga đến'),
              ),
              TextField(
                controller: departureDateController,
                decoration: const InputDecoration(labelText: 'Ngày đi'),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    departureDateController.text = date.toIso8601String().split('T')[0];
                  }
                },
                readOnly: true,
              ),
              TextField(
                controller: departureTimeController,
                decoration: const InputDecoration(labelText: 'Giờ đi'),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    departureTimeController.text = '${time.hour}:${time.minute}';
                  }
                },
                readOnly: true,
              ),
              TextField(
                controller: arrivalDateController,
                decoration: const InputDecoration(labelText: 'Ngày đến'),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    arrivalDateController.text = date.toIso8601String().split('T')[0];
                  }
                },
                readOnly: true,
              ),
              TextField(
                controller: arrivalTimeController,
                decoration: const InputDecoration(labelText: 'Giờ đến'),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    arrivalTimeController.text = '${time.hour}:${time.minute}';
                  }
                },
                readOnly: true,
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Giá vé'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              if (_validateScheduleInput(
                trainController.text,
                departureStationController.text,
                arrivalStationController.text,
                departureDateController.text,
                departureTimeController.text,
                arrivalDateController.text,
                arrivalTimeController.text,
                priceController.text,
              )) {
                context.read<ScheduleBloc>().add(
                      CreateSchedule(
                        scheduleData: {
                          'train_id': trainController.text,
                          'departure_station': departureStationController.text,
                          'arrival_station': arrivalStationController.text,
                          'departure_time': '${departureDateController.text}T${departureTimeController.text}:00',
                          'arrival_time': '${arrivalDateController.text}T${arrivalTimeController.text}:00',
                          'price': double.parse(priceController.text),
                        },
                      ),
                    );
                Navigator.pop(context);
              }
            },
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
  }

  void _showEditScheduleDialog(BuildContext context, Schedule schedule) {
    final trainController = TextEditingController(text: schedule.trainName);
    final departureStationController = TextEditingController(text: schedule.departureStation);
    final arrivalStationController = TextEditingController(text: schedule.arrivalStation);
    final departureDateController = TextEditingController(text: schedule.departureTime.split('T')[0]);
    final departureTimeController = TextEditingController(text: schedule.departureTime.split('T')[1].substring(0, 5));
    final arrivalDateController = TextEditingController(text: schedule.arrivalTime.split('T')[0]);
    final arrivalTimeController = TextEditingController(text: schedule.arrivalTime.split('T')[1].substring(0, 5));
    final priceController = TextEditingController(text: schedule.price.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sửa Lịch trình'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: trainController,
                decoration: const InputDecoration(labelText: 'Tàu'),
              ),
              TextField(
                controller: departureStationController,
                decoration: const InputDecoration(labelText: 'Ga đi'),
              ),
              TextField(
                controller: arrivalStationController,
                decoration: const InputDecoration(labelText: 'Ga đến'),
              ),
              TextField(
                controller: departureDateController,
                decoration: const InputDecoration(labelText: 'Ngày đi'),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    departureDateController.text = date.toIso8601String().split('T')[0];
                  }
                },
                readOnly: true,
              ),
              TextField(
                controller: departureTimeController,
                decoration: const InputDecoration(labelText: 'Giờ đi'),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    departureTimeController.text = '${time.hour}:${time.minute}';
                  }
                },
                readOnly: true,
              ),
              TextField(
                controller: arrivalDateController,
                decoration: const InputDecoration(labelText: 'Ngày đến'),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    arrivalDateController.text = date.toIso8601String().split('T')[0];
                  }
                },
                readOnly: true,
              ),
              TextField(
                controller: arrivalTimeController,
                decoration: const InputDecoration(labelText: 'Giờ đến'),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    arrivalTimeController.text = '${time.hour}:${time.minute}';
                  }
                },
                readOnly: true,
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Giá vé'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              if (_validateScheduleInput(
                trainController.text,
                departureStationController.text,
                arrivalStationController.text,
                departureDateController.text,
                departureTimeController.text,
                arrivalDateController.text,
                arrivalTimeController.text,
                priceController.text,
              )) {
                context.read<ScheduleBloc>().add(
                      UpdateSchedule(
                        scheduleId: schedule.id,
                        scheduleData: {
                          'train_id': trainController.text,
                          'departure_station': departureStationController.text,
                          'arrival_station': arrivalStationController.text,
                          'departure_time': '${departureDateController.text}T${departureTimeController.text}:00',
                          'arrival_time': '${arrivalDateController.text}T${arrivalTimeController.text}:00',
                          'price': double.parse(priceController.text),
                        },
                      ),
                    );
                Navigator.pop(context);
              }
            },
            child: const Text('Cập nhật'),
          ),
        ],
      ),
    );
  }

  void _showCancelScheduleDialog(BuildContext context, Schedule schedule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hủy Lịch trình'),
        content: const Text('Bạn có chắc chắn muốn hủy lịch trình này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Không'),
          ),
          TextButton(
            onPressed: () {
              context.read<ScheduleBloc>().add(CancelSchedule(scheduleId: schedule.id));
              Navigator.pop(context);
            },
            child: const Text('Có'),
          ),
        ],
      ),
    );
  }

  void _showDeleteScheduleDialog(BuildContext context, Schedule schedule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa Lịch trình'),
        content: const Text('Bạn có chắc chắn muốn xóa lịch trình này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Không'),
          ),
          TextButton(
            onPressed: () {
              context.read<ScheduleBloc>().add(DeleteSchedule(scheduleId: schedule.id));
              Navigator.pop(context);
            },
            child: const Text('Có'),
          ),
        ],
      ),
    );
  }

  bool _validateScheduleInput(
    String train,
    String departureStation,
    String arrivalStation,
    String departureDate,
    String departureTime,
    String arrivalDate,
    String arrivalTime,
    String price,
  ) {
    if (train.isEmpty ||
        departureStation.isEmpty ||
        arrivalStation.isEmpty ||
        departureDate.isEmpty ||
        departureTime.isEmpty ||
        arrivalDate.isEmpty ||
        arrivalTime.isEmpty ||
        price.isEmpty) {
      return false;
    }

    try {
      double.parse(price);
      return true;
    } catch (e) {
      return false;
    }
  }
}