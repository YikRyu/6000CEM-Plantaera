import 'package:flutter/material.dart';
import 'package:plantaera/admin/view/plant_guides/edit_plant_guide.dart';
import 'package:plantaera/admin/view/plant_guides/plant_delete_dialog.dart';
import 'package:plantaera/admin/view_model/admin_plant_viewmodel.dart';
import 'package:plantaera/res/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPlantGuideDetails extends StatefulWidget {
  AdminPlantGuideDetails({Key? key}) : super(key: key);

  @override
  State<AdminPlantGuideDetails> createState() => _AdminPlantGuideDetailsState();
}

class _AdminPlantGuideDetailsState extends State<AdminPlantGuideDetails> {
  AdminPlantVM plantVM = AdminPlantVM();

  String plantId = '';
  String plantCoverPath = '';
  List<String> plantGalleryPaths = [];

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
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
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) {
                          return AdminPlantGuideEdit();
                        },
                        settings: RouteSettings(arguments: {
                          'plantId': plantId,
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
                showDialog(barrierDismissible: true,context: context, builder: (context) => PlantDeleteDialog(currentPlantId: plantId, coverURL: plantCoverPath, galleryList: plantGalleryPaths),);
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


                  return Expanded(
                    child: ListView.builder(
                      itemCount: 1,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Center(
                              child: Text(
                                plantModel['name'],
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

                            Center(
                              child: Text(
                                plantModel['scientificName'],
                                style: TextStyle(
                                  fontSize: 20,
                                  color: darkgrey,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ), //scientific name field
                            SizedBox(
                              height: 10.0,
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
                                          future: plantVM.fetchPlantCover(
                                              plantId, coverPath),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              plantCoverPath = snapshot.data!;
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
                                                        plantCoverPath ?? ''),
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
                                            future: plantVM.fetchPlantGallery(
                                                plantId),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return SizedBox.shrink();
                                              }

                                              if (snapshot.hasData) {
                                                plantGalleryPaths =
                                                    snapshot.data!;
                                                return Wrap(
                                                  alignment: WrapAlignment
                                                      .spaceBetween,
                                                  children: plantGalleryPaths
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
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 340,
                                      child: Text(
                                        plantModel['description'],
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 0, 8, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Plant Type: ",
                                                    style: TextStyle(
                                                      fontSize: 17.0,
                                                      color: deepPink,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 0, 8, 0),
                                                  child: Container(
                                                    width: 200,
                                                    child: Text(
                                                      plantModel['plantType'],
                                                      style: TextStyle(
                                                        fontSize: 17,
                                                      ),
                                                      textAlign:
                                                          TextAlign.justify,
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
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 0, 8, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Lifespan: ",
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    color: deepPink,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 0, 8, 0),
                                                  child: Container(
                                                    width: 200,
                                                    child: Text(
                                                      plantModel['lifespan'],
                                                      style: TextStyle(
                                                        fontSize: 17,
                                                      ),
                                                      textAlign:
                                                          TextAlign.justify,
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
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 0, 8, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Bloom Time: ",
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    color: deepPink,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 0, 8, 0),
                                                  child: Container(
                                                    width: 200,
                                                    child: Text(
                                                      plantModel['bloomTime'],
                                                      style: TextStyle(
                                                        fontSize: 17,
                                                      ),
                                                      textAlign:
                                                          TextAlign.justify,
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
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 0, 8, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Habitat: ",
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    color: deepPink,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 0, 8, 0),
                                                  child: Container(
                                                    width: 200,
                                                    child: Text(
                                                      plantModel['habitat'],
                                                      style: TextStyle(
                                                        fontSize: 17,
                                                      ),
                                                      textAlign:
                                                          TextAlign.justify,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 0, 8, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Difficulty: ",
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    color: deepPink,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 0, 8, 0),
                                                  child: Container(
                                                    width: 200,
                                                    child: Text(
                                                      plantModel['difficulty'],
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                      textAlign:
                                                          TextAlign.justify,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ), //difficulty field
                                          SizedBox(
                                            height: 15.0,
                                          ), //spacing

                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 0, 8, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Sunlight: ",
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    color: deepPink,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 0, 8, 0),
                                                  child: Container(
                                                    width: 200,
                                                    child: Text(
                                                      plantModel['sunlight'],
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                      textAlign:
                                                          TextAlign.justify,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ), //sunlight field
                                          SizedBox(
                                            height: 15.0,
                                          ), //spacing

                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 0, 8, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Soil: ",
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    color: deepPink,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 0, 8, 0),
                                                  child: Container(
                                                    width: 200,
                                                    child: Text(
                                                      plantModel['soil'],
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                      textAlign:
                                                          TextAlign.justify,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ), //soil field
                                          SizedBox(
                                            height: 15.0,
                                          ), //spacing

                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 0, 8, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Water: ",
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    color: deepPink,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 0, 8, 0),
                                                  child: Container(
                                                    width: 200,
                                                    child: Text(
                                                      plantModel['water'],
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                      textAlign:
                                                          TextAlign.justify,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ), //water field
                                          SizedBox(
                                            height: 15.0,
                                          ), //spacing

                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 0, 8, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Fertilize: ",
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    color: deepPink,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 0, 8, 0),
                                                  child: Container(
                                                    width: 200,
                                                    child: Text(
                                                      plantModel['fertilize'],
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                      textAlign:
                                                          TextAlign.justify,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ), //fertilize field
                                          SizedBox(
                                            height: 15.0,
                                          ), //spacing

                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 0, 8, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Planting Time: ",
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    color: deepPink,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 0, 8, 0),
                                                  child: Container(
                                                    width: 200,
                                                    child: Text(
                                                      plantModel[
                                                          'plantingTime'],
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                      textAlign:
                                                          TextAlign.justify,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ), //planting time field
                                          SizedBox(
                                            height: 15.0,
                                          ), //spacing

                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 0, 8, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Harvest Time: ",
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    color: deepPink,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 0, 8, 0),
                                                  child: Container(
                                                    width: 200,
                                                    child: Text(
                                                      plantModel['harvestTime'],
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                      textAlign:
                                                          TextAlign.justify,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ), //harvest time field
                                          SizedBox(
                                            height: 15.0,
                                          ), //spacing

                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 0, 8, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Disease: ",
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    color: deepPink,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 0, 8, 0),
                                                  child: Container(
                                                    width: 200,
                                                    child: Text(
                                                      plantModel['disease'],
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                      textAlign:
                                                          TextAlign.justify,
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
                            ), // spacing
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
