import 'package:flutter/material.dart';
import 'package:tetris/Components/MyContent.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Game(),
    );
  }
}

class Game extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Tetris")),
        backgroundColor: Colors.grey[800],
      ),
      body: Builder(builder: (context) {
        return MyContent();
      }),
      backgroundColor: Colors.grey[900],
    );
  }
}
