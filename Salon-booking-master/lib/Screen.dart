
import 'package:demo/Admin/AdminDashboardPage.dart';
import 'package:demo/LoginScreen.dart';
import 'package:demo/Salon_Manager/SalonManagerDashboard.dart';
import 'package:demo/dashboard.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    startTimer();
    super.initState();
  }

  startTimer() {
    var duration = Duration(seconds: 5);
    return Timer(duration, () {
      checkFirstSeen();
    });
  }

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
   if (prefs.getString('uid') != null) {
        if (prefs.getString('urole') != null &&
            prefs.getString('urole') == "0") {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => AdminDashboardPage()),
                  (Route<dynamic> route) => false);
        } else if (prefs.getString('urole') != null &&
            prefs.getString('urole') == "1") {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => DashboardPage()),
                  (Route<dynamic> route) => false);
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => Salonmanagerdashboard()),
                  (Route<dynamic> route) => false);
        }
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
                (Route<dynamic> route) => false);
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white, // Background color
          ),
          child: Center(
            child: Image.asset(
              'assets/image/logo.jpeg', // Replace with your logo image path
              fit: BoxFit.fill, // Ensures the logo scales nicely
            ),
          ),
        ),
    );
  }
}
