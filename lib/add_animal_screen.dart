// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'dart:ui';
import 'package:adopciak/services/firebase_upload_image_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:adopciak/custom_snackbar';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'model/animal.dart';
import 'model/colors.dart';
import 'model/styles.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'model/styles.dart';

class AddAnimalScreen extends StatefulWidget {
  @override
  _AddAnimalScreenStatus createState() => _AddAnimalScreenStatus();
}

class _AddAnimalScreenStatus extends State<AddAnimalScreen> {
  final _auth = FirebaseAuth.instance;
  String name = "a";
  int age = 0;
  String breed = "a";
  String owner = "a";
  String location = "a";
  String info = "a";
  String errorMessage = "";
  String offertType = "";
  String dateStart = "";
  String dateEnd = "";
  bool showSpinner = false;
  bool displaySet1 = true;
  bool displaySet2 = false;
  bool displayDates = false;
  bool displayImageUpload = false;
  var uuid = Uuid();
  late String animalUId;
  String animalType = "Cat";
  String offerType = "Adopt";
  final List<String> animalTypeList = <String>['Cat', 'Dog', 'Other'];
  final List<String> offerTypeList = <String>[
    'Adopt',
    'Support',
    'Adopt for period of time'
  ];

  File? photo;
  var startDateController = TextEditingController();
  var endDateController = TextEditingController();
  bool addedPhoto = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animalUId = uuid.v4();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height - // total height
                  kToolbarHeight - // top AppBar height
                  MediaQuery.of(context).padding.top - // top padding
                  kBottomNavigationBarHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(CustomStyles.addAnimalTitle,
                      style: TextStyle(
                          fontSize: CustomStyles.enterToRegisterSize)),
                  displaySet1
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                              SizedBox(
                                  height: CustomStyles.enterToRegisterSize),
                              TextField(
                                keyboardType: TextInputType.name,
                                textAlign: TextAlign.center,
                                controller: name.isNotEmpty
                                    ? TextEditingController(text: name)
                                    : TextEditingController(text: ""),
                                onChanged: (value) {
                                  name = value;
                                  //Do something with the user input.
                                },
                                decoration: InputDecoration(
                                    hintText: 'Name',
                                    contentPadding: CustomStyles.marginsAll20,
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: CustomColors
                                                .inputTextBorderColor,
                                            width: CustomStyles.width)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: CustomColors
                                                .selectedInputTextBorderColor,
                                            width: CustomStyles.width))),
                              ),
                              SizedBox(
                                height: CustomStyles.smallBoxHeight,
                              ),
                              TextField(
                                textAlign: TextAlign.center,
                                controller: breed.isNotEmpty
                                    ? TextEditingController(text: breed)
                                    : TextEditingController(text: ""),
                                onChanged: (value) {
                                  breed = value;
                                  //Do something with the user input.
                                },
                                decoration: InputDecoration(
                                    hintText: 'Breed',
                                    contentPadding: CustomStyles.marginsAll20,
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: CustomColors
                                                .inputTextBorderColor,
                                            width: CustomStyles.width)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: CustomColors
                                                .selectedInputTextBorderColor,
                                            width: CustomStyles.width))),
                              ),
                              SizedBox(
                                height: CustomStyles.smallBoxHeight,
                              ),
                              TextField(
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                controller: age.toString().isNotEmpty
                                    ? TextEditingController(
                                        text: age.toString())
                                    : TextEditingController(text: ""),
                                onChanged: (value) {
                                  age = int.parse(value);
                                  //Do something with the user input.
                                },
                                decoration: InputDecoration(
                                    hintText: 'Age',
                                    contentPadding: CustomStyles.marginsAll20,
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: CustomColors
                                                .inputTextBorderColor,
                                            width: CustomStyles.width)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: CustomColors
                                                .selectedInputTextBorderColor,
                                            width: CustomStyles.width))),
                              ),
                              SizedBox(
                                height: CustomStyles.smallBoxHeight,
                              ),
                              DropdownButtonFormField<String>(
                                  alignment: Alignment.center,
                                  value: animalType,
                                  isExpanded: true,
                                  selectedItemBuilder: (context) {
                                    return animalTypeList.map<Widget>((e) {
                                      return Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            32, 0, 0, 0),
                                        child: Center(child: Text(e)),
                                      );
                                    }).toList();
                                  },
                                  decoration: InputDecoration(
                                      contentPadding: CustomStyles.marginsAll20,
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: CustomColors
                                                  .inputTextBorderColor,
                                              width: CustomStyles.width)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: CustomColors
                                                  .selectedInputTextBorderColor,
                                              width: CustomStyles.width))),
                                  items: animalTypeList
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                      alignment: Alignment.center,
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      animalType = newValue!;
                                    });
                                  }),
                            ])
                      : displaySet2
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                  SizedBox(
                                      height: CustomStyles.enterToRegisterSize),
                                  TextField(
                                    textAlign: TextAlign.center,
                                    controller: location.isNotEmpty
                                        ? TextEditingController(text: location)
                                        : TextEditingController(text: ""),
                                    onChanged: (value) {
                                      location = value;
                                      //Do something with the user input.
                                    },
                                    decoration: InputDecoration(
                                        hintText: 'Location',
                                        contentPadding:
                                            CustomStyles.marginsAll20,
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: CustomColors
                                                    .inputTextBorderColor,
                                                width: CustomStyles.width)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: CustomColors
                                                    .selectedInputTextBorderColor,
                                                width: CustomStyles.width))),
                                  ),
                                  SizedBox(
                                    height: CustomStyles.smallBoxHeight,
                                  ),
                                  TextField(
                                    textAlign: TextAlign.center,
                                    controller: info.isNotEmpty
                                        ? TextEditingController(text: info)
                                        : TextEditingController(text: ""),
                                    onChanged: (value) {
                                      info = value;
                                      //Do something with the user input.
                                    },
                                    decoration: InputDecoration(
                                        hintText: 'Info',
                                        contentPadding:
                                            CustomStyles.marginsAll20,
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: CustomColors
                                                    .inputTextBorderColor,
                                                width: CustomStyles.width)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: CustomColors
                                                    .selectedInputTextBorderColor,
                                                width: CustomStyles.width))),
                                  ),
                                  SizedBox(
                                    height: CustomStyles.smallBoxHeight,
                                  ),
                                  TextField(
                                    textAlign: TextAlign.center,
                                    controller: owner.isNotEmpty
                                        ? TextEditingController(text: owner)
                                        : TextEditingController(text: ""),
                                    onChanged: (value) {
                                      owner = value;
                                      //Do something with the user input.
                                    },
                                    decoration: InputDecoration(
                                        hintText: 'Owner',
                                        contentPadding:
                                            CustomStyles.marginsAll20,
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: CustomColors
                                                    .inputTextBorderColor,
                                                width: CustomStyles.width)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: CustomColors
                                                    .selectedInputTextBorderColor,
                                                width: CustomStyles.width))),
                                  ),
                                  SizedBox(
                                    height: CustomStyles.smallBoxHeight,
                                  ),
                                  DropdownButtonFormField<String>(
                                      alignment: Alignment.center,
                                      value: offerType,
                                      isExpanded: true,
                                      selectedItemBuilder: (context) {
                                        return offerTypeList.map<Widget>((e) {
                                          return Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                32, 0, 0, 0),
                                            child: Center(child: Text(e)),
                                          );
                                        }).toList();
                                      },
                                      decoration: InputDecoration(
                                          contentPadding:
                                              CustomStyles.marginsAll20,
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: CustomColors
                                                      .inputTextBorderColor,
                                                  width: CustomStyles.width)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: CustomColors
                                                      .selectedInputTextBorderColor,
                                                  width: CustomStyles.width))),
                                      items: offerTypeList
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                          alignment: Alignment.center,
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          offerType = newValue!;
                                        });
                                      }),
                                ])
                          : displayDates
                              ? Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                      SizedBox(
                                          height:
                                              CustomStyles.enterToRegisterSize),
                                      TextField(
                                          controller: startDateController,
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                              icon: Icon(Icons.calendar_today),
                                              label: const Center(
                                                child: Text("Start Date"),
                                              )),
                                          readOnly: true,
                                          onTap: startDatePickerSetDate),
                                      SizedBox(
                                          height:
                                              CustomStyles.enterToRegisterSize),
                                      TextField(
                                          controller: endDateController,
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                              icon: Icon(Icons.calendar_today),
                                              label: const Center(
                                                child: Text("End Date"),
                                              )),
                                          readOnly: true,
                                          onTap: endDatePickerSetDate),
                                    ])
                              : Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                      SizedBox(
                                          height:
                                              CustomStyles.enterToRegisterSize),
                                      Container(
                                          child: ImageUploads(
                                        function: sendPhoto,
                                      )),
                                    ]),
                  Row(children: [
                    SizedBox(
                      height: CustomStyles.bigBoxHeight,
                    ),
                  ]),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: CustomColors.secondColor),
                          child: Text(CustomStyles.previousPage,
                              style:
                                  TextStyle(fontSize: CustomStyles.fontSize40)),
                          onPressed: displaySet1 ? null : previousButton),
                      displayImageUpload
                          ? TextButton(
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: CustomColors.secondColor),
                              child: Text(CustomStyles.addAnimal,
                                  style: TextStyle(
                                      fontSize: CustomStyles.fontSize40)),
                              onPressed: !addedPhoto
                                  ? null
                                  : () async {
                                      setState(() {
                                        showSpinner = true;
                                      });

                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();

                                      String? userUId = FirebaseAuth
                                          .instance.currentUser?.uid
                                          .toString();
                                      print(offerType);
                                      Animal animal = Animal(
                                          animalUId,
                                          age,
                                          breed,
                                          name,
                                          info,
                                          location,
                                          owner,
                                          userUId!,
                                          animalType,
                                          animalUId,
                                          offerType,
                                          dateStart,
                                          dateEnd,
                                          true);

                                      FirebaseFirestore.instance
                                          .collection("animals")
                                          .doc(animalUId)
                                          .set(animal.returnMap());

                                      firebase_storage.FirebaseStorage.instance
                                          .ref('animal_images/')
                                          .child('${animalUId}')
                                          .putFile(photo!)
                                          .whenComplete(() =>
                                              Navigator.pushNamed(
                                                  context, 'navbar_screen'));

                                      if (errorMessage.isNotEmpty)
                                        errorMessage = "";
                                      setState(() {
                                        showSpinner = false;
                                      });
                                    },
                            )
                          : TextButton(
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: CustomColors.secondColor),
                              child: Text(CustomStyles.nextPage,
                                  style: TextStyle(
                                      fontSize: CustomStyles.fontSize40)),
                              onPressed: displayImageUpload ? null : nextButton)
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void endDatePickerSetDate() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (pickedDate != null) {
      dateEnd = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        endDateController.text = dateEnd;
        // if (DateTime.parse(dateStart).isBefore(DateTime.parse(dateEnd))) {
        //   displayImageUpload = true;
        //   displayDates = false;
        // } else if (!DateTime.parse(dateStart)
        //     .isBefore(DateTime.parse(dateEnd))) {
        //   Text("Date start cannot be greater than date end!");
        // } else {
        //   displayImageUpload = true;
        //   displayDates = false;
        // }
      });
    } else {
      print("Date is not selected");
    }
    //when click we have to show the datepicker
  }

  void startDatePickerSetDate() async {
    DateTime? pickedDate2 = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (pickedDate2 != null) {
      print(pickedDate2);
      dateStart = DateFormat('yyyy-MM-dd').format(pickedDate2);

      setState(() {
        startDateController.text = dateStart;
      });
    } else {
      print("Date is not selected");
    }
    //when click we have to show the datepicker
  }

  void nextButton() async {
    if (age.toString().isNotEmpty &&
        name.isNotEmpty &&
        breed.isNotEmpty &&
        animalType.isNotEmpty &&
        displaySet1) {
      displaySet1 = false;
      displaySet2 = true;
    } else if (owner.isNotEmpty &&
        location.isNotEmpty &&
        info.isNotEmpty &&
        displaySet2) {
      displaySet2 = false;
      if (offerType == offerTypeList.last) {
        displayDates = true;
      } else {
        displayImageUpload = true;
      }
    } else if (displayDates) {
      if (dateStart.isNotEmpty && dateEnd.isNotEmpty) if (DateTime.parse(
              dateStart)
          .isBefore(DateTime.parse(dateEnd))) {
        displayImageUpload = true;
        displayDates = false;
      }
    }

    setState(() {});
  }

  void previousButton() async {
    if (displaySet2) {
      displaySet2 = false;
      displaySet1 = true;
    }
    if (displayDates) {
      displayDates = false;
      displaySet2 = true;
    }
    if (displayImageUpload) {
      displayImageUpload = false;
      if (offerType == offerTypeList.last) {
        displayDates = true;
      } else {
        displaySet2 = true;
      }
    }
    setState(() {});
  }

  void sendPhoto(File file) async {
    if (file == null) return;
    photo = file;
    setState(() {
      addedPhoto = true;
    });
  }
}
