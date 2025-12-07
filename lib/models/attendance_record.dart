import 'package:ess/enums/attendance_enums.dart';
import 'attendance_log.dart';

class AttendanceRecord {
  final String employeeId;
  final DateTime date;
  final AttendanceType type;
  final AttendanceStatus status;
  final List<AttendanceLog> logs;
  final double totalHours;
  final double overtimeHours;
  final String? remarks;

  AttendanceRecord({
    required this.employeeId,
    required this.date,
    required this.type,
    required this.status,
    required this.logs,
    required this.totalHours,
    this.overtimeHours = 0.0,
    this.remarks,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      employeeId: json['employeeId'] as String,
      date: DateTime.parse(json['date'] as String),
      type: AttendanceType.values.firstWhere(
            (e) => e.name == json['type'],
      ),
      status: AttendanceStatus.values.firstWhere(
            (e) => e.name == json['status'],
      ),
      logs: (json['logs'] as List<dynamic>?)
          ?.map((log) => AttendanceLog.fromJson(log as Map<String, dynamic>))
          .toList() ??
          [],
      totalHours: (json['totalHours'] as num?)?.toDouble() ?? 0.0,
      overtimeHours: (json['overtimeHours'] as num?)?.toDouble() ?? 0.0,
      remarks: json['remarks'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employeeId': employeeId,
      'date': date.toIso8601String().split('T')[0],
      'type': type.name,
      'status': status.name,
      'logs': logs.map((log) => log.toJson()).toList(),
      'totalHours': totalHours,
      'overtimeHours': overtimeHours,
      'remarks': remarks,
    };
  }

  // Helpers
  bool get hasOvertime => overtimeHours > 0;

  AttendanceLog? get timeIn => logs.firstWhere(
        (log) => log.type == AttendanceLogType.timeIn,
    orElse: () => AttendanceLog(
      type: AttendanceLogType.timeIn,
      timestamp: DateTime.now(),
    ),
  );

  AttendanceLog? get timeOut {
    try {
      return logs.firstWhere((log) => log.type == AttendanceLogType.timeOut);
    } catch (_) {
      return null;
    }
  }

  AttendanceRecord copyWith({
    String? employeeId,
    DateTime? date,
    AttendanceType? type,
    AttendanceStatus? status,
    List<AttendanceLog>? logs,
    double? totalHours,
    double? overtimeHours,
    String? remarks,
  }) {
    return AttendanceRecord(
      employeeId: employeeId ?? this.employeeId,
      date: date ?? this.date,
      type: type ?? this.type,
      status: status ?? this.status,
      logs: logs ?? this.logs,
      totalHours: totalHours ?? this.totalHours,
      overtimeHours: overtimeHours ?? this.overtimeHours,
      remarks: remarks ?? this.remarks,
    );
  }
}