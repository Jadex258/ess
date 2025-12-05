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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Handle back navigation
          },
        ),
        title: const Text(
          'Profile',
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 15),

              // Qr Code Reminders
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Scan QR code to time in\nand time out',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 20),

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

              const SizedBox(height: 13),

              // Name
              const Text(
                'John Doe',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 20),

              Container(
                width: 280,
                height: 290,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.qr_code_2,
                    size: 250,
                    color: Colors.black,
                  ),
                ),
              ),
              
              const SizedBox(height: 20),

              // Logout Button
              SizedBox(
                width: 250,
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
                    'Attendance Summary',
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

}
