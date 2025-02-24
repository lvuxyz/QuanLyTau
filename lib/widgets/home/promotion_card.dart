import 'package:flutter/material.dart';

class PromotionCard extends StatelessWidget {
  final double width;
  final EdgeInsetsGeometry margin;

  const PromotionCard({
    Key? key,
    required this.width,
    this.margin = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        color: Color(0xFF333333),
        borderRadius: BorderRadius.circular(16),
      ),
      // Add promotional content here
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Placeholder for promotional content
            // Add real content based on your app requirements
          ],
        ),
      ),
    );
  }
}