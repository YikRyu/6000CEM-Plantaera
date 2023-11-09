import 'package:flutter/material.dart';
import 'package:plantaera/admin/view/general_guides/general_guide_detail.dart';
import 'package:plantaera/admin/view/general_guides/new_general_guide.dart';
import 'package:plantaera/res/colors.dart';

import '../../view_model/admin_generalGuide_viewmodel.dart';

class AdminGeneralGuidesList extends StatefulWidget {
  const AdminGeneralGuidesList({Key? key}) : super(key: key);

  @override
  State<AdminGeneralGuidesList> createState() => _AdminGeneralGuidesListState();
}

class _AdminGeneralGuidesListState extends State<AdminGeneralGuidesList> {
  AdminGeneralGuideVM generalGuideVM = AdminGeneralGuideVM();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(
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
                      color: deepPink,
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
                  stream: generalGuideVM.fetchAllGeneralGuides(),
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
                                          return AdminGeneralGuideDetails();
                                        },
                                            settings: RouteSettings(arguments: {
                                              'guideId': guideId,
                                            })))
                                        .then((_) => setState(() {}));
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 320,
                                        height: 96,
                                        child: FutureBuilder<String>(
                                          future: generalGuideVM.fetchGuideBanner(
                                              guideId, bannerPath),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Container(
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
                                              );
                                            }
                                            return CircularProgressIndicator(
                                              color: pink,
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
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: "newGeneral",
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NewGeneralGuide()))
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
