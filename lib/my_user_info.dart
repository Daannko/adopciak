//WSZYSTKO TUTAJ JEST PRAWDOPODOBNIE USELESS

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

  void loadUserInfo(String email) async {
    final user =
        await FirebaseFirestore.instance.collection('users').doc(email).get();

    print(email);
    // this.name = user.get("Name");
    // this.surname = user.get("Surname");
    // this.credits = user.data()["Credits"];
    // this.email = user.data()["Email"];
    // this.supports = user.data()["Supports"];
    print(name);
  }
}
