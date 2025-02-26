// lib/ui/screens/splash_screen.dart
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_boat_rounded,
              size: 80,
              color: const Color(0xFF13B8A8),
            ),
            SizedBox(height: 24),
            CircularProgressIndicator(
              color: const Color(0xFF13B8A8),
            ),
            SizedBox(height: 24),
            Text(
              'Đang tải...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}