import 'package:flutter/material.dart';
import 'package:natural_plants/pages/colors.dart';

import '../pages/Detailsview.dart';

class Tile extends StatelessWidget {
   Tile({
    super.key,
    required this.Imagepath,
    required this.Name,
    required this.Price,
    required this.Country,
  });

  String Imagepath;
  String Name;
  String Price;
  String Country;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Detailsview(),
        ),
      );},
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 10),
              blurRadius: 20,
              color: MainColor.withOpacity(0.5),
            ),
          ],
          borderRadius: BorderRadius.circular(13),
          color: Colors.white,
        ),
        height: 290,
        width: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: 180,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(Imagepath),
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    Name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  Spacer(),
                  Text(
                    Price,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.greenAccent,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
               Country,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.greenAccent.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
