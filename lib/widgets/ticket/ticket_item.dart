// lib/widgets/ticket/ticket_item.dart
import 'package:flutter/material.dart';

class TicketItem extends StatelessWidget {
  final Map<String, dynamic> ticket;
  final Color statusColor;
  final VoidCallback? onCancelPressed;

  const TicketItem({
    Key? key,
    required this.ticket,
    required this.statusColor,
    this.onCancelPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Color(0xFF333333),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Ship name and status
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ticket['name'] ?? 'Demo tên tàu',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    ticket['status'] ?? '',
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Time and location
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.white.withOpacity(0.7), size: 16),
                    SizedBox(width: 4),
                    Text(
                      ticket['time'] ?? 'Thời gian',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.white.withOpacity(0.7), size: 16),
                    SizedBox(width: 4),
                    Text(
                      ticket['location'] ?? 'địa điểm',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Cancel button (only for booked tickets)
          if (onCancelPressed != null)
            Padding(
              padding: EdgeInsets.all(16),
              child: GestureDetector(
                onTap: onCancelPressed,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red.withOpacity(0.7)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Hủy vé',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

