import 'package:flutter/material.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  String _selectedCategory = 'File a leave';
  final List<String> _categories = [
    'File a leave',
    'Request for overtime',
    'General Request',
  ];

  // State for the new functional fields
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedLeaveType;
  final List<String> _leaveTypes = [
    'Vacation Leave',
    'Sick Leave',
    'Emergency Leave',
    'Maternity/Paternity Leave',
  ];

  // Colors extracted from design
  final Color _primaryBlue = const Color(0xFF4285F4);
  final Color _borderColor = const Color(0xFFE0E0E0);
  final Color _textLabelColor = const Color(0xFF757575);

  // Helper function to format the date for display
  String _formatDate(DateTime? date) {
    if (date == null) return 'dd/mm/yr';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  // Task 1: Implements a proper date picker
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final initialDate = isStartDate
        ? (_startDate ?? DateTime.now())
        : (_endDate ?? _startDate ?? DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
      builder: (context, child) {
        // Customizing the DatePicker theme for better integration
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: _primaryBlue,
            colorScheme: ColorScheme.light(primary: _primaryBlue),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          // Ensure end date is not before start date
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = _startDate;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          'Submit a request',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Category Selector Card
              _buildCategoryCard(),
              const SizedBox(height: 32),

              // 2. Dynamic Fields based on selection
              _buildDynamicFields(context),

              const SizedBox(height: 40),

              // 3. Action Buttons
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widgets ---

  Widget _buildCategoryCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Blue Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: _primaryBlue,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: const Text(
              'Category',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          // List Options
          ..._categories.map((category) => _buildCategoryItem(category)),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String category) {
    bool isSelected = _selectedCategory == category;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Text(
              category,
              style: TextStyle(
                fontSize: 15,
                color: isSelected ? _primaryBlue : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontStyle: FontStyle.italic,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(Icons.check_circle, color: _primaryBlue, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicFields(BuildContext context) {
    switch (_selectedCategory) {
      case 'File a leave':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Leave Type'),
            // Task 2: Functional Dropdown for Leave Type
            _buildDropdownInput(
              value: _selectedLeaveType,
              hint: 'Select leave type (e.g. Sick, Vacation)',
              items: _leaveTypes,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLeaveType = newValue;
                });
              },
            ),
            const SizedBox(height: 24),
            _buildLabel('Start Date'),
            // Task 1: Functional Date Selector
            _buildDateSelector(context, _startDate, true),
            const SizedBox(height: 24),
            _buildLabel('End Date'),
            _buildDateSelector(context, _endDate, false),
            const SizedBox(height: 24),
            _buildLabel('Reason'),
            _buildTextArea(),
          ],
        );
      case 'Request for overtime':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Date'),
            _buildDateSelector(
              context,
              _startDate,
              true,
            ), // Reusing start date field for general date
            const SizedBox(height: 24),
            _buildLabel('Duration (Hours)'),
            _buildTextInput(hint: 'e.g. 2.5'),
            const SizedBox(height: 24),
            _buildLabel('Reason'),
            _buildTextArea(),
          ],
        );
      case 'General Request':
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Request Title'),
            _buildTextInput(hint: 'Short title for your request'),
            const SizedBox(height: 24),
            _buildLabel('Needed By'),
            _buildDateSelector(
              context,
              _startDate,
              true,
            ), // Reusing start date field for general date
            const SizedBox(height: 24),
            _buildLabel('Description'),
            _buildTextArea(),
          ],
        );
    }
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        text,
        style: TextStyle(
          color: _textLabelColor,
          fontSize: 14,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  // Task 1: Simplified Date Selector to match original design's aesthetic while being functional
  Widget _buildDateSelector(
    BuildContext context,
    DateTime? date,
    bool isStartDate,
  ) {
    return InkWell(
      onTap: () => _selectDate(context, isStartDate),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: _borderColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _formatDate(date),
                style: TextStyle(
                  color: date == null ? Colors.black26 : Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
            Icon(Icons.calendar_today, size: 18, color: Colors.black87),
          ],
        ),
      ),
    );
  }

  Widget _buildTextArea() {
    return Container(
      height: 150,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: _borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const TextField(
        maxLines: null,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Type here...',
          hintStyle: TextStyle(color: Colors.black26),
        ),
      ),
    );
  }

  Widget _buildTextInput({required String hint}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: _borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black26),
        ),
      ),
    );
  }

  // Task 2: Functional Dropdown Widget
  Widget _buildDropdownInput({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: _borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(
            hint,
            style: const TextStyle(color: Colors.black26, fontSize: 14),
          ),
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.black54),
          style: const TextStyle(color: Colors.black, fontSize: 15),
          items: items.map<DropdownMenuItem<String>>((String item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              // Logic for submitting request would go here
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Submitting $_selectedCategory...')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryBlue,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Submit Request',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: () {
              // Simple navigation to a dummy page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ViewRequestsPage(),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: _primaryBlue),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'View all Requests',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: _primaryBlue,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Dummy page for navigation testing
class ViewRequestsPage extends StatelessWidget {
  const ViewRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Requests"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: const Center(child: Text("List of requests will appear here")),
    );
  }
}
