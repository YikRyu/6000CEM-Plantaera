import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plantaera/admin/view/plant_guides/new_plant_guide.dart';
import 'package:plantaera/admin/view/plant_guides/plant_guide_detail.dart';
import 'package:plantaera/admin/view_model/admin_plant_viewmodel.dart';
import 'package:plantaera/res/colors.dart';

class AdminPlantGuidesList extends StatefulWidget {
  const AdminPlantGuidesList({Key? key}) : super(key: key);

  @override
  State<AdminPlantGuidesList> createState() => _AdminPlantGuidesListState();
}

class _AdminPlantGuidesListState extends State<AdminPlantGuidesList> {
  TextEditingController _searchController = TextEditingController();
  AdminPlantVM plantVM = AdminPlantVM();

  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(
                height: 55,
                width: double.infinity,
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: darkgrey,
                      size: 35,
                    ),
                    hintText: "Search for a plant...",
                    hintStyle: TextStyle(
                      color: darkgrey,
                      fontSize: 18,
                      decoration: TextDecoration.underline,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        style: BorderStyle.none,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ), //search bar
              SizedBox(
                height: 10,
              ), //spacing

              searchText == ''
                  ? StreamBuilder(
                      //get all plants
                      stream: plantVM.fetchAllPlants(),
                      builder: (context, AsyncSnapshot snapshot) {
                        //if query result is empty
                        if (snapshot.data == null) {
                          return Container(
                            width: 300,
                            height: 80,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Something went wrong when trying to fetch data...",
                                style: TextStyle(
                                  fontSize: 25,
                                  color: deepPink,
                                ),
                              ),
                            ),
                          );
                        }

                        //if query returns result
                        if (!snapshot.hasData) {
                          return Center(
                              child: CircularProgressIndicator(
                            color: pink,
                          ));
                        }
                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> plantModel =
                                  snapshot.data?.docs[index].data();
                              String name = plantModel['name'];
                              String scientificName =
                                  plantModel['scientificName'];
                              String coverPath = plantModel['cover'];
                              String plantId = plantModel['id'];

                              return Center(
                                child: Container(
                                  width: 300,
                                  height: 80,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) {
                                              return AdminPlantGuideDetails();
                                            },
                                                settings: RouteSettings(arguments: {
                                                  'plantId': plantId,
                                                })))
                                            .then((_) => setState(() {}));
                                      },
                                      child: Container(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                              width: 60,
                                              height: 60,
                                              child: FutureBuilder<String>(
                                                future: plantVM.fetchPlantCover(
                                                    plantId, coverPath),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                          10,
                                                        ),
                                                        image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage(
                                                              snapshot.data ?? ''),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  return CircularProgressIndicator(
                                                    color: pink,
                                                  );
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            SizedBox(
                                              width: 150,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 10, 0, 10),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      name,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    Text(
                                                      scientificName,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: darkgrey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Icon(
                                                Icons.chevron_right,
                                                color: Colors.black,
                                                size: 35,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      })
                  : StreamBuilder(
                      //get search result
                      stream: plantVM.returnSearchResult(searchText),
                      builder: (context, AsyncSnapshot snapshot) {
                        //if query has result
                        if (!snapshot.hasData) {
                          return Center(
                              child: CircularProgressIndicator(
                            color: pink,
                          ));
                        }
                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> plantModel =
                                  snapshot.data?.docs[index].data();
                              String name = plantModel['name'];
                              String scientificName =
                                  plantModel['scientificName'];
                              String coverPath = plantModel['cover'];
                              String plantId = plantModel['id'];

                              return Center(
                                child: Container(
                                  width: 300,
                                  height: 80,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                          return AdminPlantGuideDetails();
                                        },
                                            settings: RouteSettings(arguments: {
                                              'plantId': plantId,
                                            })))
                                        .then((_) => setState(() {}));
                                      },
                                      child: Container(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                              width: 60,
                                              height: 60,
                                              child: FutureBuilder<String>(
                                                future: plantVM.fetchPlantCover(
                                                    plantId, coverPath),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                          10,
                                                        ),
                                                        image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage(
                                                              snapshot.data ??
                                                                  ''),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  return CircularProgressIndicator(
                                                    color: pink,
                                                  );
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            SizedBox(
                                              width: 150,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 10, 0, 10),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      name,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    Text(
                                                      scientificName,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: darkgrey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Icon(
                                                Icons.chevron_right,
                                                color: Colors.black,
                                                size: 35,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: "newPlant",
          onPressed: () {
            Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NewPlantGuide()))
                .then((_) => setState(() {}));
          },
          foregroundColor: cherry,
          backgroundColor: cherry,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 45,
          ),
        ),
      ),
    );
  }
}
