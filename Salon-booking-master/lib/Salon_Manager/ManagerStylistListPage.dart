import 'dart:convert';
import 'package:demo/CommonWidget/APIConst.dart';
import 'package:demo/Salon_Manager/AddStylistDetailScreen.dart';
import 'package:demo/Salon_Manager/UpdateStylistDetailScreen.dart';
import 'package:demo/Salon_Manager/addservice.dart';
import 'package:demo/Salon_Manager/saloon_update_service.dart';
import 'package:http/http.dart ' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class Managerstylistlistpage extends StatefulWidget {
  const Managerstylistlistpage({super.key});

  @override
  State<Managerstylistlistpage> createState() => _ManagerstylistlistpageState();
}

class _ManagerstylistlistpageState extends State<Managerstylistlistpage> {
  String? data;
  var stylist;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getStylist();
  }

  void getStylist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isLoading = true;
    });
    var url = Uri.parse("${ApiConst.base_url}salon/salon_fetch_stylist.php");

    var response = await http.post(url, headers: {
      'cookie': ApiConst.cookie,
      'User-Agent': ApiConst.user_agent
    }, body: {
      "salon_id": prefs.getString('uid')!,
    });
    print(response.body);
    setState(() {
      isLoading = false;
    });
    data = response.body;
    setState(() {
      stylist = jsonDecode(data!)["stylists"];
    });
  }

  void _showDeleteConfirmationDialog(BuildContext context, String serviceId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Stylist"),
          content: Text("Are you sure you want to delete this Stylist?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteStylist(serviceId);
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _deleteStylist(String stylistId) async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.parse("${ApiConst.base_url}salon/delete_stylist.php");
    var response = await http.post(url, headers: {
      'cookie': ApiConst.cookie,
      'User-Agent': ApiConst.user_agent
    }, body: {
      "stylist_id": stylistId,
    });
    print(response.body);
    if (response.statusCode == 200) {
      getStylist();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Stylist deleted successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete Stylist")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        foregroundColor: Colors.black,
        elevation: 0,
        backgroundColor: Colors.green,
        title: Text(
          "Manage Stylist",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: Colors.green,
        ),
      )
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (stylist != null) ...[
                Container(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),

                    scrollDirection: Axis.vertical, // Vertical list
                    itemCount: stylist.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UpdateStylistDetailScreen(
                                      stylistDetail: stylist[index]),
                            ),
                          ).whenComplete((){
                            getStylist();
                          });
                        },
                        child: Card(
                          color: Color(0xFFF5F5F5), // Light Grey

                          elevation: 5,
                          margin: EdgeInsets.symmetric(
                              horizontal: 8, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            stylist[index]['name'],
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Experience: ${stylist[index]['experience']}",
                                            style:
                                            TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Speciality: ${stylist[index]['speciality']}",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color:
                                              Colors.green.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              _showDeleteConfirmationDialog(
                                                  context,
                                                  stylist[index]['stylist_id']);
                                            },
                                            child: Text(
                                              "Delete",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight:
                                                  FontWeight.bold),
                                            ),
                                            style: ButtonStyle(
                                              foregroundColor:
                                              MaterialStateProperty
                                                  .all<Color>(
                                                  Colors.white),
                                              backgroundColor:
                                              MaterialStateProperty
                                                  .all<Color>(Colors
                                                  .green
                                                  .shade500),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ] else ...[
                Center(
                    child: Text("No stylist available",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold))),
              ],
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddStylistdetailscreen()),
          ).whenComplete(() {
            getStylist();
          });
        },
        child: const Icon(Icons.add, color: Colors.white, size: 30),
        backgroundColor: Colors.green,
      ),
    );
  }
}
