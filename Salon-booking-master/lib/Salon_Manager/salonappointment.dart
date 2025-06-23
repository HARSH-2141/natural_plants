import 'dart:convert';

import 'package:demo/CommonWidget/APIConst.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart ' as http;

class salonappointment extends StatefulWidget {
  @override
  State<salonappointment> createState() => _salonappointmentState();
}

class _salonappointmentState extends State<salonappointment> {
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
    var url = Uri.parse("${ApiConst.base_url}salon/salon_fetch_booking.php");
    var response = await http.post(
      url,
      headers: {'cookie': ApiConst.cookie, 'User-Agent': ApiConst.user_agent},
      body: {'salon_id':  userID,},
    );
    print(response.body);
    var decodedData = jsonDecode(response.body);
    setState(() {
      booking = decodedData['bookings'] ?? [];
      isLoading = false;
    });
  }

  void _updateBookingStatus(String bookingId, String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse("${ApiConst.base_url}user/update_booking.php");
    var response = await http.post(url, headers: {
      'cookie': ApiConst.cookie,
      'User-Agent': ApiConst.user_agent
    }, body: {
      "booking_id": bookingId,
      "status": status,
    });
    print(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['error'] == false) {
        setState(() {
         getData();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
      }
    }
  }

  void _showStatusConfirmationDialog(
      BuildContext context, String bookingId, String status) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(status == '1' ? "Accept Booking" : "Reject Booking"),
          content: Text(status == '1'
              ? "Are you sure you want to accept this booking?"
              : "Are you sure you want to reject this booking?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateBookingStatus(bookingId, status);
              },
              child: Text(
                status == '1' ? "Accept" : "Reject",
                style:
                TextStyle(color: status == '1' ? Colors.green : Colors.red),
              ),
            ),
          ],
        );
      },
    );
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
        title: Text('Salon Appointment'),
        backgroundColor: Colors.white,
      ),
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
                  if (booking[index]['status'] == '0') ...[
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () =>
                                _showStatusConfirmationDialog(context,
                                    booking[index]['booking_id'].toString(), '1'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            child: Text('Accept'),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () =>
                                _showStatusConfirmationDialog(context,
                                    booking[index]['booking_id'].toString(), '2'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: Text('Reject'),
                          ),
                        ),
                      ],
                    )
                  ] else ...[
                    Text(
                      booking[index]['status'] == '1'
                          ? 'Accepted'
                          : 'Rejected',
                      style: TextStyle(
                        color: booking[index]['status'] == '1'
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}