import 'package:ess/enums/account_enum.dart';
import 'package:ess/main.dart';
import 'package:ess/screens/authentication/reset_password.dart';
import 'package:ess/screens/authentication/setup_account.dart';
import 'package:ess/services/employee_service.dart';
import 'package:ess/services/firebase_auth_service.dart';
import 'package:ess/widgets/bottom_navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ess/components/textformfield.dart';
import 'package:ess/components/button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _authError;
  bool _isLoading = false;

  @override
  void initState() {
    _emailController.addListener(() {
      if (_authError != null) {
        setState(() => _authError = null);
      }
    });
    _passwordController.addListener(() {
      if (_authError != null) {
        setState(() => _authError = null);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      FocusScope.of(context).unfocus();

      try {
        final input = _emailController.text.trim();
        String emailToUse = input;

        if (!input.contains('@')) {
          emailToUse = await EmployeeService.getEmailByEmployeeId(input);
        }
        await FirebaseAuthService.login(emailToUse, _passwordController.text);
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AuthChecker()),
        );
      } catch (e) {
        if (e.toString().contains('auth credential is incorrect') ||
            e.toString().contains('invalid-credential') ||
            e.toString().contains('wrong-password') ||
            e.toString().contains('user-not-found')) {
          setState(() {
            _authError = 'Invalid email/employee ID or password';
          });
          _formKey.currentState!.validate();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString().replaceAll('Exception: ', '')),
              backgroundColor: const Color(0xFFE90000),
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                spacing: 24,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildHeader(),
                  _buildLoginForm(),
                  _buildLoginButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildHeader() {
    return Column(
      children: [
        SizedBox(
          width: 140,
          height: 140,
          child: Image.asset(
            'assets/images/cenixys_ess_logo.png',
            fit: BoxFit.contain,
          ),
        ),
        Text(
          "Please enter your credentials",
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        CustomTextField(
          controller: _emailController,
          label: 'Email / Employee ID',
          hint: 'Enter your email or employee ID',
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email or employee ID';
            }
            if (_authError != null) return _authError;
            return null;
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _passwordController,
          label: 'Password',
          hint: 'Enter your password',
          isPassword: true,
          textInputAction: TextInputAction.done,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 8) {
              return 'Password must be at least 8 characters';
            }
            if (_authError != null) return _authError;
            return null;
          },
        ),
        const SizedBox(height: 8),
        _buildForgotPassword(),
      ],
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => const ResetPasswordScreen(),
            ),
          );
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          "Forgot password?",
          style: TextStyle(
            fontSize: 14,
            color: const Color(0xFF2896FD),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return PrimaryButton(
      text: 'LOGIN',
      isLoading: _isLoading,
      onPressed: _handleLogin,
    );
  }
}