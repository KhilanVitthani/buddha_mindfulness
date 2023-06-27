import 'dart:convert';

import 'package:buddha_mindfulness/utilities/ad_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

import '../app/models/daily_thought_model.dart';

class FireController {
  static FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final CollectionReference _adsReferance =
      _firebaseFirestore.collection("Ads");

  Future<List<dailyThoughtModel>> getPostData() async {
    print('getMessage');
    List<dailyThoughtModel> result = [];
    await FirebaseDatabase.instance
        .ref()
        .child("post")
        .orderByChild("dateTime")
        .onChildAdded
        .listen((event) {
      var data = event.snapshot.value;
      Map<String, dynamic> ConvertData = jsonDecode(jsonEncode(data));
      result.add(dailyThoughtModel.fromJson(ConvertData));
    });
    await Future.delayed(Duration(seconds: 2));
    return result;
  }

  Future<List<dailyThoughtModel>> getDailyData() async {
    List<dailyThoughtModel> result = [];
    await FirebaseDatabase.instance
        .ref()
        .child("dailyThought")
        .orderByChild("dateTime")
        .onChildAdded
        .listen((event) {
      var data = event.snapshot.value;
      Map<String, dynamic> ConvertData = jsonDecode(jsonEncode(data));
      result.add(dailyThoughtModel.fromJson(ConvertData));
    });
    await Future.delayed(Duration(seconds: 2));
    return result;
  }

  Future<bool> adsVisible() async {
    print('getMessage');
    QuerySnapshot querySnapshot = await _adsReferance.get();
    querySnapshot.docs.forEach((doc) {
      QueryDocumentSnapshot docu = doc;
      print(docu.data() as Map<String, dynamic>);
      Map m = docu.data() as Map<String, dynamic>;
      AdService.isVisible.value = m['isVisible'];
    });
    return AdService.isVisible.value;
  }
}
