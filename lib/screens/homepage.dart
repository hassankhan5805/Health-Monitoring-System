import 'package:demo_button/screens/add_lamp.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  // var a;
  // getData() async {
  //   a = await _databaseReference.get().then((value) {
  //     print(value);
  //   });
  // }
  void setDataFirstTime(String cmd, String cmdValue) {
    _databaseReference.child("123").update({cmd: cmdValue}).asStream();
    print("$cmd  $cmdValue");
  }

  createCollection() {
    // setDataFirstTime("esp_status", "false");
    setDataFirstTime("temperature", "0");
    setDataFirstTime("heart_rate", "0");
    setDataFirstTime("SPO2", "0");
    setDataFirstTime("pulse_pattern", "0");
    setDataFirstTime("prediction", "0");
  }

  DataSnapshot a;
  printData() async {
    a = await _databaseReference.get();
    print(a.value);
  }

  @override
  void initState() {
    createCollection();
    printData();
    // getData().then((value) {
    //   try {
    //     if (a["esp_status"] == "true") {
    //       print("esp status true");
    //     } else {
    //       Navigator.pushReplacement(
    //           context, MaterialPageRoute(builder: (context) => AddLmap()));
    //     }
    //   } catch (e) {
    //     print(e);
    //      Navigator.pushReplacement(
    //           context, MaterialPageRoute(builder: (context) => AddLmap()));
    //   }
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Hello World'),
            Text('Hello World'),
            Text('Hello World'),
            Text('Hello World'),
            Text('Hello World'),
            ElevatedButton(
                onPressed: () {
                  printData();
                },
                child: Text("data"))
          ],
        ),
      ),
    );
  }
}
