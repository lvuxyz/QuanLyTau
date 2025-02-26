// lib/widgets/ticket/ticket_empty_state.dart
import 'package:flutter/material.dart';

class TicketEmptyState extends StatelessWidget {
  final String message;
  final IconData icon;

  const TicketEmptyState({
    Key? key,
    required this.message,
    this.icon = Icons.confirmation_number_outlined,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.white.withOpacity(0.3),
          ),
          SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}