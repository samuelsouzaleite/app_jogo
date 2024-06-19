import 'dart:math';

class GameLogic {
  List<String> words4Letters = [
    "CASA", "RODA", "DADO", "BOLA", "FITA", "MOLA", "RATO", "GATO", "LAGO",
    "PORT", "PATO", "VIDA", "LAMA", "RAIZ"
    // Adicione mais palavras de 4 letras conforme necessário
  ];

  List<String> words5Letters = [
    "BARCO", "CARRO", "ROSAS", "ABRIL", "CANOE", "LIVRO", "CASAS", "TORRE",
    "MACAS", "FLORES"
    // Adicione mais palavras de 5 letras conforme necessário
  ];

  List<String> words6Letters = [
    "ANOTAR", "AMENDO", "COPIAR", "CORAIS", "BOLADO", "SABADO", "ENTRAR",
    "MOLHAR", "GOSTAR", "SORRIA"
    // Adicione mais palavras de 6 letras conforme necessário
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
      case 3:
        wordList = words6Letters;
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
    return wordsGuessedCorrectly >=
        3; // Exigir que o jogador acerte 3 palavras para avançar
  }
}
