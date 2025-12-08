import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ess/enums/attendance_enums.dart';
import 'package:ess/models/attendance_log.dart';
import 'package:ess/models/attendance_record.dart';
import 'firebase_auth_service.dart';

class AttendanceService {
  static final _firestore = FirebaseFirestore.instance;
  static const _collection = 'attendance';

  static String get _currentUserId {
    final uid = FirebaseAuthService.currentUserId;
    if (uid == null) throw Exception('No user logged in');
    return uid;
  }

  static Stream<List<AttendanceRecord>> streamMonthlyAttendance(int month,int year) {
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 0);
    return _firestore
        .collection(_collection)
        .where('employeeId', isEqualTo: _currentUserId)
        .where('date', isGreaterThanOrEqualTo: startDate.toIso8601String().split('T')[0])
        .where('date', isLessThanOrEqualTo: endDate.toIso8601String().split('T')[0])
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
              .map((doc) => AttendanceRecord.fromJson(doc.data()))
              .toList(),
        );
  }

  // Stream today's attendance (real-time)
  static Stream<AttendanceRecord?> streamTodayAttendance() {
    final today = DateTime.now().toIso8601String().split('T')[0];

    return _firestore
        .collection(_collection)
        .where('employeeId', isEqualTo: _currentUserId)
        .where('date', isEqualTo: today)
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return null;
          return AttendanceRecord.fromJson(snapshot.docs.first.data());
        });
  }

  // Get attendance by date range (one-time fetch)
  static Future<List<AttendanceRecord>> getAttendanceByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('employeeId', isEqualTo: _currentUserId)
          .where(
            'date',
            isGreaterThanOrEqualTo: startDate.toIso8601String().split('T')[0],
          )
          .where(
            'date',
            isLessThanOrEqualTo: endDate.toIso8601String().split('T')[0],
          )
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => AttendanceRecord.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch attendance: ${e.toString()}');
    }
  }

  static Stream<List<AttendanceRecord>> streamThisWeekAttendance() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday % 7));
    final weekEnd = weekStart.add(const Duration(days: 6));

    return _firestore
        .collection('attendance')
        .where('employeeId', isEqualTo: _currentUserId)
        .where(
          'date',
          isGreaterThanOrEqualTo: weekStart.toIso8601String().split('T')[0],
        )
        .where(
          'date',
          isLessThanOrEqualTo: weekEnd.toIso8601String().split('T')[0],
        )
        .orderBy('date', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AttendanceRecord.fromJson(doc.data()))
              .toList(),
        );
  }
}
