import 'package:flutter/material.dart';
import 'package:shipmanagerapp/widgets/home/promotion_card.dart';
import 'section_header.dart';

class PromotionCardsSection extends StatelessWidget {
  final List<Map<String, dynamic>> promotions;

  const PromotionCardsSection({
    Key? key,
    required this.promotions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        SectionHeader(title: "Vé khuyến mại"),
        SizedBox(height: 12),

        // Promotion cards horizontal list
        SizedBox(
          height: 160,
          child: promotions.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: promotions.length,
                  itemBuilder: (context, index) {
                    return PromotionCard(
                      width: 280,
                      margin: EdgeInsets.only(right: 16),
                      promotionData: promotions[index],
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
            Icons.local_offer,
            color: Colors.white.withOpacity(0.3),
            size: 40,
          ),
          SizedBox(height: 12),
          Text(
            "Không có khuyến mãi nào",
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