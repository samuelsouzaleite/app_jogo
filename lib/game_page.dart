import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'game_logic.dart';
import 'progress_manager.dart';

class GamePage extends StatefulWidget {
  final int level;
  final Function(int) onWordsGuessedCorrectlyUpdated;
  final int wordsGuessedCorrectly;

  GamePage({
    required this.level,
    required this.onWordsGuessedCorrectlyUpdated,
    required this.wordsGuessedCorrectly,
  });

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage>
    with SingleTickerProviderStateMixin {
  late List<String> wordsForLevel;
  late int currentWordIndex;
  late String currentWord;
  late String currentGuess;
  late List<String> guessedWords;
  late int wordsGuessedCorrectly;
  late int lives;
  final int maxLives = 5;
  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();
  GameLogic gameLogic = GameLogic();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    int numberOfWords =
        5; // Defina o número de palavras necessárias para o nível
    wordsForLevel = gameLogic.getWordsForLevel(widget.level, numberOfWords);
    currentWordIndex = widget.wordsGuessedCorrectly;
    currentWord = wordsForLevel[currentWordIndex];
    currentGuess = '';
    guessedWords = [];
    wordsGuessedCorrectly = widget.wordsGuessedCorrectly;
    lives = maxLives;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void resetLevel() {
    setState(() {
      wordsForLevel = gameLogic.getWordsForLevel(widget.level, 5);
      currentWordIndex = 0;
      currentWord = wordsForLevel[currentWordIndex];
      currentGuess = '';
      guessedWords = [];
      wordsGuessedCorrectly = 0;
      lives = maxLives;
      widget.onWordsGuessedCorrectlyUpdated(0);
    });
  }

  void handleGuess(String guess) {
    setState(() {
      guessedWords.add(guess);
      if (guess == currentWord) {
        wordsGuessedCorrectly++;
        widget.onWordsGuessedCorrectlyUpdated(wordsGuessedCorrectly);
        lives = maxLives; // Restaurar vidas ao valor máximo
        ProgressManager.saveProgress(widget.level, wordsGuessedCorrectly);
        if (currentWordIndex < wordsForLevel.length - 1) {
          _animationController.forward(from: 0.0).then((_) {
            setState(() {
              currentWordIndex++;
              currentWord = wordsForLevel[currentWordIndex];
              guessedWords.clear();
              _controller.clear();
              currentGuess = '';
            });
          });
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Parabéns!',
                    style: TextStyle(color: Colors.deepPurple)),
                content: Text('Você completou todas as palavras deste nível!',
                    style: TextStyle(color: Colors.deepPurple)),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child:
                        Text('OK', style: TextStyle(color: Colors.deepPurple)),
                  ),
                ],
              );
            },
          );
        }
      } else {
        lives--;
        if (lives <= 0) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Game Over',
                    style: TextStyle(color: Colors.deepPurple)),
                content: Text('Você perdeu todas as suas vidas!',
                    style: TextStyle(color: Colors.deepPurple)),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      resetLevel(); // Reiniciar o nível
                    },
                    child:
                        Text('OK', style: TextStyle(color: Colors.deepPurple)),
                  ),
                ],
              );
            },
          );
        }
      }
    });
  }

  Color _getBoxColor(String char, int position) {
    if (currentWord[position] == char) {
      return Colors.green;
    } else if (currentWord.contains(char)) {
      return Colors.yellow;
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    int maxLength = currentWord.length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Cor de fundo branca para o AppBar
        elevation: 0, // Remove a sombra do AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Colors.deepPurple), // Ícone de volta na cor roxa
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Nível ${widget.level}',
          style: TextStyle(color: Colors.deepPurple), // Cor do título roxa
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Indicador de progresso visual
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomPaint(
                painter: ProgressPainter(
                  currentWordIndex: currentWordIndex,
                  totalWords: wordsForLevel.length,
                  animation: _animationController,
                  color: Colors.deepPurple, // Defina a cor roxa
                ),
                child: const SizedBox(
                  width: double.infinity,
                  height: 50,
                ),
              ),
            ),
            // Mostrar palavras adivinhadas
            for (var guess in guessedWords)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: guess.split('').asMap().entries.map((entry) {
                  int idx = entry.key;
                  String char = entry.value;
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: _getBoxColor(char, idx),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      char,
                      style: const TextStyle(
                          fontSize: 24, color: Colors.black), // Texto preto
                    ),
                  );
                }).toList(),
              ),
            // Mostrar caixas vazias para a palavra atual
            GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(_focusNode);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(currentWord.length, (index) {
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      currentGuess.length > index ? currentGuess[index] : '',
                      style: const TextStyle(
                          fontSize: 24, color: Colors.black), // Texto preto
                    ),
                  );
                }),
              ),
            ),
            // Campo de entrada de texto oculto
            TextField(
              focusNode: _focusNode,
              controller: _controller,
              inputFormatters: [
                UpperCaseTextFormatter(),
                LengthLimitingTextInputFormatter(maxLength),
              ],
              onChanged: (value) {
                setState(() {
                  currentGuess = value.toUpperCase();
                });
              },
              onSubmitted: (value) {
                if (value.length == currentWord.length) {
                  handleGuess(value.toUpperCase());
                  setState(() {
                    currentGuess = '';
                    _controller.clear();
                  });
                }
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
              style: const TextStyle(
                color: Colors.transparent,
                height: 0,
              ),
              cursorColor: Colors.transparent,
              autofocus: true,
            ),
            // Barra de vida
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10), // Bordas arredondadas
                child: LinearProgressIndicator(
                  value: lives / maxLives,
                  backgroundColor: Colors.red[200],
                  color: Colors.red,
                  minHeight: 20,
                ),
              ),
            ),
            // Botão de adivinhação
            ElevatedButton(
              onPressed: () {
                if (currentGuess.length == currentWord.length) {
                  handleGuess(currentGuess);
                  setState(() {
                    currentGuess = '';
                    _controller.clear();
                  });
                }
              },
              child: const Text('Adivinhar'),
            ),
          ],
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class ProgressPainter extends CustomPainter {
  final int currentWordIndex;
  final int totalWords;
  final Animation<double> animation;
  final Color color;

  ProgressPainter(
      {required this.currentWordIndex,
      required this.totalWords,
      required this.animation,
      required this.color})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    double margin = 16.0;
    double spacing = (size.width - 2 * margin) / (totalWords - 1);
    Paint circlePaint = Paint()..color = Colors.grey;
    Paint linePaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2.0;

    // Desenhar todas as linhas cinzas primeiro
    for (int i = 0; i < totalWords - 1; i++) {
      canvas.drawLine(
        Offset(margin + i * spacing, size.height / 2),
        Offset(margin + (i + 1) * spacing, size.height / 2),
        linePaint,
      );
    }

    // Desenhar todos os círculos cinzas primeiro
    for (int i = 0; i < totalWords; i++) {
      canvas.drawCircle(
        Offset(margin + i * spacing, size.height / 2),
        10,
        circlePaint,
      );
    }

    Paint filledCirclePaint = Paint()..color = color;
    Paint filledLinePaint = Paint()
      ..color = color
      ..strokeWidth = 2.0;

    // Desenhar as linhas roxas até a palavra atual
    for (int i = 0; i < currentWordIndex; i++) {
      canvas.drawLine(
        Offset(margin + i * spacing, size.height / 2),
        Offset(margin + (i + 1) * spacing, size.height / 2),
        filledLinePaint,
      );
    }

    // Desenhar os círculos roxos até a palavra atual
    for (int i = 0; i <= currentWordIndex; i++) {
      canvas.drawCircle(
        Offset(margin + i * spacing, size.height / 2),
        10,
        filledCirclePaint,
      );
    }

    // Animar a linha para a próxima palavra
    if (currentWordIndex < totalWords - 1 &&
        animation.value > 0.0 &&
        animation.value < 1.0) {
      double progress = animation.value;
      double startX = margin + currentWordIndex * spacing;
      double endX = margin + (currentWordIndex + 1) * spacing;
      double currentX = startX + (endX - startX) * progress;

      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(currentX, size.height / 2),
        filledLinePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
