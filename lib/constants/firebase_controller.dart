import 'package:cloud_firestore/cloud_firestore.dart';

import '../main.dart';

class FireController {
  static FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final CollectionReference _postCollectionReferance =
      _firebaseFirestore.collection("post");
  final CollectionReference _dailyThoughtCollectionReferance =
      _firebaseFirestore.collection("dailyThought");

  Stream<QuerySnapshot> getPost() {
    print('getMessage');
    return _postCollectionReferance.snapshots();
  }

  Stream<QuerySnapshot> getDailyThought() {
    print('getMessage');
    return _dailyThoughtCollectionReferance.snapshots();
  }
}
