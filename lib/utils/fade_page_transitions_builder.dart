import 'package:flutter/material.dart';

class CupertinoPageTransitionsBuilderCustom extends PageTransitionsBuilder {
  const CupertinoPageTransitionsBuilderCustom();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // 180 ms 的 slide + fade，曲线用 Curves.fastOutSlowIn
    const begin = Offset(0.0, 0.05);
    const end = Offset.zero;
    const curve = Curves.fastOutSlowIn;
    final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    final fade = Tween(begin: 0.85, end: 1.0).chain(CurveTween(curve: curve));
    return FadeTransition(
      opacity: animation.drive(fade),
      child: SlideTransition(position: animation.drive(tween), child: child),
    );
  }
}

/// 桌面端通用 120 ms 的淡入淡出
class FadePageTransitionsBuilder extends PageTransitionsBuilder {
  const FadePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // 只在进入时做动画，返回时不做二次淡出
    if ( animation.status == AnimationStatus.reverse) {
      return child;
    }
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
      child: child,
    );
  }
}