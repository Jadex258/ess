  import 'package:ess/enums/account_enum.dart';
  import 'package:flutter/material.dart';
  import 'package:ess/models/employee.dart';
  import 'package:ess/services/employee_service.dart';

  class EmployeeProvider extends ChangeNotifier {
    Employee? _employee;

    Employee? get employee => _employee;

    void setEmployee(Employee employee) {
      _employee = employee;
      notifyListeners();
    }

    void listenToEmployee(BuildContext context) {
      EmployeeService.streamEmployeeProfile().listen((emp) {
        final wasSuspended = _employee?.accountStatus == AccountStatus.suspended;
        final isNowSuspended = emp.accountStatus == AccountStatus.suspended;

        _employee = emp;
        notifyListeners();

        if (!wasSuspended && isNowSuspended) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Your account has been suspended. Contact HR.'),
              backgroundColor: Color(0xFFE90000),
              duration: Duration(seconds: 5),
            ),
          );
        }
      });
    }
  }