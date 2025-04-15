import 'package:flutter/cupertino.dart';

class CustomPageRouteBuilder extends PageRouteBuilder {
  final Widget child;

  CustomPageRouteBuilder({required this.child})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: const Duration(seconds: 1),
          reverseTransitionDuration: const Duration(seconds: 1),
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    //   slide transition
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(1, 0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }
}

// scale transition
// return ScaleTransition(
//   scale: animation,
//   child: child,
// );
