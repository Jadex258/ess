import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:math';

class LoadingWidget extends StatelessWidget {
  final String loadingText;
  final bool isRequest;
  final double size;

  static const List<String> _motivationalQuotes = [
    "Success is not final, failure is not fatal: it is the courage to continue that counts.",
    "The only way to do great work is to love what you do.",
    "Don't watch the clock; do what it does. Keep going.",
    "The future depends on what you do today.",
    "It always seems impossible until it's done.",
    "Believe you can and you're halfway there.",
    "Your time is limited, don't waste it living someone else's life.",
    "The harder the battle, the sweeter the victory.",
    "Don't stop when you're tired. Stop when you're done.",
    "Success usually comes to those who are too busy to be looking for it.",
    "The way to get started is to quit talking and begin doing.",
    "Opportunities don't happen. You create them.",
    "The secret of getting ahead is getting started.",
    "Dream big and dare to fail.",
    "It does not matter how slowly you go as long as you do not stop.",
    "Everything you've ever wanted is on the other side of fear.",
    "The only limit to our realization of tomorrow will be our doubts of today.",
    "What you get by achieving your goals is not as important as what you become.",
    "The best time to plant a tree was 20 years ago. The second best time is now.",
    "Your limitation—it's only your imagination.",
  ];

  const LoadingWidget({
    super.key,
    this.loadingText = 'Loading...',
    this.isRequest = false,
    this.size = 120,
  });

  String get _randomQuote {
    final random = Random();
    return _motivationalQuotes[random.nextInt(_motivationalQuotes.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            isRequest
                ? 'assets/animations/request_loading.json'
                : 'assets/animations/main_loading.json',
            width: size,
            height: size,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 20),
          Text(
            loadingText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              _randomQuote,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}