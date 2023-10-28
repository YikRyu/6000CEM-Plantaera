import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:plantaera/res/colors.dart';

class NewGeneralGuide extends StatefulWidget {
  const NewGeneralGuide({Key? key}) : super(key: key);

  @override
  State<NewGeneralGuide> createState() => _NewGeneralGuideState();
}

class _NewGeneralGuideState extends State<NewGeneralGuide> {
  final newGeneralFormKey = GlobalKey<FormState>();

  //general fields
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();


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
            key: newGeneralFormKey,
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
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
                                        child: Container(
                                          width: double.infinity,
                                          height: 150,
                                          color: darkgrey,
                                          child: DottedBorder(
                                            borderType: BorderType.RRect,
                                            color: darkgrey,
                                            strokeWidth: 4.0,
                                            dashPattern: [6],
                                            radius: Radius.circular(10.0),
                                            child: Container(
                                              width: 215,
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
                                                          radius: Radius.circular(40.0),
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
                                                        "Add New Banner",
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
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ), //banner container
                      SizedBox(
                        height: 30.0,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            child: Text(
                              "Title: ",
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
                              controller: _titleController,
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
                                "Content",
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
                                height: 300,
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  controller: _contentController,
                                  minLines: 10,
                                  maxLines: 12,
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
                                    hintText: "Enter article content",
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
                              "Add New Article",
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
