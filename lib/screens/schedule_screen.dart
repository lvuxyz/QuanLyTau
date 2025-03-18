// lib/screens/schedule_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/schedule/schedule_bloc.dart';
import '../blocs/schedule/schedule_event.dart';
import '../blocs/schedule/schedule_state.dart';
import '../models/schedule.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_message.dart';
import 'ticket_booking_screen.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch trình'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ScheduleBloc>().add(LoadSchedules());
            },
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
            if (state.schedules.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.schedule_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Không có lịch trình nào',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: state.schedules.length,
              itemBuilder: (context, index) {
                final schedule = state.schedules[index];
                return Card(
                  child: ListTile(
                    title: Text('${schedule.departureStation} → ${schedule.arrivalStation}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tàu: ${schedule.trainName}'),
                        Text('Ngày: ${schedule.departureDate}'),
                        Text('Giờ đi: ${schedule.departureTime}'),
                        Text('Giờ đến: ${schedule.arrivalTime}'),
                        Text('Giá vé: ${schedule.price} VNĐ'),
                        Text('Trạng thái: ${schedule.status}'),
                      ],
                    ),
                    trailing: schedule.status == 'ACTIVE'
                        ? ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TicketBookingScreen(
                                    scheduleId: schedule.id,
                                  ),
                                ),
                              );
                            },
                            child: const Text('Đặt vé'),
                          )
                        : null,
                  ),
                );
              },
            );
          }

          return const LoadingIndicator();
        },
      ),
    );
  }
}