import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:health_monitoring_system/utils/constant/color.dart';
import 'package:health_monitoring_system/views/authentication/patient_login.dart';

import 'authentication/signin.dart';
import 'authentication/signup.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final devSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      width: devSize.width,
      height: devSize.height,
      // padding:
      //     const EdgeInsets.only(top: 60.0, bottom: 100, left: 16, right: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topLeft,
          colors: [Colors.black, ColorsRes.purple],
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 70,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to',
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2),
              ),
              Text(
                ' Health Monitoring',
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.green.shade400,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2),
              ),
            ],
          ),
          Image.asset("assets/images/doctor_emoji.png"),
          GestureDetector(
            onTap: () {
              Get.to(() => PatientSignin(),
                  duration: Duration(milliseconds: 500),
                  transition: Transition.rightToLeft);
            },
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25), color: Colors.green),
              child: Center(
                  child: Text('Patient Sign In',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500))),
            ),
          ),
          SizedBox(height: 24.0),
          GestureDetector(
            onTap: () {
              Get.to(() => SigninScreen(),
                  duration: Duration(milliseconds: 500),
                  transition: Transition.rightToLeft);
            },
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25), color: Colors.green),
              child: Center(
                  child: Text('Dotor Sign In',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500))),
            ),
          ),
          SizedBox(height: 24.0),
          GestureDetector(
            onTap: () {
              Get.to(() => SignupScreen(),
                  duration: Duration(milliseconds: 500),
                  transition: Transition.rightToLeft);
            },
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white),
              child: Center(
                  child: Text('Doctor Sign Up',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.w500))),
            ),
          ),
          Spacer()
        ],
      ),
    ));
  }
}
