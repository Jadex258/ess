import 'package:ess/provider/navbar_provider.dart';
import 'package:ess/screens/home.dart';
import 'package:ess/screens/payslip/payslip_list.dart';
import 'package:ess/screens/profile/view_profile.dart';
import 'package:ess/screens/qr.dart';
import 'package:ess/screens/request/request_list.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:provider/provider.dart';

class BottomNavbarWidget extends StatelessWidget {
  const BottomNavbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final navbar = context.watch<NavbarProvider>();
    return PersistentTabView(
      controller: navbar.controller,
      tabs: [
        PersistentTabConfig(
          screen: const HomeScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.home_filled),
            title: "Home",
            activeForegroundColor: const Color(0xFF2896FD),
            inactiveForegroundColor: Colors.grey,
            iconSize: 22
          ),
        ),
        PersistentTabConfig(
          screen: const PayslipListScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.receipt_long),
            title: "Payslips",
            activeForegroundColor: const Color(0xFF2896FD),
            inactiveForegroundColor: Colors.grey,
            iconSize: 22
          ),
        ),
        PersistentTabConfig(
          screen: const QRScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.qr_code_scanner, color: Colors.white,),
            activeColorSecondary: Colors.white,
            title: "QR",
            activeForegroundColor: const Color(0xFF2896FD),
            inactiveForegroundColor: Colors.grey,
            iconSize: 22
          ),
        ),
        PersistentTabConfig(
          screen: const RequestListScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.description),
            title: "Requests",
            activeForegroundColor: const Color(0xFF2896FD),
            inactiveForegroundColor: Colors.grey,
            iconSize: 22
          ),
        ),
        PersistentTabConfig(
          screen: const ViewProfileScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.person),
            title: "Profile",
            activeForegroundColor: const Color(0xFF2896FD),
            inactiveForegroundColor: Colors.grey,
            iconSize: 22
          ),
        ),
      ],
      navBarBuilder: (navBarConfig) => Style16BottomNavBar(
        height: 52,
        navBarConfig: navBarConfig,
        navBarDecoration: const NavBarDecoration(
          color: Colors.white,
        ),
      ),
    );
  }
}