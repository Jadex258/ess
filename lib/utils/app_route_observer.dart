import 'package:flutter/widgets.dart';

class AppRouteObserver extends NavigatorObserver {
  String? currentRouteName;
  Object? currentRouteArgs;

  void _update(Route<dynamic>? route) {
    if (route is PageRoute) {
      currentRouteName = route.settings.name;
      currentRouteArgs = route.settings.arguments;
    } else {
      currentRouteName = null;
      currentRouteArgs = null;
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _update(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _update(newRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _update(previousRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _update(previousRoute);
  }

  bool isShowing(String name, [Object? args]) {
    return currentRouteName == name && (args == null ? true : currentRouteArgs == args);
  }
}