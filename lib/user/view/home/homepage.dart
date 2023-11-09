import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plantaera/res/colors.dart';
import 'package:plantaera/user/view/plant_guides/plant_guide_details.dart';
import 'package:plantaera/user/view_model/disease_guide_viewmodel.dart';
import 'package:plantaera/user/view_model/general_guide_viewmodel.dart';
import 'package:plantaera/user/view_model/plant_guide_viewmodel.dart';
import 'package:plantaera/user/widget/user_nav_provider.dart';
import 'package:provider/provider.dart';
import 'package:plantaera/main.dart';
import 'package:plantaera/user/model/reminder_model.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key}) : super(key: key);

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  UserPlantVM plantVM = UserPlantVM();
  UserDiseaseVM diseaseVM = UserDiseaseVM();
  UserGeneralsVM generalsVM = UserGeneralsVM();

  String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  late Stream<List<Reminder>> streamReminders;

  @override
  void initState() {
    super.initState();
    streamReminders = objectBox.getReminders();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: SizedBox(
                    width: 310,
                    child: Column(
                      children: [
                        Text(
                          "Welcome to Plantaera",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          "Here we can help you take care of your plants, and remind you of such activities.",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ), //spacing

                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        green,
                        pastelGreen,
                      ],
                    ),
                  ),
                  child: Center(
                      child: Text(
                    "Your Reminders",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  )),
                ), //reminder banner
                Container(
                  height: 250,
                  child: Column(
                    children: [
                      StreamBuilder(
                          stream: streamReminders,
                          builder: (context, snapshots) {
                            if (!snapshots.hasData) {
                              return Container(
                                child: Center(
                                  child: Text(
                                    "There is no reminder set for now.",
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: darkGreen,
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              final reminders = snapshots.data;

                              return Expanded(
                                child: ListView.builder(
                                    itemCount: reminders!.length,
                                    itemBuilder: (context, index) {
                                      final reminderModel = reminders[index];
                                      int reminderId = reminderModel.id;

                                      return Center(
                                        child: Container(
                                          width: 320,
                                          height: 80,
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      Text(reminderModel.reminderTitle!, style: TextStyle(fontSize: 18, color: Colors.black),),
                                                      Text("${reminderModel.reminderHour} : ${reminderModel.reminderMinutes} ${reminderModel.reminderDayOrNight}" ,style: TextStyle(fontSize: 15, color: darkgrey,),),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              );
                            }
                          }),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ), //spacing

                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        green,
                        pastelGreen,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Identify Disease Or Plants",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ), //plants banner
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: SizedBox(
                      width: 125,
                      height: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          context
                              .read<UserNavProvider>()
                              .toIdentify();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: grass,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          shadowColor: Colors.grey.withOpacity(0.9),
                        ),
                        child: Center(
                          child: const Text(
                            "Go to Identify",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        green,
                        pastelGreen,
                      ],
                    ),
                  ),
                  child: Center(
                      child: Text(
                    "Plants You May Be Interested",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  ),
                ), //plants banner
                Container(
                  height: 200,
                  child: Column(
                    children: [
                      StreamBuilder(
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
                                  scrollDirection: Axis.horizontal,
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
                                        favorited = true;
                                        break;
                                      }
                                    }

                                    return Container(
                                      width: 120,
                                      height: 150,
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
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  width: 100,
                                                  height: 100,
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
                                                        color: darkGreen,
                                                      );
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 100,
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
                SizedBox(
                  height: 20,
                ), //spacing

                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        green,
                        pastelGreen,
                      ],
                    ),
                  ),
                  child: Center(
                      child: Text(
                    "Plant Diseases You May Be Interested",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  )),
                ), //disease banner
                Container(
                  height: 200,
                  child: Column(
                    children: [
                      StreamBuilder(
                        //get all plants
                          stream: diseaseVM.fetchAllDiseases(),
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
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  Map<String, dynamic> diseaseModel = snapshot.data?.docs[index].data();
                                  String name = diseaseModel['name'];
                                  String coverPath = diseaseModel['cover'];
                                  String diseaseId = diseaseModel['id'];
                                  List<dynamic> favorites = diseaseModel['favorite'];
                                  bool favorited = false;

                                  //loop through the list to check if user faved the guide
                                  for (int i = 0; i < favorites.length; i++) {
                                    if (favorites[i] == currentUserId) {
                                      favorited = true;
                                      break;
                                    }
                                  }

                                  return Container(
                                    width: 120,
                                    height: 150,
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
                                                    'diseaseId': diseaseId,
                                                    'favorited': favorited,
                                                  }))).then((_) => setState(() {}));
                                        },
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                width: 100,
                                                height: 100,
                                                child: FutureBuilder<String>(
                                                  future: diseaseVM.fetchDiseaseCover(diseaseId, coverPath),
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
                                                      color: darkGreen,
                                                    );
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                width: 100,
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
                                                    ],
                                                  ),
                                                ),
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
                SizedBox(
                  height: 30,
                ), //spacing //spacing
              ],
            ),
          ),
        ),
      ),
    );
  }
}
