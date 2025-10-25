import 'package:flutter/material.dart';
<<<<<<< Updated upstream
import 'dart:math';

void main() 
{
  runApp(const MyApp());
=======
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'hurdle_provider.dart';
import 'word_hurdle_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => HurdleProvider(),
      child: const MyApp(),
    ),
  );
>>>>>>> Stashed changes
}

class MyApp extends StatelessWidget 
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
<<<<<<< Updated upstream
      title: 'Roll the Dice',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Home Page'),
=======
      title: 'Word Hurdle Puzzle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      builder: EasyLoading.init(),
      home: const WordHurdlePage(),
>>>>>>> Stashed changes
    );
  }
}

class MyHomePage extends StatefulWidget 
{
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> 
{
  int _diceNumber = 1;
  final Random _random = Random();

  void _rollDice() {
    setState(() {
      _diceNumber = _random.nextInt(6) + 1; // 1–6
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roll the Dice'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/dice-$_diceNumber.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _rollDice,
              child: const Text(
                'Hodiť kockou',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}