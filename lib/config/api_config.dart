// lib/config/api_config.dart
import 'dart:io' show Platform;

class ApiConfig {
  static const String apiVersion = 'v1';
  static const int port = 3000;  // Your localhost port

  // Base URL for API endpoints
  static String get baseUrl {
    if (Platform.isAndroid) {
      // Android emulator uses 10.0.2.2 to access localhost
      return 'http://10.0.2.2:$port/api/$apiVersion';
    } else if (Platform.isIOS) {
      // iOS simulator uses localhost
      return 'http://localhost:$port/api/$apiVersion';
    } else {
      // For web or other platforms
      return 'http://localhost:$port/api/$apiVersion';
    }
  }

  // API Endpoints
  static String get loginEndpoint => '$baseUrl/auth/login';
  static String get registerEndpoint => '$baseUrl/auth/register';
  static String get forgotPasswordEndpoint => '$baseUrl/auth/forgot-password';

// Add more endpoints as needed
}