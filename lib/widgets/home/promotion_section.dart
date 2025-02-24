import 'package:flutter/material.dart';
import '../../blocs/home/home_state.dart';

class PromotionSection extends StatelessWidget {
  final HomeState state;

  const PromotionSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state is! HomeLoaded) {
      return SizedBox.shrink();
    }

    final homeState = state as HomeLoaded;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: homeState.promotions.map((promo) {
        return Text(
          promo['title'],
          style: TextStyle(color: Colors.white, fontSize: 18),
        );
      }).toList(),
    );
  }
}
