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
    for (int i = 0; i < 200; i++) {
      try {
        if (a.value != null) {
          setState(() {
            data_ready = true;
          });
          break;
        }
      } catch (e) {}
    }
  }

  bool data_ready = false;
  @override
  void initState() {
    // createCollection();
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
      appBar: AppBar(
        title: Text("Health Monitoring System"),
        centerTitle: true,
      ),
      body: !data_ready
          ? CircularProgressIndicator()
          : Center(
              child: StreamBuilder(
                stream: _databaseReference.child("123").onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data.snapshot.value);
                    return Column(
                      children: [
                        Text(snapshot.data.snapshot.value["temperature"]),
                        Text(snapshot.data.snapshot.value["heart_rate"]),
                        Text(snapshot.data.snapshot.value["SPO2"]),
                        Text(snapshot.data.snapshot.value["pulse_pattern"]),
                        Text(snapshot.data.snapshot.value["prediction"]),
                      ],
                    );
                  } else {
                    return Text("Loading");
                  }
                },
              ),
            ),
    );
  }
}
