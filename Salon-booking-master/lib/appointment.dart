import 'dart:convert';

import 'package:demo/CommonWidget/APIConst.dart';
import 'package:demo/FeedbackScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BookingHistoryScreen extends StatefulWidget {
  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  String? data;
  String? userID;
  String? serviceID;
  List<dynamic> booking = [];
  bool isLoading = false;
  var userData;

  void getData() async {
    SharedPreferences setpreference =
    await SharedPreferences.getInstance();

    setState(() {
      userID = setpreference.getString('uid');
      isLoading = true;
    });
    var url = Uri.parse("${ApiConst.base_url}user/fetch_booking.php");
    var response = await http.post(
      url,
      headers: {'cookie': ApiConst.cookie, 'User-Agent': ApiConst.user_agent},
      body: {'user_id':  userID,},
    );
    print(response.body);
    var decodedData = jsonDecode(response.body);
    setState(() {
      booking = decodedData['data'] ?? [];
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
        title: Text('Booking History'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body:isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: Colors.green,
        ),
      )
          : booking.isNotEmpty ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: booking.length,
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 3,
              margin: EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(booking[index]['totalamount'], style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("${booking[index]['timestamp']}"),
                trailing: booking[index]['status'] == "1" ? ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RatingScreen(salonID: booking[index]['salon_id'],),
                      ),
                    );
                  },

                  child: Text("Give Feedback"),
                ):  ElevatedButton(
                  onPressed: () {
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white54,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text( booking[index]['status'] == '0'
                      ? 'Pending'
                      :  booking[index]['status'] == '1' ? 'Accepted': 'Rejected'),
                ),
              ),
            );
          },
        ),
      ):Center(
          child: Text("No booking available",
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold))),
    );
  }
}
