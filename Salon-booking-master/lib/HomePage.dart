import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:demo/CommonWidget/APIConst.dart';
import 'package:demo/SalonDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart ' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();
  List<String> imgList = [
    'https://img.freepik.com/free-vector/flat-design-beauty-salon-sale-banner-template_23-2149672019.jpg',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://img.freepik.com/free-vector/flat-design-beauty-salon-sale-banner-template_23-2149672019.jpg',
    'https://img.freepik.com/free-vector/flat-design-beauty-salon-sale-banner-template_23-2149672019.jpg',
    'https://img.freepik.com/free-vector/flat-design-beauty-salon-sale-banner-template_23-2149672019.jpg',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];
  String? data;
  List<dynamic> salons = [];
  bool isLoading = false;

  void getData() async {
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse("${ApiConst.base_url}user/user_fetch_salon.php");
    var response = await http.get(
      url,
      headers: {'cookie': ApiConst.cookie, 'User-Agent': ApiConst.user_agent},
    );
    print(response.body);
    var decodedData = jsonDecode(response.body);
    setState(() {
      salons = decodedData['salons'] ?? [];
      isLoading = false;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Image.asset(
              'assets/image/logo.jpeg',
              height: 40,
              width: 40,
            ),
            SizedBox(width: 8,),
            Text(
              'Hair Heaven',
              style: TextStyle(color: Colors.black, fontSize: 22,fontWeight: FontWeight.bold),
            ),

          ],
        ),
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: Colors.green,
        ),
      )
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarouselSlider(
                items: imgList
                    .map((item) =>
                    Container(
                      child: Container(
                        margin: EdgeInsets.all(5.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(
                                Radius.circular(5.0)),
                            child: Stack(
                              children: <Widget>[
                                Image.network(
                                    item, fit: BoxFit.cover, width: 1000.0),
                                Positioned(
                                  bottom: 0.0,
                                  left: 0.0,
                                  right: 0.0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color.fromARGB(200, 0, 0, 0),
                                          Color.fromARGB(0, 0, 0, 0)
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                    child: Text(
                                      'No. ${imgList.indexOf(item)} image',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ))
                    .toList(),
                carouselController: _controller,
                options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 2.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imgList
                    .asMap()
                    .entries
                    .map((entry) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(entry.key),
                    child: Container(
                      width: 12.0,
                      height: 12.0,
                      margin: EdgeInsets.symmetric(vertical: 8.0,
                          horizontal: 4.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (Theme
                              .of(context)
                              .brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black)
                              .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                    ),
                  );
                }).toList(),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: salons.length,
                itemBuilder: (context, index) {
                  return GestureDetector(onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Salondetailpage(salonDetail: salons[index],)),
                    );
                  },
                    child: Container(
                      margin: EdgeInsets.only(top: 16, bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            child: Image.network("${ApiConst.base_url+salons[index]['dp']}", height: 200,
                              width: double.infinity, fit: BoxFit.fill,),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      salons[index]['Name'],
                                      style:
                                      TextStyle(
                                          fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Phone: ${salons[index]['phone_number']}",
                                      style:
                                      TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Address: ${salons[index]['address']}",
                                      style:
                                      TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


