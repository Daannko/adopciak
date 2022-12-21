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
                    // borderRadius: CustomStyles.radius20,
                    ),
                child: !displayList
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          alignment: Alignment.center,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: CustomStyles.radiusAnimalScreen,
                              color: CustomColors.homeScreenAnimalBoxColor),
                          child: Row(
                            children: [
                              Icon(Icons.person,
                                  color: CustomColors.fourthColor),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "${animals.last.name}",
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic),
                                    maxLines: CustomStyles.animalScreenMaxLines,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: CustomColors.homeScreenAnimalBoxColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 4,
                                  offset: Offset(0, 3),
                                ),
                              ],
                              borderRadius: CustomStyles.radiusAnimalScreen),
                          child: ClipRRect(
                              borderRadius: CustomStyles.radiusAnimalScreen,
                              child: image.last),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          decoration: BoxDecoration(
                              borderRadius: CustomStyles.radiusAnimalScreen,
                              color: CustomColors.homeScreenAnimalBoxColor),
                          child: Row(
                            children: [
                              Icon(Icons.style,
                                  color: CustomColors.fourthColor),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "${animals.last.breed}",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                    maxLines: CustomStyles.animalScreenMaxLines,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          decoration: BoxDecoration(
                              borderRadius: CustomStyles.radiusAnimalScreen,
                              color: CustomColors.homeScreenAnimalBoxColor),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_month,
                                  color: CustomColors.fourthColor),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "${animals.last.age}",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                    maxLines: CustomStyles.animalScreenMaxLines,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          decoration: BoxDecoration(
                              borderRadius: CustomStyles.radiusAnimalScreen,
                              color: CustomColors.homeScreenAnimalBoxColor),
                          child: Row(
                            children: [
                              Icon(Icons.signpost,
                                  color: CustomColors.fourthColor),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "${animals.last.location}",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                    maxLines: CustomStyles.animalScreenMaxLines,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          decoration: BoxDecoration(
                              borderRadius: CustomStyles.radiusAnimalScreen,
                              color: CustomColors.homeScreenAnimalBoxColor),
                          child: Row(
                            children: [
                              Icon(Icons.contact_mail,
                                  color: CustomColors.fourthColor),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "${animals.last.owner}",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                    maxLines: CustomStyles.animalScreenMaxLines,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          decoration: BoxDecoration(
                              borderRadius: CustomStyles.radiusAnimalScreen,
                              color: CustomColors.homeScreenAnimalBoxColor),
                          child: Row(
                            children: [
                              Icon(Icons.article,
                                  color: CustomColors.fourthColor),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "${animals.last.info}",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
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
