import 'package:ess/components/button.dart';
import 'package:ess/enums/request_enums.dart';
import 'package:ess/models/request.dart';
import 'package:ess/services/request_service.dart';
import 'package:ess/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewRequestScreen extends StatelessWidget {
  final Request request;

  const ViewRequestScreen({super.key, required this.request});


  Future<void> _handleCancelRequest(BuildContext context, Request req) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel Request'),
        content: const Text('Are you sure you want to cancel this request?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Yes')),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await RequestService.cancelRequest(request.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request cancelled successfully'), backgroundColor: Colors.green,),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to cancel request: ${e.toString()}'), backgroundColor: Colors.red),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> isLoading = ValueNotifier(false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Request Details',
      ),
      body: StreamBuilder<Request>(
        stream: RequestService.streamRequestById(
          request.id,
          initialValue: request,
        ),
        builder: (context, snapshot) {
          final req = snapshot.data ?? request;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusHeader(req),
                _buildRequestInfoCard(req),
                _buildRequestDetails(req),
                if (req.remarks != null && req.remarks!.isNotEmpty)
                  _buildRemarksSection(req),
                if (req.status == RequestStatus.pending)
                  ValueListenableBuilder<bool>(
                    valueListenable: isLoading,
                    builder: (context, loading, _) {
                      return SecondaryButton(
                        text: 'Cancel Request',
                        color: const Color(0xFFE90000),
                        isLoading: isLoading.value,
                        onPressed: loading
                            ? null
                            : () async {
                          isLoading.value = true;
                          await _handleCancelRequest(context, req);
                          isLoading.value = false;
                        },
                      );
                    },
                  )

              ],
            ),
          );
        },
      ),
    );
  }


  Widget _buildStatusHeader(Request req) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (req.status) {
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
                if (req.respondedAt != null)
                  Text(
                    'Responded on ${DateFormat('MMM d, yyyy').format(req.respondedAt!)}',
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

  Widget _buildRequestInfoCard(Request req) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        spacing: 4,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 2,
            runSpacing: 4,
            children: [
              _buildInfoChip(req.id),
              const SizedBox(width: 4),
              _buildInfoChip(req.type.label),
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
                DateFormat('MMM d, yyyy • h:mm a').format(req.createdAt),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (req.respondedBy != null)
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
                  req.respondedBy!,
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

  Widget _buildRequestDetails(Request req) {
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
        if (req.type == RequestType.leave)
          _buildLeaveDetails(req)
        else if (req.type == RequestType.overtime)
          _buildOvertimeDetails(req)
        else if (req.type == RequestType.attendanceCorrection)
            _buildCorrectionDetails(req)
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

  Widget _buildLeaveDetails(Request req) {
    final leaveTypeStr = req.data['leaveType'] as String?;
    final leaveTypeEnum = leaveTypeStr != null
        ? LeaveRequestType.values.firstWhere(
          (e) => e.name == leaveTypeStr,
      orElse: () => LeaveRequestType.sick,
    )
        : null;
    return _buildRequestDetailsContainer([
      {'label': 'Leave Type', 'value': leaveTypeEnum?.label ?? 'N/A'},
      {'label': 'Start Date', 'value': req.leaveStartDate ?? 'N/A'},
      {'label': 'End Date', 'value': req.leaveEndDate ?? 'N/A'},
      {'label': 'Reason', 'value': req.leaveReason ?? 'N/A', 'isMultiline': true},
    ]);
  }

  Widget _buildOvertimeDetails(Request req) {
    return _buildRequestDetailsContainer([
      {'label': 'Date', 'value': req.overTimeDate ?? 'N/A'},
      {'label': 'Duration', 'value': req.overTimeHours ?? 'N/A'},
      {'label': 'Reason', 'value': req.overTimeReason ?? 'N/A', 'isMultiline': true},
    ]);
  }

  Widget _buildCorrectionDetails(Request req) {
    return _buildRequestDetailsContainer([
      {'label': 'Date', 'value': req.correctionDate ?? 'N/A'},
      {'label': 'Correction Type', 'value': req.correctionType ?? 'N/A'},
      {'label': 'Actual Time', 'value': req.correctionActualTime ?? 'N/A'},
      {'label': 'Correct Time', 'value': req.correctionCorrectTime ?? 'N/A'},
      {'label': 'Reason', 'value': req.correctionReason ?? 'N/A', 'isMultiline': true},
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

  Widget _buildRemarksSection(Request req) {
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
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            req.remarks!,
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
