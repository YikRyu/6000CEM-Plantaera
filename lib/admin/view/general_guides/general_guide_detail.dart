import 'package:flutter/material.dart';
import 'package:plantaera/admin/view/general_guides/edit_general_guide.dart';
import 'package:plantaera/admin/view/general_guides/general_delete_dialog.dart';
import 'package:plantaera/res/colors.dart';

import '../../view_model/admin_generalGuide_viewmodel.dart';

class AdminGeneralGuideDetails extends StatefulWidget {
  const AdminGeneralGuideDetails({Key? key}) : super(key: key);

  @override
  State<AdminGeneralGuideDetails> createState() => _AdminGeneralGuideDetailsState();
}

class _AdminGeneralGuideDetailsState extends State<AdminGeneralGuideDetails> {
  AdminGeneralGuideVM generalGuideVM = AdminGeneralGuideVM();

  String currentGuideId = '';
  String bannerURL = '';

  @override
  Widget build(BuildContext context) {
    final arguments =
    ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    //fetch arguments passed from previous page
    currentGuideId = arguments['guideId']!;

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
                          return AdminGeneralGuideEdit();
                        },
                        settings: RouteSettings(arguments: {
                          'currentGuideId': currentGuideId,
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
                showDialog(barrierDismissible: true,context: context, builder: (context) => GeneralDeleteDialog(currentGuideId: currentGuideId, bannerURL: bannerURL),);
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
                future: generalGuideVM.fetchGuideDetails(currentGuideId),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: pink,
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
                                future: generalGuideVM.fetchGuideBanner(
                                    currentGuideId, bannerPath),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    bannerURL = snapshot.data!;
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
                                    color: pink,
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
