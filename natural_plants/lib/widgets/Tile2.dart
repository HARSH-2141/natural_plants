import 'package:flutter/material.dart';

import '../pages/colors.dart';

class Tile2 extends StatelessWidget {
  Tile2({super.key, required this.Iconpath});

  String Iconpath;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 70,

      child: Image.asset(Iconpath),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(offset: Offset(0, 10), blurRadius: 20, color: MainColor.withOpacity(0.5)),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
