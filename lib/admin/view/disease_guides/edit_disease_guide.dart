import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantaera/res/colors.dart';
import 'dart:io';

import '../../view_model/admin_disease_viewmodel.dart';

class AdminDiseaseGuideEdit extends StatefulWidget {
  const AdminDiseaseGuideEdit({Key? key}) : super(key: key);

  @override
  State<AdminDiseaseGuideEdit> createState() => _AdminDiseaseGuideEditState();
}

class _AdminDiseaseGuideEditState extends State<AdminDiseaseGuideEdit> {
  final editDiseaseFormKey = GlobalKey<FormState>();

  //general fields
  TextEditingController _diseaseNameController = TextEditingController();
  TextEditingController _symptomsController = TextEditingController();
  TextEditingController _causesController = TextEditingController();
  TextEditingController _solutionController = TextEditingController();
  TextEditingController _preventionController = TextEditingController();

  String currentDiseaseId = '';
  XFile? diseaseCover;
  String diseaseCoverURL = '';
  List<XFile> diseaseGallery = [];
  List<String> diseaseGalleryURLList = [];
  String editDiseaseMessage = '';
  bool _loading = false;
  AdminDiseaseVM diseaseVm = AdminDiseaseVM();

  //Function for disease cover image picker
  Future<XFile?> diseaseCoverPicker() async {
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
    if (editDiseaseFormKey.currentState!.validate()) {
      final diseaseName = _diseaseNameController.value.text;
      final diseaseNameLowerCase = diseaseName.toLowerCase();
      final symptoms = _symptomsController.value.text;
      final causes = _causesController.value.text;
      final solutions = _solutionController.value.text;
      final preventions = _preventionController.value.text;

      //call the function in VM to add data into db
      editDiseaseMessage = await diseaseVm.editDiseaseGuide(currentDiseaseId, diseaseName, diseaseNameLowerCase, symptoms, causes, solutions, preventions, diseaseCover, diseaseGallery, diseaseCoverURL);

      if (editDiseaseMessage == "ok") {
        //redirect back to admin list with toaster message shown
        Fluttertoast.showToast(
          msg: "Disease edited successfully! Redirecting back to previous page....",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        setState(() {
          _loading = false;
        });
        Navigator.pop(context);
        _loading = false;
      } else if((diseaseGallery.length == 0) && diseaseGalleryURLList.length == 0){
        setState(() {
          _loading = false;
        });
        return editDiseaseMessage = "Please provide at least one gallery image!";
      }
      else {
        setState(() {
          _loading = false; //for the loading progress bar
        });
      }
    }else {
      setState(() {
        _loading = false;
      });
      return editDiseaseMessage = "Please insert all fields";
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    //fetch arguments passed from previous page
    currentDiseaseId = arguments['currentDiseaseId']!;

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
                future: diseaseVm.fetchDiseaseDetails(currentDiseaseId),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: pink,
                      ),
                    );
                  }

                  //assign document to a map for field retrieval
                  Map<String, dynamic> diseaseModel = snapshot.data;
                  //some variables to be used ltr
                  String coverPath = diseaseModel['cover'];

                  //assign for setting up initial value for controllers
                  _diseaseNameController.text = diseaseModel['name'];
                  _symptomsController.text = diseaseModel['symptoms'];
                  _causesController.text = diseaseModel['causes'];
                  _solutionController.text = diseaseModel['solutions'];
                  _preventionController.text = diseaseModel['preventions'];

                  return Expanded(
                    child: ListView.builder(
                      itemCount: 1,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return Form(
                          key: editDiseaseFormKey,
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
                                            "Disease Name: ",
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
                                            controller: _diseaseNameController,
                                            enableSuggestions: false,
                                            autocorrect: false,
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Please enter disease name';
                                              }
                                              return null;
                                            },
                                            style: TextStyle(
                                              fontSize: 17,
                                            ),
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              hintText: "Enter disease name",
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
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            "Disease Cover: ",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: deepPink,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        diseaseCover == null
                                            ? FutureBuilder<String>(
                                          future: diseaseVm.fetchDiseaseCover(currentDiseaseId, coverPath),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              diseaseCoverURL = snapshot.data!;
                                              return InkWell(
                                                onTap: () async {
                                                  diseaseCover = await diseaseCoverPicker();
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
                                                      image: NetworkImage(diseaseCoverURL),
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
                                            diseaseCover = await diseaseCoverPicker();
                                            setState(() {});
                                          },
                                          child: Container(
                                            width: 150,
                                            height: 120,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10.0),
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: FileImage(File(diseaseCover!.path)),
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
                                                          diseaseGallery.add(_imageList);
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
                                                diseaseGallery.length != 0 && diseaseGallery.isNotEmpty
                                                    ? Wrap(
                                                  alignment: WrapAlignment.spaceBetween,
                                                  children: diseaseGallery
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
                                                                    diseaseGallery.remove(e);
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
                                                    future: diseaseVm.fetchDiseaseGallery(
                                                        currentDiseaseId),
                                                    builder: (context, snapshot) {
                                                      if (!snapshot.hasData) {
                                                        return SizedBox.shrink();
                                                      }

                                                      if (snapshot.hasData) {
                                                        diseaseGalleryURLList =
                                                        snapshot.data!;
                                                        return Wrap(
                                                          alignment: WrapAlignment
                                                              .spaceBetween,
                                                          children: diseaseGalleryURLList
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
                                                                            diseaseGalleryURLList.remove(e);
                                                                            diseaseVm.deleteDiseaseGallery(
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
                                    ), //spacing

                                    Container(
                                      width: double.infinity,
                                      height: 150,
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
                                              "Symptoms",
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
                                              height: 100,
                                              child: TextFormField(
                                                textAlign: TextAlign.center,
                                                controller: _symptomsController,
                                                minLines: 5,
                                                maxLines: 6,
                                                enableSuggestions: false,
                                                autocorrect: false,
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    _symptomsController.text = "N/A";
                                                  }
                                                  return null;
                                                },
                                                style: TextStyle(
                                                  fontSize: 17,
                                                ),
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  hintText: "Enter disease symptom(s)",
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
                                    ), //symptoms container
                                    SizedBox(
                                      height: 30,
                                    ), //spacing

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
                                              "Causes",
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
                                                controller: _causesController,
                                                minLines: 6,
                                                maxLines: 7,
                                                enableSuggestions: false,
                                                autocorrect: false,
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    _causesController.text = "N/A";
                                                  }
                                                  return null;
                                                },
                                                style: TextStyle(
                                                  fontSize: 17,
                                                ),
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  hintText: "Enter disease cause(s)",
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
                                    ), //cause container
                                    SizedBox(
                                      height: 30,
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
                                              "Solutions",
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
                                                controller: _solutionController,
                                                minLines: 6,
                                                maxLines: 7,
                                                enableSuggestions: false,
                                                autocorrect: false,
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    _solutionController.text = "N/A";
                                                  }
                                                  return null;
                                                },
                                                style: TextStyle(
                                                  fontSize: 17,
                                                ),
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  hintText: "Enter disease solution(s)",
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
                                    ), //solution container
                                    SizedBox(
                                      height: 30,
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
                                              "Preventions",
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
                                                controller: _preventionController,
                                                minLines: 6,
                                                maxLines: 7,
                                                enableSuggestions: false,
                                                autocorrect: false,
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    _preventionController.text = "N/A";
                                                  }
                                                  return null;
                                                },
                                                style: TextStyle(
                                                  fontSize: 17,
                                                ),
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  hintText: "Enter disease prevention(s)",
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
                                    ), //preventions container
                                    SizedBox(
                                      height: 30,
                                    ),

                                    Center(
                                      child: Text(
                                        editDiseaseMessage,
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
                                            "Edit Disease",
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
