import 'package:cloud_firestore/cloud_firestore.dart';

import '../main.dart';

class FireController {
  static FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final CollectionReference _dataCollectionReferance =
      _firebaseFirestore.collection("post");

  Stream<QuerySnapshot> getEntry() {
    print('getMessage');
    return _dataCollectionReferance.snapshots();
  }
}
