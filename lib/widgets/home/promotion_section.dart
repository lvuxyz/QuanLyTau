import 'package:flutter/material.dart';
import 'section_header.dart';
import 'promotion_item.dart';

class PromotionsSection extends StatelessWidget {
  final List<Map<String, dynamic>> promotions;

  const PromotionsSection({
    Key? key,
    required this.promotions,
  }) : super(key: key);

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
              promotionData: promotions.isNotEmpty ? promotions[0] : null,
            ),
            SizedBox(width: 16),
            Expanded(
              child: PromotionItem(
                height: 80,
                isSquare: false,
                promotionData: promotions.length > 1 ? promotions[1] : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}