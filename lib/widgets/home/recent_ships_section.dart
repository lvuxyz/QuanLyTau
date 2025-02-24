import 'package:flutter/material.dart';
import '../../blocs/home/home_state.dart';
import 'ticket_button.dart';

class RecentShipsSection extends StatelessWidget {
  final HomeState state;

  const RecentShipsSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state is! HomeLoaded) {
      return SizedBox.shrink();
    }

    final homeState = state as HomeLoaded;

    return Column(
      children: homeState.recentShips.map((ship) {
        return Column(
          children: [
            Text(
              ship['name'],
              style: TextStyle(color: Colors.white),
            ),
            TicketButton(
              text: "Mua vé ngay",
              onPressed: () {
                print("Mua vé cho ${ship['name']}");
              },
            ),
          ],
        );
      }).toList(),
    );
  }
}
