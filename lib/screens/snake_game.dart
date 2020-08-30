import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import '../styles.dart';

class SnakeGame extends StatefulWidget {
  @override
  _SnakeGameState createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  @override
  void initState() {
    gameBorder();
    super.initState();
  }

  // static List<int> startingSnakePosition = [65, 85, 105, 125];
  List<int> snakePosition = [65, 85, 105, 125];
  int numberOfSquares = 700;
  int crossAxisSquareCount = 20;

  Timer _timer;
  static var randomNumber = Random();
  List<int> border = [];
  int food = randomNumber.nextInt(700);
  static bool gameStarted = false;
  static bool gamePaused = false;
  static bool gameOver = false;

  int generateFood() {
    food = randomNumber.nextInt(700);
    //if random number includes outside border's number, recalculate generateFood()
    if (border.contains(food)) {
      int food = generateFood();
      return food;
    } else
      return food;
  }

  void initializeGame() {
    if (_timer != null) _timer.cancel();
    snakePosition = [65, 85, 105, 125];
    //gameStarted = false;
    gamePaused = false;
    gameOver = false;
    direction = "down";
  }

  //Calculate most left/right row and make color black as side borders
  List<int> gameBorder() {
    //Calculate right border
    int j = 19;
    for (int i = 0; i < (numberOfSquares / crossAxisSquareCount); i++) {
      border.add(j);
      j = j + 20;
    }

    //Calculate left border
    for (int i = 0; i < numberOfSquares; i++) {
      if (i % 20 == 0) {
        border.add(i);
        // print(border);
      }
    }

    return border;
  }

  void startGame(List<int> currentSnakePosition) {
    snakePosition = currentSnakePosition;

    const duration = const Duration(milliseconds: 300);

    _timer = Timer.periodic(duration, (Timer timer) {
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
  }

  void unpauseTimer() => startGame(snakePosition);

  String direction = "down";
  void updateSnake(List<int> currentSnakePosition) {
    setState(() {
      snakePosition = currentSnakePosition;
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
            //down border. If snake head exceed total square grid count.
            snakePosition.last > 700 ||
            //up border. If snake head decreases less than 0.
            snakePosition.last < 0 ||
            //left border
            (snakePosition.last) % 20 == 0 ||
            //right border
            (snakePosition.last + 1) % 20 == 0) {
          setState(() {
            gameOver = true;
          });
          return true;
        }
      }
    }
    return false;
  }

  void _gameOverPopOut() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title:
              Center(child: Text("- GAME OVER -", style: kBlackBigTextStyle1)),
          content: Text(
            "Your Score : ${(snakePosition.length - 4).toString()}",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            FlatButton(
              child: Text(
                "Play Again?",
                style: kBlackSmallTextStyle1,
              ),
              onPressed: () {
                initializeGame();
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
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Center(
              child: Text(
            "- GAME PAUSED -",
            style: kWhiteTextStyle1,
          )),
          content: Text(
            "Your Score : " + (snakePosition.length - 4).toString(),
            style: TextStyle(color: Colors.lightBlue),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButton(
                  child: Text("Reset",
                      style: TextStyle(color: Colors.red, fontSize: 14)),
                  onPressed: () {
                    initializeGame();
                    startGame(snakePosition);
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(width: 35),
                FlatButton(
                  child: Text("Continue",
                      style: TextStyle(color: Colors.green, fontSize: 14)),
                  onPressed: () {
                    setState(() {
                      gamePaused = false;
                    });
                    unpauseTimer();
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
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
    String score = (snakePosition.length - 4).toString();
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(height: 13),
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
                      crossAxisCount: crossAxisSquareCount,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      if (snakePosition.contains(index)) {
                        //If snake head collide with border, will change color to black
                        if (border.contains(index)) {
                          return Container(
                            padding: EdgeInsets.all(2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                color: Colors.black,
                              ),
                            ),
                          );
                        }
                        if (index == snakePosition.last) {
                          return Container(
                            padding: EdgeInsets.all(2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                color: Colors.lightBlue,
                              ),
                            ),
                          );
                        }
                        return Center(
                          child: Container(
                            padding: EdgeInsets.all(2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                color: (gameOver == true)
                                    ? Colors.red
                                    : Colors.white,
                              ),
                            ),
                          ),
                        );
                      }

                      if (index == food) {
                        return Center(
                          child: Container(
                            padding: EdgeInsets.all(2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                color: (gameOver)
                                    ? Colors.grey[900]
                                    : Colors.yellowAccent,
                              ),
                            ),
                          ),
                        );
                      }
                      if (border.contains(index)) {
                        return Container(
                          padding: EdgeInsets.all(2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              color: Colors.black,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  padding: EdgeInsets.only(left: 30),
                  onPressed: (gameStarted == true)
                      ? null
                      : () {
                          setState(() {
                            gameStarted = true;
                            //print('1.5 gameStarted: $gameStarted');
                          });
                          startGame(snakePosition);
                        },
                  textColor: Colors.lightGreen,
                  disabledTextColor: Colors.white24,
                  child: Text(
                    "START",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
                Text(
                  score,
                  style: TextStyle(fontSize: 40, color: Colors.white),
                ),
                // FlatButton(
                //     onPressed: gameBorder,
                //     child: Text(
                //       "ss",
                //       style: kWhiteTextStyle1,
                //     )),
                FlatButton(
                  padding: EdgeInsets.only(right: 30),
                  onPressed: (gameStarted == false || gamePaused == true)
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
                    "PAUSE",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
