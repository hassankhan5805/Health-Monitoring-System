import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_monitoring_system/utils/constant/color.dart';
import 'package:health_monitoring_system/utils/services.dart';
import 'package:health_monitoring_system/utils/widgets/loading.dart';

import '../model/data_model.dart';

class OtherData extends StatelessWidget {
  OtherData({Key? key}) : super(key: key);
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
  @override
  Widget build(BuildContext context) {
    // final userController = Get.find<UserController>();
    final devSize = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: ColorsRes.purple,
          actions: [
            SizedBox(
              width: 8,
            ),
          ],
          title: Text('Health Monitoring',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ))),
      body: Container(
        width: devSize.width,
        height: devSize.height,
        // margin: const EdgeInsets.only(top: 60.0),
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
        child: StreamBuilder<List<health>>(
            stream: Services().getData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "No Data Found",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
                final List<health>? data = snapshot.data;
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      List<String> list = data![index]
                          .predictions!
                          .split('[')
                          .last
                          .split(']')
                          .first
                          .split(',');
                      list.forEach(
                        (element) {
                          if (element.trim().isNotEmpty) {
                            values.add(double.parse(element));
                          }
                        },
                      );
                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 1400,
                          margin:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16)),
                          alignment: Alignment.center,
                          child: Column(children: [
                            Row(
                              children: [
                                rowComponent(
                                    "Name",
                                    data[index]
                                        .name
                                        .toString()
                                        .split(".")
                                        .first
                                        .toUpperCase()),
                                rowComponent("ID", data[index].ID.toString()),
                              ],
                            ),
                            Row(
                              children: [
                                rowComponent(
                                    "Temperature",
                                    data[index]
                                        .temp
                                        .toString()
                                        .split(".")
                                        .first),
                                rowComponent("Heart Rate",
                                    data[index].heartRate.toString()),
                              ],
                            ),
                            Row(
                              children: [
                                // rowComponent("Pulse Pattern",
                                //     data[index].pulsePattern.toString()),
                                rowComponent(
                                    "Oxygen", data[index].oxygen.toString()),
                              ],
                            ),
                            Column(
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
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Date: ${data[index].date.toString()}"),
                                SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                    onPressed: () async {
                                      final ref = await FirebaseFirestore
                                          .instance
                                          .collection("Data")
                                          .where("ID",
                                              isEqualTo: data[index].ID)
                                          .get()
                                          .then((value) => value.docs);

                                      await FirebaseFirestore.instance
                                          .collection("Data")
                                          .doc(ref[0].id)
                                          .delete();
                                    },
                                    icon: Icon(
                                      Icons.delete_forever,
                                      color: Colors.red,
                                    ))
                              ],
                            )
                          ]),
                        ),
                      );
                    });
              } else {
                return Center(child: LoadingWidget());
              }
            }),
      ),
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
      height: 90,
      width: 140,
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
