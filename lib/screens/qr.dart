import 'dart:async';
import 'dart:convert';

import 'package:ess/provider/employee_provider.dart';
import 'package:ess/services/employee_service.dart';
import 'package:ess/widgets/empty_widget.dart';
import 'package:ess/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';

class QRScreen extends StatefulWidget {
  const QRScreen({super.key});

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> with TickerProviderStateMixin {
  StreamSubscription? _qrSubscription;
  Map<String, dynamic>? _currentQRData;
  Timer? _countdownTimer;
  Timer? _refreshTimer;
  int _secondsRemaining = 120;
  bool _isRefreshing = false;
  bool _isVisible = true;
  bool _subscriptionPaused = false;
  bool _startingStream = false;
  AnimationController? _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _startQRStream();
  }

  @override
  void dispose() {
    _qrSubscription?.cancel();
    _refreshTimer?.cancel();
    _countdownTimer?.cancel();
    _fadeController?.dispose();
    super.dispose();
  }

  Future<void> _startQRStream({bool force = false}) async {
    if (_startingStream) return;
    _startingStream = true;

    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      if (!force && _currentQRData != null) {
        final expiry = _currentQRData!['e'] as int?;
        if (expiry != null && now < expiry) {
          if (_subscriptionPaused) {
            try {
              _qrSubscription?.resume();
            } catch (_) {}
            _subscriptionPaused = false;
          }
          _startCountdown(expiry);
          _scheduleNextRefresh();
          _startingStream = false;
          return;
        }
      }

      await _qrSubscription?.cancel();
      _qrSubscription = EmployeeService.streamQRToken().listen((data) {
        if (data['error'] == null) {
          _countdownTimer?.cancel();
          _refreshTimer?.cancel();

          if (!mounted) return;
          setState(() {
            _currentQRData = {
              't': data['t'],
              'e': data['e'],
              'u': data['u'],
              'error': null,
            };
            _isRefreshing = true;
          });

          _fadeController?.forward(from: 0.0);
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              setState(() => _isRefreshing = false);
            }
          });

          final expiry = data['e'] as int?;
          if (expiry != null) {
            _startCountdown(expiry);
            _scheduleNextRefresh();
          }
        } else {
        }
      }, onError: (e, st) {
        if (!mounted) return;
        setState(() {
          _currentQRData = {
            't': null,
            'e': null,
            'u': null,
            'error': e.toString(),
          };
        });
      }, onDone: () {

      });
      _subscriptionPaused = false;
    } finally {
      _startingStream = false;
    }
  }

  void _scheduleNextRefresh() {
    _refreshTimer?.cancel();
    if (_isVisible && _currentQRData != null) {
      final expiry = _currentQRData!['expiresAt'] as int?;
      if (expiry != null) {
        final now = DateTime.now().millisecondsSinceEpoch;
        final msRemaining = expiry - now;
        final delay = msRemaining > 0 ? Duration(milliseconds: msRemaining + 500) : Duration.zero;
        _refreshTimer = Timer(delay, () {
          if (_isVisible) _startQRStream(force: true);
        });
      } else {
        _refreshTimer = Timer(const Duration(minutes: 2), () {
          if (_isVisible) _startQRStream(force: true);
        });
      }
    }
  }

  void _handleVisibilityChanged(VisibilityInfo info) {
    final wasVisible = _isVisible;
    _isVisible = info.visibleFraction > 0.5;

    if (_isVisible && !wasVisible) {
      if (_currentQRData != null) {
        final now = DateTime.now().millisecondsSinceEpoch;
        final expiry = _currentQRData!['e'] as int?;

        if (expiry == null || now >= expiry) {
          _startQRStream(force: true);
        } else {
          _startCountdown(expiry);
          _scheduleNextRefresh();
          if (_subscriptionPaused) {
            _qrSubscription?.resume();
            _subscriptionPaused = false;
          }
        }
      } else {
        _startQRStream();
      }
    } else if (!_isVisible && wasVisible) {
      try {
        _qrSubscription?.pause();
        _subscriptionPaused = true;
      } catch (_) {
        _qrSubscription?.cancel();
        _qrSubscription = null;
        _subscriptionPaused = false;
      }

      _refreshTimer?.cancel();
      _countdownTimer?.cancel();
    }
  }

  void _startCountdown(int expiryTimestamp) {
    _countdownTimer?.cancel();

    final now = DateTime.now().millisecondsSinceEpoch;
    var remaining = ((expiryTimestamp - now) / 1000).ceil();
    if (remaining < 0) remaining = 0;
    setState(() => _secondsRemaining = remaining);

    if (remaining == 0) return;

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now().millisecondsSinceEpoch;
      final remaining = ((expiryTimestamp - now) / 1000).ceil();

      if (remaining <= 0) {
        timer.cancel();
        if (mounted) setState(() => _secondsRemaining = 0);
      } else {
        if (mounted) setState(() => _secondsRemaining = remaining);
      }
    });
  }

  Color _getTimerColor() {
    if (_secondsRemaining > 60) return Colors.green;
    if (_secondsRemaining > 30) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('qr-screen'),
      onVisibilityChanged: _handleVisibilityChanged,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                spacing: 16,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Scan QR code to time in\nand time out',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  _buildQRContent(),
                  _buildStatusText(),
                  Selector<EmployeeProvider, String?>(
                    selector: (_, provider) => provider.employee?.fullName,
                    builder: (_, fullName, __) {
                      return Text(
                        fullName ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          height: 1
                        ),
                      );
                    },
                  ),
                  Selector<EmployeeProvider, String?>(
                    selector: (_, provider) => provider.employee?.position,
                    builder: (_, position, __) {
                      return Text(
                        position ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                          height: 1
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQRContent() {
    if (_currentQRData?['error'] != null) {
      return _buildErrorState();
    }
    if (_currentQRData == null) {
      return _buildLoadingState();
    }
    return _buildQRWithCountdown();
  }

  Widget _buildQRWithCountdown() {
    final qrData = jsonEncode({
      't': _currentQRData!['t'],
      'e': _currentQRData!['e'],
    });

    return FadeTransition(
      opacity: _fadeController!,
      child: Container(
        width: 320,
        height: 320,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 280,
              backgroundColor: Colors.white,
            ),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 4,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      value: _secondsRemaining / 120,
                      strokeWidth: 5,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation(_getTimerColor()),
                    ),
                  ),
                  Text(
                    '${_secondsRemaining}s',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _getTimerColor(),
                    ),
                  ),
                ],
              ),
            ),
            if (_isRefreshing)
            Positioned(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      width: 320,
      height: 320,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: const LoadingWidget(loadingText: "Generating Qr code..."),
    );
  }

  Widget _buildErrorState() {
    return Container(
      width: 320,
      height: 320,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: EmptyWidget(title: "Failed to generate QR code",
      onRetry: (){
        setState(() => _currentQRData = null);
        _startQRStream();
      })
    );
  }

  Widget _buildStatusText() {
    final isOnline = _currentQRData?['error'] == null;
    if (!isOnline && _currentQRData?['token'] != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.orange.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, color: Colors.orange, size: 16),
            const SizedBox(width: 8),
            const Text(
              'Offline - QR still valid until expiry',
              style: TextStyle(fontSize: 12, color: Colors.orange),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}