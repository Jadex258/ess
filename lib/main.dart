import 'package:ess/enums/account_enum.dart';
import 'package:ess/firebase_options.dart';
import 'package:ess/provider/employee_provider.dart';
import 'package:ess/provider/navbar_provider.dart';
import 'package:ess/provider/notification_provider.dart';
import 'package:ess/screens/authentication/setup_account.dart';
import 'package:ess/screens/authentication/login.dart';
import 'package:ess/services/firebase_auth_service.dart';
import 'package:ess/services/employee_service.dart';
import 'package:ess/services/local_notification_service.dart';
import 'package:ess/utils/app_route_observer.dart';
import 'package:ess/widgets/bottom_navbar.dart';
import 'package:ess/widgets/empty_widget.dart';
import 'package:ess/widgets/loading_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'models/employee.dart';


final AppRouteObserver appRouteObserver = AppRouteObserver();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EmployeeProvider()),
        ChangeNotifierProvider(create: (_) => NavbarProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MaterialApp(
        title: 'Cenixys ESS',
        navigatorKey: navigatorKey,
        navigatorObservers: [appRouteObserver],
        theme: ThemeData(
          fontFamily: 'Poppins',
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF2896FD),
            surface: Colors.white,
            onSurface: Colors.black,
          ),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        home: const AuthChecker(),
      ),
    );
  }
}

class AuthChecker extends StatefulWidget {
  const AuthChecker({super.key});

  @override
  State<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  Future<Employee>? _futureEmployee;

  @override
  void initState() {
    super.initState();
    if (FirebaseAuthService.isLoggedIn()) {
      context.read<EmployeeProvider>().listenToEmployee(context);

      _futureEmployee = EmployeeService.getEmployeeProfile().then((emp) {
        context.read<EmployeeProvider>().setEmployee(emp);
        return emp;
      });
    }
  }

  Future<void> _handleLogout() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logging out...'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
      await Future.delayed(const Duration(milliseconds: 500));
      await FirebaseAuthService.logout();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: const Color(0xFFE90000),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    if (!FirebaseAuthService.isLoggedIn()) {
      return const LoginScreen();
    }

    return Selector<EmployeeProvider, AccountStatus?>(
      selector: (_, provider) => provider.employee?.accountStatus,
      builder: (context, accountStatus, _) {
        if (accountStatus == AccountStatus.suspended) {
          return Scaffold(
            body: Center(
              child: EmptyWidget(
                buttonText: 'Logout',
                title: "Your account has been suspended! Contact your HR immediately.",
                onRetry: () => _handleLogout(),
              ),
            ),
          );
        }

        return FutureBuilder<Employee>(
          future: _futureEmployee,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: LoadingWidget(loadingText: "Getting things ready..."),
                ),
              );
            }
            if (snapshot.hasError) {
              return const LoginScreen();
            }
            final employee = snapshot.data!;
            if (employee.accountStatus == AccountStatus.pendingSetup) {
              return const SetupAccountScreen();
            }
            return const BottomNavbarWidget();
          },
        );
      },
    );
  }
}
