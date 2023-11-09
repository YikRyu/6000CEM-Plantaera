import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plantaera/res/colors.dart';
import 'package:plantaera/user/view_model/disease_guide_viewmodel.dart';

class UserDiseaseGuideDetails extends StatefulWidget {
  const UserDiseaseGuideDetails({Key? key}) : super(key: key);

  @override
  State<UserDiseaseGuideDetails> createState() => _UserDiseaseGuideDetailsState();
}

class _UserDiseaseGuideDetailsState extends State<UserDiseaseGuideDetails> {
  UserDiseaseVM diseaseVM = UserDiseaseVM();

  bool favorited = false;
  String diseaseId = '';
  String name = '';
  String diseaseCoverPath = '';
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  List<String> diseaseGalleryPath = [];

  favoriteFunction(String diseaseId, String name) async {
    if(favorited){
      //remove plant from fav if found in the fav list
      await diseaseVM.removeFavorite(diseaseId, currentUserId);
      favorited = false;

      Fluttertoast.showToast(
        msg: "Removed ${name} from favorite",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );

    }else{
      //add plant into fav list
      await diseaseVM.addFavorite(diseaseId, currentUserId);
      favorited = true;

      Fluttertoast.showToast(
        msg: "Added ${name} into favorite",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    final arguments =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    //fetch arguments passed from previous page
    diseaseId = arguments['diseaseId']!;
    favorited = arguments['favorited']!;

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
          actions: [
            favorited
                ? IconButton(
              onPressed: () {
                favoriteFunction(diseaseId, name);
                setState(() {
                });
              },
              icon: Icon(
                Icons.favorite,
                color: favorite,
                size: 30,
              ),
            )
                : IconButton(
              onPressed: () {
                favoriteFunction(diseaseId, name);
                setState(() {});
              },
              icon: Icon(
                Icons.favorite,
                color: Colors.white,
                size: 28,
                shadows: [
                  Shadow(
                    // bottomLeft
                      offset: Offset(-1.5, -1.5),
                      color: darkgrey),
                  Shadow(
                    // bottomRight
                      offset: Offset(1.5, -1.5),
                      color: darkgrey),
                  Shadow(
                    // topRight
                      offset: Offset(1.5, 1.5),
                      color: darkgrey),
                  Shadow(
                    // topLeft
                      offset: Offset(-1.5, 1.5),
                      color: darkgrey),
                ],
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              FutureBuilder(
                future: diseaseVM.fetchDiseaseDetails(diseaseId),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: darkGreen,
                      ),
                    );
                  }
                  //assign document to a map for field retrieval
                  Map<String, dynamic> diseaseModel = snapshot.data;
                  //some variables to be used ltr
                  String coverPath = diseaseModel['cover'];
                  List<dynamic> favorites = diseaseModel['favorite'];
                  name = diseaseModel['name'];
                  diseaseId = diseaseModel['id'];

                  //loop through the list to check if user faved the guide
                  for (int i = 0; i < favorites.length; i++) {
                    if (favorites[i] == currentUserId) {
                      favorited = true;
                      break;
                    }
                  }


                  return Expanded(
                    child: ListView.builder(
                      itemCount: 1,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Center(
                              child: Text(
                                diseaseModel['name'],
                                style: TextStyle(
                                  fontSize: 25,
                                  color: darkGreen,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ), //plant name field
                            SizedBox(
                              height: 5.0,
                            ), //spacing

                            Container(
                              width: double.infinity,
                              height: 180,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    width: 1,
                                    color: darkGreen,
                                  ),
                                  bottom: BorderSide(
                                    width: 1,
                                    color: darkGreen,
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
                                        color: darkGreen,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ), //spacing
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        FutureBuilder<String>(
                                          future: diseaseVM.fetchDiseaseCover(
                                              diseaseId, coverPath),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              diseaseCoverPath = snapshot.data!;
                                              return Container(
                                                width: 120,
                                                height: 120,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                    10,
                                                  ),
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                        diseaseCoverPath ?? ''),
                                                  ),
                                                ),
                                              );
                                            }
                                            return CircularProgressIndicator(
                                              color: green,
                                            );
                                          },
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        FutureBuilder<List<String>>(
                                            future: diseaseVM.fetchDiseaseGallery(
                                                diseaseId),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return SizedBox.shrink();
                                              }

                                              if (snapshot.hasData) {
                                                diseaseGalleryPath =
                                                snapshot.data!;
                                                return Wrap(
                                                  alignment: WrapAlignment
                                                      .spaceBetween,
                                                  children: diseaseGalleryPath
                                                      .map(
                                                        (e) => Row(
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
                                                                  e ??
                                                                      ''),
                                                            ),
                                                          ),
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
                                                color: green,
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
                                    color: darkGreen,
                                  ),
                                  bottom: BorderSide(
                                    width: 1,
                                    color: darkGreen,
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
                                        color: darkGreen,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ), //spacing
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 340,
                                      child: Text(
                                        diseaseModel['symptoms'],
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.justify,
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
                                    color: darkGreen,
                                  ),
                                  bottom: BorderSide(
                                    width: 1,
                                    color: darkGreen,
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
                                        color: darkGreen,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ), //spacing
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 340,
                                      child: Text(
                                        diseaseModel['causes'],
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ), //causes container
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
                                    color: darkGreen,
                                  ),
                                  bottom: BorderSide(
                                    width: 1,
                                    color: darkGreen,
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
                                        color: darkGreen,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ), //spacing
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 340,
                                      child: Text(
                                        diseaseModel['solutions'],
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ), //solutions container
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
                                    color: darkGreen,
                                  ),
                                  bottom: BorderSide(
                                    width: 1,
                                    color: darkGreen,
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
                                        color: darkGreen,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ), //spacing
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 340,
                                      child: Text(
                                        diseaseModel['preventions'],
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ), //preventions container
                            SizedBox(
                              height: 30,
                            ), //spacing
                          ],
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
