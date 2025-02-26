import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAllPressed;
  final bool showViewAll;

  const SectionHeader({
    Key? key,
    required this.title,
    this.onViewAllPressed,
    this.showViewAll = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (showViewAll)
          TextButton(
            onPressed: onViewAllPressed ?? () {},
            child: Text(
              "Xem tất cả",
              style: TextStyle(
                color: Colors.teal,
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }
}