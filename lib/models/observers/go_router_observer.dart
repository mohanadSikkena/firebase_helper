import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyGoRouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (kDebugMode) {
      print('${previousRoute?.settings.name} -> Pushed:-> ${route.settings.name}');
    }
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (kDebugMode) {
      print('Popped: ${route.settings.name}');
    }
    super.didPop(route, previousRoute);
  }

// Implement other observer methods as needed (didReplace, didRemove, etc.)
}