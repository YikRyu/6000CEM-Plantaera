import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plantaera/res/colors.dart';
import 'package:plantaera/user/view_model/plant_guide_viewmodel.dart';

class UserPlantGuideDetails extends StatefulWidget {
  const UserPlantGuideDetails({Key? key}) : super(key: key);

  @override
  State<UserPlantGuideDetails> createState() => _UserPlantGuideDetailsState();
}

class _UserPlantGuideDetailsState extends State<UserPlantGuideDetails> {
  UserPlantVM plantVM = UserPlantVM();

  bool favorited = false;
  String plantId = '';
  String name = '';
  String plantCoverPath = '';
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  List<String> plantGalleryPaths = [];

  favoriteFunction(String plantId, String name) async {
    if (favorited) {
      //remove plant from fav if found in the fav list
      await plantVM.removeFavorite(plantId, currentUserId);
      favorited = false;

      Fluttertoast.showToast(
        msg: "Removed ${name} from favorite",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      //add plant into fav list
      await plantVM.addFavorite(plantId, currentUserId);
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
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    //fetch arguments passed from previous page
    plantId = arguments['plantId']!;
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
                      favoriteFunction(plantId, name);
                      setState(() {});
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: favorite,
                      size: 30,
                    ),
                  )
                : IconButton(
                    onPressed: () {
                      favoriteFunction(plantId, name);
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
                future: plantVM.fetchPlantDetails(plantId),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: darkGreen,
                      ),
                    );
                  }
                  //assign document to a map for field retrieval
                  Map<String, dynamic> plantModel = snapshot.data;
                  //some variables to be used ltr
                  String coverPath = plantModel['cover'];
                  List<dynamic> favorites = plantModel['favorite'];
                  name = plantModel['name'];
                  plantId = plantModel['id'];

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
                                plantModel['name'],
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
                                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        FutureBuilder<String>(
                                          future: plantVM.fetchPlantCover(plantId, coverPath),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              plantCoverPath = snapshot.data!;
                                              return Container(
                                                width: 120,
                                                height: 120,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(
                                                    10,
                                                  ),
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(plantCoverPath ?? ''),
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
                                            future: plantVM.fetchPlantGallery(plantId),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return SizedBox.shrink();
                                              }

                                              if (snapshot.hasData) {
                                                plantGalleryPaths = snapshot.data!;
                                                return Wrap(
                                                  alignment: WrapAlignment.spaceBetween,
                                                  children: plantGalleryPaths
                                                      .map(
                                                        (e) => Row(
                                                          children: [
                                                            Container(
                                                              width: 120,
                                                              height: 120,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(
                                                                  10,
                                                                ),
                                                                image: DecorationImage(
                                                                  fit: BoxFit.cover,
                                                                  image: NetworkImage(e ?? ''),
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
                                      "Description",
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
                                      "Characteristics",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: darkGreen,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    "Plant Type: ",
                                                    style: TextStyle(
                                                      fontSize: 17.0,
                                                      color: darkGreen,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                                  child: Container(
                                                    width: 200,
                                                    child: Text(
                                                      plantModel['plantType'],
                                                      style: TextStyle(
                                                        fontSize: 17,
                                                      ),
                                                      textAlign: TextAlign.justify,
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
                                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "Lifespan: ",
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    color: darkGreen,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                                  child: Container(
                                                    width: 200,
                                                    child: Text(
                                                      plantModel['lifespan'],
                                                      style: TextStyle(
                                                        fontSize: 17,
                                                      ),
                                                      textAlign: TextAlign.justify,
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
                                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "Bloom Time: ",
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    color: darkGreen,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                                  child: Container(
                                                    width: 200,
                                                    child: Text(
                                                      plantModel['bloomTime'],
                                                      style: TextStyle(
                                                        fontSize: 17,
                                                      ),
                                                      textAlign: TextAlign.justify,
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
                                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "Habitat: ",
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    color: darkGreen,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                                  child: Container(
                                                    width: 200,
                                                    child: Text(
                                                      plantModel['habitat'],
                                                      style: TextStyle(
                                                        fontSize: 17,
                                                      ),
                                                      textAlign: TextAlign.justify,
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
                                      "Planting Tips",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: darkGreen,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Difficulty: ",
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    color: darkGreen,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                                  child: Container(
                                                    width: 200,
                                                    child: Text(
                                                      plantModel['difficulty'],
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                      textAlign: TextAlign.justify,
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
                                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Sunlight: ",
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    color: darkGreen,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                                  child: Container(
                                                    width: 200,
                                                    child: Text(
                                                      plantModel['sunlight'],
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                      textAlign: TextAlign.justify,
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
                                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Soil: ",
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    color: darkGreen,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                                  child: Container(
                                                    width: 200,
                                                    child: Text(
                                                      plantModel['soil'],
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                      textAlign: TextAlign.justify,
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
                                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Water: ",
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    color: darkGreen,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                                  child: Container(
                                                    width: 200,
                                                    child: Text(
                                                      plantModel['water'],
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                      textAlign: TextAlign.justify,
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
                                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Fertilize: ",
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    color: darkGreen,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                                  child: Container(
                                                    width: 200,
                                                    child: Text(
                                                      plantModel['fertilize'],
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                      textAlign: TextAlign.justify,
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
                                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Planting Time: ",
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    color: darkGreen,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                                  child: Container(
                                                    width: 200,
                                                    child: Text(
                                                      plantModel['plantingTime'],
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                      textAlign: TextAlign.justify,
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
                                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Harvest Time: ",
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    color: darkGreen,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                                  child: Container(
                                                    width: 200,
                                                    child: Text(
                                                      plantModel['harvestTime'],
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                      textAlign: TextAlign.justify,
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
                                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Disease: ",
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    color: darkGreen,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                                  child: Container(
                                                    width: 200,
                                                    child: Text(
                                                      plantModel['disease'],
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                      textAlign: TextAlign.justify,
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
