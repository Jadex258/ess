import 'package:ess/components/dropdown.dart';
import 'package:ess/enums/attendance_enums.dart';
import 'package:ess/models/attendance_log.dart';
import 'package:ess/models/attendance_record.dart';
import 'package:ess/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ess/widgets/app_bar.dart';
import 'package:ess/widgets/loading_widget.dart';
import 'package:ess/widgets/empty_widget.dart';
import 'package:ess/services/attendance_service.dart';

class AttendanceListScreen extends StatefulWidget {
  const AttendanceListScreen({super.key});

  @override
  State<AttendanceListScreen> createState() => _AttendanceListScreenState();
}

class _AttendanceListScreenState extends State<AttendanceListScreen> {
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: const CustomAppBar(title: 'Attendance Records'),
      body: Column(
        children: [
          _buildMonthPicker(),
          Expanded(child: _buildStream()),
        ],
      ),
    );
  }

  Widget _buildMonthPicker() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: CustomDropdown<int>(
              label: 'Month',
              hint: 'Select month',
              value: selectedMonth,
              items: List.generate(12, (i) => i + 1)
                  .map((m) => DropdownMenuItem(
                value: m,
                child: Text(
                  DateFormat.MMMM().format(DateTime(0, m)),
                ),
              ))
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => selectedMonth = value);
              },
              validator: (value) {
                if (value == null) return 'Please select a month';
                return null;
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CustomDropdown<int>(
              label: 'Year',
              hint: 'Select year',
              value: selectedYear,
              items: List.generate(5, (i) {
                final y = DateTime.now().year - i;
                return DropdownMenuItem(value: y, child: Text('$y'));
              }),
              onChanged: (value) {
                if (value != null) setState(() => selectedYear = value);
              },
              validator: (value) {
                if (value == null) return 'Please select a year';
                return null;
              },
            ),
          ),
        ],
      )
    );
  }


  Widget _buildStream() {
    return StreamBuilder<List<AttendanceRecord>>(
      key: ValueKey('$selectedYear-$selectedMonth'),
      stream: AttendanceService.streamMonthlyAttendance(
        selectedMonth,
        selectedYear,
      ).asyncMap((data) async {
        await Future.delayed(const Duration(milliseconds: 500));
        return data;
      }),
      builder: (context, snapshot) {
        Widget child;

        if (!snapshot.hasData) {
          child = const LoadingWidget(loadingText: "Getting attendance...",);
        } else if (snapshot.data!.isEmpty) {
          child = const EmptyWidget(
            title: 'No attendance records found.',
          );
        } else {
          final list = snapshot.data!;
          child = ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: list.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                EdgeInsets.only(bottom: index < list.length - 1 ? 8 : 0),
                child: _buildAttendanceItem(list[index]),
              );
            },
          );
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildAttendanceItem(AttendanceRecord record) {
    final iconData = getAttendanceTypeIcon(record.type);
    final iconColor = getAttendanceTypeColor(record.type);

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          backgroundColor: Colors.white,
          collapsedBackgroundColor: Colors.white,
          childrenPadding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 8,
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(iconData, color: iconColor, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.type.label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      DateFormat('MMM dd, yyyy').format(record.date),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: getAttendanceStatusColor(record.status).withValues(alpha: 0.1),
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
          children: [
            _buildTimelineLogs(record.logs),
            _buildDetailRow("Total Hours", "${record.totalHours.toStringAsFixed(2)} hrs"),
            if (record.overtimeHours > 0)
              _buildDetailRow("Overtime", "${record.overtimeHours.toStringAsFixed(2)} hrs"),
            if (record.remarks != null)
              _buildDetailRow("Remarks", record.remarks!),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineLogs(List<AttendanceLog> logs) {
    return Column(
      children: logs.map((log) {
        final isLast = logs.last == log;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 20,
                    color: Colors.blue.withValues(alpha: 0.5),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  "${log.formattedTime} — ${log.type.label}",
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text("$label: ",
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 13)),
          Expanded(
            child: Text(value,
                style: const TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
