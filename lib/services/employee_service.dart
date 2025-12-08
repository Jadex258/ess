import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ess/enums/account_enum.dart';
import 'package:ess/models/employee.dart';
import 'firebase_auth_service.dart';

class EmployeeService {
  static final _firestore = FirebaseFirestore.instance;
  static const _collection = 'employees';

  // Get current user's employee ID
  static String get _currentUserId {
    final uid = FirebaseAuthService.currentUserId;
    if (uid == null) throw Exception('No user logged in');
    return uid;
  }

  // Stream employee profile (real-time)
  static Stream<Employee> streamEmployeeProfile() {
    return _firestore
        .collection(_collection)
        .doc(_currentUserId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) throw Exception('Employee profile not found');
      return Employee.fromJson(doc.data()!);
    });
  }

  // Get employee profile (one-time)
  static Future<Employee> getEmployeeProfile() async {
    try {
      final doc = await _firestore.collection(_collection).doc(_currentUserId).get();
      if (!doc.exists) throw Exception('Employee profile not found');
      return Employee.fromJson(doc.data()!);
    } catch (e) {
      throw Exception('Failed to fetch profile: ${e.toString()}');
    }
  }

  // Update employee profile (editable fields only)
  static Future<void> updateEmployeeProfile({
    String? firstName,
    String? lastName,
    String? middleName,
    String? phoneNumber,
    String? address,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (firstName != null) updates['firstName'] = firstName;
      if (lastName != null) updates['lastName'] = lastName;
      if (middleName != null) updates['middleName'] = middleName;
      if (phoneNumber != null) updates['phoneNumber'] = phoneNumber;
      if (address != null) updates['address'] = address;

      if (updates.isEmpty) return;

      await _firestore.collection(_collection).doc(_currentUserId).update(updates);
    } catch (e) {
      throw Exception('Failed to update profile: ${e.toString()}');
    }
  }

  // Complete account setup (mark as complete)
  static Future<void> completeAccountSetup() async {
    try {
      await _firestore.collection(_collection).doc(_currentUserId).update({
        'accountStatus': AccountStatus.active.name,
        'setupCompletedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to complete setup: ${e.toString()}');
    }
  }

  static Future<String> getEmailByEmployeeId(String employeeId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('id', isEqualTo: employeeId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('Employee ID not found');
      }

      return querySnapshot.docs.first.data()['email'] as String;
    } catch (e) {
      throw Exception('Failed to fetch email: ${e.toString()}');
    }
  }
}