import 'package:flutter/material.dart';
import '../common/smart_image.dart';

class PromotionItem extends StatelessWidget {
  final double? width;
  final double height;
  final bool isSquare;
  final Map<String, dynamic>? promotionData;

  const PromotionItem({
    Key? key,
    this.width,
    required this.height,
    required this.isSquare,
    this.promotionData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: SmartImage(
        imageUrl: promotionData != null ? promotionData!['imageUrl'] as String? : null,
        width: width ?? double.infinity,
        height: height,
        fallbackIcon: Icons.local_offer,
        fallbackIconColor: Color(0xFF13B8A8),
        fallbackBackgroundColor: Color(0xFF333333),
      ),
    );
  }
}