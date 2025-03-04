import 'package:flutter/material.dart';
import 'main.dart';
import 'progress_manager.dart';
import 'game_logic.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  void _resetProgress(BuildContext context) async {
    await ProgressManager.saveProgress(1, 0);
    await ProgressManager.saveProgress(2, 0);
    await ProgressManager.saveProgress(3, 0);
    GameLogic().resetUsedWords();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MyHomePage(title: 'Níveis'),
      ),
    );
  }

  void _showResetConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmação'),
          content: const Text(
              'Tem certeza de que deseja iniciar um novo jogo? Isso irá perder todo o seu progresso atual.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fechar o diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fechar o diálogo
                _resetProgress(context);
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogo de Termo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bem-vindo, Jogador',
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Column(
              children: [
                SizedBox(
                  width: 200, // Defina uma largura fixa
                  child: ElevatedButton(
                    onPressed: () {
                      _showResetConfirmationDialog(context);
                    },
                    child: const Text('Novo Jogo'),
                  ),
                ),
                const SizedBox(height: 16), // Espaço entre os botões
                SizedBox(
                  width: 200, // Defina a mesma largura fixa
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const MyHomePage(title: 'Níveis')),
                      );
                    },
                    child: const Text('Continuar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
