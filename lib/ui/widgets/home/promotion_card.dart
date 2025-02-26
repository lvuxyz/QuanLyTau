import 'package:flutter/material.dart';
import '../common/smart_image.dart';

class PromotionCard extends StatelessWidget {
  final double width;
  final EdgeInsetsGeometry? margin;
  final Map<String, dynamic>? promotionData;

  const PromotionCard({
    Key? key,
    required this.width,
    this.margin,
    this.promotionData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Hình ảnh khuyến mãi
          SmartImage(
            imageUrl: promotionData != null ? promotionData!['imageUrl'] as String? : null,
            width: width,
            height: double.infinity,
            fallbackIcon: Icons.local_offer,
            fallbackIconColor: Color(0xFF13B8A8),
            fallbackBackgroundColor: Color(0xFF333333),
          ),
          
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
          
          // Nội dung khuyến mãi
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFF13B8A8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    promotionData != null ? (promotionData!['tag'] as String? ?? 'Khuyến mãi') : 'Khuyến mãi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  promotionData != null ? (promotionData!['title'] as String? ?? 'Ưu đãi đặc biệt') : 'Ưu đãi đặc biệt',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  promotionData != null ? (promotionData!['description'] as String? ?? 'Giảm giá đặc biệt cho chuyến đi của bạn') : 'Giảm giá đặc biệt cho chuyến đi của bạn',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}