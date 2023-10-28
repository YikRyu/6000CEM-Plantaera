import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:plantaera/res/colors.dart';

class NewDiseaseGuide extends StatefulWidget {
  const NewDiseaseGuide({Key? key}) : super(key: key);

  @override
  State<NewDiseaseGuide> createState() => _NewDiseaseGuideState();
}

class _NewDiseaseGuideState extends State<NewDiseaseGuide> {
  final newDiseaseFormKey = GlobalKey<FormState>();

  //general fields
  TextEditingController _diseaseNameController = TextEditingController();
  TextEditingController _symptomsController = TextEditingController();
  TextEditingController _causesController = TextEditingController();
  TextEditingController _solutionController = TextEditingController();
  TextEditingController _preventionController = TextEditingController();
  TextEditingController _galleryController = TextEditingController();

  bool _loading = false;

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
            key: newDiseaseFormKey,
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
                                hintText: "Enter disease name",
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
                      ), //disease name field
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
                                    child: Card(
                                      child: InkWell(
                                        onTap: () {},
                                        child: DottedBorder(
                                          borderType: BorderType.RRect,
                                          color: darkgrey,
                                          strokeWidth: 4.0,
                                          dashPattern: [6],
                                          radius: Radius.circular(10.0),
                                          child: Container(
                                            width: 150,
                                            height: 125,
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
                                                      DottedBorder(
                                                        borderType: BorderType.RRect,
                                                        color: darkgrey,
                                                        strokeWidth: 2.0,
                                                        dashPattern: [5],
                                                        radius: Radius.circular(40.0),
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
                                                      "Add New Picture",
                                                      style: TextStyle(
                                                        fontSize: 20.0,
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
                      SizedBox(height: 30,), //spacing


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
                      SizedBox(height: 30,),


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
                      SizedBox(height: 30,),


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
                      SizedBox(height: 30,),


                      SizedBox(
                        width: 330,
                        height: 50,
                        child: ElevatedButton(
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
                              "Add New Disease",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ), //add new disease button
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
