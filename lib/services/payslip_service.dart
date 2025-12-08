import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ess/models/payslip.dart';
import 'firebase_auth_service.dart';

class PayslipService {
  static final _firestore = FirebaseFirestore.instance;
  static const _collection = 'payslips';

  static String get _currentUserId {
    final uid = FirebaseAuthService.currentUserId;
    if (uid == null) throw Exception('No user logged in');
    return uid;
  }

  // Stream all payslips (real-time)
  static Stream<List<Payslip>> streamPayslips() {
    return _firestore
        .collection(_collection)
        .where('employeeId', isEqualTo: _currentUserId)
        .orderBy('generatedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Payslip.fromJson(doc.data()))
        .toList());
  }

  static Future<Payslip> getPayslipById(String payslipId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(payslipId).get();
      if (!doc.exists) throw Exception('Payslip not found');
      return Payslip.fromJson(doc.data()!);
    } catch (e) {
      throw Exception('Failed to fetch payslip: ${e.toString()}');
    }
  }

  // Stream single payslip (real-time)
  static Stream<Payslip> streamPayslipById(String payslipId) {
    return _firestore
        .collection(_collection)
        .doc(payslipId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) throw Exception('Payslip not found');
      return Payslip.fromJson(doc.data()!);
    });
  }
}
