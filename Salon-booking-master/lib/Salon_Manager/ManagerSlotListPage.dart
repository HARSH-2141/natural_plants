import 'dart:convert';
import 'package:demo/CommonWidget/APIConst.dart';
import 'package:demo/Salon_Manager/AddSlotDetailScreen.dart';
import 'package:demo/Salon_Manager/AddStylistDetailScreen.dart';
import 'package:demo/Salon_Manager/UpdateSlotDetailScreen.dart';
import 'package:demo/Salon_Manager/UpdateStylistDetailScreen.dart';
import 'package:demo/Salon_Manager/addservice.dart';
import 'package:demo/Salon_Manager/saloon_update_service.dart';
import 'package:http/http.dart ' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ManagerSlotListPage extends StatefulWidget {
  const ManagerSlotListPage({super.key});

  @override
  State<ManagerSlotListPage> createState() => _ManagerSlotListPageState();
}

class _ManagerSlotListPageState extends State<ManagerSlotListPage> {
  String? data;
  var slot;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getSlot();
  }

  void getSlot() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isLoading = true;
    });
    var url = Uri.parse("${ApiConst.base_url}salon/salon_fetch_slot.php");

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
      slot = jsonDecode(data!)["slots"];
    });
  }

  void _showDeleteConfirmationDialog(BuildContext context, String serviceId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete slot"),
          content: Text("Are you sure you want to delete this slot?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteSlot(serviceId);
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _deleteSlot(String slotId) async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.parse("${ApiConst.base_url}salon/delete_slot.php");
    var response = await http.post(url, headers: {
      'cookie': ApiConst.cookie,
      'User-Agent': ApiConst.user_agent
    }, body: {
      "slot_id": slotId,
    });
    print(response.body);
    if (response.statusCode == 200) {
      getSlot();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Slot deleted successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete Slot")),
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
          "Manage Slot",
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
              if (slot != null) ...[
                Container(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),

                    scrollDirection: Axis.vertical, // Vertical list
                    itemCount: slot.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UpdateSlotDetailScreen(
                                      slotDetail: slot[index]),
                            ),
                          ).whenComplete((){
                            getSlot();
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
                                            'Date: ${slot[index]['date']}',
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
                                            "Start Time: ${slot[index]['start_time']}",
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
                                            "End Time: ${slot[index]['end_time']}",
                                            style: TextStyle(
                                              fontSize: 14,
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
                                                  slot[index]['slot_id']);
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
                    child: Text("No slot available",
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
                builder: (context) => AddSlotDetailScreen()),
          ).whenComplete(() {
            getSlot();
          });
        },
        child: const Icon(Icons.add, color: Colors.white, size: 30),
        backgroundColor: Colors.green,
      ),
    );
  }
}
