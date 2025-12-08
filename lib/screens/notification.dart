import 'dart:async';

import 'package:ess/enums/notification_enum.dart';
import 'package:ess/provider/navbar_provider.dart';
import 'package:ess/services/notification_service.dart';
import 'package:ess/models/notification.dart';
import 'package:ess/widgets/app_bar.dart';
import 'package:ess/widgets/empty_widget.dart';
import 'package:ess/widgets/loading_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  final String? notificationId;

  const NotificationScreen({super.key, this.notificationId});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final ScrollController _scrollController = ScrollController();

  final Map<NotificationType, IconData> _typeIcons = {
    NotificationType.requestApproved: Icons.check_circle,
    NotificationType.requestRejected: Icons.cancel,
    NotificationType.newPayslip: Icons.receipt_long,
    NotificationType.attendanceReminder: Icons.access_time,
  };

  final Map<NotificationType, Color> _typeColors = {
    NotificationType.requestApproved: Colors.green,
    NotificationType.requestRejected: Colors.red,
    NotificationType.newPayslip: Colors.blue,
    NotificationType.attendanceReminder: Colors.orange,
  };

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToNotification(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final position = index * 120.0;
      _scrollController.animateTo(
        position,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }


  void _handleNotificationClick(Notification notif) {
    try {
      NotificationService.markAsRead(notif.id);
      final navbar = context.read<NavbarProvider>();
      switch (notif.type) {
        case NotificationType.requestApproved:
          Navigator.of(context).pop();
          navbar.jumpTo(3);
          break;
        case NotificationType.requestRejected:
          Navigator.of(context).pop();
          navbar.jumpTo(3);
          break;
        case NotificationType.newPayslip:
          Navigator.of(context).pop();
          navbar.jumpTo(1);
          break;
        case NotificationType.attendanceReminder:
          Navigator.of(context).pop();
          break;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to open notification: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? notificationId = widget.notificationId;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Notifications',
      ),
      body: StreamBuilder<List<Notification>>(
        stream: NotificationService.streamNotifications(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: LoadingWidget(loadingText: "Getting notifications",));
          }
          if(snapshot.data!.isEmpty){
            return EmptyWidget(title: "No notifications found");
          }

          final notifications = snapshot.data!;
          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notif = notifications[index];
              final isTarget = notificationId != null && notificationId == notif.id;
              if (isTarget) {
                _scrollToNotification(index);
              }
              final icon = _typeIcons[notif.type] ?? Icons.notifications;
              final color = _typeColors[notif.type] ?? Colors.grey;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => _handleNotificationClick(notif),
                  child: HighlightedNotification(
                    notification: notif,
                    highlight: isTarget,
                    icon: icon,
                    color: color,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class HighlightedNotification extends StatefulWidget {
  final Notification notification;
  final bool highlight;
  final IconData icon;
  final Color color;

  const HighlightedNotification({
    super.key,
    required this.notification,
    this.highlight = false,
    required this.icon,
    required this.color,
  });

  @override
  State<HighlightedNotification> createState() => _HighlightedNotificationState();
}

class _HighlightedNotificationState extends State<HighlightedNotification> with SingleTickerProviderStateMixin {
  late bool _showHighlight;
  late AnimationController _pulseController;
  Timer? _endTimer;

  @override
  void initState() {
    super.initState();
    _showHighlight = widget.highlight;

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    if (_showHighlight) {
      _pulseController.repeat(reverse: true);
      _endTimer = Timer(const Duration(milliseconds: 2200), () {
        _pulseController.stop();
        if (mounted) {
          setState(() {
            _showHighlight = false;
          });
        }
        _pulseController.dispose();
      });
    } else {
      _pulseController.value = 0.0;
    }
  }

  @override
  void dispose() {
    _endTimer?.cancel();
    if (_pulseController.isAnimating) {
      _pulseController.stop();
    }
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseBackground = widget.notification.isRead
        ? const Color(0xFFF5F5F5)
        : const Color(0xFF2896FD).withValues(alpha: 0.08);

    final highlightBg = widget.color.withValues(alpha: 0.10);
    final highlightBorder = Border.all(color: Colors.orange, width: 1.5);

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final pulse = _pulseController.isAnimating ? _pulseController.value : 0.0;

        final boxShadow = _showHighlight
            ? [
          BoxShadow(
            color: Colors.orange.withValues(alpha: 0.35 * (0.5 + pulse * 0.5)),
            blurRadius: 8 + 10 * pulse,
            spreadRadius: 1.0 * pulse,
            offset: const Offset(0, 2),
          )
        ]
            : [];

        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _showHighlight ? highlightBg : baseBackground,
            borderRadius: BorderRadius.circular(10),
            border: _showHighlight ? highlightBorder : null,
          ),
          child: child,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(widget.icon, color: widget.color, size: 20),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.notification.type.label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: widget.notification.isRead ? FontWeight.w500 : FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              Text(
                DateFormat('MMM dd, yyyy').format(widget.notification.createdAt),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          NotificationText(
            text: widget.notification.text,
            maxChars: 100,
            isRead: widget.notification.isRead,
          ),
        ],
      ),
    );
  }
}

class NotificationText extends StatefulWidget {
  final String text;
  final int maxChars;
  final bool isRead;

  const NotificationText({super.key, required this.text, this.maxChars = 100, required this.isRead});

  @override
  State<NotificationText> createState() => _NotificationTextState();
}

class _NotificationTextState extends State<NotificationText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final displayText = _expanded
        ? widget.text
        : (widget.text.length > widget.maxChars
        ? widget.text.substring(0, widget.maxChars)
        : widget.text);

    final hasOverflow = widget.text.length > widget.maxChars;

    return RichText(
      text: TextSpan(
        text: displayText,
        style: TextStyle(
          fontSize: 14,
          color: Colors.black87,
          fontFamily: 'Poppins',
          fontWeight: widget.isRead ? FontWeight.w400 : FontWeight.w500,
        ),
        children: hasOverflow
            ? [
          TextSpan(
            text: _expanded ? ' See Less' : '... See More',
            style: const TextStyle(
                fontSize: 14, color: Color(0xFF2896FD), fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
          ),
        ]
            : [],
      ),
    );
  }
}