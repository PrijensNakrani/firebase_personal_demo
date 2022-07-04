import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

String? verificationCode;

class PhoneAuthService {
  static Future getOtp(mobile, context) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      codeAutoRetrievalTimeout: (String verificationId) {},
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Otp sent"),
          ),
        );
      },
      phoneNumber: '+91' + mobile,
      codeSent: (String verificationId, int? forceResendingToken) {
        verificationCode = verificationId;
      },
      verificationFailed: (FirebaseAuthException error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message.toString()),
          ),
        );
      },
    );
  }

  static Future<bool?> veryfiOtp({otp, context}) async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationCode!, smsCode: otp);
    log("${phoneAuthCredential}");
    await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
  }
}
