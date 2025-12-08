import 'package:ess/enums/attendance_enums.dart';
import 'package:flutter/material.dart';

Color getAttendanceStatusColor(AttendanceStatus status) {
  switch (status) {
    case AttendanceStatus.present:
      return Colors.green;
    case AttendanceStatus.absent:
      return Colors.red;
    case AttendanceStatus.late:
      return Colors.orange;
    case AttendanceStatus.halfDay:
      return Colors.blue;
    case AttendanceStatus.onLeave:
      return Colors.purple;
    case AttendanceStatus.incomplete:
      return Colors.grey;
  }
}


IconData getAttendanceTypeIcon(AttendanceType type) {
  switch (type) {
    case AttendanceType.regular:
      return Icons.access_time_filled;
    case AttendanceType.restDay:
      return Icons.weekend;
    case AttendanceType.holiday:
      return Icons.celebration;
    case AttendanceType.leave:
      return Icons.beach_access;
  }
}

Color getAttendanceTypeColor(AttendanceType type) {
  switch (type) {
    case AttendanceType.regular:
      return Colors.blue;
    case AttendanceType.restDay:
      return Colors.orange;
    case AttendanceType.holiday:
      return Colors.green;
    case AttendanceType.leave:
      return Colors.purple;
  }
}


Widget buildPesoRichText(String amount, double fontSize, FontWeight fontWeight, {Color color = Colors.black, int? maxLines}) {
  return RichText(
    maxLines: maxLines,
    overflow: maxLines != null ? TextOverflow.ellipsis : TextOverflow.visible,
    text: TextSpan(
      children: [
        TextSpan(
          text: '₱',
          style: TextStyle(
            fontFamily: 'Material Icons',
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
          ),
        ),
        TextSpan(
          text: amount,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
          ),
        ),
      ],
    ),
  );
}

