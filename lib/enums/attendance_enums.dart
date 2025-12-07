enum AttendanceType {
  regular,
  restDay,
  holiday,
  leave,
  absent;

  String get label {
    switch (this) {
      case AttendanceType.regular:
        return 'Regular Day';
      case AttendanceType.restDay:
        return 'Rest Day';
      case AttendanceType.holiday:
        return 'Holiday';
      case AttendanceType.leave:
        return 'On Leave';
      case AttendanceType.absent:
        return 'Absent';
    }
  }
}

enum AttendanceStatus {
  present,
  late,
  absent,
  onLeave,
  incomplete,
  halfDay;

  String get label {
    switch (this) {
      case AttendanceStatus.present:
        return 'Present';
      case AttendanceStatus.late:
        return 'Late';
      case AttendanceStatus.absent:
        return 'Absent';
      case AttendanceStatus.onLeave:
        return 'On Leave';
      case AttendanceStatus.incomplete:
        return 'Incomplete';
      case AttendanceStatus.halfDay:
        return 'Half Day';
    }
  }
}

enum AttendanceLogType {
  timeIn,
  timeOut,
  breakOut,
  breakIn;

  String get label {
    switch (this) {
      case AttendanceLogType.timeIn:
        return 'Time In';
      case AttendanceLogType.timeOut:
        return 'Time Out';
      case AttendanceLogType.breakOut:
        return 'Break Out';
      case AttendanceLogType.breakIn:
        return 'Break In';
    }
  }
}