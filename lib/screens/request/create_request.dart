import 'package:ess/components/button.dart';
import 'package:ess/components/dropdown.dart';
import 'package:ess/components/textformfield.dart';
import 'package:ess/enums/request_enums.dart';
import 'package:ess/utils/format.dart';
import 'package:ess/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  RequestType? _selectedRequestType = RequestType.leave;

  LeaveRequestType? _selectedLeaveType;
  DateTime? _startDate;
  DateTime? _endDate;
  final _leaveReasonController = TextEditingController();

  // Overtime request fields
  DateTime? _overtimeDate;
  final _overtimeHoursController = TextEditingController();
  final _overtimeReasonController = TextEditingController();

  DateTime? _correctionDate;
  CorrectionRequestType? _selectedCorrectionType;
  final _actualTimeController = TextEditingController();
  final _correctTimeController = TextEditingController();
  final _correctionReasonController = TextEditingController();
  final _correctionDateController = TextEditingController();
  final _leaveStartDateController = TextEditingController();
  final _leaveEndDateController = TextEditingController();
  final _overtimeDateController = TextEditingController();

  @override
  void dispose() {
    _leaveReasonController.dispose();
    _overtimeHoursController.dispose();
    _overtimeReasonController.dispose();
    _actualTimeController.dispose();
    _correctTimeController.dispose();
    _correctionReasonController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(DateTime? currentDate, Function(DateTime) onDateSelected) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: currentDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Submit Request',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height:12),
              CustomDropdown<RequestType>(
                label: 'Request Type',
                hint: 'Select request type',
                value: _selectedRequestType,
                items: RequestType.values
                    .map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type.label),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRequestType = value;
                  });
                },
                validator: (value) {
                  if (value == null) return 'Please select a request type';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              if (_selectedRequestType != null) ...[
                _buildRequestFields(),
                const SizedBox(height: 48),
              ],
              PrimaryButton(
                text: 'Submit Request',
                onPressed: _selectedRequestType == null
                    ? null
                    : () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Submitting ${_selectedRequestType!.label}...'),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 8),
              SecondaryButton(
                text: 'View All Requests',
                onPressed: () {
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequestFields() {
    switch (_selectedRequestType!) {
      case RequestType.leave:
        return _buildLeaveFields();
      case RequestType.overtime:
        return _buildOvertimeFields();
      case RequestType.attendanceCorrection:
        return _buildCorrectionFields();
    }
  }

  Widget _buildLeaveFields() {
    return Column(
      spacing: 12,
      children: [
        CustomDropdown<LeaveRequestType>(
          label: 'Leave Type',
          hint: 'Select leave type',
          value: _selectedLeaveType,
          items: LeaveRequestType.values
              .map((type) => DropdownMenuItem(
            value: type,
            child: Text(type.label),
          ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedLeaveType = value;
            });
          },
          validator: (value) {
            if (value == null) return 'Please select leave type';
            return null;
          },
        ),
        GestureDetector(
          onTap: () => _selectDate(_startDate, (date) {
            setState(() {
              _startDate = date;
              _leaveStartDateController.text = formatDate(_startDate);
              if (_endDate != null && _endDate!.isBefore(_startDate!)) {
                _endDate = _startDate;
              }
            });
          }),
          child: AbsorbPointer(
            child: CustomTextField(
              controller: _leaveStartDateController,
              label: 'Start Date',
              prefixIcon: const Icon(Icons.calendar_today),
              validator: (value) {
                if (_startDate == null) return 'Please select start date';
                return null;
              },
            ),
          ),
        ),
        GestureDetector(
          onTap: () => _selectDate(_endDate ?? _startDate, (date) {
            setState(() {
              _endDate = date;
              _leaveEndDateController.text = formatDate(_endDate);
            });
          }),
          child: AbsorbPointer(
            child: CustomTextField(
              controller: _leaveEndDateController,
              label: 'End Date',
              prefixIcon: const Icon(Icons.calendar_today),
              validator: (value) {
                if (_endDate == null) return 'Please select end date';
                return null;
              },
            ),
          ),
        ),
        CustomTextField(
          label: 'Reason',
          hint: 'Explain your reason for leave',
          controller: _leaveReasonController,
          textInputAction: TextInputAction.newline,
          maxLines: 4,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Reason is required';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildOvertimeFields() {
    return Column(
      spacing: 12,
      children: [
        GestureDetector(
          onTap: () => _selectDate(_overtimeDate, (date) {
            setState(() {
              _overtimeDate = date;
              _overtimeDateController.text =  formatDate(_overtimeDate);
            });
          }),
          child: AbsorbPointer(
            child: CustomTextField(
              controller: _overtimeDateController,
              label: 'Date',
              prefixIcon: const Icon(Icons.calendar_today),
              validator: (value) {
                if (_overtimeDate == null) return 'Please select date';
                return null;
              },
            ),
          ),
        ),
        CustomTextField(
          label: 'Duration (Hours)',
          hint: 'e.g. 2.5',
          controller: _overtimeHoursController,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Duration is required';
            if (double.tryParse(value) == null) return 'Enter a valid number';
            return null;
          },
        ),
        CustomTextField(
          label: 'Reason',
          hint: 'Explain reason for overtime',
          controller: _overtimeReasonController,
          textInputAction: TextInputAction.newline,
          maxLines: 4,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Reason is required';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCorrectionFields() {
    return Column(
      spacing: 12,
      children: [
        GestureDetector(
          onTap: () => _selectDate(_correctionDate, (date) {
            setState(() {
              _correctionDate = date;
              _correctionDateController.text = formatDate(_correctionDate);
            });
          }),
          child: AbsorbPointer(
            child: CustomTextField(
              controller: _correctionDateController,
              label: 'Date',
              prefixIcon: const Icon(Icons.calendar_today),
              validator: (value) {
                if (_correctionDate == null) return 'Please select date';
                return null;
              },
            ),
          ),
        ),
        CustomDropdown<CorrectionRequestType>(
          label: 'Correction Type',
          hint: 'Select what to correct',
          value: _selectedCorrectionType,
          items: CorrectionRequestType.values
              .map((type) => DropdownMenuItem(
            value: type,
            child: Text(type.label),
          ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedCorrectionType = value;
            });
          },
          validator: (value) {
            if (value == null) return 'Please select correction type';
            return null;
          },
        ),
        CustomTextField(
          label: 'Actual Time',
          hint: 'e.g. 08:15',
          controller: _actualTimeController,
          keyboardType: TextInputType.datetime,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Actual time is required';
            return null;
          },
        ),
        CustomTextField(
          label: 'Correct Time',
          hint: 'e.g. 08:00',
          controller: _correctTimeController,
          keyboardType: TextInputType.datetime,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Correct time is required';
            return null;
          },
        ),
        CustomTextField(
          label: 'Reason',
          hint: 'Explain why correction is needed',
          controller: _correctionReasonController,
          textInputAction: TextInputAction.newline,
          maxLines: 4,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Reason is required';
            return null;
          },
        ),
      ],
    );
  }
}