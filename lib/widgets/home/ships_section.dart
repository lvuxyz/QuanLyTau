import 'package:flutter/material.dart';
import 'section_header.dart';
import 'ship_card.dart';

class ShipsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header with view all button
        SectionHeader(
          title: "Các chuyến tàu mới",
          showViewAll: true,
          onViewAllPressed: () {
            // Navigate to ships list screen
          },
        ),
        SizedBox(height: 12),

        // Ship cards horizontal list
        Container(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 2, // Use dynamic data here from BLoC state
            itemBuilder: (context, index) {
              return ShipCard(
                width: 160,
                margin: EdgeInsets.only(right: 16),
              );
            },
          ),
        ),
      ],
    );
  }
}