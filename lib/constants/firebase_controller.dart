import 'package:cloud_firestore/cloud_firestore.dart';

import '../main.dart';

class FireController {
  static FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final CollectionReference _dataCollectionReferance =
      _firebaseFirestore.collection("data");

  Stream<QuerySnapshot> getEntry() {
    print('getMessage');
    return _dataCollectionReferance.snapshots();
  }
}
