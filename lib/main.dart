import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:health_monitoring_system/controllers/loading.dart';
import 'package:health_monitoring_system/views/homepage.dart';
import 'package:health_monitoring_system/views/welcome.dart';
import 'views/add_module.dart';
import 'firebase_options.dart';
import 'views/authentication/signup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(LoadingController());
  runApp(const CozyApp());
}

class CozyApp extends StatelessWidget {
  const CozyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Health Monitoring',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      initialRoute: '/',
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      if (_auth.currentUser != null) {
        if (FirebaseAuth.instance.currentUser!.displayName!.contains("false")) {
          // Get.off(() => AddModule());//Todo
          Get.off(() => MyHomePage());
        } else
          Get.off(() => SignupScreen(),
              duration: Duration(milliseconds: 500),
              transition: Transition.rightToLeft);
      } else
        Get.offAll(WelcomeScreen());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final devSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      width: devSize.width,
      height: devSize.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topLeft,
          colors: [
            Colors.black,
            Colors.green,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(CupertinoIcons.thermometer_snowflake,
              size: devSize.width * 0.2, color: Colors.white),
          Text(
            'Health Monitoring',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              'Patient data is confidential and will be used only for the purpose of monitoring the patient.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            height: 60,
          )
        ],
      ),
    ));
  }
}
