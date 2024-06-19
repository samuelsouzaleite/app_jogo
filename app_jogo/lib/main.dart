import 'package:flutter/material.dart';
import 'start_page.dart';
import 'game_page.dart';
import 'game_logic.dart';
import 'progress_manager.dart'; // Adicione a importação do gerenciador de progresso

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

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    wordsGuessedCorrectlyLevel1 = await ProgressManager.loadProgress(1);
    wordsGuessedCorrectlyLevel2 = await ProgressManager.loadProgress(2);
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

  @override
  Widget build(BuildContext context) {
    bool level2Available =
        GameLogic().isNextLevelAvailable(1, wordsGuessedCorrectlyLevel1, 5);
    bool level3Available =
        GameLogic().isNextLevelAvailable(2, wordsGuessedCorrectlyLevel2, 5);

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
              },
              child: const Text('Nível 1'),
            ),
            ElevatedButton(
              onPressed: level2Available
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GamePage(
                            level: 2,
                            onWordsGuessedCorrectlyUpdated:
                                updateWordsGuessedCorrectlyLevel2,
                            wordsGuessedCorrectly: wordsGuessedCorrectlyLevel2,
                          ),
                        ),
                      );
                    }
                  : null,
              child: const Text('Nível 2'),
            ),
            ElevatedButton(
              onPressed: level3Available
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GamePage(
                            level: 3,
                            onWordsGuessedCorrectlyUpdated: (int count) {},
                            wordsGuessedCorrectly:
                                0, // Ajuste conforme necessário
                          ),
                        ),
                      );
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
