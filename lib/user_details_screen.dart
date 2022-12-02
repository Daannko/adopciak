import 'package:adopciak/services/firebase_storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'model/animal.dart';
import 'model/colors.dart';
import 'model/styles.dart';
import 'model/user_details.dart';

class UserDetalisScreen extends StatefulWidget {
  @override
  _UserDetalisState createState() => _UserDetalisState();
}

class _UserDetalisState extends State<UserDetalisScreen> {
  final _auth = FirebaseAuth.instance;
  final FirebaseStorageService firebaseStorageSerivce =
      Get.put(FirebaseStorageService());
  final myController = TextEditingController();
  List<UserDetails> users = [];
  List<String?> imagePath = [];
  List<Image> images = [];
  bool displayList = false;

  void initState() {
    super.initState();
    myController.addListener(changeData);

    final db = FirebaseFirestore.instance;

    final User? user = _auth.currentUser;
    final uid = user!.uid;

    db
        .collection("users")
        .where('UserID', isEqualTo: uid)
        .get()
        .then(((value) async {
      for (int i = 0; i < value.size; i++) {
        final data = value.docs[i].data();

        users.add(UserDetails(data["UserID"], data["Credits"], data["Email"],
            data["Name"], data["Surname"]));

        // String? path =
        //     await firebaseStorageSerivce.getImage(data["imageName"].toString());
        // images.add(Image.network(path!));
      }
      setState(() {
        displayList = true;
      });
    }));
  }

  void changeData() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: double.infinity,
          color: CustomColors.homePageBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: SingleChildScrollView(
              child: Container(
                margin: CustomStyles.mariginsAll20,
                decoration: BoxDecoration(
                  borderRadius: CustomStyles.radius20,
                ),
                child: !displayList
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(children: [
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(spreadRadius: 1, blurRadius: 1)
                            ],
                            borderRadius: CustomStyles.radius20,
                          ),
                          child: Image.asset('images/down.jpg'),
                        ),
                        Container(
                          width: double.infinity,
                          margin: CustomStyles.marigin10,
                          padding: CustomStyles.paddingAll7,
                          decoration: BoxDecoration(
                              borderRadius: CustomStyles.radius30,
                              color: CustomColors.animalScreenBodyColor),
                          child: Row(
                            children: [
                              Text(
                                users.last.name,
                                style: TextStyle(
                                    fontSize: CustomStyles.fontSize20),
                                maxLines: CustomStyles.animalScreenMaxLines,
                              ),
                              Text(
                                users.last.surname,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: CustomStyles.fontSize20),
                                maxLines: CustomStyles.animalScreenMaxLines,
                              ),
                            ],
                          ),
                        ),
                      ]),
              ),
            ),
          )),
    );
  }
}
