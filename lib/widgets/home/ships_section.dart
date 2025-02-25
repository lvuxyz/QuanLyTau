import 'package:flutter/material.dart';
import 'section_header.dart';
import 'ship_card.dart';

class ShipsSection extends StatelessWidget {
  final List<Map<String, dynamic>> ships;
  final VoidCallback? onViewAllPressed;

  const ShipsSection({
    Key? key,
    required this.ships,
    this.onViewAllPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header with view all button
        SectionHeader(
          title: "Các chuyến tàu mới",
          showViewAll: true,
          onViewAllPressed: onViewAllPressed,
        ),
        SizedBox(height: 12),

        // Ship cards horizontal list with optimizations
        SizedBox(
          height: 180,
          child: ships.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: ships.length,
            // Only build visible items + small buffer
            cacheExtent: 300,
            itemBuilder: (context, index) {
              return ShipCard(
                width: 160,
                margin: EdgeInsets.only(right: 16),
                shipData: ships[index],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF333333),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_boat_filled,
            color: Colors.white.withOpacity(0.3),
            size: 40,
          ),
          SizedBox(height: 12),
          Text(
            "Không có tàu nào",
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}