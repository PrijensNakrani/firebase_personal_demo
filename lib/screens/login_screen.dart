import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_personal_demo/fire_base_service/fire_base_service.dart';
import 'package:firebase_personal_demo/firebase_database/notes_screen.dart';
import 'package:firebase_personal_demo/screens/forgot_password_screen.dart';
import 'package:firebase_personal_demo/screens/register_screen.dart';
import 'package:flutter/material.dart';

import '../view2/mobile_login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Login",
                    textScaleFactor: 2,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: _email,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter valid email address";
                      }
                    },
                    decoration: const InputDecoration(
                        labelText: "Email",
                        hintText: "Email",
                        enabledBorder: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: _password,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter valid password";
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: "password",
                      hintText: "password",
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : MaterialButton(
                          color: Colors.purple,
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            FireBaseAuthService.loginUser(
                                    email: _email.text,
                                    password: _password.text)
                                .then((user) {
                              if (user != null) {
                                setState(() {
                                  isLoading = false;
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NotesScreen(),
                                  ),
                                );
                                log("${FirebaseAuth.instance.currentUser}");
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text("Login sucssesfully")));
                              } else {
                                setState(() {
                                  isLoading = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: const Text("user invalide")));
                              }
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            child: Text(
                              "Login",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Creat account",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    color: Colors.teal,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MobileLogin(),
                        ),
                      );
                    },
                    child: const Text(
                      "Login with phone no.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    color: Colors.orange,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Forgot Password",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
