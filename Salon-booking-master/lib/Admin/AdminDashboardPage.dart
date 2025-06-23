import 'package:demo/Admin/AdminPaymentList.dart';
import 'package:demo/Admin/about.dart';
import 'package:demo/Admin/complain.dart';
import 'package:demo/Admin/history.dart';
import 'package:demo/Admin/salon.dart';
import 'package:demo/Admin/user.dart';
import 'package:demo/CommonWidget/EditProfileScreen.dart';
import 'package:demo/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final List<String> title = ["About Us", "Logout"];
  final List<IconData> icon = [Icons.info_outline, Icons.logout];

  final List<Map<String, dynamic>> example=[
    {
    'name': ' View Users',

    'color': Color(0xffB1F2),
    'route':userscreen(),
  },
    {
      'name': 'View Salons',

      'color':Color(0xffB7B1F2),
      'route': salonscreen(),
    },
    {
      'name': 'View Booking ',

      'color': Color(0xffFFDCCC),
      'route': historyscreen(),
    },
    {
      'name': 'View Feedback',

      'color': Color(0xffFBF3B9),
      'route': complainscreen(),
    },
    {
      'name': 'View Payment',

      'color': Color(0xffB7B1F2),
      'route': AdminPaymentList(),
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
      appBar: AppBar(title: Text("ADMIN"),),
      body: SingleChildScrollView(
        child: Column(
          children: [

            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: example.length,
              itemBuilder: (context,index){
                final containers = example[index];
                return  GestureDetector(
                  onTap: containers.containsKey('route')
                      ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => containers['route'],
                      ),
                    );
                  }
                      : null,
                  child: Card(
                    margin: EdgeInsets.only(bottom: 16,left: 16,right: 16),
                   color: containers['color'],
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text( containers['name'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                    ),
                  ),
                );
              }
            )
          ],


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
        )
      ),
    );
  }
}
