import 'package:flutter/material.dart';
import 'package:shipmanagerapp/screens/home_screen.dart';
import 'package:shipmanagerapp/screens/search_screen.dart';
import 'package:shipmanagerapp/screens/ticket_screen.dart';
import 'package:shipmanagerapp/utils/custom_route.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border(
            top: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 0.5,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: Offset(0, -2),
            ),
          ],
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
                    FadePageRoute(page: HomeScreen()),
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
                    SlidePageRoute(
                      page: SearchScreen(),
                      direction: currentIndex < 1
                          ? SlideDirection.fromRight
                          : SlideDirection.fromLeft,
                    ),
                  );
                }
              },
            ),
            NavBarItem(
              icon: Icons.directions_boat_outlined,
              label: "Vé",
              isActive: currentIndex == 2,
              onTap: () {
                if (currentIndex != 2) {
                  Navigator.pushReplacement(
                    context,
                    SlidePageRoute(
                      page: TicketScreen(),
                      direction: currentIndex < 2
                          ? SlideDirection.fromRight
                          : SlideDirection.fromLeft,
                    ),
                  );
                }
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

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: Color(0xFF13B8A8).withOpacity(0.1),
          highlightColor: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 22),
                SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}