import 'package:flutter/material.dart';
import 'package:tetris/Components/GridNode.dart';

class Grid extends StatelessWidget {
  List<int> selectedPiece;
  List<int> landedPieces;
  var childToShow;
  List<List<int>> landedPiecesColors;
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
  Grid(
      {this.selectedPiece,
      this.landedPieces,
      this.selectedPieceColor,
      this.landedPiecesColors,
      this.childToShow});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: 150,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 10),
        itemBuilder: (context, index) {
          if (landedPieces.contains(index)) {
            for (var i = 0; i < landedPiecesColors.length; i++) {
              if (landedPiecesColors[i].contains(index)) {
                return GridNode(
                  color: colors[i],
                );
              }
            }
          }
          if (selectedPiece.contains(index)) {
            return GridNode(
              color: this.selectedPieceColor,
            );
          } else {
            return GridNode(
              color: Colors.black,
            );
          }
        });
  }
}
