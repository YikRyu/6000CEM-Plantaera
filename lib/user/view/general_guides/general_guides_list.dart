import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plantaera/res/colors.dart';
import 'package:plantaera/user/view/general_guides/general_guide_details.dart';
import 'package:plantaera/user/view_model/general_guide_viewmodel.dart';

class UserGeneralGuidesList extends StatefulWidget {
  const UserGeneralGuidesList({Key? key}) : super(key: key);

  @override
  State<UserGeneralGuidesList> createState() => _UserGeneralGuidesListState();
}

class _UserGeneralGuidesListState extends State<UserGeneralGuidesList> {
  UserGeneralsVM generalsVM = UserGeneralsVM();
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  List<String> favList = [];

  favoriteFunction(String diseaseId) async {
    if(favList.contains(diseaseId)){
      //remove plant from fav if found in the fav list
      await generalsVM.removeFavorite(diseaseId, currentUserId);
      favList.remove(diseaseId);

      Fluttertoast.showToast(
        msg: "Removed article from favorite",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );

    }else{
      //add plant into fav list
      await generalsVM.addFavorite(diseaseId, currentUserId);
      favList.add(diseaseId);

      Fluttertoast.showToast(
        msg: "Added aarticle into favorite",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10,),
          height: 100,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              //background image
              image: AssetImage("assets/gardening-guide-banner.jpg"),
              fit: BoxFit.cover,
              opacity: 0.8,
            ),
          ),
          child: Center(
            child: Text(
              "Gardening Guides",
              style: TextStyle(
                fontSize: 28,
                color: grass,
                shadows: [
                  Shadow(
                    // bottomLeft
                      offset: Offset(-1.5, -1.5),
                      color: Colors.white),
                  Shadow(
                    // bottomRight
                      offset: Offset(1.5, -1.5),
                      color: Colors.white),
                  Shadow(
                    // topRight
                      offset: Offset(1.5, 1.5),
                      color: Colors.white),
                  Shadow(
                    // topLeft
                      offset: Offset(-1.5, 1.5),
                      color: Colors.white),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 10,),

        StreamBuilder(
          //get all plants
            stream: generalsVM.fetchAllGeneralGuides(),
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
                    Map<String, dynamic> guideModel =
                    snapshot.data?.docs[index].data();
                    String guideId = guideModel['id'];
                    String title = guideModel['title'];
                    String titlePreview = '';
                    if (title.length > 28){
                      titlePreview = title.substring(0,28) + '...';
                    }else{
                      titlePreview = title;
                    }
                    String content = guideModel['content'];
                    String contentPreview = '';
                    if (content.length > 125){
                      contentPreview = content.substring(0, 125) + '...';
                    }else{
                      contentPreview = content;
                    }
                    String bannerPath = guideModel['banner'];
                    List<dynamic> favorites = guideModel['favorite'];
                    bool favorited = false;

                    //loop through the list to check if user faved the guide
                    for (int i = 0; i < favorites.length; i++) {
                      if (favorites[i] == currentUserId) {
                        favList.add(guideId); //add the plant id into the list if found user faved it
                        favorited = true;
                        break; //stop the loop once found
                      }
                    }


                    return Center(
                      child: Container(
                        width: 320,
                        height: 185,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    return UserGeneralGuideDetails();
                                  },
                                      settings: RouteSettings(arguments: {
                                        'guideId': guideId,
                                        'favorited': favorited,
                                      })))
                                  .then((_) => setState(() {}));
                            },
                            child: Column(
                              children: [
                                Container(
                                  width: 320,
                                  height: 96,
                                  child: FutureBuilder<String>(
                                    future: generalsVM.fetchGuideBanner(
                                        guideId, bannerPath),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Stack(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                ),
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      snapshot.data ?? ''),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 320,
                                              padding: EdgeInsets.fromLTRB(0, 5, 5, 0),
                                              child: Align(
                                                alignment:
                                                Alignment.topRight,
                                                child: favList.contains(guideId)
                                                    ? InkWell(
                                                  onTap: () {
                                                    favoriteFunction(guideId);
                                                  },
                                                  child: Container(
                                                    width: 40,
                                                    height: 40,
                                                    child: Icon(
                                                      Icons.favorite,
                                                      color: favorite,
                                                      size: 30,
                                                    ),
                                                  ),
                                                )
                                                    : InkWell(
                                                  onTap: () {
                                                    favoriteFunction(guideId);
                                                  },
                                                  child: Container(
                                                    width: 40,
                                                    height: 40,
                                                    child: Icon(
                                                      Icons.favorite,
                                                      color: Colors.white,
                                                      size: 27,
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
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                      return CircularProgressIndicator(
                                        color: green,
                                      );
                                    },
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: 250,
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              titlePreview,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            Text(
                                              contentPreview,
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                              textAlign: TextAlign.justify,
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
                                        size: 45,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
    );
  }
}
