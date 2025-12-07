import 'package:flutter/material.dart';

enum NotificationType {
  requestApproved,
  requestRejected,
  newPayslip,
  attendanceReminder;

  String get label {
    switch (this) {
      case NotificationType.requestApproved:
        return 'Request Approved';
      case NotificationType.requestRejected:
        return 'Request Rejected';
      case NotificationType.newPayslip:
        return 'New Payslip';
      case NotificationType.attendanceReminder:
        return 'Attendance Reminder';
    }
  }

  IconData get icon {
    switch (this) {
      case NotificationType.requestApproved:
        return Icons.check_circle;
      case NotificationType.requestRejected:
        return Icons.cancel;
      case NotificationType.newPayslip:
        return Icons.receipt_long;
      case NotificationType.attendanceReminder:
        return Icons.access_time;
    }
  }

  Color get color {
    switch (this) {
      case NotificationType.requestApproved:
        return Colors.green;
      case NotificationType.requestRejected:
        return const Color(0xFFE90000);
      case NotificationType.newPayslip:
        return const Color(0xFF2896FD);
      case NotificationType.attendanceReminder:
        return Colors.orange;
    }
  }
}