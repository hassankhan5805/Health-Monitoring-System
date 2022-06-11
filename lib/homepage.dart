
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'model/data_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseReference? _databaseReference = FirebaseDatabase.instance.reference();
  // var a;
  // getData() async {
  //   a = await _databaseReference.get().then((value) {
  //     print(value);
  //   });
  // }
  void setDataFirstTime(String cmd, String cmdValue) {
    _databaseReference!.child("123").update({cmd: cmdValue}).asStream();
    print("$cmd  $cmdValue");
  }

  createCollection() {
    // setDataFirstTime("esp_status", "false");
    setDataFirstTime("temperature", "0");
    setDataFirstTime("heart_rate", "0");
    setDataFirstTime("oxygen", "0");
    setDataFirstTime("pulse_pattern", "0");
    setDataFirstTime("prediction", "0");
  }

  DataSnapshot? a;
  printData() async {
    a = await _databaseReference!.get();
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

  bool doctorView = false;
  @override
  Widget build(BuildContext context) {
    final devSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Health Monitoring System"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: devSize.width,
          height: devSize.height,
          // margin: const EdgeInsets.only(top: 60.0),
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
          child: StreamBuilder(
            stream: _databaseReference!.child("123").onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Row(
                      children: [
                        rowComponent("Temperature",
                            "{snapshot.data.snapshot.}"),
                        rowComponent("Heart Rate",
                            "{snapshot.data.snap}"),
                      ],
                    ),
                    Row(
                      children: [
                        rowComponent("Pulse Pattern",
                            "{snapshot.data.snaps}"),
                        rowComponent("Oxygen",
                            "{snapshot.data.}"),
                      ],
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(120, 40),
                          primary: Colors.blueGrey,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                        ),
                        onPressed: () {
                          print("objects");
                          // var x = health(
                          //   temp:
                          //       "${snapshot.data.snapshot.value["temperature"]}",
                          //   pulsePattern:
                          //       "${snapshot.data.snapshot.value["pulse_pattern"]}",
                          //   heartRate:
                          //       "${snapshot.data.snapshot.value["heart_rate"]}",
                          //   oxygen: "${snapshot.data.snapshot.value["oxygen"]}",
                          // );
                          // Services().setDataOnFirestore(x);
                        },
                        child: Text("Upload Data")),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Doctor View",
                          style: TextStyle(color: Colors.white),
                        ),
                        Switch(
                            value: doctorView,
                            onChanged: (a) {
                              setState(() {
                                doctorView = a;
                              });
                            })
                      ],
                    ),
                    // Visibility(
                    //   visible: doctorView,
                    //   child: rowComponent("Prediction",
                    //       "${snapshot.data.snapshot.value["prediction"]}"),
                    // ),
                  ],
                );
              } else {
                return Text("Loading");
              }
            },
          ),
        ),
      ),
    );
  }

  rowComponent(String s, String t) {
    return Container(
      alignment: Alignment.center,
      height: 100,
      width: 160,
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey.shade200,
          boxShadow: [
            BoxShadow(
              color: Colors.black45.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(0, 3), // changes position of shadow
            )
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$s',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '$t',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.3),
          ),
        ],
      ),
    );
  }
}
