import 'package:flutter/material.dart';
import 'start_page.dart'; // Adicione a importação da nova página
import 'game_page.dart';
import 'game_logic.dart';

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
      home: const StartPage(), // Altere para StartPage
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

  void updateWordsGuessedCorrectly(int count) {
    setState(() {
      wordsGuessedCorrectlyLevel1 = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool level2Available =
        GameLogic().isNextLevelAvailable(1, wordsGuessedCorrectlyLevel1, 4);

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
                          updateWordsGuessedCorrectly,
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
                            onWordsGuessedCorrectlyUpdated: (int count) {},
                          ),
                        ),
                      );
                    }
                  : null,
              child: const Text('Nível 2'),
            ),
            // Adicionar mais botões de níveis conforme necessário
          ],
        ),
      ),
    );
  }
}
