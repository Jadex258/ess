import 'package:ess/screens/notification.dart';
import 'package:ess/service/quote_service.dart';
import 'package:ess/widgets/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: CustomAppBar(
        bgColor: Color(0xFFF3F3F3),
        title: 'Morning, John Doe',
        trailing: IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            pushWithoutNavBar(
              context,
              CupertinoPageRoute(
                builder: (context) => const NotificationScreen(),
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
                    Row(
                      children: [
                        Expanded(
                          child: _buildTimeCard(
                            title: 'Time In',
                            time: '08:30 am',
                            subtitle: 'On time',
                            icon: Icons.login,
                            iconColor: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTimeCard(
                            title: 'Time Out',
                            time: '...',
                            subtitle: 'Ongoing',
                            icon: Icons.logout,
                            iconColor: Colors.red,
                          ),
                        ),
                      ],
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
                                'Requests',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'See More',
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
                              )
                            ],
                          ),
                          _buildRequestItem(
                            'Leave',
                            'Nag igit igit',
                            'Dec. 05 2025',
                          ),
                          _buildRequestItem(
                            'Overtime',
                            'Motivated',
                            'Dec. 05 2025',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Activity',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'See More',
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
                        )
                      ],
                    ),
                    _buildActivityItem(
                      title: 'Checked In',
                      date: 'Dec. 05 2025',
                      time: '08:30 AM',
                      status: 'On time',
                      icon: Icons.login,
                      iconColor: Colors.green,
                    ),
                    _buildActivityItem(
                      title: 'Checked Out',
                      date: 'Dec. 05 2025',
                      time: '05:30 PM',
                      status: 'Late',
                      icon: Icons.logout,
                      iconColor: Colors.red,
                    ),
                    _buildActivityItem(
                      title: 'Checked Out',
                      date: 'Dec. 05 2025',
                      time: '05:30 PM',
                      status: 'Late',
                      icon: Icons.access_time,
                      iconColor: Colors.blue,
                    ),
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
        border: Border.all(color: Colors.grey[200]!),
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
                    backgroundColor: const Color(0xFF2896FD).withValues(alpha: 0.1),
                    foregroundColor: const Color(0xFF2896FD),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                    visualDensity: VisualDensity.compact,
                  ),
                  child: const Text(
                    'Get Inspired',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
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
            return const AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Have you sip your coffee today?'),
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
                const Icon(Icons.lightbulb_circle_sharp, color: Color(0xFFFFD600)),
                const SizedBox(width: 8),
                Text(
                  'Quote of the day',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500
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


  Widget _buildRequestItem(String title, String subtitle, String date) {
    return ListTile(
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
          const SizedBox(height: 4),
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

  Widget _buildActivityItem({
    required String title,
    required String date,
    required String time,
    required String status,
    required IconData icon,
    required Color iconColor,
  }) {
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
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                status,
                style: TextStyle(
                  fontSize: 12,
                  color: status == 'Late' ? Colors.red : Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
