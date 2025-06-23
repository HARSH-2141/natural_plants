import 'dart:convert';
import 'package:demo/CommonWidget/APIConst.dart';
import 'package:demo/Salon_Manager/addservice.dart';
import 'package:demo/Salon_Manager/saloon_update_service.dart';
import 'package:http/http.dart ' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class Managerservicelistpage extends StatefulWidget {
  const Managerservicelistpage({super.key});

  @override
  State<Managerservicelistpage> createState() => _ManagerservicelistpageState();
}

class _ManagerservicelistpageState extends State<Managerservicelistpage> {
  String? data;
  var saloon;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getSaloon();
  }

  void getSaloon() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isLoading = true;
    });
    var url = Uri.parse("${ApiConst.base_url}salon/salon_fetch_service.php");

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
      saloon = jsonDecode(data!)["services"];
    });
  }

  void _showDeleteConfirmationDialog(BuildContext context, String serviceId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Service"),
          content: Text("Are you sure you want to delete this Service?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteService(serviceId);
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _deleteService(String serviceId) async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.parse("${ApiConst.base_url}salon/delete_service.php");
    var response = await http.post(url, headers: {
      'cookie': ApiConst.cookie,
      'User-Agent': ApiConst.user_agent
    }, body: {
      "service_id": serviceId,
    });
    print(response.body);
    if (response.statusCode == 200) {
      getSaloon();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Service deleted successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete Service")),
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
          "Manage Service",
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
              if (saloon != null) ...[
                Container(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),

                    scrollDirection: Axis.vertical, // Vertical list
                    itemCount: saloon.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SaloonUpdateService(
                                      serviceDetail: saloon[index]),
                            ),
                          ).whenComplete((){
                            getSaloon();
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
                                // Left Side: Vehicle Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    saloon[index]['image'],
                                    height: 150,
                                    width: 150,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                SizedBox(
                                    width:
                                    10), // Space between image & details
                                // Right Side: Vehicle Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            saloon[index]['name'],
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
                                        MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.ev_station,
                                              size: 16),
                                          SizedBox(width: 5),
                                          Text(
                                            "Duration ${saloon[index]['duration']}",
                                            style:
                                            TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "₹ ${saloon[index]['price']}",
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
                                                  saloon[index]['service_id']);
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
                    child: Text("No Service available",
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
                builder: (context) => addservice()),
          ).whenComplete(() {
            getSaloon();
          });
        },
        child: const Icon(Icons.add, color: Colors.white, size: 30),
        backgroundColor: Colors.green,
      ),
    );
  }
}
