import 'dart:convert';

import 'package:demo/CommonWidget/APIConst.dart';
import 'package:demo/appointment.dart';
import 'package:demo/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RatingScreen extends StatefulWidget {
  final String salonID;

  RatingScreen({
    required this.salonID,
  });

  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double _rating = 3.0;
  final TextEditingController _descriptioncontroller = TextEditingController();

  final formKey = new GlobalKey<FormState>();
  var logindata;
  var data;
  var bookingid = "";
  String userid = "";

  bool isLoading = false;

  @override
  void initState() {
    getSelectedValue();
    super.initState();
  }

  getSelectedValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString('uid')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Rate Your Experience")),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _descriptioncontroller,
                      decoration: InputDecoration(
                          labelText: "Description",
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Rating",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    RatingBar.builder(
                      initialRating: _rating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          _rating = rating;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _submit();
                      },
                      child: Text(
                        "Submit",
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _submit() async {
    final form = formKey.currentState;
    if (form!.validate()) {
      setState(() {
        isLoading = true;
      });

      final login_url = Uri.parse("${ApiConst.base_url}user/add_feedback.php");
      final response = await http.post(login_url, headers: {
        'cookie': ApiConst.cookie,
        'User-Agent': ApiConst.user_agent
      }, body: {
        "user_id": userid,
        "salon_id": widget.salonID,
        "rating": _rating.toString(),
        "review": _descriptioncontroller.text,
      });

      print(response.body);
      if (response.statusCode == 200) {
        logindata = jsonDecode(response.body);
        setState(() {
          isLoading = false;
        });

        if (logindata['error'] == false) {
          // Feedback successfully submitted
          Fluttertoast.showToast(
            msg: logindata['message'].toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
          );
          // Navigate back to the previous page
          _showSuccessPopup(context);
        } else {
          // If feedback already exists, show a SnackBar message
          if (logindata['message'].toString().toLowerCase().contains(
              "feedback for this booking and vehicle already exists")) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Feedback has already been submitted for this vehicle!'),
                backgroundColor: Colors.red,
              ),
            );
          } else {
            Fluttertoast.showToast(
              msg: logindata['message'].toString(),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2,
            );
          }
        }
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit feedback. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showSuccessPopup(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Thank You"),
            content: Text("Thank You For Feedback"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DashboardPage()),
                        (route) => false);
                  },
                  child: Text("OK"))
            ],
          );
        });
  }
}
