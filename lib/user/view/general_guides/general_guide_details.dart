import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plantaera/res/colors.dart';
import 'package:plantaera/user/view_model/general_guide_viewmodel.dart';

class UserGeneralGuideDetails extends StatefulWidget {
  const UserGeneralGuideDetails({Key? key}) : super(key: key);

  @override
  State<UserGeneralGuideDetails> createState() => _UserGeneralGuideDetailsState();
}

class _UserGeneralGuideDetailsState extends State<UserGeneralGuideDetails> {
  UserGeneralsVM generalsVM = UserGeneralsVM();

  String currentGuideId = '';
  bool favorited = false;
  String guideBannerURL = '';
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;


  favoriteFunction(String currentGuideId) async {
    if(favorited){
      //remove plant from fav if found in the fav list
      await generalsVM.removeFavorite(currentGuideId, currentUserId);
      favorited = false;

      Fluttertoast.showToast(
        msg: "Removed article from favorite",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );

    }else{
      //add plant into fav list
      await generalsVM.addFavorite(currentGuideId, currentUserId);
      favorited = true;

      Fluttertoast.showToast(
        msg: "Added article into favorite",
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
    currentGuideId = arguments['guideId']!;
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
                favoriteFunction(currentGuideId);
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
                favoriteFunction(currentGuideId);
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
                future: generalsVM.fetchGeneralGuideDetails(currentGuideId),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.green,
                      ),
                    );
                  }
                  //assign document to a map for field retrieval
                  Map<String, dynamic> generalGuideModel = snapshot.data;
                  //some variables to be used ltr
                  currentGuideId = generalGuideModel['id'];
                  String bannerPath = generalGuideModel['banner'];

                  return Expanded(
                    child: ListView.builder(
                      itemCount: 1,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
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
                                future: generalsVM.fetchGuideBanner(
                                    currentGuideId, bannerPath),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    guideBannerURL = snapshot.data!;
                                    return Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              snapshot.data ?? ''),
                                        ),
                                      ),
                                    );
                                  }
                                  return CircularProgressIndicator(
                                    color: Colors.green,
                                  );
                                },
                              ),
                            ), //banner container
                            SizedBox(
                              height: 30.0,
                            ),

                            Center(
                              child: SizedBox(
                                width: 300,
                                child: Text(
                                  generalGuideModel['title'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ), //guide title
                            SizedBox(
                              height: 30.0,
                            ), //spacing

                            Container(
                              width: 320,
                              child: Column(
                                children: [
                                  Center(
                                    child: Text(
                                      generalGuideModel['content'],
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                ],
                              ),
                            ), //symptoms container
                            SizedBox(
                              height: 40,
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
