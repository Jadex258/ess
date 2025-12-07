import 'package:ess/components/button.dart';
import 'package:ess/enums/request_enums.dart';
import 'package:ess/models/request.dart';
import 'package:ess/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewRequestScreen extends StatelessWidget {
  final Request request;

  const ViewRequestScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Request Details',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusHeader(),
            _buildRequestInfoCard(),
            _buildRequestDetails(),
            if (request.remarks != null && request.remarks!.isNotEmpty)
              _buildRemarksSection(),
            if (request.status == RequestStatus.pending)
              SecondaryButton(
                text: "Cancel Request",
                color: Color(0xFFE90000),
                onPressed: () {

                },
              )
          ],
        ),
      ),
    );
  }

  Widget _buildStatusHeader() {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (request.status) {
      case RequestStatus.pending:
        statusColor = const Color(0xFF3F51B5);
        statusIcon = Icons.pending;
        statusText = RequestStatus.pending.label;
        break;
      case RequestStatus.approved:
        statusColor = const Color(0xFF43A047);
        statusIcon = Icons.check_circle;
        statusText = RequestStatus.approved.label;
        break;
      case RequestStatus.rejected:
        statusColor = const Color(0xFFE53935);
        statusIcon = Icons.cancel;
        statusText = RequestStatus.rejected.label;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
                if (request.respondedAt != null)
                  Text(
                    'Responded on ${DateFormat('MMM d, yyyy').format(request.respondedAt!)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        spacing: 4,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 2,
            runSpacing: 4,
            children: [
              _buildInfoChip(request.id),
              const SizedBox(width: 4),
              _buildInfoChip(request.type.label),
            ],
          ),
          const SizedBox(height: 2),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Submitted',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                DateFormat('MMM d, yyyy • h:mm a').format(request.createdAt),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (request.respondedBy != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Responded by',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  request.respondedBy!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildRequestDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Request Details',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        if (request.type == RequestType.leave)
          _buildLeaveDetails()
        else if (request.type == RequestType.overtime)
          _buildOvertimeDetails()
        else if (request.type == RequestType.attendanceCorrection)
            _buildCorrectionDetails()
          else
            SizedBox(),
      ],
    );
  }


  Widget _buildRequestDetailsContainer(List<Map<String, dynamic>> fields) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: fields.length,
        separatorBuilder: (context, index) => const Divider(height: 16, color: Colors.grey),
        itemBuilder: (context, index) {
          final field = fields[index];
          return _buildDetailRow(
            field['label'] as String,
            field['value'] as String,
            isMultiline: field['isMultiline'] ?? false,
          );
        },
      ),
    );
  }

  Widget _buildLeaveDetails() {
    final data = request.data;
    return _buildRequestDetailsContainer([
      {'label': 'Leave Type', 'value': data['leaveType']?.toString() ?? 'N/A'},
      {'label': 'Start Date', 'value': data['startDate']?.toString() ?? 'N/A'},
      {'label': 'End Date', 'value': data['endDate']?.toString() ?? 'N/A'},
      {'label': 'Reason', 'value': data['reason']?.toString() ?? 'N/A', 'isMultiline': true},
    ]);
  }

  Widget _buildOvertimeDetails() {
    final data = request.data;
    return _buildRequestDetailsContainer([
      {'label': 'Date', 'value': data['date']?.toString() ?? 'N/A'},
      {'label': 'Duration', 'value': data['hours']?.toString() ?? 'N/A'},
      {'label': 'Reason', 'value': data['reason']?.toString() ?? 'N/A', 'isMultiline': true},
    ]);
  }

  Widget _buildCorrectionDetails() {
    final data = request.data;
    return _buildRequestDetailsContainer([
      {'label': 'Date', 'value': data['date']?.toString() ?? 'N/A'},
      {'label': 'Correction Type', 'value': data['correctionType']?.toString() ?? 'N/A'},
      {'label': 'Actual Time', 'value': data['actualTime']?.toString() ?? 'N/A'},
      {'label': 'Correct Time', 'value': data['correctTime']?.toString() ?? 'N/A'},
      {'label': 'Reason', 'value': data['reason']?.toString() ?? 'N/A', 'isMultiline': true},
    ]);
  }

  Widget _buildDetailRow(String label, String value, {bool isMultiline = false}) {
    return Row(
      crossAxisAlignment: isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
            maxLines: isMultiline ? null : 1,
            overflow: isMultiline ? null : TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildRemarksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Remarks',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Text(
            request.remarks!,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),

      ],
    );
  }

  Widget _buildInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF2896FD).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF2896FD),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
