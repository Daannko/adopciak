import 'package:adopciak/services/firebase_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'model/animal.dart';
import 'model/colors.dart';
import 'model/styles.dart';

class AnimalScreen extends StatefulWidget {
  final String animalId;
  AnimalScreen(this.animalId);

  @override
  _AnimeScreenState createState() => _AnimeScreenState();
}

class _AnimeScreenState extends State<AnimalScreen> {
  bool expandedText = false;
  bool displayList = false;
  List<Animal> animals = [];
  List<Image> image = [];

  @override
  void initState() {
    super.initState();

    print(widget.animalId);

    final db = FirebaseFirestore.instance;
    db.collection("animals").doc(widget.animalId).get().then(((value) async {
      final data = value.data();

      animals.add(Animal(
          data!["Id"],
          data["Age"],
          data["Breed"],
          data["Name"],
          data["Info"],
          data["Location"],
          data["Owner"],
          data["OwnerId"],
          data["Type"],
          data["ImageName"],
          data["OfferType"],
          data["DateStart"],
          data["DateEnd"],
          data["Visible"]));

      String? path = await FirebaseStorageService()
          .getImage(data["ImageName"]?.toString());
      image.add(Image.network(path!));
      setState(() {
        displayList = true;
      });
    }));
  }

  void updateAnimal(data) {}
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
                margin: CustomStyles.marginsAll20,
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
                          child: ClipRRect(
                              borderRadius: CustomStyles.radius20,
                              child: image.last),
                        ),
                        Container(
                          width: double.infinity,
                          margin: CustomStyles.margin10,
                          padding: CustomStyles.paddingAll7,
                          decoration: BoxDecoration(
                              borderRadius: CustomStyles.radius30,
                              color: CustomColors.animalScreenBodyColor),
                          child: Row(
                            children: [
                              Text(
                                "${animals.last.type}",
                                style: TextStyle(
                                    fontSize: CustomStyles.fontSize20),
                                maxLines: CustomStyles.animalScreenMaxLines,
                              ),
                              Text(
                                " ${animals.last.breed}: ",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: CustomStyles.fontSize20),
                                maxLines: CustomStyles.animalScreenMaxLines,
                              ),
                              Text(
                                "${animals.last.name} ",
                                style: TextStyle(
                                    fontSize: CustomStyles.fontSize20),
                                maxLines: CustomStyles.animalScreenMaxLines,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: CustomStyles.margin10,
                          padding: CustomStyles.paddingAll7,
                          decoration: BoxDecoration(
                              borderRadius: CustomStyles.radius30,
                              color: CustomColors.animalScreenBodyColor),
                          child: Text(
                            "Location: ${animals.last.location}",
                            style: TextStyle(fontSize: CustomStyles.fontSize20),
                            maxLines: CustomStyles.animalScreenMaxLines,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: CustomStyles.margin10,
                          padding: CustomStyles.paddingAll7,
                          decoration: BoxDecoration(
                              borderRadius: CustomStyles.radius30,
                              color: CustomColors.animalScreenBodyColor),
                          child: Text(
                            "Owner: ${animals.last.owner}",
                            style: TextStyle(fontSize: CustomStyles.fontSize20),
                            maxLines: CustomStyles.animalScreenMaxLines,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: CustomStyles.margin10,
                          padding: CustomStyles.paddingAll7,
                          decoration: BoxDecoration(
                              borderRadius: CustomStyles.radius30,
                              color: CustomColors.animalScreenBodyColor),
                          child: Text(
                            "Info: ${animals.last.info}",
                            style: TextStyle(fontSize: CustomStyles.fontSize20),
                          ),
                        ),
                      ]),
              ),
            ),
          )),
    );
  }
}
