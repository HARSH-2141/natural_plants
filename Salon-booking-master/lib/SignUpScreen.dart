import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:demo/CommonWidget/APIConst.dart';
import 'package:demo/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';


class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController documentController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  final formKey = new GlobalKey<FormState>();
  bool hideShowPassword = true;
  var logindata;
  var data;
  bool isLoading = false;
  String role = "1";
  final ImagePicker _picker = ImagePicker();
  XFile? pickedFile;
  dynamic _pickImageError;

  Future<void> pickImage() async {
    try {
      pickedFile = await _picker.pickImage(
        maxHeight: 250,
        maxWidth: 550,
        source: ImageSource.gallery,
      );
      setState(() {
        documentController.text = pickedFile!.path.toString();
        print(pickedFile);
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: Colors.greenAccent,
        ),
      )
          :Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/image/background_image.jpg", // Change to your image
            fit: BoxFit.cover,
          ),
          // Blur Effect
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: 8, sigmaY: 8), // Adjust blur intensity
              child: Container(
                color: Colors.white24.withOpacity(0.3), // Dark overlay
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white,)),
                  SizedBox(height: 20),
                  Text(
                    "Let's Get Started",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person),
                      labelText: 'Username',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide()),

                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter username";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email),
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter Email";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: phoneNumberController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.phone),
                      labelText: 'Phone',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter Phone";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.password),
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter Password"; //
                      }
                      return null; //
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.password),
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter Confirm Password";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: documentController,
                    readOnly: true,
                    onTap: () {
                      pickImage();
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.document_scanner),
                      labelText: 'Profile Image',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Upload a Profile image";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person),
                      labelText: 'Address',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide()),

                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter address";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Select Role:",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal),
                      ),

                      // User Radio Button
                      Row(
                        children: [
                          Radio(
                            activeColor: Colors.green,
                            value: "1",
                            groupValue: role,
                            onChanged: (value) {
                              setState(() {
                                role = value!;
                              });
                            },
                          ),
                          Text("User"),
                        ],
                      ),

                      // Agency Radio Button
                      Row(
                        children: [
                          Radio(
                            activeColor: Colors.green,
                            value: "2",
                            groupValue: role,
                            onChanged: (value) {
                              setState(() {
                                role = value!;
                              });
                            },
                          ),
                          Text("Saloon"),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                      onPressed: () {
                        _submit(File(pickedFile!.path));
                      },
                      child: Text('SUBMIT')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future<void> _submit(File fileImage) async {
    final form = formKey.currentState;
    if (form!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        final mimeTypeData =
        lookupMimeType(fileImage.path, headerBytes: [0xFF, 0xD8])?.split('/');

        final imageUploadRequest = http.MultipartRequest(
          'POST',
          Uri.parse("${ApiConst.base_url}register.php"),
        );

        // Add headers
        imageUploadRequest.headers['Cookie'] = ApiConst.cookie;
        imageUploadRequest.headers['User-Agent'] = ApiConst.user_agent;

        // Add text fields
        imageUploadRequest.fields['Name'] = nameController.text;
        imageUploadRequest.fields['email'] = emailController.text;
        imageUploadRequest.fields['phone_number'] = phoneNumberController.text;
        imageUploadRequest.fields['password'] = passwordController.text;
        imageUploadRequest.fields['address'] = addressController.text;
        imageUploadRequest.fields['Role'] = role;
        // Add image file
        final file = await http.MultipartFile.fromPath(
          'dp',
          fileImage.path,
          contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
        );
        imageUploadRequest.files.add(file);

        // Send request
        final streamedResponse = await imageUploadRequest.send();

        // Handle response
        streamedResponse.stream.transform(utf8.decoder).listen((value) {
          setState(() {
            isLoading = false;
          });

          final logindata = jsonDecode(value);

          if (streamedResponse.statusCode == 200 && logindata['error'] == false) {
            Fluttertoast.showToast(
              msg: logindata['message'].toString(),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2,
            );

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false,
            );
          } else {
            Fluttertoast.showToast(
              msg: logindata['message'].toString(),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2,
            );
          }

          print("Response: $value");
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        print("Error: $e");
        Fluttertoast.showToast(
          msg: "Something went wrong",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
        );
      }
    }
  }
}
