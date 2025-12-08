import 'package:ess/components/button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyWidget extends StatelessWidget {
  final String title;
  final Widget? child;
  final String? subtitle;
  final double size;
  final VoidCallback? onRetry;
  final String buttonText;

  const EmptyWidget({
    super.key,
    required this.title,
    this.child,
    this.subtitle,
    this.size = 200,
    this.onRetry,
    this.buttonText = 'Try Again',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/empty.json',
              width: size,
              height: size,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
            if (child != null) ...[
              const SizedBox(height: 20),
              child!,
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: 150,
                child: SecondaryButton(
                  text: buttonText,
                  onPressed: onRetry,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}