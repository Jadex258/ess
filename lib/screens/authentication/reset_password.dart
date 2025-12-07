import 'package:flutter/material.dart';

class Reset_Password extends StatelessWidget {
  const Reset_Password({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Reset your password",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            const Text(
              "Enter your email / employee ID to reset",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const Text(
              "Your Password",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54
              ),
            ),
            const SizedBox(height: 18, width: 16),

            _textField("Email / employee ID"),

            const SizedBox(height: 24),

            _button("Continue"),
          ],
        ),
      ),
    );
  }

  Widget _textField(String hint) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Colors.black54,
          fontSize: 14.0,
        ),
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
      ),
    );
  }

  Widget _button(String text) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff2196F3),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        onPressed: () {},
        child: Text(text, style: const TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }
}
