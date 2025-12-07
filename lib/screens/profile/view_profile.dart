import 'package:ess/enums/account_enum.dart';
import 'package:ess/models/employee.dart';
import 'package:ess/screens/profile/edit_profile.dart';
import 'package:ess/widgets/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class ViewProfileScreen extends StatelessWidget {
  const ViewProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Create dummy Employee object
    final dummyEmployee = Employee(
      id: 'EMP001',
      email: 'johndoe@company.com',
      firstName: 'John',
      lastName: 'Doe',
      middleName: 'Michael',
      phoneNumber: '+1 (555) 123-4567',
      address: '123 Main Street, Ormoc City, Leyte 6541',
      department: 'Engineering',
      employmentType: EmploymentType.fullTime,
      position: 'Senior UI/UX Designer',
      hireDate: DateTime(2024, 1, 15), // January 15, 2024
      accountStatus: AccountStatus.active,
    );

    // Format hire date
    String hireYear = dummyEmployee.hireDate.year.toString();
    String formattedHireDate = DateFormat('MMMM d, yyyy').format(dummyEmployee.hireDate);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Profile',
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            pushWithoutNavBar(
              context,
              CupertinoPageRoute(
                builder: (context) => const EditProfileScreen(),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            spacing: 16,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.grey[400],
                ),
              ),
              Column(
                children: [
                  Text(
                    dummyEmployee.fullName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    dummyEmployee.position,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildInfoChip(dummyEmployee.department),
                  const SizedBox(width: 12),
                  _buildInfoChip(dummyEmployee.employmentType.label),
                  const SizedBox(width: 12),
                  _buildInfoChip('Joined $hireYear'),
                ],
              ),
              Column(
                spacing: 16,
                children: [
                  _buildInfoCard(
                      label: 'Address',
                      value: dummyEmployee.address ?? 'Not provided'
                  ),
                  _buildInfoCard(
                      label: 'Email Address',
                      value: dummyEmployee.email
                  ),
                  _buildInfoCard(
                      label: 'Contact Number',
                      value: dummyEmployee.phoneNumber ?? 'Not provided'
                  ),
                  _buildInfoCard(
                      label: 'Department',
                      value: dummyEmployee.department
                  ),
                  _buildInfoCard(
                      label: 'Position',
                      value: dummyEmployee.position
                  ),
                  _buildInfoCard(
                      label: 'Hire Date',
                      value: formattedHireDate
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle logout
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF8A80),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String label,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF2896FD).withOpacity(0.1),
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

  Color _getStatusColor(AccountStatus status) {
    switch (status) {
      case AccountStatus.active:
        return Colors.green;
      case AccountStatus.suspended:
        return Colors.red;
      case AccountStatus.pendingSetup:
        return Colors.blue;
      default:
        return Colors.black;
    }
  }
}