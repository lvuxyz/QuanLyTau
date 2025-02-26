import 'package:flutter/material.dart';
import 'package:shipmanagerapp/ui/screens/home_screen.dart';
import 'package:shipmanagerapp/ui/screens/search_screen.dart';
import 'package:shipmanagerapp/ui/screens/ticket_screen.dart';
import 'package:shipmanagerapp/utils/custom_route.dart';

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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          NavBarItem(
            icon: Icons.home_filled,
            label: "Home",
            isActive: currentIndex == 0,
            onTap: () {
              if (currentIndex != 0) {
                Navigator.pushReplacement(
                  context,
                  FadePageRoute(page: const HomeScreen()),
                );
              }
            },
          ),
          NavBarItem(
            icon: Icons.search,
            label: "Search",
            isActive: currentIndex == 1,
            onTap: () {
              if (currentIndex != 1) {
                // You'll need to create a SearchScreen class
                // Navigator.pushReplacement(
                //   context,
                //   SlidePageRoute(
                //     page: SearchScreen(),
                //     direction: currentIndex < 1
                //         ? SlideDirection.fromRight
                //         : SlideDirection.fromLeft,
                //   ),
                // );
              }
            },
          ),
          NavBarItem(
            icon: Icons.directions_boat_outlined,
            label: "Ships",
            isActive: currentIndex == 2,
            onTap: () {
              if (currentIndex != 2) {
                // You'll need to create a TicketScreen class
                // Navigator.pushReplacement(
                //   context,
                //   SlidePageRoute(
                //     page: TicketScreen(),
                //     direction: currentIndex < 2
                //         ? SlideDirection.fromRight
                //         : SlideDirection.fromLeft,
                //   ),
                // );
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
    Color color = isActive ? const Color(0xFF13B8A8) : Colors.grey;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: const Color(0xFF13B8A8).withOpacity(0.1),
        highlightColor: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}