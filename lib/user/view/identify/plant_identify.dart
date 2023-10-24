//dotted border reference: https://pub.dev/packages/dotted_border

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:plantaera/res/colors.dart';

class IdentifyPlant extends StatefulWidget {
  const IdentifyPlant({Key? key}) : super(key: key);

  @override
  State<IdentifyPlant> createState() => _IdentifyPlantState();
}

class _IdentifyPlantState extends State<IdentifyPlant> {
  String plantName = 'Upload a picture/ Take a picture to identify';
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
                  child: InkWell(
                    onTap: () {},
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.camera_alt, color: Colors.black, size: 45,),
                                      SizedBox(width: 10.0,), //spacing
                                      Text("Take a picture", style: TextStyle(fontSize: 20, color: Colors.black,),),
                                    ],
                                  ),
                                  SizedBox(height: 10.0,), //spacing
                                  Text("OR", style: TextStyle(fontSize: 20.0, color: Colors.black,),),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Upload a picture", style: TextStyle(fontSize: 20, color: Colors.black,),),
                                      SizedBox(width: 10.0,),
                                      Icon(Icons.photo, color: Colors.black, size: 45,),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
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
                child: Card(
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
                    child: Center(
                        child: Text(
                      plantName,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    )),
                  ),
                ),
              ), //plant name
              SizedBox(
                height: 20,
              ), //spacing

              SizedBox(
                width: 150,
                height: 45,
                child: ElevatedButton(
                  //sign in button
                  onPressed: () {},
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
