import 'package:flutter/material.dart';
import 'section_header.dart';
import 'promotion_item.dart';

class PromotionsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header with view all button
        SectionHeader(
          title: "Khuyến mãi",
          showViewAll: true,
          onViewAllPressed: () {
            // Navigate to promotions list screen
          },
        ),
        SizedBox(height: 12),

        // Promotion items in a row
        Row(
          children: [
            PromotionItem(
              width: 80,
              height: 80,
              isSquare: true,
            ),
            SizedBox(width: 16),
            Expanded(
              child: PromotionItem(
                height: 80,
                isSquare: false,
              ),
            ),
          ],
        ),
      ],
    );
  }
}