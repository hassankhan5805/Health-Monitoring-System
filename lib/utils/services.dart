import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/data_model.dart';

class Services {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> setData(health health) async {
    print("object");
    await _firestore.collection('Data').doc().set(health.toJson());
  }

  Stream<List<health>>? getData() {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return _firestore.collection('tenants').snapshots().map((event) {
      return event.docs.map((e) => health.fromJson(e.data())).toList();
    });
  }
}
