import 'package:flutter/material.dart';

class PromotionItem extends StatelessWidget {
  final double? width;
  final double height;
  final bool isSquare;

  const PromotionItem({
    Key? key,
    this.width,
    required this.height,
    required this.isSquare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Color(0xFF333333),
        borderRadius: BorderRadius.circular(12),
      ),
      // Add promotional item content here
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            isSquare ? "Khuyến mãi" : "Ưu đãi đặc biệt",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}