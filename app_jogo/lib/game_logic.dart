import 'dart:math';

class GameLogic {
  List<String> words4Letters = [
    "CASA", "RODA", "DADO", "BOLA"
    // Adicione mais palavras de 4 letras
  ];

  List<String> words5Letters = [
    "BARCO", "CARRO", "ROSAS", "ABRIL"
    // Adicione mais palavras de 5 letras
  ];

  // Adicione mais listas conforme necessário para níveis mais altos

  List<String> getWordsForLevel(int level, int numberOfWords) {
    List<String> wordList;
    switch (level) {
      case 1:
        wordList = words4Letters;
        break;
      case 2:
        wordList = words5Letters;
        break;
      // Adicione mais casos conforme necessário
      default:
        wordList = []; // Caso de erro ou nível não definido
    }

    Random random = Random();
    List<String> selectedWords = [];

    while (selectedWords.length < numberOfWords && wordList.isNotEmpty) {
      String word = wordList[random.nextInt(wordList.length)];
      if (!selectedWords.contains(word)) {
        selectedWords.add(word);
      }
    }

    return selectedWords;
  }

  bool isNextLevelAvailable(
      int level, int wordsGuessedCorrectly, int totalWords) {
    int majority = (totalWords / 2).ceil();
    return wordsGuessedCorrectly >= majority;
  }
}
