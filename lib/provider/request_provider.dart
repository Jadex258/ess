import 'package:ess/models/request.dart';
import 'package:flutter/material.dart';


class RequestProvider extends ChangeNotifier {
  final List<Request> _localPendingRequests = [];

  List<Request> get localPendingRequests => List.unmodifiable(_localPendingRequests);

  void addLocalPending(Request request) {
    _localPendingRequests.add(request);
    notifyListeners();
  }

  void removeLocalPending(String requestId) {
    _localPendingRequests.removeWhere((r) => r.id == requestId);
    notifyListeners();
  }
}
