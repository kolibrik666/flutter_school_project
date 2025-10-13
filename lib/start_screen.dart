import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  final void Function() onStartQuiz;
  const StartScreen({super.key, required this.onStartQuiz});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: onStartQuiz,
          child: const Text('Spustiť kvíz'),
        ),
      ),
    );
  }
}