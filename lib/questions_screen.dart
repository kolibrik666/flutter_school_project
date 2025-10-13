import 'package:flutter/material.dart';
import 'data/questions.dart';
import 'answer_button.dart'; // Opravený import


class QuestionsScreen extends StatefulWidget {
  final void Function(String answer) onSelectAnswer;
  const QuestionsScreen({super.key, required this.onSelectAnswer});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  int currentQuestionIndex = 0;

  void answerQuestion(String answer) {
    widget.onSelectAnswer(answer);
    setState(() {
      currentQuestionIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestionIndex];

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(question.text),
            const SizedBox(height: 20),
            ...question.answers.map((answer) => 
              AnswerButton(
                answerText: answer,
                onTap: () => answerQuestion(answer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}