import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:health_monitoring_system/controllers/loading.dart';
import 'package:health_monitoring_system/views/other_data.dart';
// import 'package:firebase_auth/firebase_auth.dart';

import '../model/data_model.dart';

class Services {
  final loading = Get.find<LoadingController>();

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> setData(health health) async {
    await _firestore.collection('Data').doc().set(health.toJson());
  }

  Stream<List<health>>? getData(
      {bool filter = false, bool isDoc = false, String id = ''}) {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    if (filter) {
      return _firestore
          .collection('Data')
          .where(isDoc ? "docID" : "ID",
              isEqualTo: isDoc ? FirebaseAuth.instance.currentUser!.uid : id)
          .snapshots()
          .map((event) {
        return event.docs.map((e) => health.fromJson(e.data())).toList();
      });
    }
    return _firestore.collection('Data').snapshots().map((event) {
      return event.docs.map((e) => health.fromJson(e.data())).toList();
    });
  }

  verifyPatient(String id) async {
    await FirebaseFirestore.instance
        .collection("Data")
        .where("ID", isEqualTo: id)
        .get()
        .then((value) {
      if (value.size > 0) {
        Get.offAll(() => OtherData(
              isDoc: false,
              patientID: id,
            ));
      } else {
        Get.snackbar(
          "Something wrong",
          "Wrong ID",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    });
    loading.isLoading(false);
  }
}
