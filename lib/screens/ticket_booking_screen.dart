import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/ticket/ticket_bloc.dart';
import '../blocs/ticket/ticket_event.dart';
import '../blocs/ticket/ticket_state.dart';
import '../models/ticket.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_message.dart';

class TicketBookingScreen extends StatelessWidget {
  final String scheduleId;
  
  const TicketBookingScreen({
    Key? key,
    required this.scheduleId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đặt vé'),
      ),
      body: BlocBuilder<TicketBloc, TicketState>(
        builder: (context, state) {
          if (state is TicketInitial) {
            context.read<TicketBloc>().add(LoadAvailableSeats(scheduleId));
            return const LoadingIndicator();
          }

          if (state is TicketLoading) {
            return const LoadingIndicator();
          }

          if (state is TicketError) {
            return ErrorMessage(message: state.message);
          }

          if (state is AvailableSeatsLoaded) {
            return _buildSeatSelection(context, state.seats);
          }

          return const LoadingIndicator();
        },
      ),
    );
  }

  Widget _buildSeatSelection(BuildContext context, List<Map<String, dynamic>> seats) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: seats.length,
            itemBuilder: (context, index) {
              final seat = seats[index];
              final isAvailable = seat['available'] as bool;
              final seatNumber = seat['seatNumber'] as String;
              
              return GestureDetector(
                onTap: isAvailable ? () => _showBookingDialog(context, seatNumber) : null,
                child: Container(
                  decoration: BoxDecoration(
                    color: isAvailable ? Colors.green : Colors.grey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      seatNumber,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _buildLegendItem(Colors.green, 'Ghế trống'),
              const SizedBox(width: 16),
              _buildLegendItem(Colors.grey, 'Ghế đã đặt'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }

  void _showBookingDialog(BuildContext context, String seatNumber) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đặt vé'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Họ và tên'),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Số điện thoại'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
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
              if (_validateBookingInput(
                nameController.text,
                phoneController.text,
                emailController.text,
              )) {
                context.read<TicketBloc>().add(
                      BookTicket(
                        ticketData: {
                          'schedule_id': scheduleId,
                          'seat_number': seatNumber,
                          'passenger_name': nameController.text,
                          'passenger_phone': phoneController.text,
                          'passenger_email': emailController.text,
                        },
                      ),
                    );
                Navigator.pop(context);
              }
            },
            child: const Text('Đặt vé'),
          ),
        ],
      ),
    );
  }

  bool _validateBookingInput(String name, String phone, String email) {
    if (name.isEmpty || phone.isEmpty || email.isEmpty) {
      return false;
    }
    return true;
  }
}

class MyTicketsScreen extends StatelessWidget {
  const MyTicketsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vé của tôi'),
      ),
      body: BlocBuilder<TicketBloc, TicketState>(
        builder: (context, state) {
          if (state is TicketInitial) {
            context.read<TicketBloc>().add(LoadUserTickets());
            return const LoadingIndicator();
          }

          if (state is TicketLoading) {
            return const LoadingIndicator();
          }

          if (state is TicketError) {
            return ErrorMessage(message: state.message);
          }

          if (state is UserTicketsLoaded) {
            return _buildTicketList(context, state.tickets);
          }

          return const LoadingIndicator();
        },
      ),
    );
  }

  Widget _buildTicketList(BuildContext context, List<Ticket> tickets) {
    if (tickets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.confirmation_number_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'Bạn chưa có vé nào',
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
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final ticket = tickets[index];
        return Card(
          child: ListTile(
            title: Text('${ticket.departureStation} → ${ticket.arrivalStation}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ghế: ${ticket.seatNumber}'),
                Text('Ngày: ${ticket.departureTime}'),
                Text('Trạng thái: ${ticket.status}'),
              ],
            ),
            trailing: ticket.status == 'ACTIVE'
                ? IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () => _showCancelDialog(context, ticket),
                  )
                : null,
          ),
        );
      },
    );
  }

  void _showCancelDialog(BuildContext context, Ticket ticket) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hủy vé'),
        content: const Text('Bạn có chắc chắn muốn hủy vé này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Không'),
          ),
          TextButton(
            onPressed: () {
              context.read<TicketBloc>().add(CancelTicket(ticketId: ticket.id));
              Navigator.pop(context);
            },
            child: const Text('Có'),
          ),
        ],
      ),
    );
  }
} 