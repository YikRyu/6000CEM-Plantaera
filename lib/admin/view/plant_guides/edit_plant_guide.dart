import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plantaera/admin/view_model/admin_plant_viewmodel.dart';
import 'package:plantaera/res/colors.dart';
import 'package:image_picker/image_picker.dart';

class AdminPlantGuideEdit extends StatefulWidget {
  AdminPlantGuideEdit({Key? key}) : super(key: key);

  @override
  State<AdminPlantGuideEdit> createState() => _AdminPlantGuideEditState();
}

class _AdminPlantGuideEditState extends State<AdminPlantGuideEdit> {
  final editPlantFormKey = GlobalKey<FormState>();

  //general fields
  TextEditingController _plantNameController = TextEditingController();
  TextEditingController _scientificNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  XFile? plantCover;
  List<XFile> plantGallery = [];
  //characteristics fields
  TextEditingController _plantTypeController = TextEditingController();
  TextEditingController _lifespanController = TextEditingController();
  TextEditingController _bloomTimeController = TextEditingController();
  TextEditingController _habitatController = TextEditingController();
  //planting tips fields
  TextEditingController _difficultyController = TextEditingController();
  TextEditingController _sunlightController = TextEditingController();
  TextEditingController _soilController = TextEditingController();
  TextEditingController _waterController = TextEditingController();
  TextEditingController _fertilizeController = TextEditingController();
  TextEditingController _plantingTimeController = TextEditingController();
  TextEditingController _harvestTimeController = TextEditingController();
  TextEditingController _diseaseController = TextEditingController();

  bool _loading = false;
  String editPlantStateMessage = '';
  String plantId = '';
  String plantCoverURL = '';
  List<String> plantGalleryURLList = [];
  AdminPlantVM plantVM = AdminPlantVM();

  //Function for plant cover image picker
  Future<XFile?> plantCoverPicker() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  //Function for gallery image picker
  Future<List<XFile>> galleryImagePicker() async {
    List<XFile>? _gallery = await ImagePicker().pickMultiImage();

    if (_gallery.length != 0 && _gallery.isNotEmpty) {
      return _gallery;
    }
    return [];
  }

  //function for new plant
  handleSubmit() async {
    if (editPlantFormKey.currentState!.validate() && ((plantGalleryURLList.length != 0) || (plantGallery.length != 0))) {
      final plantName = _plantNameController.value.text;
      final plantNameLowercase = plantName.toLowerCase();
      final scientificName = _scientificNameController.value.text;
      final scientificLowerCase = scientificName.toLowerCase();
      final description = _descriptionController.value.text;
      final plantType = _plantTypeController.value.text;
      final lifespan = _lifespanController.value.text;
      final bloom = _bloomTimeController.value.text;
      final habitat = _habitatController.value.text;
      final difficulty = _difficultyController.value.text;
      final sunlight = _sunlightController.value.text;
      final soil = _soilController.value.text;
      final water = _waterController.value.text;
      final fertilize = _fertilizeController.value.text;
      final plantingTime = _plantingTimeController.value.text;
      final harvestTime = _harvestTimeController.value.text;
      final disease = _diseaseController.value.text;
      setState(() {
        _loading = false;
      });

      //call the function in VM to add data into db
      editPlantStateMessage = await plantVM.editPlantGuide(
          plantId,
          plantName,
          plantNameLowercase,
          scientificName,
          scientificLowerCase,
          description,
          plantType,
          lifespan,
          bloom,
          habitat,
          difficulty,
          sunlight,
          soil,
          water,
          fertilize,
          plantingTime,
          harvestTime,
          disease,
          plantCover,
          plantGallery,
          plantCoverURL);

      if (editPlantStateMessage == "ok") {
        //redirect back to admin list with toaster message shown
        Fluttertoast.showToast(
          msg: "Plant guide edited successfully! Redirecting back to previous page....",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        Navigator.pop(context);
        _loading = false;
      } else {
        setState(() {
          _loading = false; //for the loading progress bar
        });
      }
    } else if((plantGallery.length == 0) && plantGalleryURLList.length == 0){
      setState(() {
        _loading = false;
      });
      return editPlantStateMessage = "Please provide at least one gallery image!";
    }
    else {
      setState(() {
        _loading = false;
      });
      return editPlantStateMessage = "Please insert all fields";
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    //fetch arguments passed from previous page
    plantId = arguments['plantId']!;

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
          child: Column(
            children: [
              FutureBuilder(
                future: plantVM.fetchPlantDetails(plantId),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: pink,
                      ),
                    );
                  }

                  //assign document to a map for field retrieval
                  Map<String, dynamic> plantModel = snapshot.data;
                  //some variables to be used ltr
                  String coverPath = plantModel['cover'];

                  //assign for setting up initial value for controllers
                  _plantNameController.text = plantModel['name'];
                  _scientificNameController.text = plantModel['scientificName'];
                  _descriptionController.text = plantModel['description'];
                  _plantTypeController.text = plantModel['plantType'];
                  _lifespanController.text = plantModel['lifespan'];
                  _bloomTimeController.text = plantModel['bloomTime'];
                  _habitatController.text = plantModel['habitat'];
                  _difficultyController.text = plantModel['difficulty'];
                  _sunlightController.text = plantModel['sunlight'];
                  _soilController.text = plantModel['soil'];
                  _waterController.text = plantModel['water'];
                  _fertilizeController.text = plantModel['fertilize'];
                  _plantingTimeController.text = plantModel['plantingTime'];
                  _harvestTimeController.text = plantModel['harvestTime'];
                  _diseaseController.text = plantModel['disease'];

                  return Expanded(
                    child: ListView.builder(
                      itemCount: 1,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return Form(
                          key: editPlantFormKey,
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
                                              contentPadding: EdgeInsets.all(8),
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
                                              contentPadding: EdgeInsets.all(8),
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
                                        plantCover == null
                                            ? FutureBuilder<String>(
                                                future: plantVM.fetchPlantCover(plantId, coverPath),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    plantCoverURL = snapshot.data!;
                                                    return InkWell(
                                                      onTap: () async {
                                                        plantCover = await plantCoverPicker();
                                                        setState(() {});
                                                      },
                                                      child: Container(
                                                        width: 120,
                                                        height: 120,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(
                                                            10,
                                                          ),
                                                          image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: NetworkImage(plantCoverURL),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  return CircularProgressIndicator(
                                                    color: pink,
                                                  );
                                                },
                                              )
                                            : InkWell(
                                                onTap: () async {
                                                  plantCover = await plantCoverPicker();
                                                  setState(() {});
                                                },
                                                child: Container(
                                                  width: 150,
                                                  height: 120,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: FileImage(File(plantCover!.path)),
                                                    ),
                                                  ),
                                                ),
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
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: InkWell(
                                                    onTap: () async {
                                                      List<XFile>? plantGalleryList = await galleryImagePicker();
                                                      if (plantGalleryList.isNotEmpty) {
                                                        for (XFile _imageList in plantGalleryList) {
                                                          plantGallery.add(_imageList);
                                                        }
                                                        setState(() {});
                                                      }
                                                    },
                                                    child: DottedBorder(
                                                      borderType: BorderType.RRect,
                                                      color: darkgrey,
                                                      strokeWidth: 4.0,
                                                      dashPattern: [5],
                                                      radius: Radius.circular(10.0),
                                                      child: Container(
                                                        width: 120,
                                                        height: 120,
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(
                                                            10,
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  DottedBorder(
                                                                    borderType: BorderType.RRect,
                                                                    color: darkgrey,
                                                                    strokeWidth: 2.0,
                                                                    dashPattern: [5],
                                                                    radius: Radius.circular(50.0),
                                                                    child: Container(
                                                                      height: 40,
                                                                      width: 40,
                                                                      decoration: BoxDecoration(
                                                                        color: Colors.grey,
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
                                                                  "Add Plant Picture",
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
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                plantGallery.length != 0 && plantGallery.isNotEmpty
                                                    ? Wrap(
                                                        alignment: WrapAlignment.spaceBetween,
                                                        children: plantGallery
                                                            .map(
                                                              (e) => Row(
                                                                children: [
                                                                  Stack(
                                                                    children: [
                                                                      Container(
                                                                        width: 120,
                                                                        height: 120,
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                            10,
                                                                          ),
                                                                          image: DecorationImage(
                                                                            fit: BoxFit.cover,
                                                                            image: FileImage(
                                                                              File(e.path),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        width: 120,
                                                                        padding: EdgeInsets.fromLTRB(0, 5, 5, 0),
                                                                        child: Align(
                                                                          alignment: Alignment.topRight,
                                                                          child: InkWell(
                                                                            onTap: () {
                                                                              plantGallery.remove(e);
                                                                              setState(() {});
                                                                            },
                                                                            child: Stack(
                                                                              children: [
                                                                                Icon(
                                                                                  Icons.delete,
                                                                                  size: 25,
                                                                                  color: Colors.red,
                                                                                  shadows: [
                                                                                    Shadow(
                                                                                        // bottomLeft
                                                                                        offset: Offset(-1.5, -1.5),
                                                                                        color: Colors.white),
                                                                                    Shadow(
                                                                                        // bottomRight
                                                                                        offset: Offset(1.5, -1.5),
                                                                                        color: Colors.white),
                                                                                    Shadow(
                                                                                        // topRight
                                                                                        offset: Offset(1.5, 1.5),
                                                                                        color: Colors.white),
                                                                                    Shadow(
                                                                                        // topLeft
                                                                                        offset: Offset(-1.5, 1.5),
                                                                                        color: Colors.white),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                            .toList(),
                                                      )
                                                    : SizedBox.shrink(),
                                                FutureBuilder<List<String>>(
                                                    future: plantVM.fetchPlantGallery(
                                                        plantId),
                                                    builder: (context, snapshot) {
                                                      if (!snapshot.hasData) {
                                                        return SizedBox.shrink();
                                                      }

                                                      if (snapshot.hasData) {
                                                        plantGalleryURLList =
                                                        snapshot.data!;
                                                        return Wrap(
                                                          alignment: WrapAlignment
                                                              .spaceBetween,
                                                          children: plantGalleryURLList
                                                              .map(
                                                                (e) => Row(
                                                              children: [
                                                                Stack(
                                                                  children: [
                                                                    Container(
                                                                      width: 120,
                                                                      height: 120,
                                                                      decoration:
                                                                      BoxDecoration(
                                                                        borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                          10,
                                                                        ),
                                                                        image:
                                                                        DecorationImage(
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          image:
                                                                          NetworkImage(
                                                                              e),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      width: 120,
                                                                      padding: EdgeInsets.fromLTRB(0, 5, 5, 0),
                                                                      child: Align(
                                                                        alignment: Alignment.topRight,
                                                                        child: InkWell(
                                                                          onTap: () {
                                                                            plantGalleryURLList.remove(e);
                                                                            plantVM.deletePlantGallery(
                                                                                e); //remove the gallery image from firebase storage
                                                                            setState(() {});
                                                                          },
                                                                          child: Stack(
                                                                            children: [
                                                                              Icon(
                                                                                Icons.delete,
                                                                                size: 25,
                                                                                color: Colors.red,
                                                                                shadows: [
                                                                                  Shadow(
                                                                                    // bottomLeft
                                                                                      offset: Offset(-1.5, -1.5),
                                                                                      color: Colors.white),
                                                                                  Shadow(
                                                                                    // bottomRight
                                                                                      offset: Offset(1.5, -1.5),
                                                                                      color: Colors.white),
                                                                                  Shadow(
                                                                                    // topRight
                                                                                      offset: Offset(1.5, 1.5),
                                                                                      color: Colors.white),
                                                                                  Shadow(
                                                                                    // topLeft
                                                                                      offset: Offset(-1.5, 1.5),
                                                                                      color: Colors.white),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                              .toList(),
                                                        );
                                                      }
                                                      return CircularProgressIndicator(
                                                        color: pink,
                                                      );
                                                    }),
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
                                                textAlign: TextAlign.justify,
                                                controller: _descriptionController,
                                                minLines: 6,
                                                maxLines: 7,
                                                enableSuggestions: false,
                                                autocorrect: false,
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    _descriptionController.text = "N/A";
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
                                                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                              if (value == null || value.isEmpty) {
                                                                _plantTypeController.text = "N/A";
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
                                                              contentPadding: EdgeInsets.all(8),
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
                                                                borderRadius: BorderRadius.circular(7.0),
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
                                                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                              if (value == null || value.isEmpty) {
                                                                _lifespanController.text = "N/A";
                                                              }
                                                              return null;
                                                            },
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                            ),
                                                            decoration: InputDecoration(
                                                              filled: true,
                                                              fillColor: Colors.white,
                                                              contentPadding: EdgeInsets.all(8),
                                                              hintText: "Enter plant lifespan",
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
                                                                borderRadius: BorderRadius.circular(7.0),
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
                                                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                              if (value == null || value.isEmpty) {
                                                                _bloomTimeController.text = "N/A";
                                                              }
                                                              return null;
                                                            },
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                            ),
                                                            decoration: InputDecoration(
                                                              filled: true,
                                                              fillColor: Colors.white,
                                                              contentPadding: EdgeInsets.all(8),
                                                              hintText: "Enter plant flower bloom time",
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
                                                                borderRadius: BorderRadius.circular(7.0),
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
                                                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                              if (value == null || value.isEmpty) {
                                                                _habitatController.text = "N/A";
                                                              }
                                                              return null;
                                                            },
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                            ),
                                                            decoration: InputDecoration(
                                                              filled: true,
                                                              fillColor: Colors.white,
                                                              contentPadding: EdgeInsets.all(8),
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
                                                                borderRadius: BorderRadius.circular(7.0),
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
                                                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                            minLines: 5,
                                                            maxLines: 6,
                                                            validator: (value) {
                                                              if (value == null || value.isEmpty) {
                                                                _difficultyController.text = "N/A";
                                                              }
                                                              return null;
                                                            },
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                            ),
                                                            decoration: InputDecoration(
                                                              filled: true,
                                                              fillColor: Colors.white,
                                                              contentPadding: EdgeInsets.all(8),
                                                              hintText: "Enter planting difficulty",
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
                                                                borderRadius: BorderRadius.circular(7.0),
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
                                                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                              if (value == null || value.isEmpty) {
                                                                _sunlightController.text = "N/A";
                                                              }
                                                              return null;
                                                            },
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                            ),
                                                            decoration: InputDecoration(
                                                              filled: true,
                                                              fillColor: Colors.white,
                                                              contentPadding: EdgeInsets.all(8),
                                                              hintText: "Enter suitable sunlight",
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
                                                                borderRadius: BorderRadius.circular(7.0),
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
                                                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                              if (value == null || value.isEmpty) {
                                                                _soilController.text = "N/A";
                                                              }
                                                              return null;
                                                            },
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                            ),
                                                            decoration: InputDecoration(
                                                              filled: true,
                                                              fillColor: Colors.white,
                                                              contentPadding: EdgeInsets.all(8),
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
                                                                borderRadius: BorderRadius.circular(7.0),
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
                                                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                          height: 100,
                                                          child: TextFormField(
                                                            textAlign: TextAlign.center,
                                                            controller: _waterController,
                                                            enableSuggestions: false,
                                                            autocorrect: false,
                                                            minLines: 5,
                                                            maxLines: 6,
                                                            validator: (value) {
                                                              if (value == null || value.isEmpty) {
                                                                _waterController.text = "N/A";
                                                              }
                                                              return null;
                                                            },
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                            ),
                                                            decoration: InputDecoration(
                                                              filled: true,
                                                              fillColor: Colors.white,
                                                              contentPadding: EdgeInsets.all(8),
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
                                                                borderRadius: BorderRadius.circular(7.0),
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
                                                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                            minLines: 5,
                                                            maxLines: 6,
                                                            validator: (value) {
                                                              if (value == null || value.isEmpty) {
                                                                _fertilizeController.text = "N/A";
                                                              }
                                                              return null;
                                                            },
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                            ),
                                                            decoration: InputDecoration(
                                                              filled: true,
                                                              fillColor: Colors.white,
                                                              contentPadding: EdgeInsets.all(8),
                                                              hintText: "Enter fertilize info",
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
                                                                borderRadius: BorderRadius.circular(7.0),
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
                                                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                            controller: _plantingTimeController,
                                                            enableSuggestions: false,
                                                            autocorrect: false,
                                                            validator: (value) {
                                                              if (value == null || value.isEmpty) {
                                                                _plantingTimeController.text = "N/A";
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
                                                              contentPadding: EdgeInsets.all(8),
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
                                                                borderRadius: BorderRadius.circular(7.0),
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
                                                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                            controller: _harvestTimeController,
                                                            enableSuggestions: false,
                                                            autocorrect: false,
                                                            validator: (value) {
                                                              if (value == null || value.isEmpty) {
                                                                _harvestTimeController.text = "N/A";
                                                              }
                                                              return null;
                                                            },
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                            ),
                                                            decoration: InputDecoration(
                                                              filled: true,
                                                              fillColor: Colors.white,
                                                              contentPadding: EdgeInsets.all(8),
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
                                                                borderRadius: BorderRadius.circular(7.0),
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
                                                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                              if (value == null || value.isEmpty) {
                                                                _diseaseController.text = "N/A";
                                                              }
                                                              return null;
                                                            },
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                            ),
                                                            decoration: InputDecoration(
                                                              filled: true,
                                                              fillColor: Colors.white,
                                                              contentPadding: EdgeInsets.all(8),
                                                              hintText: "Enter disease vulnerabilities",
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
                                                                borderRadius: BorderRadius.circular(7.0),
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
                                        editPlantStateMessage,
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
                                        onPressed: () {
                                          setState(() {
                                            _loading = true;
                                            handleSubmit();
                                          });
                                        },
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
                                                  "Edit Plant",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ), //add new plant button
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
