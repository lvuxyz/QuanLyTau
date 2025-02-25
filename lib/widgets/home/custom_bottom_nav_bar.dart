import 'package:flutter/material.dart';
import 'package:shipmanagerapp/screens/home_screen.dart';
import 'package:shipmanagerapp/screens/search_screen.dart';
import 'package:shipmanagerapp/screens/ticket_screen.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          NavBarItem(
            icon: Icons.home_filled,
            label: "Trang chủ",
            isActive: currentIndex == 0,
            onTap: () {
              if (currentIndex != 0) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              }
            },
          ),
          NavBarItem(
            icon: Icons.search,
            label: "Tìm kiếm",
            isActive: currentIndex == 1,
            onTap: () {
              if (currentIndex != 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SearchScreen()),
                );
              }
            },
          ),
          NavBarItem(
            icon: Icons.directions_boat_outlined,
            label: "Vé",
            isActive: currentIndex == 2,
            onTap: () {
              Navigator.pushReplacement(
              context,
                  MaterialPageRoute(builder: (context) => TicketScreen()),
              );
            },
          ),
          NavBarItem(
            icon: Icons.person_outline,
            label: "Profile",
            isActive: currentIndex == 3,
            onTap: () {
              // To be implemented
            },
          ),
        ],
      ),
    );
  }
}

class NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const NavBarItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = isActive ? Color(0xFF13B8A8) : Colors.grey;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}