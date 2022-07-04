import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_personal_demo/fire_base_service/fire_base_service.dart';
import 'package:firebase_personal_demo/firebase_database/notes_screen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'fb_login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? confirmPass;
  bool isLoading = false;
  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final file = await picker.getImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _image = File(file.path);
      });
    }
  }

  Future uploadUserImage({File? file}) async {
    try {
      var response = firebase_storage.FirebaseStorage.instance
          .ref('user_image')
          .putFile(file!);

      final url = response.storage.ref('user_image').getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      print('ERROR==>>>$e');
    }
  }

  Future addUserData() async {
    final url = await uploadUserImage(file: _image);
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'email': _email.text,
      'password': _password.text,
      'user_image': url
    }).then((value) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotesScreen(),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                GestureDetector(
                  onTap: () {
                    getImage();
                  },
                  child: Container(
                    height: 170,
                    width: 170,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade200,
                    ),
                    child: ClipOval(
                      child: _image == null
                          ? const Icon(
                              Icons.person_outline,
                              size: 100,
                            )
                          : Image.file(
                              _image!,
                              fit: BoxFit.fill,
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _email,
                  validator: (value) {
                    RegExp regex = RegExp(
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                    if (!regex.hasMatch(value!)) {
                      return "Enter valid Email";
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: "Email",
                    hintText: "Email",
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _password,
                  validator: (value) {
                    confirmPass = value;
                    RegExp regex = RegExp(
                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                    if (!regex.hasMatch(value!)) {
                      return "Enter valid password";
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: "password",
                    hintText: "password",
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  validator: (value) {
                    if (confirmPass != value) {
                      return "Password must be same";
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: "Confirm password",
                    hintText: "Confirm password",
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            FireBaseAuthService.registerUser(
                                    email: _email.text,
                                    password: _password.text)
                                .then(
                              (user) async {
                                if (user != null) {
                                  setState(() {
                                    isLoading = false;
                                  });

                                  addUserData();
                                  print("${FirebaseAuth.instance.currentUser}");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text("Sign Up sucssesfully")));
                                } else {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("user Already Exist"),
                                    ),
                                  );
                                }
                              },
                            );
                          }
                        },
                        child: Text("Register"),
                      ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FacebookLoginDemo(),
                          ));
                    },
                    child: Text("Login with Facebook"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
