import 'package:ess/enums/attendance_enums.dart';
import 'package:ess/enums/skeleton_loading_enum.dart';
import 'package:ess/models/attendance_log.dart';
import 'package:ess/models/attendance_record.dart';
import 'package:ess/models/request.dart';
import 'package:ess/provider/employee_provider.dart';
import 'package:ess/provider/navbar_provider.dart';
import 'package:ess/provider/notification_provider.dart';
import 'package:ess/screens/attendance_list.dart';
import 'package:ess/screens/notification.dart';
import 'package:ess/services/attendance_service.dart';
import 'package:ess/services/notification_service.dart';
import 'package:ess/services/quote_service.dart';
import 'package:ess/services/request_service.dart';
import 'package:ess/utils/helper.dart';
import 'package:ess/widgets/app_bar.dart';
import 'package:ess/widgets/skeleton_loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';

import 'request/view_request.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final notifProvider = context.read<NotificationProvider>();
    notifProvider.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CustomAppBar(
        bgColor: const Color(0xFFF5F5F5),
        titleWidget: Selector<EmployeeProvider?, String>(
          selector: (_, provider) => provider?.employee?.firstName ?? '',
          builder: (_, firstName, __) {
            return Text(
              '👋 Hi $firstName!',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            );
          },
        ),
        trailing: StreamBuilder<int>(
          stream: NotificationService.streamUnreadCount(),
          builder: (context, snapshot) {
            final unreadCount = snapshot.data ?? 0;
            return Badge(
              showBadge: unreadCount > 0,
              badgeContent: Text(
                unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              position: BadgePosition.topEnd(top: 3, end: 10),
              child: IconButton(
                icon: const Icon(Icons.notifications, size: 26, color: Color(0xFF2896FD)),
                onPressed: () {
                  pushWithoutNavBar(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const NotificationScreen(),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDateCardWithQuote(context),
                    const SizedBox(height: 16),
                    StreamBuilder<AttendanceRecord?>(
                      stream: AttendanceService.streamTodayAttendance(),
                      builder: (context, snapshot) {
                        final today = snapshot.data;
                        final timeIn = today?.timeIn?.formattedTime ?? '...';
                        final timeOut = today?.timeOut?.formattedTime ?? '...';

                        return Row(
                          children: [
                            Expanded(
                              child: _buildTimeCard(
                                title: 'Time In',
                                time: timeIn,
                                subtitle:
                                    today?.status.label ?? 'Not clocked in',
                                icon: Icons.login,
                                iconColor: Colors.green,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildTimeCard(
                                title: 'Time Out',
                                time: timeOut,
                                subtitle: timeOut == '...'
                                    ? 'Ongoing'
                                    : 'Completed',
                                icon: Icons.logout,
                                iconColor: Colors.red,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Pending Requests',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => context.read<NavbarProvider>().jumpTo(3),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'See All',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF2896FD),
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(
                                      Icons.chevron_right,
                                      size: 18,
                                      color: Color(0xFF2896FD),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          _buildPendingRequestList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.white),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'This Week Attendance',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            pushWithoutNavBar(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    const AttendanceListScreen(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'See All',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF2896FD),
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.chevron_right,
                                size: 18,
                                color: Color(0xFF2896FD),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    _buildAttendanceList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateCardWithQuote(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = DateFormat('MMMM d, yyyy').format(now);
    final weekday = DateFormat('EEEE').format(now);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  weekday,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  formattedDate,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 40,
            width: 1,
            color: Colors.grey[300],
            margin: const EdgeInsets.symmetric(horizontal: 12),
          ),
          SizedBox(
            width: 110,
            child: Column(
              children: [
                Text(
                  'Not motivated?',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                ElevatedButton(
                  onPressed: () => _showQuoteDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFF2896FD,
                    ).withValues(alpha: 0.1),
                    foregroundColor: const Color(0xFF2896FD),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                    visualDensity: VisualDensity.compact,
                  ),
                  child: const Text(
                    'Get Inspired',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showQuoteDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => FutureBuilder<Map<String, dynamic>>(
        future: fetchRandomQuote(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    'assets/animations/main_loading.json',
                    width: 70,
                    height: 70,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 16),
                  const Text('Have you sip your coffee today?'),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return AlertDialog(
              title: const Text('Oops!'),
              content: Text('Failed to fetch quote: ${snapshot.error}'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            );
          }
          final quote = snapshot.data!;
          return AlertDialog(
            title: Row(
              children: [
                const Icon(
                  Icons.lightbulb_circle_sharp,
                  color: Color(0xFFFFD600),
                ),
                const SizedBox(width: 8),
                Text(
                  'Quote of the day',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quote['content'] ?? 'No quote available',
                  style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                if (quote['author'] != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '— ${quote['author']}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTimeCard({
    required String title,
    required String time,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            time,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingRequestList() {
    return StreamBuilder<List<Request>>(
      stream: RequestService.streamPendingRequests().asyncMap((data) async {
        await Future.delayed(const Duration(milliseconds: 500));
        return data;
      }),
      builder: (context, snapshot) {
        Widget child;
        if (!snapshot.hasData) {
          child = const Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: SkeletonLoading(type: SkeletonType.list, count: 2),
          );
        } else if (snapshot.data!.isEmpty) {
          child = const Padding(
            padding: EdgeInsets.all(18),
            child: Text(
              'No pending requests',
              style: TextStyle(color: Colors.grey),
            ),
          );
        } else {
          final requests = snapshot.data!;
          child = ListView.builder(
            key: const ValueKey('request_list'),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final req = requests[index];
              return _buildRequestItem(
                req,
                req.type.label,
                req.data['reason'] ?? 'No reason provided',
                DateFormat('MMM. dd yyyy').format(req.createdAt),
                req.status.label,
              );
            },
          );
        }

        return AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildRequestItem(
    Request req,
    String title,
    String subtitle,
    String date,
    String status,
  ) {
    return ListTile(
      onTap: (){
        pushWithoutNavBar(
          context,
          CupertinoPageRoute(
            builder: (context) => ViewRequestScreen(request: req),
          ),
        );
      },
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity(horizontal: -4, vertical: -4),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                date,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ],
          ),
          const Text(
            'Pending',
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceList() {
    return StreamBuilder<List<AttendanceRecord>>(
      stream: AttendanceService.streamThisWeekAttendance().asyncMap((
        data,
      ) async {
        await Future.delayed(const Duration(milliseconds: 500));
        return data;
      }),
      builder: (context, snapshot) {
        Widget child;

        if (!snapshot.hasData) {
          child = const Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: SkeletonLoading(type: SkeletonType.list, count: 3),
          );
        } else if (snapshot.data!.isEmpty) {
          child = Center(
            child: Column(
              children: [
                Lottie.asset(
                  'assets/animations/empty.json',
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
                ),
                const Text(
                  'No attendance record this week',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        } else {
          child = ListView.builder(
            key: const ValueKey('attendance_list'),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) =>
                _buildAttendanceRecordItem(snapshot.data![index]),
          );
        }

        return AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildAttendanceRecordItem(AttendanceRecord record) {
    final icon = getAttendanceTypeIcon(record.type);
    final iconColor = getAttendanceTypeColor(record.type);
    final dateFormat = DateFormat('MMM d, yyyy');

    return Container(
      padding: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.type.label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateFormat.format(record.date),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: getAttendanceStatusColor(
                record.status,
              ).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              record.status.label,
              style: TextStyle(
                fontSize: 12,
                color: getAttendanceStatusColor(record.status),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
