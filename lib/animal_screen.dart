import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'model/colors.dart';
import 'model/styles.dart';

class AnimalScreen extends StatefulWidget {
  final String animalId;
  AnimalScreen(this.animalId);

  @override
  _AnimeScreenState createState() => _AnimeScreenState();
}

class _AnimeScreenState extends State<AnimalScreen> {
  void updateAnimal(data) {}

  void initState() {
    super.initState();
  }

  //   getMarker() async {

  //   FirebaseDatabase firebaseDatabase = f
  //   const snapshot = await firebase.firestore().collection('events').get()
  //   return snapshot.docs.map(doc => doc.data());
  // }

  @override
  Widget build(BuildContext context) {
    CollectionReference animals =
        FirebaseFirestore.instance.collection('animals');

    bool expandedText = false;

    return Scaffold(
      body: Center(
          child: FutureBuilder<DocumentSnapshot>(
        future: animals.doc(widget.animalId).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Scaffold(
              appBar: AppBar(
                leading: null,
                actions: <Widget>[],
                title: Text(data["Name"]),
                backgroundColor: CustomColors.appBarColor,
              ),
              body: Container(
                  color: CustomColors.homePageBackgroundColor,
                  child: SingleChildScrollView(
                    child: Container(
                      margin: CustomStyles.mariginsAll20,
                      decoration: BoxDecoration(
                        borderRadius: CustomStyles.radius20,
                      ),
                      child: Column(children: [
                        Container(
                          child: ClipRRect(
                            borderRadius: CustomStyles.radius20,
                            child: Image(
                              image: AssetImage("images/dog.png"),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: CustomStyles.marigin10,
                          padding: CustomStyles.paddingAll7,
                          decoration: BoxDecoration(
                              borderRadius: CustomStyles.radius30,
                              color: CustomColors.animalScreenBodyColor),
                          child: Text(
                            "Name: ${data["Name"]}",
                            style: TextStyle(fontSize: CustomStyles.fontSize20),
                            maxLines: CustomStyles.animalScreenMaxLines,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: CustomStyles.marigin10,
                          padding: CustomStyles.paddingAll7,
                          decoration: BoxDecoration(
                              borderRadius: CustomStyles.radius30,
                              color: CustomColors.animalScreenBodyColor),
                          child: Text(
                            "Breed: ${data["Breed"]}",
                            style: TextStyle(fontSize: CustomStyles.fontSize20),
                            maxLines: CustomStyles.animalScreenMaxLines,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: CustomStyles.marigin10,
                          padding: CustomStyles.paddingAll7,
                          decoration: BoxDecoration(
                              borderRadius: CustomStyles.radius30,
                              color: CustomColors.animalScreenBodyColor),
                          child: Text(
                            "Location: ${data["Location"]}",
                            style: TextStyle(fontSize: CustomStyles.fontSize20),
                            maxLines: CustomStyles.animalScreenMaxLines,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: CustomStyles.marigin10,
                          padding: CustomStyles.paddingAll7,
                          decoration: BoxDecoration(
                              borderRadius: CustomStyles.radius30,
                              color: CustomColors.animalScreenBodyColor),
                          child: Text(
                            "Owner: ${data["Owner"]}",
                            style: TextStyle(fontSize: CustomStyles.fontSize20),
                            maxLines: CustomStyles.animalScreenMaxLines,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: CustomStyles.marigin10,
                          padding: CustomStyles.paddingAll7,
                          decoration: BoxDecoration(
                              borderRadius: CustomStyles.radius30,
                              color: CustomColors.animalScreenBodyColor),
                          child: Text(
                            "Info: ${data["Info"]}",
                            style: TextStyle(fontSize: CustomStyles.fontSize20),
                          ),
                        ),
                      ]),
                    ),
                  )),
            );
          }
          return CircularProgressIndicator();
        },
      )),
    );
  }
}
