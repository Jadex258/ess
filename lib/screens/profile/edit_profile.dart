import 'dart:io';
import 'package:ess/components/button.dart';
import 'package:ess/components/textformfield.dart';
import 'package:ess/models/employee.dart';
import 'package:ess/provider/employee_provider.dart';
import 'package:ess/services/employee_service.dart';
import 'package:ess/services/firebase_auth_service.dart';
import 'package:ess/widgets/app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isUploadingImage = false;
  bool _isLoading = false;

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
  String? _authError;

  bool _hasMinLength = false;
  bool _hasSpecialChar = false;
  bool _hasUppercaseLowercase = false;
  bool _hasNumber = false;
  bool _passwordsMatch = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _currentPasswordController.addListener((){
      if (_authError != null) {
        setState(() => _authError = null);
      }
    });
    _newPasswordController.addListener(_checkPasswordRequirements);
    _newPasswordController.addListener(_checkPasswordMatch);
    _confirmPasswordController.addListener(_checkPasswordMatch);

    final employee = context.read<EmployeeProvider>().employee;
    if (employee != null) {
      _firstNameController.text = employee.firstName;
      _lastNameController.text = employee.lastName;
      _middleNameController.text = employee.middleName ?? '';
      _phoneNumberController.text = employee.phoneNumber ?? '';
      _addressController.text = employee.address ?? '';
    }
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

  void _checkPasswordRequirements() {
    final password = _newPasswordController.text;
    setState(() {
      _hasMinLength = password.length >= 8;
      _hasUppercaseLowercase = RegExp(r'(?=.*[a-z])(?=.*[A-Z])').hasMatch(password);
      _hasNumber = RegExp(r'[0-9]').hasMatch(password);
      _hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>_\-\\/\[\];+=]').hasMatch(password);
    });
  }

  void _checkPasswordMatch() {
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;
    setState(() {
      _passwordsMatch = newPassword.isNotEmpty &&
          confirmPassword.isNotEmpty &&
          confirmPassword == newPassword;
    });
  }

  bool get _allRequirementsMet {
    return _hasMinLength && _hasUppercaseLowercase && _hasNumber && _hasSpecialChar &&_passwordsMatch;
  }


  Future<void> _saveChanges(EmployeeProvider employeeProvider, BuildContext context) async {
    setState(() => _isLoading = true);
    if (_tabController.index == 0) {
      final updatedEmployee = employeeProvider.employee?.copyWith(
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
      );

      try {
        await EmployeeService.updateEmployeeProfile(
          firstName: updatedEmployee?.firstName,
          lastName: updatedEmployee?.lastName,
          middleName: updatedEmployee?.middleName,
          phoneNumber: updatedEmployee?.phoneNumber,
          address: updatedEmployee?.address,
        );

        employeeProvider.setEmployee(updatedEmployee!);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context, updatedEmployee);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    } else {
      final currentPassword = _currentPasswordController.text.trim();
      final newPassword = _newPasswordController.text.trim();

      String? currentPasswordError;

      try {
        final user = FirebaseAuthService.currentUser;
        if (user == null) throw Exception('No user logged in');

        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );

        await user.reauthenticateWithCredential(credential);

        await FirebaseAuthService.updatePassword(newPassword);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password changed successfully'),
            backgroundColor: Colors.green,
          ),
        );

        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();

        _tabController.animateTo(0);
      } on FirebaseAuthException catch (e) {
        if (e.toString().contains('credential is incorrect')) {
          currentPasswordError = 'Current password is incorrect';
        } else if (e.toString().contains('weak')) {
          currentPasswordError = 'Password is too weak';
        } else {
          currentPasswordError = e.message ?? 'Failed to change password';
        }
      }
      finally {
        setState(() => _isLoading = false);
      }
      _formKey.currentState!.validate();
      if(currentPasswordError != null) setState(() => _authError = currentPasswordError);
    }
  }

  Future<void> _pickImage(ImageSource source, Employee employee) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() => _isUploadingImage = true);

        final imageFile = File(image.path);
        await EmployeeService.updateProfilePicture(imageFile);

        // Fetch updated employee
        final updatedEmployee = await EmployeeService.getEmployeeProfile();
        context.read<EmployeeProvider>().setEmployee(updatedEmployee);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile picture updated'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update picture: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isUploadingImage = false);
    }
  }

// Add remove method
  Future<void> _removeProfilePicture(Employee employee) async {
    try {
      setState(() => _isUploadingImage = true);

      await EmployeeService.deleteProfilePicture();

      final updatedEmployee = await EmployeeService.getEmployeeProfile();
      context.read<EmployeeProvider>().setEmployee(updatedEmployee);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile picture removed'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to remove picture: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isUploadingImage = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeProvider>(
      builder: (context, employeeProvider, _) {
        final employee = employeeProvider.employee;
        if (employee == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(title: 'Edit Profile'),
          body: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildProfileHeader(employee),
                TabBar(
                  controller: _tabController,
                  labelColor: const Color(0xFF2896FD),
                  unselectedLabelColor: Colors.grey[600],
                  indicatorColor: const Color(0xFF2896FD),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    fontFamily: 'Poppins',
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
          bottomNavigationBar: _buildBottomButtons(employeeProvider),
        );
      },
    );
  }

  Widget _buildProfileHeader(Employee employee) {
    String initials = '';
    if (employee.firstName.isNotEmpty) initials += employee.firstName[0];
    if (employee.lastName.isNotEmpty) initials += employee.lastName[0];

    return Column(
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: () => _showProfilePictureOptions(context, employee),
              child: _isUploadingImage
                  ? Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF2896FD), width: 2),
                ),
                child: const Center(
                  child: SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  ),
                ),
              )
                  : employee.profilePictureUrl != null && employee.profilePictureUrl!.isNotEmpty
                  ? Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF2896FD), width: 2),
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: employee.profilePictureUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
              )
                  : Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF2896FD).withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF2896FD), width: 2),
                ),
                child: Center(
                  child: Text(
                    initials.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => _showProfilePictureOptions(context, employee),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2896FD),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          employee.fullName,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Text(
          employee.position,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
          CustomTextField(
            label: 'First Name',
            controller: _firstNameController,
            prefixIcon: const Icon(Icons.person, size: 20),
            validator: (value) =>
            (value == null || value.isEmpty) ? 'First name is required' : null,
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
            validator: (value) =>
            (value == null || value.isEmpty) ? 'Last name is required' : null,
          ),
          CustomTextField(
            label: 'Phone Number',
            controller: _phoneNumberController,
            prefixIcon: const Icon(Icons.phone, size: 20),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Phone Number is required';
              }
              return null;
            }
          ),
          CustomTextField(
            label: 'Address',
            controller: _addressController,
            prefixIcon: const Icon(Icons.location_on, size: 20),
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Address is required';
              }
              return null;
            }
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
          CustomTextField(
            label: 'Current Password',
            controller: _currentPasswordController,
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your current password';
              }
              if (_authError != null) return _authError;
              return null;
            }
          ),
          CustomTextField(
            label: 'New Password',
            controller: _newPasswordController,
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your new password';
              }
              return null;
            }
          ),
          CustomTextField(
            label: 'Confirm New Password',
            controller: _confirmPasswordController,
            textInputAction: TextInputAction.done,
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your new password';
              }
              return null;
            }
          ),
          _buildPasswordRequirements(),
        ],
      ),
    );
  }

  Widget _buildPasswordRequirements() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
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
          const SizedBox(height: 12),
          _buildRequirementItem('At least 8 characters', _hasMinLength),
          _buildRequirementItem('Uppercase and lowercase letters', _hasUppercaseLowercase),
          _buildRequirementItem('At least one number', _hasNumber),
          _buildRequirementItem('At least one special character', _hasSpecialChar),
          _buildRequirementItem('Passwords match', _passwordsMatch),
        ],
      ),
    );
  }


  Widget _buildRequirementItem(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            size: 18,
            color: isMet ? Colors.green : Colors.grey[400],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: isMet ? Colors.grey[800] : Colors.grey[600],
                fontWeight: isMet ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildBottomButtons(EmployeeProvider employeeProvider) {
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
            isLoading: _isLoading,
            onPressed: () async {
              if (_tabController.index == 1 && !_allRequirementsMet) return;
              if (!_formKey.currentState!.validate()) return;
              await _saveChanges(employeeProvider, context);
            },
          ),
        ],
      ),
    );
  }

  void _showProfilePictureOptions(BuildContext context, Employee employee) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              visualDensity: VisualDensity.compact,
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery, employee);
              },
            ),
            ListTile(
              visualDensity: VisualDensity.compact,
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera, employee);
              },
            ),
            if (employee.profilePictureUrl != null && employee.profilePictureUrl!.isNotEmpty)
              ListTile(
                visualDensity: VisualDensity.compact,
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove Photo', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _removeProfilePicture(employee);
                },
              ),
          ],
        ),
      ),
    );
  }

}
