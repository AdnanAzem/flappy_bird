import 'dart:async';

import 'package:flappybirdclone/barriers.dart';
import 'package:flappybirdclone/bird.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double birdYaxis = 0;
  double time = 0;
  double height = 0;
  double initialHeight = birdYaxis;
  bool gameHasStarted = false;
  static double barrierXone = 1;
  double barrierXtwo = barrierXone + 1.5;
  double birdWidth = 0.2;
  double birdHeight = 0.2;
  int counter = 0;
  int bestScore = 0;

  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWidth = 0.5;
  List<List<double>> barrierHeight = [
    [0.6, 0.4],
    [0.4, 0.6]
  ];

  void jump() {
    setState(() {
      time = 0;
      initialHeight = birdYaxis;
      for (int i = 0; i < barrierX.length; i++)
        if (barrierX[i] <= birdWidth && barrierX[i] + barrierWidth >= -birdWidth) 
          counter++;
    });
  }

  void resetGame() {
    Navigator.pop(context);
    setState(() {
      if (counter > bestScore) {
        bestScore = counter;
      }
      birdYaxis = 0;
      gameHasStarted = false;
      time = 0;
      initialHeight = birdYaxis;
    });
  }

  void startGame() {
    counter = 0;
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 60), (timer) {
      setState(() {
        time += 0.05;
        height = -4.9 * time * time + 2.8 * time;
        setState(() {
          birdYaxis = initialHeight - height;
        });

        setState(() {
          for (int i = 0; i < barrierX.length; i++) {
            if (barrierX[i] < -2) {
              barrierX[i] += 3.5;
            } else {
              barrierX[i] -= 0.05;
            }
          }
        });

        // setState(() {
        //   if (barrierXone < -2) {
        //     barrierXone += 3.5;
        //   } else {
        //     barrierXone -= 0.05;
        //   }
        // });

        // setState(() {
        //   if (barrierXtwo < -2) {
        //     barrierXtwo += 3.5;
        //   } else {
        //     barrierXtwo -= 0.05;
        //   }
        // });

        if (birdIsDead()) {
          setState(() {
            timer.cancel();
            _showDialog();
            // gameHasStarted = false;
          });
        }
        // time += 0.01;
      });
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.brown,
            title: Center(
              child: Text(
                "G A M E  O V E R",
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: resetGame,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: EdgeInsets.all(7),
                    color: Colors.white,
                    child: Text(
                      "PLAY AGAIN",
                      style: TextStyle(color: Colors.brown),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  bool birdIsDead() {
    // check if the bird is hitting the top or the bottom of screen
    if (birdYaxis < -1 || birdYaxis > 1) {
      return true;
    }

    // check if the bird is hiiting a barrier
    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= birdWidth &&
          barrierX[i] + barrierWidth >= -birdWidth &&
          (birdYaxis <= -1 + barrierHeight[i][0] ||
              birdYaxis + birdHeight >= 1 - barrierHeight[i][1])) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (gameHasStarted) {
          jump();
        } else {
          startGame();
        }
      },
      child: Scaffold(
        body: Column(children: [
          Expanded(
              flex: 2,
              child: Stack(
                children: [
                  (AnimatedContainer(
                    alignment: Alignment(0, birdYaxis),
                    duration: Duration(milliseconds: 0),
                    color: Colors.blue,
                    child: MyBird(
                      birdYaxis: birdYaxis,
                      birdHeight: birdHeight,
                      birdWidth: birdWidth,
                    ),
                  )),
                  Container(
                    alignment: Alignment(0, -0.3),
                    child: gameHasStarted
                        ? Text(" ")
                        : Text(
                            "T A P  T O  P L A Y",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                  ),
                  AnimatedContainer(
                    // alignment: Alignment(barrierXone, 1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      barrierX: barrierX[0],
                      barrierWidth: barrierWidth,
                      barrierHeight: barrierHeight[0][0],
                      isThisBottomBarrier: false,
                    ),
                  ),
                  AnimatedContainer(
                    // alignment: Alignment(barrierXone, -1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      barrierX: barrierX[0],
                      barrierWidth: barrierWidth,
                      barrierHeight: barrierHeight[0][1],
                      isThisBottomBarrier: true,
                    ),
                  ),
                  AnimatedContainer(
                    // alignment: Alignment(barrierXtwo, 1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      barrierX: barrierX[1],
                      barrierWidth: barrierWidth,
                      barrierHeight: barrierHeight[1][0],
                      isThisBottomBarrier: false,
                    ),
                  ),
                  AnimatedContainer(
                    // alignment: Alignment(barrierXtwo, -1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      barrierX: barrierX[1],
                      barrierWidth: barrierWidth,
                      barrierHeight: barrierHeight[1][1],
                      isThisBottomBarrier: true,
                    ),
                  ),
                ],
              )),
          Container(
            height: 15,
            color: Colors.green,
          ),
          Expanded(
              child: Container(
            color: Colors.brown,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "SCORE",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        counter.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "BEST",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        bestScore.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                        ),
                      ),
                    ],
                  )
                ]),
          ))
        ]),
      ),
    );
  }
}
