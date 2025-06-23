import 'dart:convert';

import 'package:demo/CommonWidget/APIConst.dart';
import 'package:demo/Slotbook.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart ' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Salondetailpage extends StatefulWidget {
  var salonDetail;
  Salondetailpage({super.key, required this.salonDetail});

  @override
  State<Salondetailpage> createState() => _SalondetailpageState();
}

class _SalondetailpageState extends State<Salondetailpage> {
  String? data;
  String? userID;
  String? serviceID;
  List<dynamic> service = [];
  bool isLoading = false;
  var userData;

  void getData() async {
    SharedPreferences setpreference =
    await SharedPreferences.getInstance();

    setState(() {
      userID = setpreference.getString('uid');
      print(userID);
      userData = widget.salonDetail;
      isLoading = true;
    });
    var url = Uri.parse("${ApiConst.base_url}user/user_fetch_service.php");
    var response = await http.post(
      url,
      headers: {'cookie': ApiConst.cookie, 'User-Agent': ApiConst.user_agent},
      body: {'salon_id':  userData["id"] ?? "",},
    );
    print(response.body);
    var decodedData = jsonDecode(response.body);
    setState(() {
      service = decodedData['services'] ?? [];
      isLoading = false;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  int? selectedServiceIndex;
  String? totalPrice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: Colors.green,
        ),
      )
          : Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Image.network(
                        "${ApiConst.base_url+userData['dp']}",
                        width: double.infinity,
                        fit: BoxFit.cover,
                        height: 306,
                      ),
                      Positioned(
                        left: 10,
                        bottom: 10,
                        child: Text(
                          userData['Name'],
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Phone: ${userData['phone_number']}",
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
                            "Address: ${userData['address']}",
                            style:
                            TextStyle(
                                fontSize: 16, fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ListView.builder(
                    itemCount: service.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Image.network(
                         service[index]['image'],
                          fit: BoxFit.fill,
                          width: 50,
                          height: 50,
                        ),
                        title: Text(service[index]['name']),
                        subtitle: Text("₹${service[index]['price']}"),
                        trailing: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              serviceID = service[index]['service_id'];
                              totalPrice = service[index]['price'].toString();
                              selectedServiceIndex =
                              selectedServiceIndex == index ? null : index;
                            });
                          },
                          child: Text(
                            selectedServiceIndex == index ? "REMOVE" : "SELECT",
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          if (selectedServiceIndex != null)
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total: ₹$totalPrice",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Slotbook(
                          salonId: userData["id"],
                          serviceId: serviceID,
                          totalPrice: totalPrice,
                          userId: userID,
                        )),
                      );
                    },
                    child: Text(
                      "Continue",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
