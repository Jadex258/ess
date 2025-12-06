import 'package:flutter/material.dart';

void main() {
  runApp(const NotificationApp());
}

class NotificationApp extends StatelessWidget {
  const NotificationApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF3F3F3),
        fontFamily: 'Poppins',
      ),
      home: const NotificationPage(),
    );
  }
}

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              
              Row(
                children: [
                  Container(
                    child: Icon(Icons.chevron_left, size: 24, color: Colors.black),
                ),

                const Text(
                  'Notifications',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: Colors.black87,
                    ),
                ),
              ]
            ),
                
              const SizedBox(height: 16),
              // Example Activity Items
              _buildActivityItem(
                title: 'Approved',
                subtitle: 'Leave Request',
                time: '3 hours ago',
                icon: Icons.arrow_forward,
                iconColor: Colors.green,
              ),

              _buildActivityItem(
                title: 'Declined',
                subtitle: 'Leave Request',
                time: '1 day ago',
                icon: Icons.arrow_forward,
                iconColor: Colors.red,
              ),

              _buildActivityItem(
                title: 'Declined',
                subtitle: 'Leave Request',
                time: '2 days ago',
                icon: Icons.arrow_forward,
                iconColor: Colors.red,
              ),

              _buildActivityItem(
                title: 'Approved',
                subtitle: 'Leave Request',
                time: '3 weeks ago',
                icon: Icons.arrow_forward,
                iconColor: Colors.green,
              ),

              ]
              ),
            ),
          ),
        ),
    );
  }
  
  Widget _buildActivityItem({
    required String title,
    required String subtitle,
    required String time,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
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
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

              const SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(
                  fontSize: 8,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
        ],
      ),
    );
  }

}