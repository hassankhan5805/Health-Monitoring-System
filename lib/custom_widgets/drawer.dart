import 'package:demo_button/firebase/auth.dart';
import 'package:demo_button/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
      void setStatus() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences preferences = await _prefs;
    preferences.setInt('Log', 0);
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Color(0xff333333),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              Text("Hi, Bratin",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white)),
              Spacer(),
              TextButton(
                onPressed: () {
                  signOut().then((value) {
                    if (value == null) {
                      setStatus();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    } else {
                      Fluttertoast.showToast(
                          msg: 'Error Signing Out',
                          textColor: Colors.white,
                          backgroundColor: Colors.red);
                    }
                  });
                },
                child: Text("Logout",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white)),
              ),
              Text("support@novellamptheory.com",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ));
  }
}
