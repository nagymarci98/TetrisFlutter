import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final childToAdd;
  MyButton({this.childToAdd});

  @override
  State<StatefulWidget> createState() => MyButtonState(childToAdd: childToAdd);
}

class MyButtonState extends State<MyButton> {
  final childToAdd;
  MyButtonState({this.childToAdd});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(2),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: Colors.black,
            child: Center(
              child: childToAdd,
            ),
          ),
        ));
  }
}
