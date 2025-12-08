import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ess/enums/request_enums.dart';
import 'package:ess/models/request.dart';
import 'firebase_auth_service.dart';

class RequestService {
  static final _firestore = FirebaseFirestore.instance;
  static const _collection = 'requests';

  static String get _currentUserId {
    final uid = FirebaseAuthService.currentUserId;
    if (uid == null) throw Exception('No user logged in');
    return uid;
  }

// Stream all my requests (real-time) with debug prints
  static Stream<List<Request>> streamMyRequests() {
    return _firestore
        .collection(_collection)
        .where('employeeId', isEqualTo: _currentUserId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Request.fromJson(doc.data()))
          .toList();
    });
  }

  static Stream<Request> streamRequestById(String requestId, {Request? initialValue}) async* {
    final docRef = _firestore.collection(_collection).doc(requestId);

    if (initialValue != null) {
      yield initialValue;
    }

    await for (final snapshot in docRef.snapshots()) {
      if (!snapshot.exists) {
        throw Exception('Request not found');
      }

      yield Request.fromJson(snapshot.data()!);
    }
  }

  // Get single request by ID (one-time)
  static Future<Request> getRequestById(String requestId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(requestId).get();
      if (!doc.exists) throw Exception('Request not found');
      return Request.fromJson(doc.data()!);
    } catch (e) {
      throw Exception('Failed to fetch request: ${e.toString()}');
    }
  }

  // Create leave request
  static Future<String> createLeaveRequest({
    required LeaveRequestType leaveType,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
  }) async {
    try {
      final docRef = _firestore.collection(_collection).doc();
      final docId = docRef.id;

      await docRef.set({
        'id': docId,
        'employeeId': _currentUserId,
        'type': RequestType.leave.name,
        'status': RequestStatus.pending.name,
        'createdAt': DateTime.now().toIso8601String(),
        'data': {
          'leaveType': leaveType.name,
          'startDate': startDate.toIso8601String().split('T')[0],
          'endDate': endDate.toIso8601String().split('T')[0],
          'reason': reason,
        },
        'respondedAt': null,
        'respondedBy': null,
        'remarks': null,
      });

      return docId;
    } catch (e) {
      throw Exception('Failed to create leave request: ${e.toString()}');
    }
  }

  // Create overtime request
  static Future<String> createOvertimeRequest({
    required DateTime date,
    required double hours,
    required String reason,
  }) async {
    try {
      final docRef = _firestore.collection(_collection).doc();
      final docId = docRef.id;


      await docRef.set({
        'id': docId,
        'employeeId': _currentUserId,
        'type': RequestType.overtime.name,
        'status': RequestStatus.pending.name,
        'createdAt': DateTime.now().toIso8601String(),
        'data': {
          'date': date.toIso8601String().split('T')[0],
          'hours': hours,
          'reason': reason,
        },
      });

      return docId;
    } catch (e) {
      throw Exception('Failed to create overtime request: ${e.toString()}');
    }
  }

  // Create attendance correction request
  static Future<String> createCorrectionRequest({
    required DateTime date,
    required CorrectionRequestType correctionType,
    required String actualTime,
    required String correctTime,
    required String reason,
  }) async {
    try {
      final docRef = _firestore.collection(_collection).doc();
      final docId = docRef.id;

      await docRef.set({
        'id': docId,
        'employeeId': _currentUserId,
        'type': RequestType.attendanceCorrection.name,
        'status': RequestStatus.pending.name,
        'createdAt': DateTime.now().toIso8601String(),
        'data': {
          'date': date.toIso8601String().split('T')[0],
          'correctionType': correctionType.name,
          'actualTime': actualTime,
          'correctTime': correctTime,
          'reason': reason,
        },
      });
      return docId;
    } catch (e) {
      throw Exception('Failed to create correction request: ${e.toString()}');
    }
  }

  // Cancel pending request (delete)
  static Future<void> cancelRequest(String requestId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(requestId).get();
      if (!doc.exists) throw Exception('Request not found');

      final request = Request.fromJson(doc.data()!);
      if (request.status != RequestStatus.pending) {
        throw Exception('Can only cancel pending requests');
      }

      await _firestore.collection(_collection).doc(requestId).delete();
    } catch (e) {
      throw Exception('Failed to cancel request: ${e.toString()}');
    }
  }

  static Stream<List<Request>> streamPendingRequests() {
    return _firestore
        .collection(_collection)
        .where('employeeId', isEqualTo: _currentUserId)
        .where('status', isEqualTo: RequestStatus.pending.name)
        .orderBy('createdAt', descending: true)
        .limit(5)
        .snapshots(includeMetadataChanges: true)
        .map((snapshot) {
      final requests = snapshot.docs.map((doc) {
        return Request.fromJson(doc.data());
      }).toList();
      return requests;
    });
  }

}