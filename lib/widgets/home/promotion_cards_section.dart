import 'package:flutter/material.dart';
import 'package:shipmanagerapp/widgets/home/promotion_card.dart';
import 'section_header.dart';

class PromotionCardsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        SectionHeader(title: "Vé khuyến mại"),
        SizedBox(height: 12),

        // Promotion cards horizontal list
        Container(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 2, // Use dynamic data here from BLoC state
            itemBuilder: (context, index) {
              return PromotionCard(
                width: 280,
                margin: EdgeInsets.only(right: 16),
              );
            },
          ),
        ),
      ],
    );
  }
}