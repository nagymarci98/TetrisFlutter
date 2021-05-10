import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tetris/Components/MyButton.dart';

class ControlRow extends StatelessWidget {
  void startGame() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      color: Colors.black45,
      child: Row(
        children: [
          Expanded(
              child: GestureDetector(
            onTap: startGame,
            child: MyButton(
              childToAdd: Text(
                "PLAY",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          )),
          Expanded(
              child: GestureDetector(
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
    );
  }
}
