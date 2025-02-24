import 'package:flutter/material.dart';

class GreetingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      "Hôm nay bạn khỏe không?",
      style: TextStyle(color: Colors.white.withOpacity(0.7)),
    );
  }
}
