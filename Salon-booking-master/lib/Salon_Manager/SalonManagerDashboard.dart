import 'package:demo/Admin/about.dart';
import 'package:demo/CommonWidget/EditProfileScreen.dart';
import 'package:demo/FeedbackScreen.dart';
import 'package:demo/LoginScreen.dart';
import 'package:demo/Salon_Manager/AddStylistDetailScreen.dart';
import 'package:demo/Salon_Manager/ManagerServiceListPage.dart';
import 'package:demo/Salon_Manager/ManagerSlotListPage.dart';
import 'package:demo/Salon_Manager/ManagerStylistListPage.dart';
import 'package:demo/Salon_Manager/addservice.dart';
import 'package:demo/Salon_Manager/salonappointment.dart';
import 'package:demo/Salon_Manager/viewreview.dart';
import 'package:demo/appointment.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Salonmanagerdashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SelectionScreen(),
    );
  }
}

class SelectionScreen extends StatefulWidget {
  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  final List<Map<String, dynamic>> stores = [
    {
      'name': 'ADD Stylist',
      'description': 'ADD Stylist NAME, experience',
      'color': Colors.pink.shade100,
      'route': Managerstylistlistpage(),
    },
    {
      'name': 'ADD SERVICE',
      'description': 'ADD SERVICE, STYLIST,UPLOAD IMAGE, PRICE, DURATION',
      'color': Colors.lime.shade300,
      'route' : Managerservicelistpage(),
    },
    {
      'name': 'ADD Slot',
      'description': 'ADD SLOT',
      'color': Colors.lime.shade300,
      'route' : ManagerSlotListPage(),
    },
    {
      'name': 'APPOINTMENT',
      'description': 'VIEW APPOINTMENT',
      'color': Color(0xFFFAFFC5),
      'route': salonappointment()
    },
    {
      'name': 'FEEDBACK',
      'description': 'MANAGE FEEDBACK',
      'color': Colors.black12,
      'route' :viewreview()
    },
  ];
  String userName = "a";
  String userEmail = "";

  getSelectedValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('uname')!;
      userEmail = prefs.getString('email')!;
    });
  }

  @override
  void initState() {
    getSelectedValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('ADD'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: stores.length,
          itemBuilder: (context, index) {
            final store = stores[index];
            return StoreCard(
              name: store['name'],
              description: store['description'],
              color: store['color'],
              onTap: store.containsKey('route')
                  ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => store['route'],
                  ),
                );
              }
                  : null, // Allow null values for onTap
            );
          },
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Color(0xff66023c)),
              accountName: Text(
                userName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(
                userEmail,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  userName[0].toString().toUpperCase(),
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person_pin_outlined, color: Colors.red),
              title: Text("Edit Profile"),
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=>EditProfileScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.info_outline, color: Colors.red),
              title: Text("About Us"),
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=>about()));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text("Logout"),
              onTap: (){
                showDialog(
                    context: context,
                    builder:(context) =>AlertDialog(
                      title: Text("Logout"),
                      content: Text("Are you sure want to log out?"),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Cancel")
                        ),
                        TextButton(
                            onPressed: () async {
                              final pref = await SharedPreferences.getInstance();
                              await pref.clear();
                              await pref.setBool('seen', true);
                              Navigator.pop(context);
                              Navigator.pushAndRemoveUntil(
                                  context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                              (route) => false,
                              );
                            },
                          child: Text("Logout"),

                        ),


                      ],
                    )) ;
              },
            ),
          ],
        ),
      ),
    );
  }
}

class StoreCard extends StatelessWidget {
  final String name;
  final String description;
  final VoidCallback? onTap; // Change VoidCallback to VoidCallback?
  final Color color;

  StoreCard({
    required this.name,
    required this.description,
    required this.color,
    this.onTap, // Allow null values for onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(16),
          title: Text(name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          subtitle: Text(description, style: TextStyle(fontSize: 14)),
        ),
      ),
    );
  }
}
