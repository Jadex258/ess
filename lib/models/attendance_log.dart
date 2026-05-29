import 'package:ess/enums/attendance_enums.dart';

class AttendanceLog {
  final AttendanceLogType type;
  final DateTime timestamp;

  AttendanceLog({
    required this.type,
    required this.timestamp,
  });

  factory AttendanceLog.fromJson(Map<String, dynamic> json) {
    return AttendanceLog(
      type: AttendanceLogType.values.firstWhere(
            (e) => e.name == json['type'],
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  String get formattedTime {
    final local = timestamp.toLocal();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
