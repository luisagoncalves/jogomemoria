import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(Round6MemoryGame());
}

class Round6MemoryGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Round 6 Memory',
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/records': (context) => RecordsPage(),
        '/levels': (context) => LevelsPage(),
        '/game': (context) => GamePage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
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
                  'Round 6 Memory',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/levels');
                  },
                  child: Text('Modo Normal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/levels');
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      side: BorderSide(color: Colors.pink)),
                  child: Text('Modo Round 6'),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/records');
                  },
                  child: Text(
                    'Recordes',
                    style: TextStyle(
                        color: Colors.pink,
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RecordsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recordes'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Modo Normal'),
            onTap: () {},
          ),
          ListTile(
            title: Text('Modo Round 6'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class LevelsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nível do Jogo'),
      ),
      body: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: 9, // Número de níveis
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/game');
            },
            child: Card(
              color: Colors.pink,
              child: Center(
                child: Text(
                  '${(index + 1) * 2}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<String> cards = [];
  List<bool> cardFlipped = [];
  List<int> flippedIndices = [];
  int lives = 3;
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
            child: Text('Voltar ao Menu'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              initializeGame();
            },
            child: Text('Tentar Novamente'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo'),
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
                    color: cardFlipped[index] ? Colors.white : Colors.grey[800],
                    child: Center(
                      child: Text(
                        cardFlipped[index] ? cards[index] : '',
                        style: TextStyle(fontSize: 24),
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
