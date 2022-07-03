import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_monitoring_system/controllers/loading.dart';
import 'package:health_monitoring_system/utils/constant/color.dart';
import 'package:health_monitoring_system/utils/widgets/loading.dart';
import 'package:health_monitoring_system/views/other_data.dart';
import 'package:health_monitoring_system/views/welcome.dart';

import '../model/data_model.dart';
import '../services/auth.dart';
import '../services/services.dart';
import 'package:http/http.dart' as http;

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
  final loading = Get.find<LoadingController>();
  void setDataFirstTime(String cmd, String cmdValue) {
    _databaseReference!.child("123").update({cmd: cmdValue}).asStream();
    print("$cmd  $cmdValue");
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController IDController = TextEditingController();
  List<double> values = [];
  List<String> predictions = [
    "Fever",
    "Flu Fever",
    "Sore Throat",
    "COVID",
    "Heart Infection",
    "Dangue",
    "Malaria",
    "Astama",
    "Typhoid",
    "Pnemonia",
    "Syncopi",
    "Anxiety Stress",
    "General Pain",
    "Heart Attack"
  ];
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
    print("printing theinkspeak as future string");
    print(thinkspeak());
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

  Future<String> thinkspeak() async {
    http.Response a = await http.get(Uri.parse(
        'https://api.thingspeak.com/channels/1776612/fields/1/last.json'));
    // print("answer ${a.body.toString()}");
    return "${a.body.toString()}";
  }

  bool doctorView = false;
  @override
  Widget build(BuildContext context) {
    final devSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        Container(
          width: devSize.width,
          height: devSize.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topLeft,
              colors: [
                Colors.black,
                ColorsRes.purple,
              ],
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text("Health Monitoring System"),
            centerTitle: true,
            backgroundColor: ColorsRes.purple,
            actions: [
              IconButton(
                  onPressed: () {
                    signOut();
                    Get.offAll(WelcomeScreen());
                  },
                  icon: Icon(Icons.logout_rounded, color: Colors.white))
            ],
          ),
          body: Center(
            child: StreamBuilder(
              stream: _databaseReference!.child("123").onValue,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            rowComponent("Temperature",
                                "${snapshot.data.snapshot.value["temperature"].toString().split(".").first}"),
                            rowComponent("Heart Rate",
                                "${snapshot.data.snapshot.value["heart_rate"]}"),
                            rowComponent("Oxygen",
                                "${snapshot.data.snapshot.value["oxygen"]}"),
                          ],
                        ),
                        FutureBuilder(
                            future: thinkspeak(),
                            builder: ((context, snapshot) {
                              if (snapshot.hasData && !snapshot.hasError) {
                                var a = jsonDecode(snapshot.data.toString());

                                List<String> list = a['field1'].split(' ');
                                values.clear();
                                list.forEach(
                                  (element) {
                                    if (element.trim().isNotEmpty) {
                                      values.add(double.parse(element));
                                    }
                                  },
                                );

                                print(values);
                                return Column(
                                  children: [
                                    tableValue("${values[0]}", 0),
                                    tableValue("${values[1]}", 1),
                                    tableValue("${values[2]}", 2),
                                    tableValue("${values[3]}", 3),
                                    tableValue("${values[4]}", 4),
                                    tableValue("${values[5]}", 5),
                                    tableValue("${values[6]}", 6),
                                    tableValue("${values[7]}", 7),
                                    tableValue("${values[8]}", 8),
                                    tableValue("${values[9]}", 9),
                                    tableValue("${values[10]}", 10),
                                    tableValue("${values[11]}", 11),
                                    tableValue("${values[12]}", 12),
                                    tableValue("${values[13]}", 13),
                                  ],
                                );
                                // ListView.builder(
                                //     itemCount: values.length,
                                //     itemBuilder: ((context, index) {
                                //       return Padding(
                                //         padding: EdgeInsets.all(8.0),
                                //         child: Container(
                                //           height: 100,
                                //           width: 100,
                                //           color: Colors.red,
                                //         ),
                                //       );
                                //     }));
                              } else {
                                print(snapshot.error);
                                print("............");
                                return SizedBox();
                              }
                              // return SizedBox();
                            }))
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Text(
                        //       "Doctor View",
                        //       style: TextStyle(color: Colors.white),
                        //     ),
                        //     Switch(
                        //         value: doctorView,
                        //         onChanged: (a) {
                        //           setState(() {
                        //             doctorView = a;
                        //           });
                        //         })
                        //   ],
                        // ),
                        // Visibility(
                        //   visible: doctorView,
                        //   child: rowComponent("Prediction",
                        //       "${snapshot.data.snapshot.value["prediction"]}"),
                        // ),
                        ,
                        Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 1, horizontal: 6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black45.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 3,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                )
                              ]),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(15),
                                child: TextField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    fillColor: Colors.red,
                                    border: OutlineInputBorder(),
                                    labelText: 'Name',
                                    hintText: 'Patient Name',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(15),
                                child: TextField(
                                  controller: IDController,
                                  decoration: InputDecoration(
                                    fillColor: Colors.red,
                                    border: OutlineInputBorder(),
                                    labelText: 'ID',
                                    hintText: 'Patient ID',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(120, 40),
                                primary: Colors.blueGrey,
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                              ),
                              onPressed: () {
                                Get.to(() => OtherData(isDoc: true,));
                              },
                              child: Text("View Data"),
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(120, 40),
                                  primary: Colors.blueGrey,
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0),
                                  ),
                                ),
                                onPressed: () {
                                  if (nameController.text.isEmpty ||
                                      IDController.text.isEmpty) {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                        content: Text("Field required")));
                                  } else {
                                    setState(() {
                                      loading.isLoading.value = true;
                                    });
                                    print("Values just before");
                                    print(values);

                                    var x = health(
                                      docID: FirebaseAuth.instance.currentUser!.uid,
                                        predictions: values.toString(),
                                        name: nameController.text,
                                        ID: IDController.text,
                                        temp:
                                            "${snapshot.data.snapshot.value["temperature"].toString().split(".").first}",
                                        // pulsePattern:
                                        //     "${snapshot.data.snapshot.value["pulse_pattern"]}",
                                        heartRate:
                                            "${snapshot.data.snapshot.value["heart_rate"]}",
                                        oxygen:
                                            "${snapshot.data.snapshot.value["oxygen"]}",
                                        date: DateTime.now().day.toString() +
                                            "-" +
                                            DateTime.now().month.toString() +
                                            "-" +
                                            DateTime.now().year.toString() +
                                            "  " +
                                            DateTime.now().hour.toString() +
                                            ":" +
                                            DateTime.now().minute.toString());
                                    Services().setData(x).then((value) {
                                      setState(() {
                                        loading.isLoading.value = false;
                                      });
                                    });
                                    nameController.clear();
                                    IDController.clear();
                                  }
                                },
                                child: Text("Upload Data")),
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ),
        LoadingWidget(),
      ],
    );
  }

  tableValue(String value, int index) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 1, horizontal: 6),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: double.parse(value) <= 0.5
                ? Colors.green
                : double.parse(value) < 0.65
                    ? Colors.amber
                    : Colors.red,
            boxShadow: [
              BoxShadow(
                color: Colors.black45.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 3,
                offset: const Offset(0, 3), // changes position of shadow
              )
            ]),
        height: 50,
        width: double.infinity,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 8,
              ),
              Text(
                "${predictions[index]}",
                style: TextStyle(fontSize: 24),
              ),
              Spacer(),
              Text(
                "$value",
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                width: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }

  rowComponent(String s, String t) {
    return Container(
      alignment: Alignment.center,
      height: 100,
      width: 100,
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
              fontSize: 17,
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
