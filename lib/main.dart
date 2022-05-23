import 'package:demo_button/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'screens/homepage.dart';
import 'dart:async';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(411.4, 891.4),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Health monitoring',
            theme: ThemeData(
                primarySwatch: Colors.green,
                visualDensity: VisualDensity.adaptivePlatformDensity),
            builder: (context, widget) {
              ScreenUtil.defaultSize;
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: widget,
              );
            },
            home: MyHomePage());
      },
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
  final _prefs = SharedPreferences.getInstance();

  Future<int> getStatus() async {
    SharedPreferences prefs = await _prefs;
    int isLoggedIn = prefs.getInt('Log');
    return isLoggedIn;
  }
navigation()async{
      await getStatus() == 2
          ? Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
              return MyHomePage();
            }))
          : Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
              return LoginScreen();
            }));
    }
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    navigation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: Center(
       
      ),
    );
  }
}
