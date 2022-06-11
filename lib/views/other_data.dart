import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_monitoring_system/utils/services.dart';
import 'package:health_monitoring_system/utils/widgets/loading.dart';

import '../model/data_model.dart';

class OtherData extends StatelessWidget {
  OtherData({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // final userController = Get.find<UserController>();
    final devSize = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.green,
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
              Colors.green,
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
                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 300,
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
                                    "Temperature",
                                    data![index]
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
                                rowComponent("Pulse Pattern",
                                    data[index].pulsePattern.toString()),
                                rowComponent(
                                    "Oxygen", data[index].oxygen.toString()),
                              ],
                            ),
                            Center(
                              child:
                                  Text("Date: ${data[index].date.toString()}"),
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
