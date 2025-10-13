import '../models/quiz_question.dart';

const questions = [
    QuizQuestion(
    'Aký je hlavný jazyk Flutteru?',
    ['Dart', 'Java', 'Kotlin', 'Swift'],
  ),
  QuizQuestion(
    'Ktorý widget je bezstavový?',
    ['StatelessWidget', 'StatefulWidget', 'Container', 'Scaffold'],
  ),
  QuizQuestion(
    'Čo robí setState() vo Flutteri?',
    [
      'Aktualizuje stav a prekreslí widget',
      'Zastaví aplikáciu',
      'Spustí animáciu',
      'Odstráni widget zo stromu'
    ],
  ),
  QuizQuestion(
    'Ktorý príkaz sa používa na vytvorenie nového Flutter projektu?',
    [
      'flutter create projekt',
      'flutter start projekt',
      'flutter new projekt',
      'flutter init projekt'
    ],
  ),
  QuizQuestion(
    'Na čo slúži widget Scaffold?',
    [
      'Poskytuje základnú štruktúru obrazovky (AppBar, Body, atď.)',
      'Spravuje stav aplikácie',
      'Renderuje obrázky',
      'Dekóduje JSON dáta'
    ],
  ),
  QuizQuestion(
    'Kto vytvoril jazyk C#?',
    ['Microsoft', 'Google', 'Sun Microsystems', 'Apple'],
  ),
  QuizQuestion(
    'V ktorom prostredí sa najčastejšie používa C#?',
    ['.NET', 'JVM', 'Node.js', 'Android SDK'],
  ),
  QuizQuestion(
    'Aký je správny spôsob deklarácie premennej v C#?',
    ['int cislo = 10;', 'var int = 10;', 'num cislo = 10;', 'let cislo = 10;'],
  ),
  QuizQuestion(
    'Čo znamená kľúčové slovo "static" v C#?',
    [
      'Metóda alebo premenná patrí triede, nie inštancii',
      'Zabráni dedeniu triedy',
      'Uloží hodnotu iba počas behu aplikácie',
      'Vytvorí novú inštanciu triedy'
    ],
  ),
  QuizQuestion(
    'Ktorý dátový typ sa používa pre textové reťazce v C#?',
    ['string', 'char', 'text', 'StringBuilder'],
  ),
  QuizQuestion(
    'Ako sa volá hlavná metóda, ktorá sa spúšťa ako prvá v C# programe?',
    ['Main()', 'Start()', 'Run()', 'Begin()'],
  ),
  QuizQuestion(
    'Ktoré rozšírenie má súbor so zdrojovým kódom C#?',
    ['.cs', '.csharp', '.c#', '.cpp'],
  ),
  QuizQuestion(
    'Čo robí príkaz "using" v C#?',
    [
      'Importuje menné priestory (namespaces)',
      'Vytvára slučku',
      'Definuje rozhranie',
      'Vyvolá výnimku'
    ],
  ),
];