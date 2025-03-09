import 'package:flutter/material.dart';

class FadePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadePageRoute({required this.page})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = 0.0;
      const end = 1.0;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var opacityAnimation = animation.drive(tween);

      return FadeTransition(
        opacity: opacityAnimation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 200),
  );
}

class SlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final SlideDirection direction;

  SlidePageRoute({
    required this.page,
    this.direction = SlideDirection.fromRight,
  }) : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const curve = Curves.easeInOut;
      Offset begin;
      const end = Offset.zero;

      switch (direction) {
        case SlideDirection.fromRight:
          begin = const Offset(1.0, 0.0);
          break;
        case SlideDirection.fromLeft:
          begin = const Offset(-1.0, 0.0);
          break;
        case SlideDirection.fromBottom:
          begin = const Offset(0.0, 1.0);
          break;
        case SlideDirection.fromTop:
          begin = const Offset(0.0, -1.0);
          break;
      }

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 200),
  );
}

enum SlideDirection {
  fromRight,
  fromLeft,
  fromBottom,
  fromTop,
}