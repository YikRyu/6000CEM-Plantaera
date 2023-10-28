//scrollable row reference: https://stackoverflow.com/questions/46222788/how-to-create-a-row-of-scrollable-text-boxes-or-widgets-in-flutter-inside-a-list

import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:plantaera/res/colors.dart';

class NewPlantGuide extends StatefulWidget {
  const NewPlantGuide({Key? key}) : super(key: key);

  @override
  State<NewPlantGuide> createState() => _NewPlantGuideState();
}

class _NewPlantGuideState extends State<NewPlantGuide> {
  final newPlantFormKey = GlobalKey<FormState>();
  String? coverPath;

  //general fields
  TextEditingController _plantNameController = TextEditingController();
  TextEditingController _scientificNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String? plantCover;
  String? plantGallery;
  //characteristics fields
  TextEditingController _plantTypeController = TextEditingController();
  TextEditingController _lifespanController = TextEditingController();
  TextEditingController _bloomTimeController = TextEditingController();
  TextEditingController _habitatController = TextEditingController();
  //plnating tips fields
  TextEditingController _difficultyController = TextEditingController();
  TextEditingController _sunlightController = TextEditingController();
  TextEditingController _soilController = TextEditingController();
  TextEditingController _waterController = TextEditingController();
  TextEditingController _fertilizeController = TextEditingController();
  TextEditingController _plantingTimeController = TextEditingController();
  TextEditingController _harvestTimeController = TextEditingController();
  TextEditingController _diseaseController = TextEditingController();

  bool _loading = false;
  String newPlantStateMessage = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: null,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: deepPink,
              size: 35,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: Form(
            key: newPlantFormKey,
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            child: Text(
                              "Plant Name: ",
                              style: TextStyle(
                                fontSize: 20,
                                color: deepPink,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            width: 215,
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              controller: _plantNameController,
                              enableSuggestions: false,
                              autocorrect: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter plant name';
                                }
                                return null;
                              },
                              style: TextStyle(
                                fontSize: 17,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Enter plant name",
                                hintStyle: const TextStyle(
                                  fontSize: 17,
                                  color: lightgrey,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: deepPink,
                                    width: 1.0,
                                    style: BorderStyle.none,
                                  ),
                                  borderRadius: BorderRadius.circular(7.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ), //plant name field
                      SizedBox(
                        height: 10.0,
                      ), //spacing

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            child: Text(
                              "Scientific Name: ",
                              style: TextStyle(
                                fontSize: 20,
                                color: deepPink,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            width: 215,
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              controller: _scientificNameController,
                              enableSuggestions: false,
                              autocorrect: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter scientific name';
                                }
                                return null;
                              },
                              style: TextStyle(
                                fontSize: 17,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Enter plant scientific name",
                                hintStyle: const TextStyle(
                                  fontSize: 17,
                                  color: lightgrey,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: deepPink,
                                    width: 1.0,
                                    style: BorderStyle.none,
                                  ),
                                  borderRadius: BorderRadius.circular(7.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ), //scientific name field
                      SizedBox(
                        height: 10.0,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 100,
                            child: Text(
                              "Plant Cover: ",
                              style: TextStyle(
                                fontSize: 20,
                                color: deepPink,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          coverPath == null
                              ? DottedBorder(
                                borderType: BorderType.RRect,
                                color: darkgrey,
                                strokeWidth: 4.0,
                                dashPattern: [6],
                                radius: Radius.circular(10.0),
                                child: Container(
                                  width: 150,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            DottedBorder(
                                              borderType: BorderType.RRect,
                                              color: darkgrey,
                                              strokeWidth: 2.0,
                                              dashPattern: [5],
                                              radius: Radius.circular(10.0),
                                              child: Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.add,
                                                  size: 35,
                                                  color: darkgrey,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ), //spacing
                                        Center(
                                          child: Text(
                                            "Add Plant Cover",
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              : Container(
                                  width: double.infinity,
                                  height: 150,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: FileImage(
                                            File(coverPath as String)),
                                      )),
                                ),
                        ],
                      ), //cover container
                      SizedBox(
                        height: 30.0,
                      ), //spacing

                      Container(
                        width: double.infinity,
                        height: 180,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              width: 1,
                              color: deepPink,
                            ),
                            bottom: BorderSide(
                              width: 1,
                              color: deepPink,
                            ),
                          ),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                "Gallery",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: deepPink,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ), //spacing
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: DottedBorder(
                                      borderType: BorderType.RRect,
                                      color: darkgrey,
                                      strokeWidth: 4.0,
                                      dashPattern: [6],
                                      radius: Radius.circular(10.0),
                                      child: Container(
                                        width: 150,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  DottedBorder(
                                                    borderType: BorderType.RRect,
                                                    color: darkgrey,
                                                    strokeWidth: 2.0,
                                                    dashPattern: [5],
                                                    radius: Radius.circular(10.0),
                                                    child: Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Icon(
                                                        Icons.add,
                                                        size: 35,
                                                        color: darkgrey,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ), //spacing
                                              Center(
                                                child: Text(
                                                  "Add Plant Cover",
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors.black,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ), //gallery container
                      SizedBox(
                        height: 30.0,
                      ),

                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              width: 1,
                              color: deepPink,
                            ),
                            bottom: BorderSide(
                              width: 1,
                              color: deepPink,
                            ),
                          ),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                "Description",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: deepPink,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ), //spacing
                            Center(
                              child: SizedBox(
                                width: 340,
                                height: 150,
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  controller: _descriptionController,
                                  minLines: 6,
                                  maxLines: 7,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      value = "N/A";
                                    }
                                    return null;
                                  },
                                  style: TextStyle(
                                    fontSize: 17,
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: "Enter plant description",
                                    hintStyle: const TextStyle(
                                      fontSize: 17,
                                      color: lightgrey,
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: deepPink,
                                        width: 1.0,
                                        style: BorderStyle.none,
                                      ),
                                      borderRadius: BorderRadius.circular(7.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ), //description container
                      SizedBox(
                        height: 30,
                      ), //spacing

                      Container(
                        padding: const EdgeInsets.only(
                          bottom: 10.0,
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              width: 1,
                              color: deepPink,
                            ),
                            bottom: BorderSide(
                              width: 1,
                              color: deepPink,
                            ),
                          ),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                "Characteristics",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: deepPink,
                                ),
                              ),
                            ),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Plant Type: ",
                                            style: TextStyle(
                                              fontSize: 17.0,
                                              color: deepPink,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 200,
                                            height: 40,
                                            child: TextFormField(
                                              textAlign: TextAlign.center,
                                              controller: _plantTypeController,
                                              enableSuggestions: false,
                                              autocorrect: false,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  value = "N/A";
                                                }
                                                return null;
                                              },
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                hintText: "Enter plant type",
                                                hintStyle: const TextStyle(
                                                  fontSize: 15,
                                                  color: lightgrey,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: deepPink,
                                                    width: 1.0,
                                                    style: BorderStyle.none,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          7.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ), //plant type field
                                    SizedBox(
                                      height: 5.0,
                                    ), //spacing

                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Lifespan: ",
                                            style: TextStyle(
                                              fontSize: 17.0,
                                              color: deepPink,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 200,
                                            height: 40,
                                            child: TextFormField(
                                              textAlign: TextAlign.center,
                                              controller: _lifespanController,
                                              enableSuggestions: false,
                                              autocorrect: false,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  value = "N/A";
                                                }
                                                return null;
                                              },
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                hintText:
                                                    "Enter plant lifespan",
                                                hintStyle: const TextStyle(
                                                  fontSize: 15,
                                                  color: lightgrey,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: deepPink,
                                                    width: 1.0,
                                                    style: BorderStyle.none,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          7.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ), //lifespan field
                                    SizedBox(
                                      height: 5.0,
                                    ), //spacing

                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Bloom Time: ",
                                            style: TextStyle(
                                              fontSize: 17.0,
                                              color: deepPink,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 200,
                                            height: 40,
                                            child: TextFormField(
                                              textAlign: TextAlign.center,
                                              controller: _bloomTimeController,
                                              enableSuggestions: false,
                                              autocorrect: false,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  value = "N/A";
                                                }
                                                return null;
                                              },
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                hintText:
                                                    "Enter plant flower bloom time",
                                                hintStyle: const TextStyle(
                                                  fontSize: 15,
                                                  color: lightgrey,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: deepPink,
                                                    width: 1.0,
                                                    style: BorderStyle.none,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          7.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ), //bloom time field
                                    SizedBox(
                                      height: 5.0,
                                    ),

                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Habitat: ",
                                            style: TextStyle(
                                              fontSize: 17.0,
                                              color: deepPink,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 200,
                                            height: 40,
                                            child: TextFormField(
                                              textAlign: TextAlign.center,
                                              controller: _habitatController,
                                              enableSuggestions: false,
                                              autocorrect: false,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  value = "N/A";
                                                }
                                                return null;
                                              },
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                hintText: "Enter plant habitat",
                                                hintStyle: const TextStyle(
                                                  fontSize: 15,
                                                  color: lightgrey,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: deepPink,
                                                    width: 1.0,
                                                    style: BorderStyle.none,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          7.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ), //habitat field
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                  ],
                                ),
                              ),
                            ), //list of the characteristics
                          ],
                        ),
                      ), //characteristics container
                      SizedBox(
                        height: 30,
                      ), //spacing

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                          bottom: 10.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              width: 1,
                              color: deepPink,
                            ),
                            bottom: BorderSide(
                              width: 1,
                              color: deepPink,
                            ),
                          ),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                "Planting Tips",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: deepPink,
                                ),
                              ),
                            ),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Difficulty: ",
                                            style: TextStyle(
                                              fontSize: 17.0,
                                              color: deepPink,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 200,
                                            height: 100,
                                            child: TextFormField(
                                              textAlign: TextAlign.center,
                                              controller: _difficultyController,
                                              enableSuggestions: false,
                                              autocorrect: false,
                                              minLines: 3,
                                              maxLines: 4,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  value = "N/A";
                                                }
                                                return null;
                                              },
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                hintText:
                                                    "Enter planting difficulty",
                                                hintStyle: const TextStyle(
                                                  fontSize: 15,
                                                  color: lightgrey,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: deepPink,
                                                    width: 1.0,
                                                    style: BorderStyle.none,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          7.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ), //difficulty field
                                    SizedBox(
                                      height: 5.0,
                                    ), //spacing

                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Sunlight: ",
                                            style: TextStyle(
                                              fontSize: 17.0,
                                              color: deepPink,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 200,
                                            height: 40,
                                            child: TextFormField(
                                              textAlign: TextAlign.center,
                                              controller: _sunlightController,
                                              enableSuggestions: false,
                                              autocorrect: false,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  value = "N/A";
                                                }
                                                return null;
                                              },
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                hintText:
                                                    "Enter suitable sunlight",
                                                hintStyle: const TextStyle(
                                                  fontSize: 15,
                                                  color: lightgrey,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: deepPink,
                                                    width: 1.0,
                                                    style: BorderStyle.none,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          7.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ), //sunlight field
                                    SizedBox(
                                      height: 5.0,
                                    ), //spacing

                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Soil: ",
                                            style: TextStyle(
                                              fontSize: 17.0,
                                              color: deepPink,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 200,
                                            height: 40,
                                            child: TextFormField(
                                              textAlign: TextAlign.center,
                                              controller: _soilController,
                                              enableSuggestions: false,
                                              autocorrect: false,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  value = "N/A";
                                                }
                                                return null;
                                              },
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                hintText: "Enter suitable soil",
                                                hintStyle: const TextStyle(
                                                  fontSize: 15,
                                                  color: lightgrey,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: deepPink,
                                                    width: 1.0,
                                                    style: BorderStyle.none,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          7.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ), //soil field
                                    SizedBox(
                                      height: 5.0,
                                    ), //spacing

                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Water: ",
                                            style: TextStyle(
                                              fontSize: 17.0,
                                              color: deepPink,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 200,
                                            height: 40,
                                            child: TextFormField(
                                              textAlign: TextAlign.center,
                                              controller: _waterController,
                                              enableSuggestions: false,
                                              autocorrect: false,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  value = "N/A";
                                                }
                                                return null;
                                              },
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                hintText: "Enter water amount",
                                                hintStyle: const TextStyle(
                                                  fontSize: 15,
                                                  color: lightgrey,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: deepPink,
                                                    width: 1.0,
                                                    style: BorderStyle.none,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          7.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ), //water field
                                    SizedBox(
                                      height: 5.0,
                                    ), //spacing

                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Fertilize: ",
                                            style: TextStyle(
                                              fontSize: 17.0,
                                              color: deepPink,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 200,
                                            height: 100,
                                            child: TextFormField(
                                              textAlign: TextAlign.center,
                                              controller: _fertilizeController,
                                              enableSuggestions: false,
                                              autocorrect: false,
                                              minLines: 3,
                                              maxLines: 4,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  value = "N/A";
                                                }
                                                return null;
                                              },
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                hintText:
                                                    "Enter fertilize info",
                                                hintStyle: const TextStyle(
                                                  fontSize: 15,
                                                  color: lightgrey,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: deepPink,
                                                    width: 1.0,
                                                    style: BorderStyle.none,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          7.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ), //fertilize field
                                    SizedBox(
                                      height: 5.0,
                                    ), //spacing

                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Planting Time: ",
                                            style: TextStyle(
                                              fontSize: 17.0,
                                              color: deepPink,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 200,
                                            height: 40,
                                            child: TextFormField(
                                              textAlign: TextAlign.center,
                                              controller:
                                                  _plantingTimeController,
                                              enableSuggestions: false,
                                              autocorrect: false,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  value = "N/A";
                                                }
                                                return null;
                                              },
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                hintText: "Enter planting time",
                                                hintStyle: const TextStyle(
                                                  fontSize: 15,
                                                  color: lightgrey,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: deepPink,
                                                    width: 1.0,
                                                    style: BorderStyle.none,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          7.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ), //planting time field
                                    SizedBox(
                                      height: 5.0,
                                    ), //spacing

                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Harvest Time: ",
                                            style: TextStyle(
                                              fontSize: 17.0,
                                              color: deepPink,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 200,
                                            height: 40,
                                            child: TextFormField(
                                              textAlign: TextAlign.center,
                                              controller:
                                                  _harvestTimeController,
                                              enableSuggestions: false,
                                              autocorrect: false,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  value = "N/A";
                                                }
                                                return null;
                                              },
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                hintText: "Enter harvest time",
                                                hintStyle: const TextStyle(
                                                  fontSize: 15,
                                                  color: lightgrey,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: deepPink,
                                                    width: 1.0,
                                                    style: BorderStyle.none,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          7.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ), //harvest time field
                                    SizedBox(
                                      height: 5.0,
                                    ), //spacing

                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Disease: ",
                                            style: TextStyle(
                                              fontSize: 17.0,
                                              color: deepPink,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 200,
                                            height: 40,
                                            child: TextFormField(
                                              textAlign: TextAlign.center,
                                              controller: _diseaseController,
                                              enableSuggestions: false,
                                              autocorrect: false,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  value = "N/A";
                                                }
                                                return null;
                                              },
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                hintText:
                                                    "Enter dissease vulnerabilities",
                                                hintStyle: const TextStyle(
                                                  fontSize: 15,
                                                  color: lightgrey,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: deepPink,
                                                    width: 1.0,
                                                    style: BorderStyle.none,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          7.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ), //disease field
                                    SizedBox(
                                      height: 5.0,
                                    ), //spacing
                                  ],
                                ),
                              ),
                            ), //list of the characteristics
                          ],
                        ),
                      ), // container
                      SizedBox(
                        height: 30,
                      ), //spacing

                      Center(
                        child: Text(
                          newPlantStateMessage,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ), //new plant status message

                      SizedBox(
                        width: 330,
                        height: 50,
                        child: ElevatedButton(
                          //change password button
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cherry,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                            shadowColor: Colors.grey.withOpacity(0.9),
                          ),
                          child: Center(
                            child: _loading
                                ? const SizedBox(
                                    width: 50,
                                    height: 44,
                                    child: CircularProgressIndicator(
                                      color: pastelPink,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    "Add New Plant",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                          ),
                        ),
                      ), //add new plant button
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
