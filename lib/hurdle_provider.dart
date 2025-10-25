import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:english_words/english_words.dart' as words; // import s aliasom
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'wordle.dart';

// Enum pre stav hry
enum GameStatus { playing, won, lost }

class HurdleProvider extends ChangeNotifier {
  // Generátor náhodných čísel (pre výber cieľového slova)
  final random = Random.secure();

  // Zoznam všetkých slov dĺžky 5 znakov
  List<String> totalWords = [];

  // Dočasné vstupy používateľa (aktuálny riadok v mriežke)
  List<String> rowInputs = [];

  // Zoznam vyradených písmen (písmená, ktoré nie sú v cieľovom slove)
  List<String> excludedLetters = [];

  // Herný panel – obsahuje 30 prvkov typu Wordle (6 riadkov × 5 písmen)
  List<Wordle> hurdleBoard = [];

  // Cieľové (náhodne vybrané) slovo
  String targetWord = '';

  // Getter pre target (pre jednoduchší prístup)
  String get target => targetWord.toLowerCase();

  // Herná logika
  int count = 0;
  int index = 0; // sleduje pozíciu v mriežke
  int currentRow = 0; // aktuálny riadok (0-5)
  final int lettersPerRow = 5;
  final int maxRows = 6;
  final int totalAttempts = 6;
  int attempts = 0;

  // Stav hry
  GameStatus gameStatus = GameStatus.playing;

  init() {
    // Získame všetky slová z balíčka english_words a vyfiltrujeme len tie, ktoré majú 5 znakov
    totalWords = words.all.where((element) => element.length == 5).toList();

    // Vygenerujeme herný panel (30 prázdnych políčok)
    generateBoard();

    // Vyberieme náhodné cieľové slovo
    generateRandomWord();
  }

  // ------------------------- GENEROVANIE MRIEŽKY -------------------------
  generateBoard() {
    hurdleBoard = List.generate(30, (index) => Wordle(letter: ''));
  }

  // ------------------------- GENEROVANIE CIEĽOVÉHO SLOVA -------------------------
  generateRandomWord() {
    // Získame cieľové slovo a uložíme ho vo veľkých písmenách
    targetWord = totalWords[random.nextInt(totalWords.length)].toUpperCase();
    print('🎯 CORRECT ANSWER FOR TESTING: $targetWord');
  }

  // ------------------------- VSTUP PÍSMEN -------------------------
  // Pridanie písmena do aktuálneho vstupu
  void inputLetter(String letter) {
    if (count < lettersPerRow) {
      // pridanie písmena do zoznamu aktuálneho vstupu
      rowInputs.add(letter);

      // vloženie písmena do príslušnej pozície v hernej doske
      hurdleBoard[index] = Wordle(letter: letter);

      // inkrementácia počítadiel
      count++;
      index++;

      // aktualizácia UI
      notifyListeners();
    }
  }

  // Vymazanie posledného písmena
  void deleteLetter() {
    if (count > 0) {
      // odstránenie posledného písmena z aktuálneho vstupu
      rowInputs.removeLast();

      // dekrementácia počítadiel
      count--;
      index--;

      // vymazanie písmena z hernej dosky
      hurdleBoard[index] = Wordle(letter: "");

      // aktualizácia UI
      notifyListeners();
    }
  }

  // Potvrdenie slova a pokračovanie na ďalší riadok
  bool submitWord() {
    if (count == lettersPerRow) {
      // kontrola, či je slovo platné
      if (!isValidWord) {
        return false; // slovo nie je platné
      }

      // získanie aktuálneho slova
      String currentWord = rowInputs.join().toLowerCase();

      // kontrola, či slovo existuje v cieľovom slove
      checkWord(currentWord);

      // prechod na ďalší riadok
      nextRow();

      // kontrola ukončenia hry
      checkGameEnd();

      return true; // slovo je platné a bolo spracované
    }
    return false; // nedostatok písmen
  }

  // Kontrola písmen v slove
  void checkWord(String inputWord) {
    for (int i = 0; i < lettersPerRow; i++) {
      int currentIndex = (currentRow * lettersPerRow) + i;
      String currentLetter = inputWord[i];

      if (target[i] == currentLetter) {
        // písmeno je na správnom mieste
        hurdleBoard[currentIndex] = Wordle(
          letter: currentLetter.toUpperCase(),
          existsInTarget: true,
        );
      } else if (target.contains(currentLetter)) {
        // písmeno existuje v slove, ale na zlom mieste
        hurdleBoard[currentIndex] = Wordle(
          letter: currentLetter.toUpperCase(),
          existsInTarget: true,
          doesNotExistInTarget: false,
        );
        // pridanie do zoznamu vylúčených písmen
        if (!excludedLetters.contains(currentLetter.toUpperCase())) {
          excludedLetters.add(currentLetter.toUpperCase());
        }
      } else {
        // písmeno neexistuje v slove
        hurdleBoard[currentIndex] = Wordle(
          letter: currentLetter.toUpperCase(),
          existsInTarget: false,
          doesNotExistInTarget: true,
        );
        // pridanie do zoznamu vylúčených písmen
        if (!excludedLetters.contains(currentLetter.toUpperCase())) {
          excludedLetters.add(currentLetter.toUpperCase());
        }
      }
    }
  }

  // Prechod na ďalší riadok
  void nextRow() {
    currentRow++;
    count = 0;
    rowInputs.clear();
    notifyListeners();
  }

  // Kontrola ukončenia hry
  void checkGameEnd() {
    // kontrola výhry
    String currentWord = "";
    for (
      int i = (currentRow - 1) * lettersPerRow;
      i < currentRow * lettersPerRow;
      i++
    ) {
      currentWord += hurdleBoard[i].letter.toLowerCase();
    }

    if (currentWord == target) {
      // víťazstvo
      gameStatus = GameStatus.won;
      EasyLoading.showSuccess(
        'Gratulujeme! Uhádli ste slovo: ${target.toUpperCase()}',
      );
    } else if (currentRow >= maxRows) {
      // prehra
      gameStatus = GameStatus.lost;
      EasyLoading.showError(
        'Hra skončená! Slovo bolo: ${target.toUpperCase()}',
      );
    }

    notifyListeners();
  }

  // Getter pre validáciu slova
  bool get isValidWord => totalWords.contains(rowInputs.join('').toLowerCase());

  // Getter pre kontrolu dĺžky slova
  bool get shouldCheckForAnswer => rowInputs.length == lettersPerRow;

  // Premenná pre výhru
  bool wins = false;

  // Vyhodnotenie odpovede
  void checkAnswer() {
    final input = rowInputs.join('').toUpperCase();
    if (targetWord == input) {
      wins = true;
    } else {
      _markLettersOnBoard();
      if (attempts < totalAttempts) {
        _goToNextRow();
      }
    }
  }

  // Označenie písmen na hernej doske
  void _markLettersOnBoard() {
    for (int i = 0; i < hurdleBoard.length; i++) {
      if (hurdleBoard[i].letter.isNotEmpty &&
          targetWord.contains(hurdleBoard[i].letter)) {
        hurdleBoard[i].existsInTarget = true;
      } else if (hurdleBoard[i].letter.isNotEmpty &&
          !targetWord.contains(hurdleBoard[i].letter)) {
        hurdleBoard[i].doesNotExistInTarget = true;
        if (!excludedLetters.contains(hurdleBoard[i].letter)) {
          excludedLetters.add(hurdleBoard[i].letter);
        }
      }
    }
    notifyListeners();
  }

  // Prechod na ďalší riadok
  void _goToNextRow() {
    attempts++;
    count = 0;
    index =
        attempts *
        lettersPerRow; // nastavenie indexu na začiatok ďalšieho riadku
    rowInputs.clear();
    notifyListeners();
  }

  // Resetovanie hry
  void resetGame() {
    // vyčistenie všetkých premenných
    count = 0;
    index = 0;
    currentRow = 0;
    attempts = 0;
    wins = false;
    rowInputs.clear();
    excludedLetters.clear();
    gameStatus = GameStatus.playing;

    // nové cieľové slovo
    generateRandomWord();

    // nová herná doska
    generateBoard();

    print('🔄 GAME RESET - New target word: $targetWord');
    notifyListeners();
  }

  // Getters pre UI
  bool get isGameOver =>
      gameStatus != GameStatus.playing || wins || attempts >= totalAttempts;
  bool get hasWon => gameStatus == GameStatus.won || wins;
  bool get hasLost =>
      gameStatus == GameStatus.lost || attempts >= totalAttempts;
}
