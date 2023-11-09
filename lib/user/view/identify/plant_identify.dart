//dotted border reference: https://pub.dev/packages/dotted_border
//image classification ref: https://medium.com/@utsavdutta/image-classification-using-flutter-tensorflowlite-322a66998aa4

import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantaera/res/colors.dart';
import 'dart:async';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:intl/intl.dart';

class IdentifyPlant extends StatefulWidget {
  const IdentifyPlant({Key? key}) : super(key: key);

  @override
  State<IdentifyPlant> createState() => _IdentifyPlantState();
}


class _IdentifyPlantState extends State<IdentifyPlant> {
  XFile? plantImage;
  String plantName = 'Upload a picture/ Take a picture to identify';
  String confidence = '';
  String identifyStatus = '';
  bool _loading = false;


  //pick image from mobile camera
  Future<XFile?> imgFromCamera() async {
    return await ImagePicker().pickImage(source: ImageSource.camera);
  }

  Future<XFile?> imgFromGallery() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  //loading the plant classification model
  Future loadPlantModel() async {
    Tflite.close();
    String? res;
    res = await Tflite.loadModel(
      model: "assets/plant_model.tflite",
      labels: "assets/plant_labels.txt",
    );
  }

  Future plantClassification(XFile image) async {
    // Run tflite image classification model on the image
    final List? results = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 1,
      threshold: 0.05,
      imageMean: 117.0,
      imageStd: 1.0,
    );

    setState(() {
      for(dynamic result in results!){
        String plantResult = result['label'];
        plantName = toBeginningOfSentenceCase(plantResult)!;
        confidence = result['confidence'].toStringAsFixed(2);
      }
      identifyStatus = '';
    });
  }

  identify(){
    if(plantImage == null){
      setState(() {
        identifyStatus = 'Please select an image to identify!';
      });
    }else{
      plantClassification(plantImage!);
    }
  }

  //show image picker
  void _showImagePicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(
                        Icons.photo_library,
                        color: darkGreen,
                      ),
                      title: new Text('Gallery'),
                      onTap: () async{
                        plantImage = await imgFromGallery();
                        Navigator.of(context).pop();
                        setState(() {
                        });
                      }),
                  new ListTile(
                    leading: new Icon(
                      Icons.photo_camera,
                      color: darkGreen,
                    ),
                    title: new Text('Camera'),
                    onTap: () async{
                      plantImage = await imgFromCamera();
                      Navigator.of(context).pop();
                      setState(() {
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    loadPlantModel();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
              color: darkGreen,
              size: 35,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Plant Identification",
                  style: TextStyle(
                    fontSize: 30,
                    color: darkGreen,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ), //spacing

              Center(
                child: Card(
                  child: plantImage == null
                      ? InkWell(
                          onTap: () {
                            _showImagePicker(context);
                          },
                          child: Container(
                            height: 350,
                            width: 300,
                            decoration: BoxDecoration(
                              color: lightgrey,
                            ),
                            child: Center(
                              child: DottedBorder(
                                borderType: BorderType.RRect,
                                color: Colors.black,
                                strokeWidth: 4.0,
                                dashPattern: [6],
                                radius: Radius.circular(10.0),
                                child: Container(
                                  width: 250,
                                  height: 220,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
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
                                            Icon(
                                              Icons.camera_alt,
                                              color: Colors.black,
                                              size: 45,
                                            ),
                                            SizedBox(
                                              width: 10.0,
                                            ), //spacing
                                            Text(
                                              "Take a picture",
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ), //spacing
                                        Text(
                                          "OR",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Upload a picture",
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            Icon(
                                              Icons.photo,
                                              color: Colors.black,
                                              size: 45,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            _showImagePicker(context);
                          },
                          child: Container(
                            height: 350,
                            width: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(File(plantImage!.path)),
                              ),
                            ),
                          ),
                        ),
                ),
              ), //picture card
              SizedBox(
                height: 20,
              ), //spacing

              Center(
                child: plantName == 'Upload a picture/ Take a picture to identify'
                ? Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    height: 70,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        width: 1.0,
                        color: darkGreen,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          plantName,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
                : Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    height: 70,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        width: 1.0,
                        color: darkGreen,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          plantName,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        /*Text(
                          'Confidence: ${confidence}%',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),*/
                      ],
                    ),
                  ),
                ),
              ), //plant result
              SizedBox(
                height: 20,
              ), //spacing

              Center(child: Text(identifyStatus, style: TextStyle(color: Colors.red, fontSize: 15,),)),
              SizedBox(
                width: 150,
                height: 45,
                child: ElevatedButton(
                  //sign in button
                  onPressed: () { identify(); },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: grass,
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
                              color: pastelGreen,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Identify!",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                  ),
                ),
              ), //identify button
            ],
          ),
        ),
      ),
    );
  }
}
