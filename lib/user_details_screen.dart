import 'package:adopciak/services/firebase_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'model/animal.dart';
import 'model/colors.dart';
import 'model/styles.dart';

class UserDetalisScreen extends StatefulWidget {
  // final String userId;
  UserDetalisScreen();

  @override
  _UserDetalisState createState() => _UserDetalisState();
}

class _UserDetalisState extends State<UserDetalisScreen> {
  bool expandedText = false;
  bool displayList = true;

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
                                "Downiel",
                                style: TextStyle(
                                    fontSize: CustomStyles.fontSize20),
                                maxLines: CustomStyles.animalScreenMaxLines,
                              ),
                              Text(
                                "Koziarski",
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
