import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:final_advanced_exam1/screen/home/model/firestore_model.dart';

class CloudFirestoreHelper {
  static CloudFirestoreHelper fireDBHelper = CloudFirestoreHelper._();

  CloudFirestoreHelper._();

  var db = FirebaseFirestore.instance;

  Future<void> addData(FireStoreModel model) async {
    await db
        .collection("shopping")
        .add({"name": model.name, "price": model.price, "qua": model.qua});
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> readData() {
    return FirebaseFirestore.instance.collection("shopping").snapshots();
  }




  Future<void> updateData(FireStoreModel model) async {
    await db
        .collection("shopping")
        .doc(model.id)
        .set({"name": model.name, "price": model.price, "qua": model.qua});
  }

  Future<void> deleteData(String dId) async {
    await db.collection("shopping").doc(dId).delete();
  }
}
