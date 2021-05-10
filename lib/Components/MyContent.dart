import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tetris/Components/Grid.dart';
import 'package:tetris/Components/MyButton.dart';

class MyContent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyContentState();
}

class MyContentState extends State<MyContent> {
  Timer timer = new Timer(Duration(milliseconds: 500), () {});
  int selectedPieceIndex;
  int rotatedCounter = 0;
  String playOrRestartButtonText = "PLAY";
  static List<List<int>> tetrisPieces = [
    [4, 5, 14, 15], //négyzet
    [3, 4, 5, 6], // 4-es lapos fektetve
    [4, 14, 24, 25], //L
    [5, 15, 25, 24], // fordított L
    [4, 14, 24, 15], //E
    [5, 15, 14, 24], //S
    [4, 14, 15, 25] //S tukorkepe
  ];
  Color selectedPieceColor;
  List<Color> colors = [
    Colors.red,
    Colors.yellow,
    Colors.purple,
    Colors.green,
    Colors.blue,
    Colors.brown,
    Colors.pink
  ];
  List<int> chosedPiece = [];
  List<int> landedPieces = [];
  List<List<int>> landedPiecesColors = [
    [], //Red
    [], //Yellow
    [], //Purple
    [], //Green
    [], //Blue
    [], //Brown
    [] //Pink
  ];
  static int numberOfNodes = 150;

  void moveDown() {
    setState(() {
      for (var i = 0; i < chosedPiece.length; i++) {
        chosedPiece[i] = chosedPiece[i] + 10;
      }
    });
  }

  void startGame() {
    timer.cancel();
    resetPieces();
    selectAPiece();
    const duration = const Duration(milliseconds: 700);
    this.timer = new Timer.periodic(duration, (Timer t) {
      clearRow();
      if (pieceLandedOrTouchedOtherPiece()) {
        addSelectedPieceToLanded();
        startGame();
      } else {
        moveDown();
      }
    });
  }

  void addSelectedPieceToLanded() {
    setState(() {
      for (var i = 0; i < chosedPiece.length; i++) {
        landedPieces.add(chosedPiece[i]);
        landedPiecesColors[this.selectedPieceIndex].add(chosedPiece[i]);
      }
    });
  }

  bool pieceLandedOrTouchedOtherPiece() {
    chosedPiece.sort();
    if (chosedPiece.last + 10 >= numberOfNodes) {
      return true;
    } else {
      for (var i = 0; i < landedPieces.length; i++) {
        for (var j = 0; j < chosedPiece.length; j++) {
          if (chosedPiece[j] + 10 == landedPieces[i]) {
            return true;
          }
        }
      }
      return false;
    }
  }

  void selectAPiece() {
    var randomNumber = new Random().nextInt(tetrisPieces.length);
    setState(() {
      this.selectedPieceIndex = randomNumber;
      this.chosedPiece = tetrisPieces[this.selectedPieceIndex];
      this.selectedPieceColor = colors[this.selectedPieceIndex];
      this.rotatedCounter = 0;
    });
  }

  int roundUp(int number, int factor) {
    if (factor < 1) throw RangeError.range(factor, 1, null, "factor");
    number += factor - 1;
    return number - (number % factor);
  }

  void resetPieces() {
    setState(() {
      tetrisPieces = [
        [4, 5, 14, 15], //négyzet
        [3, 4, 5, 6], // 4-es lapos fektetve
        [4, 14, 24, 25], //L
        [5, 15, 25, 24], // fordított L
        [4, 5, 6, 15], //E
        [5, 15, 14, 24], //S
        [4, 14, 15, 25] //S tukorkepe
      ];
    });
  }

  void moveLeft() {
    bool ableToMoveLeft = true;
    for (var i = 0; i < landedPieces.length; i++) {
      for (var j = 0; j < chosedPiece.length; j++) {
        if (chosedPiece[j] - 1 == landedPieces[i]) {
          ableToMoveLeft = false;
        }
      }
    }
    for (var i = 0; i < chosedPiece.length; i++) {
      if (chosedPiece[i] % 10 == 0) {
        ableToMoveLeft = false;
      }
    }
    if (ableToMoveLeft) {
      setState(() {
        for (var i = 0; i < chosedPiece.length; i++) {
          chosedPiece[i] -= 1;
        }
      });
    }
  }

  void moveRight() {
    bool ableToRightLeft = true;
    for (var i = 0; i < landedPieces.length; i++) {
      for (var j = 0; j < chosedPiece.length; j++) {
        if (chosedPiece[j] + 1 == landedPieces[i]) {
          ableToRightLeft = false;
        }
      }
    }
    for (var i = 0; i < chosedPiece.length; i++) {
      if ((chosedPiece[i] + 1) % 10 == 0) {
        ableToRightLeft = false;
      }
    }
    if (ableToRightLeft) {
      setState(() {
        for (var i = 0; i < chosedPiece.length; i++) {
          chosedPiece[i] += 1;
        }
      });
    }
  }

  void rotateSquare() {
    //stays the same, whatever
  }

  void rotateLaposNegyesCucc() {
    bool ableToRotate = true;
    chosedPiece.sort();
    if (this.rotatedCounter.isEven) {
      for (var i = 0; i < chosedPiece.length; i++) {
        if (landedPieces.contains(chosedPiece.first + i * 1) ||
            !(chosedPiece.first + i * 1 < roundUp(chosedPiece.first, 10))) {
          ableToRotate = false;
        }
      }
      if (ableToRotate) {
        for (var i = 0; i < chosedPiece.length; i++) {
          setState(() {
            chosedPiece[i] = chosedPiece.first + i * 1;
          });
        }
      }
    } else {
      for (var i = 0; i < chosedPiece.length; i++) {
        if (landedPieces.contains(chosedPiece.first + i * 10) ||
            chosedPiece.first + i * 10 > numberOfNodes) {
          ableToRotate = false;
        }
      }
      if (ableToRotate) {
        for (var i = 0; i < chosedPiece.length; i++) {
          setState(() {
            chosedPiece[i] = chosedPiece.first + i * 10;
          });
        }
      }
    }
  }

  void rotateTAlakuCucc() {
    bool ableToRotate = true;
    chosedPiece.sort();
    //alap helyzetből 1-be
    if (this.rotatedCounter == 1) {
      if (landedPieces.contains(chosedPiece[0] + 1) ||
          landedPieces.contains(chosedPiece[1] + 10) ||
          landedPieces.contains(chosedPiece[2] + 20 - 1) ||
          landedPieces.contains(chosedPiece[3] - 1)) {
        ableToRotate = false;
      }
      if (ableToRotate) {
        setState(() {
          chosedPiece[0] += 1;
          chosedPiece[1] += 10;
          chosedPiece[2] += 19;
          chosedPiece[3] -= 1;
        });
      }
    }
    if (this.rotatedCounter == 2) {
      if (landedPieces.contains(chosedPiece[0] + 10 + 1) ||
          landedPieces.contains(chosedPiece[1] - 10 + 1) ||
          landedPieces.contains(chosedPiece[2]) ||
          landedPieces.contains(chosedPiece[3] - 10 - 1)) {
        ableToRotate = false;
      }
      if (ableToRotate) {
        setState(() {
          chosedPiece[0] += 11;
          chosedPiece[1] -= 9;
          chosedPiece[3] -= 11;
        });
      }
    }
    if (this.rotatedCounter == 3) {
      if (landedPieces.contains(chosedPiece[0] + 10) ||
          landedPieces.contains(chosedPiece[1] - 10) ||
          landedPieces.contains(chosedPiece[2] - 1) ||
          landedPieces.contains(chosedPiece[3] + 10 - 2)) {
        ableToRotate = false;
      }
      if (ableToRotate) {
        setState(() {
          chosedPiece[0] += 10;
          chosedPiece[1] -= 10;
          chosedPiece[2] -= 1;
          chosedPiece[3] += 8;
        });
      }
    }
    if (this.rotatedCounter == 4) {
      if (landedPieces.contains(chosedPiece[0] + 2) ||
          landedPieces.contains(chosedPiece[1] - 10 + 1) ||
          landedPieces.contains(chosedPiece[2]) ||
          landedPieces.contains(chosedPiece[3] - 20)) {
        ableToRotate = false;
      }
      if (ableToRotate) {
        setState(() {
          chosedPiece[0] += 2;
          chosedPiece[1] -= 9;
          chosedPiece[3] -= 20;
        });
      }
    }
  }

  void rotateLForditottAlakuCucc() {
    bool ableToRotate = true;
    chosedPiece.sort();
    //alap helyzetből 1-be
    if (this.rotatedCounter == 1) {
      if (landedPieces.contains(chosedPiece[0] + 10 + 1) ||
          landedPieces.contains(chosedPiece[1]) ||
          landedPieces.contains(chosedPiece[2] - 20) ||
          landedPieces.contains(chosedPiece[3] - 10 - 1)) {
        ableToRotate = false;
      }
      if (ableToRotate) {
        setState(() {
          chosedPiece[0] += 11;
          chosedPiece[2] -= 20;
          chosedPiece[3] -= 11;
        });
      }
    }
    if (this.rotatedCounter == 2) {
      if (landedPieces.contains(chosedPiece[0] + 1) ||
          landedPieces.contains(chosedPiece[1] - 10) ||
          landedPieces.contains(chosedPiece[2] - 1) ||
          landedPieces.contains(chosedPiece[3] + 10 - 2)) {
        ableToRotate = false;
      }
      if (ableToRotate) {
        setState(() {
          chosedPiece[0] += 1;
          chosedPiece[1] -= 10;
          chosedPiece[2] -= 1;
          chosedPiece[3] += 8;
        });
      }
    }
    if (this.rotatedCounter == 3) {
      if (landedPieces.contains(chosedPiece[0] + 2) ||
          landedPieces.contains(chosedPiece[1] + 11) ||
          landedPieces.contains(chosedPiece[2] - 10 + 1) ||
          landedPieces.contains(chosedPiece[3] - 20)) {
        ableToRotate = false;
      }
      if (ableToRotate) {
        setState(() {
          chosedPiece[0] += 2;
          chosedPiece[1] += 11;
          chosedPiece[2] -= 9;
          chosedPiece[3] -= 20;
        });
      }
    }
    if (this.rotatedCounter == 4) {
      if (landedPieces.contains(chosedPiece[0] + 1) ||
          landedPieces.contains(chosedPiece[1] + 10) ||
          landedPieces.contains(chosedPiece[2] + 20 - 1) ||
          landedPieces.contains(chosedPiece[3] + 10 - 2)) {
        ableToRotate = false;
      }
      if (ableToRotate) {
        setState(() {
          chosedPiece[0] += 1;
          chosedPiece[1] += 10;
          chosedPiece[2] += 19;
          chosedPiece[3] += 8;
        });
      }
    }
  }

  void rotateLAlakuCucc() {
    bool ableToRotate = true;
    chosedPiece.sort();
    //alap helyzetből 1-be
    if (this.rotatedCounter == 1) {
      if (landedPieces.contains(chosedPiece[0] + 2) ||
          !(chosedPiece[0] + 2 < roundUp(chosedPiece.first, 10)) ||
          landedPieces.contains(chosedPiece[1] + 1 - 10) ||
          landedPieces.contains(chosedPiece[2] - 20) ||
          landedPieces.contains(chosedPiece[3] - 1 - 10)) {
        ableToRotate = false;
      }
      if (ableToRotate) {
        setState(() {
          chosedPiece[0] += 2;
          chosedPiece[1] -= 9;
          chosedPiece[2] -= 20;
          chosedPiece[3] -= 11;
        });
      }
    }
    if (this.rotatedCounter == 2) {
      if (landedPieces.contains(chosedPiece[0] + 1) ||
          !(chosedPiece[0] + 1 < roundUp(chosedPiece.first, 10)) ||
          landedPieces.contains(chosedPiece[1] + 10) ||
          landedPieces.contains(chosedPiece[2] + 20 - 1) ||
          landedPieces.contains(chosedPiece[3] - 10)) {
        ableToRotate = false;
      }
      if (ableToRotate) {
        setState(() {
          chosedPiece[0] += 1;
          chosedPiece[1] += 10;
          chosedPiece[2] += 19;
          chosedPiece[3] -= 10;
        });
      }
    }
    if (this.rotatedCounter == 3) {
      if (landedPieces.contains(chosedPiece[0] + 2) ||
          landedPieces.contains(chosedPiece[1] + 11) ||
          landedPieces.contains(chosedPiece[2]) ||
          landedPieces.contains(chosedPiece[3] - 10 - 1)) {
        ableToRotate = false;
      }
      if (ableToRotate) {
        setState(() {
          chosedPiece[0] += 2;
          chosedPiece[1] += 11;
          chosedPiece[3] -= 11;
        });
      }
    }
    if (this.rotatedCounter == 4) {
      if (landedPieces.contains(chosedPiece[0] + 20 - 1) ||
          landedPieces.contains(chosedPiece[1] - 10) ||
          landedPieces.contains(chosedPiece[2] - 1) ||
          landedPieces.contains(chosedPiece[3] + 10 - 2)) {
        ableToRotate = false;
      }
      if (ableToRotate) {
        setState(() {
          chosedPiece[0] += 19;
          chosedPiece[1] -= 10;
          chosedPiece[2] -= 1;
          chosedPiece[3] += 8;
        });
      }
    }
  }

  void rotateSAlakuCucc() {
    bool ableToRotate = true;
    chosedPiece.sort();
    if (this.rotatedCounter.isOdd) {
      if (landedPieces.contains(chosedPiece[0] + 2) ||
          landedPieces.contains(chosedPiece[1] - 10 + 1) ||
          landedPieces.contains(chosedPiece[2]) ||
          landedPieces.contains(chosedPiece[3] - 10 - 1)) {
        ableToRotate = false;
      }
      if (ableToRotate) {
        setState(() {
          chosedPiece[0] += 2;
          chosedPiece[1] -= 9;
          chosedPiece[3] -= 11;
        });
      }
    } else {
      if (landedPieces.contains(chosedPiece[0] + 10 - 1) ||
          landedPieces.contains(chosedPiece[1] - 2) ||
          landedPieces.contains(chosedPiece[2] + 10 + 1) ||
          landedPieces.contains(chosedPiece[3])) {
        ableToRotate = false;
      }
      if (ableToRotate) {
        setState(() {
          chosedPiece[0] += 9;
          chosedPiece[1] -= 2;
          chosedPiece[2] += 11;
        });
      }
    }
  }

  void rotateSForditottAlakuCucc() {
    bool ableToRotate = true;
    chosedPiece.sort();
    if (this.rotatedCounter.isOdd) {
      if (landedPieces.contains(chosedPiece[0] + 10 + 1) ||
          landedPieces.contains(chosedPiece[1] - 10 + 1) ||
          landedPieces.contains(chosedPiece[2]) ||
          landedPieces.contains(chosedPiece[3] - 20)) {
        ableToRotate = false;
      }
      if (ableToRotate) {
        setState(() {
          chosedPiece[0] += 11;
          chosedPiece[1] -= 9;
          chosedPiece[3] -= 20;
        });
      }
    } else {
      if (landedPieces.contains(chosedPiece[0] + 1) ||
          landedPieces.contains(chosedPiece[1] + 10) ||
          landedPieces.contains(chosedPiece[2] - 1) ||
          landedPieces.contains(chosedPiece[3] + 10 - 2)) {
        ableToRotate = false;
      }
      if (ableToRotate) {
        setState(() {
          chosedPiece[0] += 1;
          chosedPiece[1] += 10;
          chosedPiece[2] -= 1;
          chosedPiece[3] += 8;
        });
      }
    }
  }

  void rotate() {
    this.rotatedCounter++;
    if (this.rotatedCounter > 4) {
      this.rotatedCounter = 1;
    }
    switch (selectedPieceIndex) {
      //elso elem a pieces-ben forgatas
      case 0:
        rotateSquare();
        break;
      //negyes lapos cucc megforgatasa
      case 1:
        rotateLaposNegyesCucc();
        break;
      case 2:
        rotateLAlakuCucc();
        break;
      case 3:
        rotateLForditottAlakuCucc();
        break;
      case 4:
        rotateTAlakuCucc();
        break;
      case 5:
        rotateSForditottAlakuCucc();
        break;
      case 6:
        rotateSAlakuCucc();
        break;
      default:
    }
  }

  void clearRow() {
    int counter = 0;
    List<int> remove = [];
    //15: number of rows
    for (var i = 0; i < 15; i++) {
      remove.clear();
      counter = 0;
      //10 is the number of nodes in a row
      for (var j = 0; j < 10; j++) {
        if (landedPieces.contains(i * 10 + j)) {
          remove.add(i * 10 + j);
          counter++;
        }
        if (counter == 10) {
          setState(() {
            //megtelt sor kisedese
            remove.forEach((element) {
              landedPieces.remove(element);
            });
            //kiszedett sor szineinek torlese
            for (var i = 0; i < landedPiecesColors.length; i++) {
              remove.forEach((element) {
                landedPiecesColors[i].remove(element);
              });
            }
            //minden elotte levo sort lentebb viszunt
            for (var i = 0; i < landedPieces.length; i++) {
              if (landedPieces[i] < remove.first) {
                landedPieces[i] += 10;
              }
            }
            for (var i = 0; i < landedPiecesColors.length; i++) {
              for (var j = 0; j < landedPiecesColors[i].length; j++) {
                if (landedPiecesColors[i][j] < remove.first) {
                  landedPiecesColors[i][j] += 10;
                }
              }
            }
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Grid(
          selectedPiece: chosedPiece,
          landedPieces: landedPieces,
          selectedPieceColor: selectedPieceColor,
          landedPiecesColors: landedPiecesColors,
        )),
        Container(
          height: 70,
          color: Colors.black45,
          child: Row(
            children: [
              Expanded(
                  child: GestureDetector(
                onTap: startGame,
                child: MyButton(
                  childToAdd: Text(
                    playOrRestartButtonText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              )),
              Expanded(
                  child: GestureDetector(
                onTap: moveLeft,
                child: MyButton(
                  childToAdd: Icon(
                    Icons.arrow_left,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              )),
              Expanded(
                  child: GestureDetector(
                onTap: moveRight,
                child: MyButton(
                  childToAdd: Icon(
                    Icons.arrow_right,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              )),
              Expanded(
                  child: GestureDetector(
                onTap: rotate,
                child: MyButton(
                  childToAdd: Icon(
                    Icons.shuffle,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }
}
