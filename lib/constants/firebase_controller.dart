import 'package:buddha_mindfulness/app/models/save_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireController {
  static FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final CollectionReference _postCollectionReferance =
      _firebaseFirestore.collection("post");
  final CollectionReference _dailyThoughtCollectionReferance =
      _firebaseFirestore.collection("dailyThought");
  final CollectionReference _adsReferance =
      _firebaseFirestore.collection("Ads");

  Stream<QuerySnapshot> getPost() {
    print('getMessage');
    return _postCollectionReferance
        .orderBy("dateTime", descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getDailyThought() {
    print('getMessage');
    return _dailyThoughtCollectionReferance
        .orderBy("dateTime", descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> adsVisible() {
    print('getMessage');
    return _adsReferance.snapshots();
  }

  Future<void> saveQuote({required bool status, required String Uid}) async {
    return await _dailyThoughtCollectionReferance
        .doc(Uid)
        .update({"isSave": status});
  }

  Future<void> LikeQuote({required bool status, required String Uid}) async {
    return await _dailyThoughtCollectionReferance
        .doc(Uid)
        .update({"isLike": status});
  }


}
