import 'package:ess/components/button.dart';
import 'package:ess/components/textformfield.dart';
import 'package:ess/enums/account_enum.dart';
import 'package:ess/models/employee.dart';
import 'package:ess/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  // Dummy employee data (replace with actual employee data)
  final _employee = Employee(
    id: 'EMP001',
    email: 'johndoe@company.com',
    firstName: 'John',
    lastName: 'Doe',
    middleName: 'Michael',
    phoneNumber: '+1 (555) 123-4567',
    address: '123 Main Street, Ormoc City, Leyte 6541',
    department: 'Engineering',
    position: 'Senior UI/UX Designer',
    employmentType: EmploymentType.fullTime,
    hireDate: DateTime(2024, 1, 15),
    accountStatus: AccountStatus.active,
  );

  // Editable fields controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _addressController = TextEditingController();

  // Password change fields
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Initialize controllers with employee data
    _firstNameController.text = _employee.firstName;
    _lastNameController.text = _employee.lastName;
    _middleNameController.text = _employee.middleName ?? '';
    _phoneNumberController.text = _employee.phoneNumber ?? '';
    _addressController.text = _employee.address ?? '';
  }

  @override
  void dispose() {
    _tabController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _middleNameController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Edit Profile',
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildProfileHeader(),
            TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF2896FD),
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: const Color(0xFF2896FD),
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                fontFamily: 'Poppins'
              ),
              tabs: const [
                Tab(text: 'Personal Info'),
                Tab(text: 'Change Password'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPersonalInfoTab(),
                  _buildChangePasswordTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButtons(),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Text(
          _employee.fullName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),

        Text(
          _employee.position,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(),
          CustomTextField(
            label: 'First Name',
            controller: _firstNameController,
            prefixIcon: const Icon(Icons.person, size: 20),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'First name is required';
              }
              return null;
            },
          ),
          CustomTextField(
            label: 'Middle Name (Optional)',
            controller: _middleNameController,
            prefixIcon: const Icon(Icons.person_outline, size: 20),
          ),
          CustomTextField(
            label: 'Last Name',
            controller: _lastNameController,
            prefixIcon: const Icon(Icons.person, size: 20),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Last name is required';
              }
              return null;
            },
          ),
          CustomTextField(
            label: 'Phone Number',
            controller: _phoneNumberController,
            prefixIcon: const Icon(Icons.phone, size: 20),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value != null && value.isNotEmpty && !RegExp(r'^[\d\s\-\+\(\)]{10,}$').hasMatch(value)) {
                return 'Enter a valid phone number';
              }
              return null;
            },
          ),
          CustomTextField(
            label: 'Address',
            controller: _addressController,
            prefixIcon: const Icon(Icons.location_on, size: 20),
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
    );
  }

  Widget _buildChangePasswordTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(),
          CustomTextField(
            label: 'Current Password',
            controller: _currentPasswordController,
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Current password is required';
              }
              // Add validation against actual current password
              return null;
            },
          ),
          CustomTextField(
            label: 'New Password',
            controller: _newPasswordController,
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'New password is required';
              }
              if (value.length < 8) {
                return 'Password must be at least 8 characters';
              }
              return null;
            },
          ),
          CustomTextField(
            label: 'Confirm New Password',
            controller: _confirmPasswordController,
            textInputAction: TextInputAction.done,
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _newPasswordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          SizedBox(),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Password Requirements:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                _buildPasswordRequirement('At least 8 characters long'),
                _buildPasswordRequirement('Contains uppercase and lowercase letters'),
                _buildPasswordRequirement('Includes at least one number'),
                _buildPasswordRequirement('Includes at least one special character'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PrimaryButton(
            text: 'Save Changes',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _saveChanges();
              }
            },
          ),
        ],
      ),
    );
  }

  void _saveChanges() {
    if (_tabController.index == 0) {
      // Save personal info
      final updatedEmployee = Employee(
        id: _employee.id,
        email: _employee.email,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        middleName: _middleNameController.text.trim().isNotEmpty
            ? _middleNameController.text.trim()
            : null,
        phoneNumber: _phoneNumberController.text.trim().isNotEmpty
            ? _phoneNumberController.text.trim()
            : null,
        address: _addressController.text.trim().isNotEmpty
            ? _addressController.text.trim()
            : null,
        department: _employee.department,
        position: _employee.position,
        employmentType: _employee.employmentType,
        hireDate: _employee.hireDate,
        accountStatus: _employee.accountStatus,
      );

      // TODO: Save updated employee to backend
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, updatedEmployee);

    } else {
      // Change password
      // TODO: Implement password change API call
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password changed successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear password fields
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();

      // Switch back to personal info tab
      _tabController.animateTo(0);
    }
  }

  Widget _buildPasswordRequirement(String requirement) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            size: 16,
            color: Colors.green,
          ),
          const SizedBox(width: 8),
          Text(
            requirement,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}