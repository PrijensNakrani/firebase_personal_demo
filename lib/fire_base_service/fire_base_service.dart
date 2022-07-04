import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';

class FireBaseAuthService {
  static Future<User?> registerUser(
      {required String email, required String password}) async {
    try {
      User? user = (await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password))
          .user;
      if (user != null) {
        print("Sign Up Successfully");
        return user;
      } else {
        print("Sign Up Faild");
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<User?> loginUser(
      {required String email, required String password}) async {
    try {
      User? user = (await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password))
          .user;
      if (user != null) {
        print("logIn Successfully");
        return user;
      } else {
        print("Login Faild");
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future deleteUser() async {
    try {
      FirebaseAuth.instance.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      log('delete ERROR==>>$e');
    }
  }

  static Future logOutUSer() async {
    try {
      FirebaseAuth.instance.signOut();
    } on FirebaseException catch (e) {
      log("$e");
    }
  }

  static Future resetPassword({required String email}) async {
    try {
      FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseException catch (e) {
      log("$e");
    }
  }
}
