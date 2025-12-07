import 'package:ess/enums/request_enums.dart';
import 'package:ess/models/request.dart';
import 'package:ess/screens/payslip/view_payslip.dart';
import 'package:ess/screens/request/view_request.dart';
import 'package:ess/widgets/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import 'create_request.dart';

class RequestListScreen extends StatelessWidget {
  const RequestListScreen({super.key});

  Request createDummyRequest() {
    return Request(
      id: 'REQ-2024-12-001',
      employeeId: 'EMP-001',
      type: RequestType.leave,
      status: RequestStatus.pending,
      createdAt: DateTime(2024, 12, 15, 9, 30),
      respondedAt: null,
      respondedBy: null,
      data: {
        'leaveType': 'Vacation Leave',
        'startDate': 'December 20, 2024',
        'endDate': 'December 22, 2024',
        'reason': 'Family vacation and personal rest',
      },
      remarks: null,
    );
  }

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
      appBar: CustomAppBar(
        title: 'Requests',
        trailing: IconButton(
          icon: const Icon(Icons.add_comment),
          onPressed: () {
            pushWithoutNavBar(
              context,
              CupertinoPageRoute(
                builder: (context) => const CreateRequestScreen(),
              ),
            );
          },
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: requests.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final item = requests[index];
          return _buildRequestItem(
            context,
            category: item['category'],
            description: item['description'],
            date: item['date'],
            status: item['status'],
          );
        },
      ),
    );
  }

  Widget _buildRequestItem( BuildContext context, {
    required String category,
    required String description,
    required String date,
    required String status,
  }) {
    IconData iconData;
    if (status == 'Pending') {
      iconData = Icons.watch_later;
    } else if (status == 'Declined') {
      iconData = Icons.thumb_down;
    } else {
      iconData = Icons.thumb_up;
    }

    Color statusColor;
    if (status == 'Pending') {
      statusColor = const Color(0xFF3F51B5);
    } else if (status == 'Declined') {
      statusColor = const Color(0xFFE53935);
    } else {
      statusColor = const Color(0xFF43A047);
    }

    return ListTile(
      onTap: () {
        pushWithoutNavBar(
          context,
          CupertinoPageRoute(
            builder: (context) => ViewRequestScreen(
              request: createDummyRequest(),
            ),
          ),
        );
      },
      contentPadding: EdgeInsets.zero,
      dense: true,
      minVerticalPadding: 0,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          iconData,
          size: 20,
          color: Colors.black,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Text(
            description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      trailing: Column(
        children: [
          Text(
            date,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical:1),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 11,
                color: statusColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}