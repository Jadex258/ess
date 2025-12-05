import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 43,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Handle back navigation
          },
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 15),

              // Profile Picture
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person, size: 40, color: Colors.grey[400]),
              ),

              const SizedBox(height: 16),

              // Name
              const Text(
                'John Doe',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 20),

              // Part time and UI/UX Designer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildInfoChip('Part time'),
                  const SizedBox(width: 12),
                  _buildInfoChip('UI/UX Designer'),
                  const SizedBox(width: 12),
                  _buildInfoChip('Joined 2024'),
                ],
              ),

              const SizedBox(height: 16),

              // Address
              _buildInfoCard(label: 'Address', value: 'Ormoc City, Leyte'),

              const SizedBox(height: 16),

              // Birthdate
              _buildInfoCard(label: 'Birthdate', value: 'December 25, 2025'),

              const SizedBox(height: 16),

              // Email Address
              _buildInfoCard(
                label: 'Email Address',
                value: 'johndoe@gmail.com',
              ),

              const SizedBox(height: 16),

              // Contact Number
              _buildInfoCard(label: 'Contact Number', value: '0912 3456 789'),

              const SizedBox(height: 25),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Change Password',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              
              const SizedBox(height: 16),

              _changePasswordCard(label: 'Old password', placeholder: 'Enter current password',
              ),

              const SizedBox(height: 16),

              // Birthdate
              _changePasswordCard(label: 'New password', placeholder: 'Enter new password',
              ),

              const SizedBox(height: 16),

              // Email Address
              _changePasswordCard(label: 'Confirm password', placeholder: 'Re-enter new password',
              ),

              const SizedBox(height: 16),

              // Logout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle logout
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2896FD),
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

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String label, required String value}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
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
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              hintText: value,
              hintStyle: TextStyle(color: Colors.black, fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _changePasswordCard({required String label, required String placeholder}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
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
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: TextStyle(color: Colors.black, fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
