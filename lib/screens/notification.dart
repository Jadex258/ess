import 'package:ess/widgets/app_bar.dart';
import 'package:flutter/material.dart';


class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Notifications',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        minVerticalPadding: 0,
        minTileHeight: 40,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        trailing: Text(
          time,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        dense: true,
      )
    );
  }
}

