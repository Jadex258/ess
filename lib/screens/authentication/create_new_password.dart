import 'package:flutter/material.dart';

class Create_New_Password extends StatelessWidget {
  const Create_New_Password({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: (){
                Navigator.pop(context);

              },
              child: const Text(
                "<", style: TextStyle(fontSize: 42, fontWeight: FontWeight.w300),
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              "Create new password",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
            ),

            const SizedBox(height: 20),

            _textField("New password"),
            const SizedBox(height: 16),
            _textField("Confirm password"),

            const SizedBox(height: 24),

            _button("Save password"),
          ],
        ),
      ),
    );
  }

  Widget _textField(String hint) {
    return TextField(
      obscureText: true,
      textAlignVertical: TextAlignVertical.top,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
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
        child: Text(text, style: const TextStyle(fontSize: 16, color: Colors.white,)),
      ),
    );
  }
}
