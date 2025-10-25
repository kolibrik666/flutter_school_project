import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hello_world/hurdle_provider.dart';
import 'wordle_view.dart';
import 'keyboard_view.dart';
import 'helper_functions.dart';

class WordHurdlePage extends StatefulWidget {
  const WordHurdlePage({super.key});

  @override
  State<WordHurdlePage> createState() => _WordHurdlePageState();
}

class _WordHurdlePageState extends State<WordHurdlePage> {
  @override
  void didChangeDependencies() {
    // Inicializácia provideru iba raz pri prvej dostupnosti
    Provider.of<HurdleProvider>(context, listen: false).init();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Hurdle'),
        centerTitle: true,
        actions: [
          Consumer<HurdleProvider>(
            builder: (context, provider, child) => IconButton(
              onPressed: () => provider.resetGame(),
              icon: const Icon(Icons.refresh),
              tooltip: 'New Game',
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            // Expanded zabezpečí, že GridView zaberie dostupný priestor
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.70,
                child: Consumer<HurdleProvider>(
                  builder: (context, provider, child) => GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                    ),
                    itemCount: provider.hurdleBoard.length,
                    itemBuilder: (context, index) {
                      final wordle = provider.hurdleBoard[index];
                      return WordleView(wordle: wordle);
                    },
                  ),
                ),
              ),
            ),

            // Keyboard wrapped in Consumer
            Consumer<HurdleProvider>(
              builder: (context, provider, child) => KeyboardView(
                excludedLetters: provider.excludedLetters,
                onPressed: (value) => provider.inputLetter(value),
              ),
            ),

            // Ovládacie tlačidlá DELETE a SUBMIT
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<HurdleProvider>(
                builder: (context, provider, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: provider.count > 0 && !provider.isGameOver
                          ? () => provider.deleteLetter()
                          : null,
                      child: const Text('DELETE'),
                    ),
                    ElevatedButton(
                      onPressed: provider.count == provider.lettersPerRow &&
                              !provider.isGameOver
                          ? () {
                              if (!provider.isValidWord) {
                                showMsg(context, 'Not a word in my dictionary');
                                return;
                              }
                              if (provider.shouldCheckForAnswer) {
                                provider.checkAnswer();

                                if (provider.wins || provider.hasWon) {
                                  showResult(
                                    context: context,
                                    title: 'You Win!!!',
                                    body: 'The word was ${provider.targetWord}',
                                    onPlayAgain: () {
                                      Navigator.of(context).pop();
                                      provider.resetGame();
                                    },
                                    onCancel: () => Navigator.of(context).pop(),
                                  );
                                } else if (provider.hasLost) {
                                  showResult(
                                    context: context,
                                    title: 'Game Over!',
                                    body: 'The word was ${provider.targetWord}',
                                    onPlayAgain: () {
                                      Navigator.of(context).pop();
                                      provider.resetGame();
                                    },
                                    onCancel: () => Navigator.of(context).pop(),
                                  );
                                }
                              }
                            }
                          : null,
                      child: const Text('SUBMIT'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
