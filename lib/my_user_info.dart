import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class MyUserInfo {
  String name = "";
  String surname = "";
  String email = "";
  int credits = 0;
  var supports = [];

  MyUserInfo() {}

  Future<void> loadUserInfo(String email) async {
    final user =
        await FirebaseFirestore.instance.collection('users').doc(email).get();
    name = user.data()["Name"];
    surname = user.data()["Surname"];
    credits = user.data()["Credits"];
    email = user.data()["Email"];
    supports = user.data()["Supports"];
  }
}
