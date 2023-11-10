import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantaera/admin/view_model/admin_generalGuide_viewmodel.dart';
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
  XFile? guideBannerPath;

  bool _loading = false;
  String newArticleStatusMessage = '';
  AdminGeneralGuideVM guideVM = AdminGeneralGuideVM();

  //Function for plant cover image picker
  Future<XFile?> guideBannerPicker() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  handleSubmit () async{
    if(newGeneralFormKey.currentState!.validate() && (guideBannerPath != null)){
      final title = _titleController.value.text;
      final content = _contentController.value.text;

      newArticleStatusMessage = await guideVM.addGuideToDB(title, content, guideBannerPath!);

      if (newArticleStatusMessage == "ok") {
        //redirect back to admin list with toaster message shown
        Fluttertoast.showToast(
          msg:
          "New guide added successfully! Redirecting back to previous page....",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        _loading = false;
        Navigator.pop(context);
      } else {
        setState(() {
          _loading = false; //for the loading progress bar
        });
      }
    } else if (guideBannerPath == null) {
      setState(() {
        _loading = false;
      });
      return newArticleStatusMessage = "Please insert article banner!";
    } else {
      setState(() {
        _loading = false;
      });
      return newArticleStatusMessage = "Please insert all required fields";
    }
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
                      Center(
                        child: guideBannerPath == null
                            ? Card(
                                child: InkWell(
                                  onTap: () async{
                                    guideBannerPath = await guideBannerPicker();
                                    setState(() {
                                    });
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 150,
                                    color: Colors.grey,
                                    child: Center(
                                      child: DottedBorder(
                                        borderType: BorderType.RRect,
                                        color: darkgrey,
                                        strokeWidth: 4.0,
                                        dashPattern: [6],
                                        radius: Radius.circular(10,),
                                        child: Container(
                                          width: 215,
                                          height: 120,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10,),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  DottedBorder(
                                                    borderType:
                                                        BorderType.RRect,
                                                    color: darkgrey,
                                                    strokeWidth: 2.0,
                                                    dashPattern: [5],
                                                    radius:
                                                        Radius.circular(40.0),
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
                              )
                            : Card(
                                child: InkWell(
                                  onTap: () async{
                                    guideBannerPath = await guideBannerPicker();
                                    setState(() {
                                    });
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: FileImage(File(guideBannerPath!.path)),
                                      ),
                                    ),
                                  ),
                                ),
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
                                  return 'Please enter article title';
                                }
                                return null;
                              },
                              style: TextStyle(
                                fontSize: 17,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.all(8),
                                hintText: "Enter article title",
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
                        height: 340,
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
                                width: 330,
                                height: 300,
                                child: TextFormField(
                                  textAlign: TextAlign.justify,
                                  controller: _contentController,
                                  minLines: 12,
                                  maxLines: 13,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      _contentController.text = "N/A";
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
                      SizedBox(
                        height: 30,
                      ), //spacing

                      Center(
                        child: Text(newArticleStatusMessage, style: TextStyle(color: Colors.red, fontSize: 15,),),
                      ),

                      SizedBox(
                        width: 330,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _loading = true;
                            });
                            handleSubmit(); },
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
                      ), //add new article button
                      SizedBox(height: 20,), //spacing
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
