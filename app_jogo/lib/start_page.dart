import 'package:flutter/material.dart';
import 'main.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogo de Termo'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const MyHomePage(title: 'Níveis')),
            );
          },
          child: const Text('Iniciar Novo Jogo'),
        ),
      ),
    );
  }
}
