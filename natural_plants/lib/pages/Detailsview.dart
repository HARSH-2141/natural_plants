import 'package:flutter/material.dart';
import 'package:natural_plants/pages/Homepage1.dart';
import 'package:natural_plants/pages/colors.dart';
import 'package:natural_plants/widgets/Tile2.dart';

class Detailsview extends StatelessWidget {
  const Detailsview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              // FIRST
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(
                          context,
                          MaterialPageRoute(builder: (context) => Homepage1()),
                        );
                      },
                      child: Container(
                        height: 70,
                        width: 70,
                        color: Colors.white,
                        child: Image.asset("assets/icons/back_arrow.png"),
                      ),
                    ),
                    SizedBox(height: 90),
                    Tile2(Iconpath: ("assets/icons/sun.png")),
                    SizedBox(height: 60),
                    Tile2(Iconpath: ("assets/icons/icon_2.png")),
                    SizedBox(height: 60),
                    Tile2(Iconpath: ("assets/icons/icon_3.png")),
                    SizedBox(height: 60),
                    Tile2(Iconpath: ("assets/icons/icon_4.png")),
                  ],
                ),
              ),
              SizedBox(width: 30),

              //  SECOND
              Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 700,
                        width: 280,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(-10, 10),
                              blurRadius: 30,
                              color: MainColor.withOpacity(0.3),
                            ),
                          ],
                          color: MainColor,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/images/img.png"),
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(70),
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(
                      "Angelica",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(
                      "Russia",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: MainColor.withOpacity(0.6),
                      ),
                    ),
                  ),
                  Container(
                    height: 70,
                    width: 200,
                    child: Center(child: Text("Buy Now",style: TextStyle(fontSize: 25),)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.0),
                      ),
                      color: MainColor,
                    ),
                  ),
                ],
              ),Spacer(),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20,top: 4,bottom: 15),
                    child: Text(
                      "\$300",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: MainColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Text("Discription      ", style: TextStyle(fontSize: 25),),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
