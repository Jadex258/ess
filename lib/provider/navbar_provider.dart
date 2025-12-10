import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class NavbarProvider extends ChangeNotifier {
  final PersistentTabController controller;

  NavbarProvider() : controller = PersistentTabController(initialIndex: 0);

  int get currentIndex => controller.index;

  void jumpTo(int index) {
    controller.jumpToTab(index);
    notifyListeners();
  }
}
