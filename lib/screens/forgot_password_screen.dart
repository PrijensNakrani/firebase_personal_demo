import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _email = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("ForgotPassword"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Recive an Email to Reset Password",
                textScaleFactor: 1.5,
              ),
              const SizedBox(
                height: 50,
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  decoration: const InputDecoration(hintText: "Email"),
                  controller: _email,
                  // validator: (value) {
                  //   RegExp regex = RegExp(
                  //       r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                  //   if (!regex.hasMatch(value!)) {
                  //     return "Enter valid Email";
                  //   }
                  //   return null;
                  // },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              MaterialButton(
                onPressed: () {
                  try {
                    FirebaseAuth.instance
                        .sendPasswordResetEmail(email: _email.text);
                  } on FirebaseAuthException catch (e) {
                    log('ERROR++>>${e.message}');
                    log('ERROR++>>${e.code}');
                    log('ERROR++>>${e.email}');
                  }
                },
                child: const Text("Reset Password"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
