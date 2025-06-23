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
import 'package:shared_preferences/shared_preferences.dart';


class EditProfileScreen extends StatefulWidget {
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
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
  String? profiledata;
  var profile;

  void getData() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = Uri.parse("${ApiConst.base_url}user/fetch_profile_detail.php");
    var response = await http.post(
        url,
        headers: {
          'cookie': ApiConst.cookie,
          'User-Agent': ApiConst.user_agent,
        },
        body: {
          'user_id': prefs.getString('uid')!,
        }
    );
    print(response.body);
    profiledata = response.body;
    setState(() {
      isLoading = false;

      profile = jsonDecode(profiledata!)['user'];
      nameController.text = profile['Name'];
      emailController.text = profile['email'];
      passwordController.text =profile['password'];
      phoneNumberController.text = profile['phone_number'];
      addressController.text = profile['address'];
    });
  }


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
  void initState() {
    getData();
    super.initState();
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
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white,)),
                      Text('Edit Profile',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),)
                    ],
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: pickImage,
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey[300],
                              child: ClipOval(
                                child: pickedFile != null
                                    ? Image.file(
                                  File(pickedFile!.path),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.fill,
                                )
                                    : profile["dp"] != null
                                    ? Image.network(
                                 ApiConst.base_url+profile["dp"],
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.fill,
                                )
                                    : Icon(
                                  Icons.camera_alt,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                              bottom: 0,
                              left: 70,
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: new BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
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
                  Center(
                    child: ElevatedButton(
                        onPressed: () {
                          uploadImageMedia(pickedFile != null ? File(pickedFile!.path) : null);
                        },
                        child: Text('Update')),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  uploadImageMedia(File? fileImage) async {
    SharedPreferences setpreference =
    await SharedPreferences.getInstance();

    final form = formKey.currentState;
    if (form!.validate()) {
      setState(() {
        isLoading = true;
      });
    }

    final imageUploadRequest = http.MultipartRequest(
      'POST',
      Uri.parse("${ApiConst.base_url}new_update_profile.php"),
    );

    imageUploadRequest.headers['Cookie'] = ApiConst.cookie;
    imageUploadRequest.headers['User-Agent'] = ApiConst.user_agent;

    imageUploadRequest.fields['id'] = setpreference.getString('uid')!;
    imageUploadRequest.fields['Name'] = nameController.text;
    imageUploadRequest.fields['email'] = emailController.text;
    imageUploadRequest.fields['phone_number'] = phoneNumberController.text;
    imageUploadRequest.fields['password'] = passwordController.text;
    imageUploadRequest.fields['address'] = addressController.text;

    // **Only add the image file if it is not null**
    if (fileImage != null) {
      final mimeTypeData =
      lookupMimeType(fileImage.path, headerBytes: [0xFF, 0xD8])?.split('/');
      final file = await http.MultipartFile.fromPath(
        'dp',
        fileImage.path,
        contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
      );
      imageUploadRequest.files.add(file);
    }

    try {
      isLoading = true;

      final streamedResponse = await imageUploadRequest.send();

      streamedResponse.stream.transform(utf8.decoder).listen((value) {
        setState(() {
          isLoading = false;
        });

        if (streamedResponse.statusCode == 200) {
          logindata = jsonDecode(value);
          Fluttertoast.showToast(
            msg: logindata['message'].toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
          );

          if (logindata['error'] == false) {
            setpreference.setString('uname', nameController.text);
            setpreference.setString('email', emailController.text);
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
      print(e);
    }
  }

}
