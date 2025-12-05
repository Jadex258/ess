import 'package:flutter/material.dart';

class RequestListPage extends StatelessWidget {
  const RequestListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data based on your image
    final List<Map<String, dynamic>> requests = [
      {
        'category': 'Leave',
        'description': 'Vacation',
        'date': 'Dec. 04, 2025',
        'status': 'Pending',
      },
      {
        'category': 'Overtime',
        'description': 'will take a leave in the next day',
        'date': 'Dec. 02, 2025',
        'status': 'Declined',
      },
      {
        'category': 'General Request',
        'description': 'Salary Increase',
        'date': 'Dec. 04, 2025',
        'status': 'Accepted',
      },
      {
        'category': 'Leave',
        'description': 'Vacation',
        'date': 'Dec. 04, 2025',
        'status': 'Pending',
      },
      {
        'category': 'Overtime',
        'description': 'will take a leave in the next day',
        'date': 'Dec. 02, 2025',
        'status': 'Declined',
      },
      {
        'category': 'General Request',
        'description': 'Salary Increase',
        'date': 'Dec. 04, 2025',
        'status': 'Accepted',
      },
      {
        'category': 'Leave',
        'description': 'Vacation',
        'date': 'Dec. 04, 2025',
        'status': 'Pending',
      },
      {
        'category': 'Overtime',
        'description': 'will take a leave in the next day',
        'date': 'Dec. 02, 2025',
        'status': 'Declined',
      },
      {
        'category': 'General Request',
        'description': 'Salary Increase',
        'date': 'Dec. 04, 2025',
        'status': 'Accepted',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Request List',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        itemCount: requests.length,
        separatorBuilder: (context, index) => const SizedBox(height: 24),
        itemBuilder: (context, index) {
          final item = requests[index];
          return _buildRequestItem(
            category: item['category'],
            description: item['description'],
            date: item['date'],
            status: item['status'],
          );
        },
      ),
    );
  }

  Widget _buildRequestItem({
    required String category,
    required String description,
    required String date,
    required String status,
  }) {
    // Determine Icon based on status (matching the visual pattern in your image)
    IconData iconData;
    if (status == 'Pending') {
      iconData = Icons.watch_later; // Clock icon
    } else if (status == 'Declined') {
      iconData = Icons.thumb_down; // Thumbs down
    } else {
      iconData = Icons.thumb_up; // Thumbs up
    }

    // Determine Status Text Color
    Color statusColor;
    if (status == 'Pending') {
      statusColor = const Color(0xFF3F51B5); // Indigo/Blue
    } else if (status == 'Declined') {
      statusColor = const Color(0xFFE53935); // Red
    } else {
      statusColor = const Color(0xFF43A047); // Green
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Status Icon (Left)
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Icon(
            iconData,
            size: 28,
            color: Colors.black, // Icons are solid black in design
          ),
        ),
        const SizedBox(width: 16),

        // 2. Main Content (Middle)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),

        // 3. Date & Status (Right)
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              date,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              status,
              style: TextStyle(
                fontSize: 13,
                color: statusColor,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
