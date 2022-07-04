import 'package:firebase_personal_demo/fire_base_service/fire_base_service.dart';
import 'package:firebase_personal_demo/screens/login_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Home screen",
              textScaleFactor: 3,
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                FireBaseAuthService.logOutUSer().then(
                  (value) => ScaffoldMessenger.of(context)
                      .showSnackBar(
                          SnackBar(content: Text("Log Out successfuly")))
                      .closed
                      .whenComplete(
                        () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        ),
                      ),
                );
              },
              child: Text(
                "Log out",
                style: TextStyle(color: Colors.blue),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () {
                FireBaseAuthService.deleteUser().then(
                  (value) => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  ),
                );
              },
              child: Text("Delete User"),
            ),
          ],
        ),
      ),
    );
  }
}
