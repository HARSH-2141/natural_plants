import 'dart:convert';
import 'dart:io';

import 'package:demo/CommonWidget/APIConst.dart';
import 'package:demo/Salon_Manager/SalonManagerDashboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart ' as http;


class SaloonUpdateService extends StatefulWidget {
  var serviceDetail;
  SaloonUpdateService({required this.serviceDetail});

  @override
  _SaloonUpdateServiceState createState() => _SaloonUpdateServiceState();
}

class _SaloonUpdateServiceState extends State<SaloonUpdateService> {
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _descriptionControroller = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  var vehicledata;
  String? data;
  String? serviceId = "";

  File? _image;
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData(){
    var userData = widget.serviceDetail; // Extract first user
    setState(() {
      isLoading = false;
      serviceId = userData["service_id"] ?? "";
      _serviceNameController.text = userData["name"] ?? "";
      _priceController.text = userData["price"] ?? "";
      _durationController.text = userData["duration"] ?? "";
      _descriptionControroller.text = userData["description"] ?? "";
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Service"),
        backgroundColor: Colors.white,
      ),
      body:isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: Colors.green,
        ),
      )
          :  Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _serviceNameController,
                decoration: InputDecoration(
                  labelText: "Service Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter service name";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _descriptionControroller,
                decoration: InputDecoration(
                  labelText:"Description",
                  border: OutlineInputBorder(),
                ),
                validator: (value){
                  if (value==null||value.isEmpty){
                    return"Please enter description";
                  }
                  return null;
                }
              ),

              SizedBox(height: 16),
              //
              // GestureDetector(
              //   onTap: _pickImage,
              //   child: Container(
              //     height: 150,
              //     decoration: BoxDecoration(
              //       border: Border.all(color: Colors.grey),
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     child: _image == null
              //         ? Center(child: Text("Tap to select image"))
              //         : Image.file(_image!, fit: BoxFit.cover),
              //   ),
              // ),
              SizedBox(height: 16),

              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Price",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter price";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Duration (in minutes)",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter duration";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    uploadImageMedia(_image);
                  }
                },
                child: Text("Save Service"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  uploadImageMedia(File? fileImage) async {
    final form = _formKey.currentState;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('uid'));
    if (form!.validate()) {
      setState(() {
        isLoading = true;
      });
    }

    final imageUploadRequest = http.MultipartRequest(
      'POST',
      Uri.parse("${ApiConst.base_url}salon/update_services.php"),
    );

    // Add headers
    imageUploadRequest.headers['Cookie'] = ApiConst.cookie;
    imageUploadRequest.headers['User-Agent'] = ApiConst.user_agent;

    // Add required form fields
    imageUploadRequest.fields['service_id'] = serviceId!;
    imageUploadRequest.fields['salon_id'] = prefs.getString('uid') ?? "";
    imageUploadRequest.fields['name'] = _serviceNameController.text;
    imageUploadRequest.fields['price'] = _priceController.text;
    imageUploadRequest.fields['duration'] = _durationController.text;
    imageUploadRequest.fields['description'] = _descriptionControroller.text;

    // Add image only if provided
    if (fileImage != null) {
      final mimeTypeData =
      lookupMimeType(fileImage.path, headerBytes: [0xFF, 0xD8])?.split('/');

      if (mimeTypeData != null) {
        final file = await http.MultipartFile.fromPath(
          'image',
          fileImage.path,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
        );
        imageUploadRequest.files.add(file);
      }
    }

    try {
      isLoading = true;

      final streamedResponse = await imageUploadRequest.send();

      streamedResponse.stream.transform(utf8.decoder).listen((value) {
        setState(() {
          isLoading = false;
        });

        if (streamedResponse.statusCode == 200) {
          vehicledata = jsonDecode(value);

          Fluttertoast.showToast(
            msg: vehicledata['message'].toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
          );

          if (vehicledata['error'] == false) {
            Navigator.of(context).pop();
          }
        } else {
          Fluttertoast.showToast(
            msg: "Something went wrong",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
          );
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
        msg: "Error: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
      );
      print(e);
    }
  }


}