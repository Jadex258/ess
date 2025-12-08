import 'package:ess/services/firebase_auth_service.dart';
import 'package:ess/services/employee_service.dart';
import 'package:flutter/material.dart';
import 'package:ess/components/textformfield.dart';
import 'package:ess/components/button.dart';
import 'package:ess/widgets/app_bar.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      FocusScope.of(context).unfocus();

      try {
        final input = _emailController.text.trim();
        String emailToUse = input;
        if (!input.contains('@')) {
          emailToUse = await EmployeeService.getEmailByEmployeeId(input);
        }
        await FirebaseAuthService.sendPasswordResetEmail(emailToUse);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset link sent to your email'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: const Color(0xFFE90000),
          ),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Reset Password'),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            spacing: 24,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter your email or employee ID to reset your password",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              CustomTextField(
                controller: _emailController,
                label: 'Email / Employee ID',
                hint: 'Enter your email or employee ID',
                textInputAction: TextInputAction.done,
                autofocus: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email or employee ID';
                  }
                  return null;
                },
              ),
              PrimaryButton(
                text: 'CONTINUE',
                isLoading: _isLoading,
                onPressed: _handleResetPassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}