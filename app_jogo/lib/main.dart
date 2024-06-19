import 'package:flutter/material.dart';
import 'start_page.dart';
import 'game_page.dart';
import 'game_logic.dart';
import 'progress_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo de Termo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple),
          bodyLarge: TextStyle(fontSize: 18, color: Colors.deepPurple),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle: const TextStyle(fontSize: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
      home: const StartPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int wordsGuessedCorrectlyLevel1 = 0;
  int wordsGuessedCorrectlyLevel2 = 0;
  int wordsGuessedCorrectlyLevel3 = 0;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    wordsGuessedCorrectlyLevel1 = await ProgressManager.loadProgress(1);
    wordsGuessedCorrectlyLevel2 = await ProgressManager.loadProgress(2);
    wordsGuessedCorrectlyLevel3 = await ProgressManager.loadProgress(3);
    setState(() {});
  }

  void updateWordsGuessedCorrectlyLevel1(int count) {
    setState(() {
      wordsGuessedCorrectlyLevel1 = count;
    });
    ProgressManager.saveProgress(1, count);
  }

  void updateWordsGuessedCorrectlyLevel2(int count) {
    setState(() {
      wordsGuessedCorrectlyLevel2 = count;
    });
    ProgressManager.saveProgress(2, count);
  }

  void updateWordsGuessedCorrectlyLevel3(int count) {
    setState(() {
      wordsGuessedCorrectlyLevel3 = count;
    });
    ProgressManager.saveProgress(3, count);
  }

  void _showLevelCompletedDialog(int level) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Nível $level Completo'),
          content: Text('Você já completou este nível. Tente o próximo!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool level2Available =
        GameLogic().isNextLevelAvailable(1, wordsGuessedCorrectlyLevel1, 3);
    bool level3Available =
        GameLogic().isNextLevelAvailable(2, wordsGuessedCorrectlyLevel2, 3);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const StartPage()),
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                if (wordsGuessedCorrectlyLevel1 >= 5) {
                  _showLevelCompletedDialog(1);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GamePage(
                        level: 1,
                        onWordsGuessedCorrectlyUpdated:
                            updateWordsGuessedCorrectlyLevel1,
                        wordsGuessedCorrectly: wordsGuessedCorrectlyLevel1,
                      ),
                    ),
                  );
                }
              },
              child: const Text('Nível 1'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: level2Available
                  ? () {
                      if (wordsGuessedCorrectlyLevel2 >= 5) {
                        _showLevelCompletedDialog(2);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GamePage(
                              level: 2,
                              onWordsGuessedCorrectlyUpdated:
                                  updateWordsGuessedCorrectlyLevel2,
                              wordsGuessedCorrectly:
                                  wordsGuessedCorrectlyLevel2,
                            ),
                          ),
                        );
                      }
                    }
                  : null,
              child: const Text('Nível 2'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: level3Available
                  ? () {
                      if (wordsGuessedCorrectlyLevel3 >= 5) {
                        _showLevelCompletedDialog(3);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GamePage(
                              level: 3,
                              onWordsGuessedCorrectlyUpdated:
                                  updateWordsGuessedCorrectlyLevel3,
                              wordsGuessedCorrectly:
                                  wordsGuessedCorrectlyLevel3,
                            ),
                          ),
                        );
                      }
                    }
                  : null,
              child: const Text('Nível 3'),
            ),
          ],
        ),
      ),
    );
  }
}
