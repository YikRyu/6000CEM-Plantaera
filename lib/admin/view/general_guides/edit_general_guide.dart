import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantaera/res/colors.dart';
import 'dart:io';

import '../../view_model/admin_generalGuide_viewmodel.dart';

class AdminGeneralGuideEdit extends StatefulWidget {
  const AdminGeneralGuideEdit({Key? key}) : super(key: key);

  @override
  State<AdminGeneralGuideEdit> createState() => _AdminGeneralGuideEditState();
}

class _AdminGeneralGuideEditState extends State<AdminGeneralGuideEdit> {
  final editGeneralFormKey = GlobalKey<FormState>();

  //general fields
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  XFile? guideBannerPath;

  String currentGuideId = '';
  String bannerURL = '';
  bool _loading = false;
  String editGeneralGuideMessage = '';
  AdminGeneralGuideVM guideVM = AdminGeneralGuideVM();

  //Function for plant cover image picker
  Future<XFile?> guideBannerPicker() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  handleSubmit() async {
    if (editGeneralFormKey.currentState!.validate()) {
      final title = _titleController.value.text;
      final content = _contentController.value.text;

      editGeneralGuideMessage = await guideVM.editGeneralGuide(currentGuideId, title, content, guideBannerPath, bannerURL);

      if (editGeneralGuideMessage == "ok") {
        //redirect back to admin list with toaster message shown
        Fluttertoast.showToast(
          msg: "Guide edited! Redirecting back to previous page....",
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
    } else {
      setState(() {
        _loading = false;
      });
      return editGeneralGuideMessage = "Please insert all fields";
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    //fetch arguments passed from previous page
    currentGuideId = arguments['currentGuideId']!;

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
                future: guideVM.fetchGuideDetails(currentGuideId),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: pink,
                      ),
                    );
                  }

                  //assign document to a map for field retrieval
                  Map<String, dynamic> guideModel = snapshot.data;
                  //some variables to be used ltr
                  String bannerPath = guideModel['banner'];

                  _titleController.text = guideModel['title'];
                  _contentController.text = guideModel['content'];

                  return Expanded(
                    child: ListView.builder(
                      itemCount: 1,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return Form(
                          key: editGeneralFormKey,
                          child: SingleChildScrollView(
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    Center(
                                      child: guideBannerPath == null
                                          ? Container(
                                              width: double.infinity,
                                              height: 150,
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(0.5),
                                                    spreadRadius: 5,
                                                    blurRadius: 7,
                                                    offset: Offset(0, 3), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: FutureBuilder<String>(
                                                future: guideVM.fetchGuideBanner(currentGuideId, bannerPath),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage(snapshot.data ?? ''),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  return CircularProgressIndicator(
                                                    color: pink,
                                                  );
                                                },
                                              ),
                                            )
                                          : Card(
                                              child: InkWell(
                                                onTap: () async {
                                                  guideBannerPath = await guideBannerPicker();
                                                  setState(() {});
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
                                      child: Text(
                                        editGeneralGuideMessage,
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),

                                    SizedBox(
                                      width: 330,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _loading = true;
                                          });
                                          handleSubmit();
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
                                                  "Edit Article",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ), //add new article button
                                    SizedBox(
                                      height: 20,
                                    ), //spacing
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
