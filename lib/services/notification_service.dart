import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ess/models/notification.dart';
import 'firebase_auth_service.dart';

class NotificationService {
  static final _firestore = FirebaseFirestore.instance;
  static const _collection = 'notifications';

  static String get _currentUserId {
    final uid = FirebaseAuthService.currentUserId;
    if (uid == null) throw Exception('No user logged in');
    return uid;
  }

  // Stream all notifications (real-time)
  static Stream<List<Notification>> streamNotifications() {
    return _firestore
        .collection(_collection)
        .where('employeeId', isEqualTo: _currentUserId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Notification.fromJson(doc.data()))
        .toList());
  }

  // Stream unread count (real-time)
  static Stream<int> streamUnreadCount() {
    return _firestore
        .collection(_collection)
        .where('employeeId', isEqualTo: _currentUserId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // Mark as read
  static Future<void> markAsRead(String notificationId) async {
    try {
      await _firestore.collection(_collection).doc(notificationId).update({
        'isRead': true,
      });
    } catch (e) {
      throw Exception('Failed to mark as read: ${e.toString()}');
    }
  }

  // Mark all as read
  static Future<void> markAllAsRead() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('employeeId', isEqualTo: _currentUserId)
          .where('isRead', isEqualTo: false)
          .get();

      final batch = _firestore.batch();
      for (var doc in snapshot.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to mark all as read: ${e.toString()}');
    }
  }
}