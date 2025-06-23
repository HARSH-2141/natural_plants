import 'package:demo/Admin/AdminDashboardPage.dart';
import 'package:demo/HomePage.dart';
import 'package:demo/Salon_Manager/SalonManagerDashboard.dart';
import 'package:demo/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:demo/Screen.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home:SplashScreen(),
        );
  }
}
