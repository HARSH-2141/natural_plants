import 'dart:convert';

import 'package:demo/CommonWidget/APIConst.dart';
import 'package:demo/Salon_Manager/SalonManagerDashboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class AddStylistdetailscreen extends StatefulWidget {
  const AddStylistdetailscreen({super.key});

  @override
  State<AddStylistdetailscreen> createState() => _AddStylistdetailscreenState();
}

class _AddStylistdetailscreenState extends State<AddStylistdetailscreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _specialityController = TextEditingController();
  final formKey = new GlobalKey<FormState>();
  var logindata;
  var data;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Add Stylish') ,),
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
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Stylish Name",
                border: OutlineInputBorder(),
              ),
              validator: (value){
                if (value==null || value.isEmpty){
                  return"Please Enter Salon Name ";
                }
                return null;
              }
            ),
            SizedBox(height: 15,),
            TextFormField(
                controller: _experienceController,
                decoration: InputDecoration(
                  labelText: "Stylish experience",
                  border: OutlineInputBorder(),
                ),
                validator: (value){
                  if (value==null || value.isEmpty){
                    return"Please Enter experience ";
                  }
                  return null;
                }
            ),
            SizedBox(height: 15),
            TextFormField(
                controller: _specialityController,
                decoration: InputDecoration(
                  labelText: "Stylish speciality",
                  border: OutlineInputBorder(),
                ),
                validator: (value){
                  if (value==null || value.isEmpty){
                    return"Please Enter speciality ";
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
      final login_url = Uri.parse("${ApiConst.base_url}salon/addstylist.php");
      final response = await http.post(login_url, headers: {
        'Cookie': ApiConst.cookie,
        'User-Agent': ApiConst.user_agent
      }, body: {
        "salon_id": prefs.getString('uid')!,
        "name": _nameController.text,
        "experience": _experienceController.text,
        "speciality": _specialityController.text,
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

