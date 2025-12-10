enum RequestType {
  leave,
  overtime,
  attendanceCorrection;

  String get label {
    switch (this) {
      case RequestType.leave:
        return 'Leave Request';
      case RequestType.overtime:
        return 'Overtime Request';
      case RequestType.attendanceCorrection:
        return 'Correction Request';
    }
  }
}

enum RequestStatus {
  pending,
  approved,
  rejected;

  String get label {
    switch (this) {
      case RequestStatus.pending:
        return 'Pending';
      case RequestStatus.approved:
        return 'Approved';
      case RequestStatus.rejected:
        return 'Rejected';
    }
  }
}

enum CorrectionRequestType {
  timeIn,
  timeOut,
  breakOut,
  breakIn,
  missingLog;  // Forgot to clock in/out entirely

  String get label {
    switch (this) {
      case CorrectionRequestType.timeIn: return 'Time In Correction';
      case CorrectionRequestType.timeOut: return 'Time Out Correction';
      case CorrectionRequestType.breakOut: return 'Break Out Correction';
      case CorrectionRequestType.breakIn: return 'Break In Correction';
      case CorrectionRequestType.missingLog: return 'Missing Log';
    }
  }
}


enum LeaveRequestType {
  vacation,
  sick,
  emergency,
  maternity;
  String get label {
    switch (this) {
      case LeaveRequestType.vacation: return 'Vacation Leave';
      case LeaveRequestType.sick: return 'Sick Leave';
      case LeaveRequestType.emergency: return 'Emergency Leave';
      case LeaveRequestType.maternity: return 'Maternity/Paternity Leave';
    }
  }
}