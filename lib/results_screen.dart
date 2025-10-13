import 'package:flutter/material.dart';
import 'data/questions.dart';

class ResultsScreen extends StatelessWidget {
  final List<String> chosenAnswers;
  final void Function() onRestart;

  const ResultsScreen({
    super.key,
    required this.chosenAnswers,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    // Výpočet správnych odpovedí
    int correctCount = 0;
    for (int i = 0; i < chosenAnswers.length; i++) {
      if (chosenAnswers[i] == questions[i].answers[0]) {
        correctCount++;
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Výsledky kvízu',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'Správne odpovede: $correctCount / ${questions.length}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 24),
              // Sumár odpovedí
              ...List.generate(questions.length, (index) {
                final question = questions[index];
                final userAnswer = chosenAnswers[index];
                final correctAnswer = question.answers[0];
                final isCorrect = userAnswer == correctAnswer;
                return Card(
                  color: isCorrect ? Colors.green[100] : Colors.red[100],
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  child: ListTile(
                    title: Text(question.text),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tvoja odpoveď: $userAnswer'),
                        Text('Správna odpoveď: $correctAnswer'),
                      ],
                    ),
                    trailing: Icon(
                      isCorrect ? Icons.check : Icons.close,
                      color: isCorrect ? Colors.green : Colors.red,
                    ),
                  ),
                );
              }),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRestart,
                child: const Text('Reštartovať kvíz'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}