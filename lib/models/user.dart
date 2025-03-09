// lib/models/user.dart
class User {
  final String id;
  final String username;
  final String email;
  final String? name;
  final String? role;
  final String token;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.name,
    this.role,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      username: json['username'],
      email: json['email'],
      name: json['name'],
      role: json['role'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'name': name,
      'role': role,
      'token': token,
    };
  }

  // You might add convenience methods here
  bool get isAdmin => role == 'admin';
}