import 'package:flutter/material.dart';

void main() {
  runApp(const AttendanceApp());
}

class AttendanceApp extends StatelessWidget {
  const AttendanceApp({Key? key}) : super(key: key);

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
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
                  'Attendance List',
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
                title: 'Time In',
                date: 'Dec. 05 2025',
                time: '08:30 AM',
                status: 'On time',
                icon: Icons.login,
                iconColor: Colors.green,
              ),

              const SizedBox(height: 12),
              _buildActivityItem(
                title: 'Time Out',
                date: 'Dec. 05 2025',
                time: '05:30 PM',
                status: 'Late',
                icon: Icons.logout,
                iconColor: Colors.red,
              ),

              const SizedBox(height: 12),
              _buildActivityItem(
                title: 'Overtime',
                date: 'Dec. 05 2025',
                time: '05:30 PM',
                status: 'Late',
                icon: Icons.access_time,
                iconColor: Colors.blue,
              ),

              _buildActivityItem(
                title: 'Time In',
                date: 'Dec. 05 2025',
                time: '08:30 AM',
                status: 'On time',
                icon: Icons.login,
                iconColor: Colors.green,
              ),

              const SizedBox(height: 12),
              _buildActivityItem(
                title: 'Time Out',
                date: 'Dec. 05 2025',
                time: '05:30 PM',
                status: 'Late',
                icon: Icons.logout,
                iconColor: Colors.red,
              ),

              const SizedBox(height: 12),
              _buildActivityItem(
                title: 'Overtime',
                date: 'Dec. 05 2025',
                time: '05:30 PM',
                status: 'Late',
                icon: Icons.access_time,
                iconColor: Colors.blue,
              ),

            _buildActivityItem(
                title: 'Time In',
                date: 'Dec. 05 2025',
                time: '08:30 AM',
                status: 'On time',
                icon: Icons.login,
                iconColor: Colors.green,
              ),

              const SizedBox(height: 12),
              _buildActivityItem(
                title: 'Time Out',
                date: 'Dec. 05 2025',
                time: '05:30 PM',
                status: 'Late',
                icon: Icons.logout,
                iconColor: Colors.red,
              ),

              const SizedBox(height: 12),
              _buildActivityItem(
                title: 'Overtime',
                date: 'Dec. 05 2025',
                time: '05:30 PM',
                status: 'Late',
                icon: Icons.access_time,
                iconColor: Colors.blue,
              ),

            _buildActivityItem(
                title: 'Time In',
                date: 'Dec. 05 2025',
                time: '08:30 AM',
                status: 'On time',
                icon: Icons.login,
                iconColor: Colors.green,
              ),

              const SizedBox(height: 12),
              _buildActivityItem(
                title: 'Time Out',
                date: 'Dec. 05 2025',
                time: '05:30 PM',
                status: 'Late',
                icon: Icons.logout,
                iconColor: Colors.red,
              ),

              const SizedBox(height: 12),
              _buildActivityItem(
                title: 'Overtime',
                date: 'Dec. 05 2025',
                time: '05:30 PM',
                status: 'Late',
                icon: Icons.access_time,
                iconColor: Colors.blue,
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
    required String date,
    required String time,
    required String status,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
                  date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
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
                  fontWeight: FontWeight.w600,
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