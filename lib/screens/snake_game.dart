import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class SnakeGame extends StatefulWidget {
  @override
  _SnakeGameState createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  // static List<int> startingSnakePosition = [65, 85, 105, 125];
  List<int> snakePosition = [65, 85, 105, 125];
  int numberOfSquares = 700;

  Timer _timer;
  // int _startTimer = 0;
  static var randomNumber = Random();
  int food = randomNumber.nextInt(640);
  static bool gameStarted = false;
  static bool gamePaused = false;

  void generateFood() {
    food = randomNumber.nextInt(640);
  }

  void startGame(List<int> currentSnakePosition) {
    snakePosition = currentSnakePosition;
    print('3resetSnakePosotion: $snakePosition');

    const duration = const Duration(milliseconds: 300);
    // setState(() {
    //   snakePosition = currentSnakePosition;
    //   // _startTimer = timerDuration;
    //   // print('2. gameStarted: $gameStarted');
    // });
    _timer = Timer.periodic(duration, (Timer timer) {
      // print('timerDuration $timerDuration');
      //print('startTimer: $_startTimer');
      // _startTimer = _startTimer + 1;
      updateSnake(snakePosition);
      if (_gameOver()) {
        _timer.cancel();
        _gameOverPopOut();
      } else if (gamePaused == true) {
        pauseTimer();
      }
    });
  }

  void pauseTimer() {
    if (_timer != null) _timer.cancel();
    //print('pausedTimer : ${_timer.toString()}');
  }

  void unpauseTimer() => startGame(snakePosition);

  var direction = "down";
  void updateSnake(List<int> currentSnakePosition) {
    setState(() {
      snakePosition = currentSnakePosition;
      print(snakePosition);
      //print('3. gameStarted: $gameStarted');
      switch (direction) {
        case "down":
          //.last refers to last number in snakePosition list(becomes snake's head in this case)
          snakePosition.add(snakePosition.last + 20);
          break;
        case "up":
          snakePosition.add(snakePosition.last - 20);
          break;
        case "left":
          snakePosition.add(snakePosition.last - 1);
          break;
        case "right":
          snakePosition.add(snakePosition.last + 1);
          break;
        default:
      }
      if (snakePosition.last == food)
        generateFood();
      else {
        snakePosition.removeAt(0);
      }
    });
  }

  bool _gameOver() {
    for (int i = 0; i < snakePosition.length; i++) {
      int count = 0;
      for (int j = 0; j < snakePosition.length; j++) {
        if (snakePosition[i] == snakePosition[j]) {
          count += 1;
        }
        if (count == 2 ||
            //down border
            snakePosition.last > 680 ||
            //up border
            snakePosition.last < 20 ||
            //left border
            snakePosition.last % 20 == 0 ||
            //right border
            (snakePosition.last + 1) % 20 == 0) {
          return true;
        }
      }
    }
    return false;
  }

  void _gameOverPopOut() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Center(child: Text("- GAME OVER -")),
          content: Text(
            "Your Score : ${(snakePosition.length - 4).toString()}",
            style: TextStyle(color: Colors.lightBlue),
          ),
          actions: [
            FlatButton(
              child: Text("Play Again?"),
              onPressed: () {
                setState(() {
                  //snakePosition.removeRange(0, 3);
                  snakePosition = [65, 85, 105, 125];
                  print('1resetSnakePosotion: $snakePosition');
                });
                print('2resetSnakePosotion: $snakePosition');
                startGame(snakePosition);
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void _pauseScreenPopOut() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Center(child: Text("- GAME PAUSED -")),
          content: Text(
            "Your Score : " + (snakePosition.length - 4).toString(),
            style: TextStyle(color: Colors.lightBlue),
          ),
          actions: [
            FlatButton(
              child: Text("Reset"),
              onPressed: () {
                setState(() {
                  gamePaused = false;
                  snakePosition = [65, 85, 105, 125];
                  //snakePosition = startingSnakePosition;
                });
                startGame(snakePosition);
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Continue"),
              onPressed: () {
                setState(() {
                  gamePaused = false;
                });
                unpauseTimer();
                //startGame();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (direction != "up" && details.delta.dy > 0) {
                    direction = "down";
                  } else if (direction != "down" && details.delta.dy < 0) {
                    direction = "up";
                  }
                },
                onHorizontalDragUpdate: (details) {
                  if (direction != "left" && details.delta.dx > 0) {
                    direction = "right";
                  } else if (direction != "right" && details.delta.dx < 0) {
                    direction = "left";
                  }
                },
                child: Container(
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: numberOfSquares,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 20,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      if (snakePosition.contains(index))
                        return Center(
                          child: Container(
                            padding: EdgeInsets.all(2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      if (index == food) {
                        return Center(
                          child: Container(
                            padding: EdgeInsets.all(2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                color: Colors.lightBlue,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          padding: EdgeInsets.all(2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              color: Colors.grey[900],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  onPressed: (gameStarted == true)
                      ? null
                      : () {
                          //print('1. gameStarted: $gameStarted');
                          setState(() {
                            gameStarted = true;
                            print('1.5 gameStarted: $gameStarted');
                          });
                          startGame(snakePosition);
                        },
                  textColor: Colors.lightGreen,
                  disabledTextColor: Colors.white24,
                  child: Text(
                    "s t a r t",
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: (gameStarted == false)
                      ? null
                      : () {
                          setState(() {
                            gamePaused = true;
                          });
                          _pauseScreenPopOut();
                        },
                  textColor: Colors.redAccent,
                  disabledTextColor: Colors.white24,
                  child: Text(
                    "p a u s e",
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),
                // GestureDetector(
                //   onTap: startGame,
                //   child: Center(
                //     child: Text(
                //       "s t a r t",
                //       style: TextStyle(
                //         color: Colors.lightBlue,
                //         fontSize: 20.0,
                //       ),
                //     ),
                //   ),
                // ),
                // GestureDetector(
                //   onTap: () {
                //     //timer.pause;
                //     _resetScreen;
                //   },
                //   child: Text(
                //     "r e s e t",
                //     style: TextStyle(
                //       color: Colors.lightBlue,
                //       fontSize: 20.0,
                //     ),
                //   ),
                // ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
