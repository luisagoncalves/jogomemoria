import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(Round6MemoryGame());
}

class Round6MemoryGame extends StatelessWidget {
  const Round6MemoryGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jogo da Memória',
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/game': (context) => GamePage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Column(
              children: [
                Text(
                  'Jogo da Memória',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 242, 245, 216)),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/game');
                  },
                  child: Text('Jogar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<String> cards = [];
  List<bool> cardFlipped = [];
  List<int> flippedIndices = [];
  int lives = 5;
  late Timer flipBackTimer;

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  void initializeGame() {
    List<String> images = [
      '👩\u200d🦱',
      '👩\u200d🦱',
      '👨\u200d🦰',
      '👨\u200d🦰',
      '🐶',
      '🐶',
      '🐱',
      '🐱',
      '🐭',
      '🐭',
      '🐸',
      '🐸',
      '🦊',
      '🦊',
      '🐻',
      '🐻'
    ];
    images.shuffle();
    setState(() {
      cards = images;
      cardFlipped = List.filled(images.length, false);
      flippedIndices.clear();
      lives = 5;
    });
  }

  void onCardTap(int index) {
    if (!cardFlipped[index] && flippedIndices.length < 2) {
      setState(() {
        cardFlipped[index] = true;
        flippedIndices.add(index);
      });

      if (flippedIndices.length == 2) {
        if (cards[flippedIndices[0]] == cards[flippedIndices[1]]) {
          // Par encontrado
          flippedIndices.clear();
        } else {
          // Não é um par
          flipBackTimer = Timer(Duration(seconds: 1), () {
            setState(() {
              cardFlipped[flippedIndices[0]] = false;
              cardFlipped[flippedIndices[1]] = false;
              flippedIndices.clear();
              lives--;
              if (lives == 0) {
                showGameOverDialog();
              }
            });
          });
        }
      }
    }
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Game Over!'),
        content: Text('Você perdeu todas as vidas!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Voltar ao menu'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              initializeGame();
            },
            child: Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo da Memória'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Vidas: $lives'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Sair'),
                ),
              ),
            ],
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => onCardTap(index),
                  child: Card(
                    color: cardFlipped[index] ? const Color.fromARGB(255, 34, 27, 39) : const Color.fromARGB(255, 247, 244, 231),
                    child: Center(
                      child: Text(
                        cardFlipped[index] ? cards[index] : '',
                        style: TextStyle(fontSize: 100),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
