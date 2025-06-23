import 'dart:convert';

import 'package:demo/CommonWidget/APIConst.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart ' as http;


class AdminPaymentList extends StatefulWidget {
  const AdminPaymentList({super.key});

  @override
  State<AdminPaymentList> createState() => _AdminPaymentListState();
}

class _AdminPaymentListState extends State<AdminPaymentList> {
  String? selectedPaymentMethod;
  String? data;
  String? userID;
  String? serviceID;
  List<dynamic> payment = [];
  bool isLoading = false;
  var userData;

  void getData() async {
    SharedPreferences setpreference =
    await SharedPreferences.getInstance();

    setState(() {
      userID = setpreference.getString('uid');
      isLoading = true;
    });
    var url = Uri.parse("${ApiConst.base_url}admin/payment_fetch_admin.php");
    var response = await http.get(
      url,
      headers: {'cookie': ApiConst.cookie, 'User-Agent': ApiConst.user_agent},
    );
    print(response.body);
    var decodedData = jsonDecode(response.body);
    setState(() {
      payment = decodedData['payments'] ?? [];
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
      appBar: AppBar(
        title: Text("Payment methods"),
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: Colors.green,
        ),
      )
          : payment.isNotEmpty ? ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: payment.length,
        itemBuilder: (context,index){
          return Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xff66023c),
                  child: Text(
                    payment[index]["user_id"][0].toString().toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Payed amount: ${payment[index]["amount"]}",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Date: ${payment[index]["timestamp"]}",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Mode of payment: ${payment[index]["method"]}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      ):Center(
          child: Text("No payment available",
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold))),
    );
  }
}