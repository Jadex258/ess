import 'package:ess/main.dart';
import 'package:ess/models/employee.dart';
import 'package:ess/provider/employee_provider.dart';
import 'package:ess/screens/authentication/login.dart';
import 'package:ess/screens/profile/edit_profile.dart';
import 'package:ess/services/firebase_auth_service.dart';
import 'package:ess/widgets/app_bar.dart';
import 'package:ess/widgets/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

class ViewProfileScreen extends StatelessWidget {
  const ViewProfileScreen({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logging out...'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
      await Future.delayed(const Duration(milliseconds: 500));
      await FirebaseAuthService.logout();
      navigatorKey.currentState?.pushAndRemoveUntil( CupertinoPageRoute(builder: (_) => const LoginScreen()), (route) => false, );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: const Color(0xFFE90000),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Profile',
        trailing: IconButton(
          icon: const Icon(Icons.edit, size: 26, color: Color(0xFF2896FD)),
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
            children: [
              Selector<EmployeeProvider, Employee?>(
                selector: (_, provider) => provider.employee,
                builder: (_, employee, __) {
                  if (employee == null) {
                    return  EmptyWidget(
                      buttonText: 'Logout',
                      title: "Employee profile not found.",
                      onRetry: () => _handleLogout(context),
                    );
                  }
                  String initials = '';
                  if (employee.firstName.isNotEmpty) initials += employee.firstName[0];
                  if (employee.lastName.isNotEmpty) initials += employee.lastName[0];
                  final hireYear = employee.hireDate.year.toString();
                  final formattedHireDate = DateFormat('MMMM d, yyyy').format(employee.hireDate);
                  return Column(
                    children: [
                      employee.profilePictureUrl != null && employee.profilePictureUrl!.isNotEmpty
                          ? Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF2896FD), width: 2),
                        ),
                        child: ClipOval(
                          child: InstaImageViewer(
                            child: CachedNetworkImage(
                              imageUrl: employee.profilePictureUrl!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          ),
                        ),
                      )
                          : Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2896FD).withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF2896FD), width: 2),
                        ),
                        child: Center(
                          child: Text(
                            initials.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        employee.firstName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        employee.position,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildInfoChip(employee.department),
                          const SizedBox(width: 12),
                          _buildInfoChip(employee.employmentType.label),
                          const SizedBox(width: 12),
                          _buildInfoChip('Joined $hireYear'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(label: 'Employee ID', value: employee.employeeId),
                      const SizedBox(height: 8),
                      _buildInfoCard(label: 'Full name', value: employee.fullName),
                      const SizedBox(height: 8),
                      _buildInfoCard(label: 'Address', value: employee.address ?? 'Not provided'),
                      const SizedBox(height: 8),
                      _buildInfoCard(label: 'Email Address', value: employee.email),
                      const SizedBox(height: 8),
                      _buildInfoCard(label: 'Contact Number', value: employee.phoneNumber ?? 'Not provided'),
                      const SizedBox(height: 8),
                      _buildInfoCard(label: 'Department', value: employee.department),
                      const SizedBox(height: 8),
                      _buildInfoCard(label: 'Position', value: employee.position),
                      const SizedBox(height: 8),
                      _buildInfoCard(label: 'Hire Date', value: formattedHireDate),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: ()=> _handleLogout(context),
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
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String label, required String value}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              )),
          Text(value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              )),
        ],
      ),
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
