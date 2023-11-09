import 'package:flutter/material.dart';
import 'package:plantaera/admin/view/disease_guides/disease_delete_dialog.dart';
import 'package:plantaera/admin/view/disease_guides/edit_disease_guide.dart';
import 'package:plantaera/admin/view_model/admin_disease_viewmodel.dart';
import 'package:plantaera/res/colors.dart';

class AdminDiseaseGuideDetails extends StatefulWidget {
  const AdminDiseaseGuideDetails({Key? key}) : super(key: key);

  @override
  State<AdminDiseaseGuideDetails> createState() => _AdminDiseaseGuideDetailsState();
}

class _AdminDiseaseGuideDetailsState extends State<AdminDiseaseGuideDetails> {
  AdminDiseaseVM diseaseVM = AdminDiseaseVM();

  String currentDiseaseId = '';
  String diseaseCoverURL = '';
  List<String> diseaseGalleryURL = [];

  @override
  Widget build(BuildContext context) {
    final arguments =
    ModalRoute.of(context)!.settings.arguments as Map<String, String>;
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
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) {
                          return AdminDiseaseGuideEdit();
                        },
                        settings: RouteSettings(arguments: {
                          'currentDiseaseId': currentDiseaseId,
                        }))).then((_) => setState(() {}));
              },
              icon: Icon(
                Icons.edit,
                color: deepPink,
                size: 30,
              ),
            ),
            IconButton(
              onPressed: () {
                showDialog(barrierDismissible: true,context: context, builder: (context) => DiseaseDeleteDialog(currentDiseaseId: currentDiseaseId, coverURL: diseaseCoverURL, galleryList: diseaseGalleryURL),);
              },
              icon: Icon(
                Icons.delete,
                color: deepPink,
                size: 30,
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              FutureBuilder(
                future: diseaseVM.fetchDiseaseDetails(currentDiseaseId),
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
                                  color: deepPink,
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
                                    padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        FutureBuilder<String>(
                                          future: diseaseVM.fetchDiseaseCover(
                                              currentDiseaseId, coverPath),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              diseaseCoverURL = snapshot.data!;
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
                                                        diseaseCoverURL ?? ''),
                                                  ),
                                                ),
                                              );
                                            }
                                            return CircularProgressIndicator(
                                              color: pink,
                                            );
                                          },
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        FutureBuilder<List<String>>(
                                            future: diseaseVM.fetchDiseaseGallery(
                                                currentDiseaseId),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return SizedBox.shrink();
                                              }

                                              if (snapshot.hasData) {
                                                diseaseGalleryURL =
                                                snapshot.data!;
                                                return Wrap(
                                                  alignment: WrapAlignment
                                                      .spaceBetween,
                                                  children: diseaseGalleryURL
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
                            ),
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
