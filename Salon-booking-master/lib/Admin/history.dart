import 'dart:convert';

import 'package:demo/CommonWidget/APIConst.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart ' as http;


class historyscreen extends StatefulWidget {
  @override
  State<historyscreen> createState() => _historyscreenState();
}

class _historyscreenState extends State<historyscreen> {
  String? data;

  String? userID;

  String? serviceID;

  List<dynamic> booking = [];

  bool isLoading = false;

  var userData;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    SharedPreferences setpreference =
    await SharedPreferences.getInstance();

    setState(() {
      userID = setpreference.getString('uid');
      isLoading = true;
    });
    var url = Uri.parse("${ApiConst.base_url}admin/admin_fetch_booking.php");
    var response = await http.get(
      url,
      headers: {'cookie': ApiConst.cookie, 'User-Agent': ApiConst.user_agent},
    );
    print(response.body);
    var decodedData = jsonDecode(response.body);
    setState(() {
      booking = decodedData['bookings'] ?? [];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Booking History")),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: Colors.green,
        ),
      )
          :ListView.builder(
        padding: EdgeInsets.only(left: 16,right: 16),
        itemCount: booking.length,
        itemBuilder: (context, index) {
          return Card(
            color: Color(0xFFF5F5F5),
            margin: EdgeInsets.only(bottom: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "User Name: ${booking[index]['user_name'] ?? 'Unknown username'}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    "Service: ${booking[index]['service_name']}",
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Amount: ${booking[index]['totalamount']}",
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Date: ${booking[index]['timestamp']}",
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    booking[index]['status'] == '0'
                        ? 'Pending'
                        :booking[index]['status'] == '1'
                        ? 'Accepted'
                        : 'Rejected',
                    style: TextStyle(
                      color: booking[index]['status'] == '0'
                          ? Colors.orange
                          : booking[index]['status'] == '1'
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
