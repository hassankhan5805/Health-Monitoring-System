import 'package:demo_button/screens/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_lamp.dart';

class VerificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff040F23),
        title: Text(
          'Email Verification',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              'Verification Link has been sent to your email address. Please click on the link to verify your email address. If email is not found, check your spam folder.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 20)),
          SizedBox(height: 40),
          GestureDetector(
            onTap: () async {
              final User _user = FirebaseAuth.instance.currentUser;
              await _user.reload().then((value) {
                if (_user.emailVerified) {
                  setStatus();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddLmap(),
                    ),
                  );
                } else {
                  _showMyDialog(context);
                }
              });
            },
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Color(0xff040F23)),
              child: Center(
                  child:
                      Text('Continue', style: TextStyle(color: Colors.white))),
            ),
          ),
        ],
      ),
    );
  }

  void setStatus() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences preferences = await _prefs;
    preferences.setInt('Log', 2);
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Verification Error'),
          content: Text('Please verify your email address and try again.'),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
