import 'package:flutter/material.dart';

class SearchHeader extends StatelessWidget {
  const SearchHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      color: Colors.black,
      child: Row(
        children: [
          // User avatar
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/images/user_avatar.jpg'),
            onBackgroundImageError: (_, __) {},
            backgroundColor: Colors.grey[800],
            child: Icon(Icons.person, color: Colors.white, size: 24),
          ),
          SizedBox(width: 12),
          // Greeting text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Chào, Admin",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Hôm nay bạn khỏe không?",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Spacer(),
          // Notification icon
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}