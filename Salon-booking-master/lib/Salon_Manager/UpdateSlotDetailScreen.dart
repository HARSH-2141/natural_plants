import 'dart:convert';

import 'package:demo/CommonWidget/APIConst.dart';
import 'package:demo/Salon_Manager/SalonManagerDashboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UpdateSlotDetailScreen extends StatefulWidget {
  var slotDetail;
  UpdateSlotDetailScreen({super.key,required this.slotDetail});

  @override
  State<UpdateSlotDetailScreen> createState() => _UpdateSlotDetailScreenState();
}

class _UpdateSlotDetailScreenState extends State<UpdateSlotDetailScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final formKey = new GlobalKey<FormState>();
  var logindata;
  var data;
  bool isLoading = false;
  String? slotId = "";

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData(){
    var userData = widget.slotDetail; // Extract first user
    setState(() {
      isLoading = false;
      slotId = userData["slot_id"] ?? "";
      _dateController.text = userData["date"] ?? "";
      _startTimeController.text = userData["start_time"] ?? "";
      _endTimeController.text = userData["end_time"] ?? "";
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Update Slot') ,),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: Colors.green,
        ),
      )
          : Padding(padding: const EdgeInsets.all(10.0),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _dateController,
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 15)),
                );
                if (pickedDate != null) {
                  setState(() {
                    _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                  });
                }
              },
              decoration: InputDecoration(
                labelText: "Date",
                border: OutlineInputBorder(),
              ),
              validator: (value){
                if (value==null || value.isEmpty){
                  return"Please Enter Date";
                }
                return null;
              }
            ),
            SizedBox(height: 15,),
            TextFormField(
                controller: _startTimeController,
                readOnly: true,
                onTap: () async {
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          primaryColor: Colors.green, // Header background color
                          hintColor: Colors.black, // Hint text color
                          colorScheme: ColorScheme.light(
                            primary: Colors.green, // Selected time color
                            onPrimary: Colors.white, // Text color on selected time
                            onSurface: Colors.black, // Text color on unselected times
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.green, // OK and Cancel buttons color
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (picked != null) {
                    setState(() {
                      _startTimeController.text =  '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                    });
                  }
                },
                decoration: InputDecoration(
                  labelText: "Start Time",
                  border: OutlineInputBorder(),
                ),
                validator: (value){
                  if (value==null || value.isEmpty){
                    return"Please Enter start time ";
                  }
                  return null;
                }
            ),
            SizedBox(height: 15),
            TextFormField(
                controller: _endTimeController,
                readOnly: true,
                onTap: () async {
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          primaryColor: Colors.green, // Header background color
                          hintColor: Colors.black, // Hint text color
                          colorScheme: ColorScheme.light(
                            primary: Colors.green, // Selected time color
                            onPrimary: Colors.white, // Text color on selected time
                            onSurface: Colors.black, // Text color on unselected times
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.green, // OK and Cancel buttons color
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (picked != null) {
                    setState(() {
                      _endTimeController.text =  '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                    });
                  }
                },
                decoration: InputDecoration(
                  labelText: "End Time",
                  border: OutlineInputBorder(),
                ),
                validator: (value){
                  if (value==null || value.isEmpty){
                    return"Please Enter End Time ";
                  }
                  return null;
                }
            ),
            SizedBox(height: 12),

            ElevatedButton(onPressed: (){
              if(formKey.currentState!.validate()){
                _submit();
              }
            },
            child: Text("Submit"),)

          ],
        ),
      ),),

    );
  }

  Future<void> _submit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final form = formKey.currentState;
    if (form!.validate()) {
      setState(() {
        isLoading = true;
      });
      final login_url = Uri.parse("${ApiConst.base_url}salon/update_slot.php");
      final response = await http.post(login_url, headers: {
        'Cookie': ApiConst.cookie,
        'User-Agent': ApiConst.user_agent
      }, body: {
        "salon_id": prefs.getString('uid')!,
        "slot_id": slotId,
        "date": _dateController.text,
        "start_time": _startTimeController.text,
        "end_time": _endTimeController.text,
      });
      print(response.body);
      if (response.statusCode == 200) {
        logindata = jsonDecode(response.body);
        print(logindata);
        setState(() {
          isLoading = false;
        });
        if (logindata['error'] == false) {
          Navigator.pop(context);
          Fluttertoast.showToast(
              msg: logindata['message'].toString(),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2);
        } else {
          Fluttertoast.showToast(
              msg: logindata['message'].toString(),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2);
        }
      }
    }
  }

}

