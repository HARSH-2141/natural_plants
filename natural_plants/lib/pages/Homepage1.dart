import 'package:flutter/material.dart';
import 'package:natural_plants/pages/Detailsview.dart';
import 'package:natural_plants/pages/colors.dart';

import '../widgets/Tile.dart';

class Homepage1 extends StatelessWidget {
  const Homepage1({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0),
                    ),
                    child: Container(
                      height: 240,
                      width: double.maxFinite,
                      color: MainColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Image.asset("assets/icons/menu.png"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 75,
                      left: 15,
                      right: 15,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "hi uishopy",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Spacer(),
                        Image.asset("assets/images/logo.png"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 200,
                      left: 20,
                      right: 20,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: MainColor.withOpacity(0.4),
                            offset: Offset(0, 10),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 70,
                            width: 300,
                            child: TextFormField(
                              decoration: InputDecoration(
                                label: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 30.0,
                                    top: 10.0,
                                  ),
                                  child: Text(
                                    "Search ",
                                    style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                      color: MainColor.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Container(
                            height: 70,
                            width: 70,
                            child: Image.asset("assets/icons/search.png"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 35),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: [
                    Row(
                      children: [
                        Text(
                          "Recommendad",
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Spacer(),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Container(
                            height: 30,
                            width: 70,
                            color: MainColor,
                            child: Center(
                              child: Text(
                                "More",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    Container(
                      width: double.maxFinite,
                      height: 290,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Tile(
                            Imagepath: "assets/images/image_1.png",
                            Name: "SAMANTHA",
                            Price: "\$300",
                            Country: "RUSSIN",
                          ),
                          SizedBox(width: 20),
                          Tile(
                            Imagepath: "assets/images/image_2.png",
                            Name: "ANGELICA",
                            Price: "\$500",
                            Country: "RUSSIN",
                          ),

                          SizedBox(width: 20),
                          Tile(
                            Imagepath: "assets/images/image_3.png",
                            Name: "SAMANTHA",
                            Price: "\$250",
                            Country: "RUSSIN",
                          ),

                          SizedBox(width: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    Text(
                      "Featured Plants",
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Spacer(),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        height: 30,
                        width: 70,
                        color: MainColor,
                        child: Center(
                          child: Text(
                            "More",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 200,
                width: 380,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      height: 20,
                      width: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        image: DecorationImage(
                          image: AssetImage("assets/images/bottom_img_1.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Container(
                      height: 20,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        image: DecorationImage(
                          image: AssetImage("assets/images/bottom_img_2.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Container(
                      height: 20,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        image: DecorationImage(
                          image: AssetImage("assets/images/img.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Image(image: AssetImage("assets/icons/flower.png")),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Image(image: AssetImage("assets/icons/heart-icon.png")),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Image(image: AssetImage("assets/icons/user-icon.png")),
              label: "",
            ),
          ],
        ),
      ),
    );
  }
}
