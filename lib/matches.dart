import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_monitoring_system/utils/services.dart';
import 'package:health_monitoring_system/utils/widgets/loading.dart';

import 'model/data_model.dart';

class MatchesScreen extends StatelessWidget {
  MatchesScreen({Key? key}) : super(key: key);
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
            IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.search)),
            SizedBox(
              width: 8,
            ),
          ],
          title: Text('Cozy Tech',
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
                      "No Chat yet",
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
                          height: 80,
                          margin:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16)),
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                            ],
                          ),
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
}
