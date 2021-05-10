import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GridNode extends StatelessWidget {
  final color;
  final child;
  GridNode({this.color, this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(color: color, child: this.child),
      ),
    );
  }
}
