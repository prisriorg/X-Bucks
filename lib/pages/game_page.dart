import 'package:flutter/material.dart';
import 'package:xbucks/helpper/function.dart';
import 'package:xbucks/pages/ball_page.dart';

class GamePage extends StatefulWidget {
  const GamePage({
    Key? key,
    required this.modeName,
    required this.time,
    required this.fee,
    required this.win,
    required this.ball,
    required this.speed,
    required this.shake,
  }) : super(key: key);

  final String modeName;
  final int time; // Change type to int
  final String fee;
  final String win;
  final int ball;
  final int speed;
  final int shake;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game'),
        actions: [
          // GestureDetector(onTap: () => {}, child: Icon(Icons.done_all))
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  // Game title
                  Text(
                    widget.modeName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Game description
                  Text(
                    'Welcome to the most amazing game ever created! '
                    'Embark on an epic journey full of excitement and challenges.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Game time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Game Time:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('${widget.time}'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Game price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Price:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('${widget.win}'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Entry fee
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Entry Fee:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('${widget.fee}'),
                    ],
                  ),
                  SizedBox(height: 40),
                  // Start the game button
                  ElevatedButton(
                    onPressed: gamepage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Start the Game',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void gamepage() {
    navigateToPop(
        context,
        BallPage(
          time: widget.time,
          speed: widget.speed,
          ball: widget.ball,
          shake: widget.shake,
        ));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
        "Insuficent Balence",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    ));
  }
}
