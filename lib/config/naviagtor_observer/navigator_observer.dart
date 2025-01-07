import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';

class AppNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);

    developer.log("Navigator observer [Push] :: $route");
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    developer.log("Navigator observer [Pop] :: $route");
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    developer.log("Navigator observer [Replace] - old router :: $oldRoute");
    developer.log("Navigator observer [Replace] - new router :: $newRoute");
  }
}