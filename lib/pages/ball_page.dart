import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:xbucks/helpper/function.dart';
import 'package:xbucks/pages/result_page.dart';

class BallPage extends StatefulWidget {
  const BallPage({
    Key? key,
    required this.time,
    required this.speed,
    required this.ball,
    required this.shake,
  }) : super(key: key);

  final int time;
  final int speed;
  final int ball;
  final int shake;

  @override
  _BallPageState createState() => _BallPageState();
}

class _BallPageState extends State<BallPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Positions of the balls
  late List<Offset> ballPositions;
  int? selectedBallIndex;
  late Timer _timer;
  late int _secondsRemaining;

  late List<Color> ballColors;
  late bool stclick = false;

  @override
  void initState() {
    super.initState();
    ballColors = List.generate(widget.ball, (index) => Colors.lightBlueAccent);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.speed),
    );
    _initializeBalls();
    _secondsRemaining = widget.time;
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer.cancel();
          todata("Time Out");
        }
      });
    });
  }

  Future<void> showTimeOverDialog() async {
    // int aaa = selectedBallIndex! + 1;
    // navigateToPop(context, ResultPage(gameResult: 'You selected ball $aaa'));

    showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Prevents dialog from closing when tapped outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Time Over'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Your time is over.$selectedBallIndex+ Do you want to play again?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                // Implement your logic to restart the game here
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
                // Implement your logic to navigate back or exit the game here
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _initializeBalls() {
    ballPositions = List.generate(widget.ball, (index) => _gridPosition(index));
  }

  Offset _gridPosition(int index) {
    int ro = widget.ball < 9 ? 2 : 3;
    final int row = index ~/ ro;
    final int col = index % ro;
    const double ballSize = 50.0;
    const double padding = 40.0;
    final double x = col * (ballSize + padding);
    final double y = row * (ballSize + padding);
    return Offset(x, y);
  }

  void _handleTap(int index) {
    final randomIndex = _getRandomBallIndex(index);
    setState(() {
      final tempPosition = ballPositions[index];
      ballPositions[index] = ballPositions[randomIndex];
      ballPositions[randomIndex] = tempPosition;
    });
  }

  int _getRandomBallIndex(int currentIndex) {
    final random = Random();
    int randomIndex = random.nextInt(widget.ball);
    while (randomIndex == currentIndex) {
      randomIndex = random.nextInt(widget.ball);
    }
    return randomIndex;
  }

  void todata(result) {
    navigateToPop(context, ResultPage(gameResult: result));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Page'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Stack(
              children: [
                // Ball Image
                Center(
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                        Color.fromARGB(255, 255, 17, 0),
                        BlendMode.modulate), // Default filter
                    child: Image.asset("assets/ball.png", width: 75),
                  ),
                ),
                Center(
                  child: Text(
                    '$_secondsRemaining',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 10),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                  left: widget.ball < 9
                      ? MediaQuery.of(context).size.width * 0.3
                      : MediaQuery.of(context).size.width * 0.2,
                  top: MediaQuery.of(context).size.width * 0.1),
              child: Stack(
                alignment: AlignmentDirectional
                    .center, // Center all the balls within the Stack
                children: List.generate(
                  widget.ball,
                  (index) => AnimatedPositioned(
                    duration: Duration(milliseconds: widget.speed),
                    left: ballPositions[index].dx,
                    top: ballPositions[index].dy,
                    child: GestureDetector(
                      onTap: () {
                        if (selectedBallIndex == null) {
                          selectedBallIndex = index;
                          setState(() {
                            ballColors[index] = Colors.green;
                            stclick = false;
                          });
                          Future.delayed(Duration(seconds: 2), () {
                            setState(() {
                              ballColors[index] = Colors.lightBlueAccent;
                              int iterationCount = 0;
                              int runt = 0;
                              Timer.periodic(Duration(milliseconds: 500),
                                  (timer) {
                                _handleTap(index);
                                _handleTap(index);
                                for (int i = 0; i < widget.ball; i++) {
                                  _handleTap(i);
                                }
                                for (int i = 0; i < widget.ball; i++) {
                                  _handleTap(i);
                                }
                                for (int i = 0; i < widget.ball; i++) {
                                  _handleTap(i);
                                }
                                // });
                                // Timer.periodic(
                                //     Duration(milliseconds: widget.speed),
                                //     (timer) {
                                //   if (runt < widget.ball) {
                                //     _handleTap(runt);
                                //   }

                                iterationCount++;
                                if (iterationCount >= widget.shake) {
                                  timer.cancel();
                                  _startTimer();
                                  setState(() {
                                    stclick = true;
                                  });
                                }
                              });
                            });
                          });
                        } else if (stclick) {
                          if (index == selectedBallIndex) {
                            setState(() {
                              ballColors[index] = Colors.lightGreenAccent;
                            });

                            todata("Correct selection");
                          } else {
                            setState(() {
                              ballColors[index] = Colors.redAccent;
                            });

                            todata("wrong");
                          }
                        }
                      },
                      child: ColorFiltered(
                        colorFilter: selectedBallIndex == index
                            ? ColorFilter.mode(
                                ballColors[index], BlendMode.modulate)
                            : ColorFilter.mode(
                                ballColors[index], BlendMode.modulate),
                        child: Image.asset("assets/ball.png", width: 50),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
