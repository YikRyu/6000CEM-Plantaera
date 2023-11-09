import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plantaera/res/colors.dart';
import 'package:plantaera/user/view_model/plant_guide_viewmodel.dart';

import '../plant_guides/plant_guide_details.dart';

class FavoritePlantList extends StatefulWidget {
  const FavoritePlantList({Key? key}) : super(key: key);

  @override
  State<FavoritePlantList> createState() => _FavoritePlantListState();
}

class _FavoritePlantListState extends State<FavoritePlantList> {
  UserPlantVM plantVM = UserPlantVM();

  String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  List<String> favList = [];

  favoriteFunction(String plantId, String name) async {
    if(favList.contains(plantId)){
      //remove plant from fav if found in the fav list
      await plantVM.removeFavorite(plantId, currentUserId);
      favList.remove(plantId);

      Fluttertoast.showToast(
        msg: "Removed ${name} from favorite",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );

    }else{
      //add plant into fav list
      await plantVM.addFavorite(plantId, currentUserId);
      favList.add(plantId);

      Fluttertoast.showToast(
        msg: "Added ${name} into favorite",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children:[
        SizedBox(height: 10,),
        StreamBuilder(
          //get all plants
            stream: plantVM.fetchFavoritePlants(currentUserId),
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
                        color: darkGreen,
                      ),
                    ),
                  ),
                );
              }

              //if query returns result
              if (!snapshot.hasData) {
                return Center(
                    child: CircularProgressIndicator(
                      color: green,
                    ));
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> plantModel = snapshot.data?.docs[index].data();
                    String name = plantModel['name'];
                    String scientificName = plantModel['scientificName'];
                    String coverPath = plantModel['cover'];
                    String plantId = plantModel['id'];
                    List<dynamic> favorites = plantModel['favorite'];
                    bool favorited = false;

                    //loop through the list to check if user faved the guide
                    for (int i = 0; i < favorites.length; i++) {
                      if (favorites[i] == currentUserId) {
                        favList.add(plantId); //add the plant id into the list if found user faved it
                        favorited = true;
                        break;
                      }
                    }

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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) {
                                        return UserPlantGuideDetails();
                                      },
                                      settings: RouteSettings(arguments: {
                                        'plantId': plantId,
                                        'favorited': favorited,
                                      }))).then((_) => setState(() {}));
                            },
                            child: Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  favList.contains(plantId)
                                      ? InkWell(
                                    onTap: () {
                                      favoriteFunction(plantId, name);
                                    },
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      child: Icon(
                                        Icons.favorite,
                                        color: favorite,
                                        size: 28,
                                      ),
                                    ),
                                  )
                                      : InkWell(
                                    onTap: () {
                                      favoriteFunction(plantId, name);
                                    },
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      child: Icon(
                                        Icons.favorite,
                                        color: Colors.white,
                                        size: 25,
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
                                  ),
                                  Container(
                                    width: 60,
                                    height: 60,
                                    child: FutureBuilder<String>(
                                      future: plantVM.fetchPlantCover(plantId, coverPath),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(
                                                10,
                                              ),
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(snapshot.data ?? ''),
                                              ),
                                            ),
                                          );
                                        }
                                        return CircularProgressIndicator(
                                          color: green,
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    width: 120,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
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
            }
            ),
      ],
    );
  }
}
