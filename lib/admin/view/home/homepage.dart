//provider reference for page changes: https://www.youtube.com/watch?v=L_QMsE2v6dw

import 'package:flutter/material.dart';
import 'package:plantaera/res/colors.dart';
import 'package:provider/provider.dart';

import 'package:plantaera/admin/view/admin_management/new_admin.dart';
import 'package:plantaera/admin/view/disease_guides/new_disease_guide.dart';
import 'package:plantaera/admin/view/general_guides/new_general_guide.dart';
import 'package:plantaera/admin/view/plant_guides/new_plant_guide.dart';
import 'package:plantaera/admin/widget/admin_nav_provider.dart';


class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
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
                              "Plantaera Admin Dashboard",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              "Manage guide information here.",
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
                            pink,
                            pastelPink,
                          ],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Plant Guide Management",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ), //plant guide banner
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 125,
                            height: 100,
                            child: ElevatedButton(
                              //sign in button
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NewPlantGuide()));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: cherry,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                shadowColor: Colors.grey.withOpacity(0.9),
                              ),
                              child: Center(
                                child: const Text(
                                  "Add New Plant",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ), //add new plant button
                          SizedBox(
                            width: 30,
                          ), //spacing
                          SizedBox(
                            width: 125,
                            height: 100,
                            child: ElevatedButton(
                              //sign in button
                              onPressed: () {
                                context
                                    .read<AdminNavProvider>()
                                    .toPlantGuideList();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: cherry,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                shadowColor: Colors.grey.withOpacity(0.9),
                              ),
                              child: Center(
                                child: const Text(
                                  "Manage Existing Plants",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ), //manage existing plant button
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
                            pink,
                            pastelPink,
                          ],
                        ),
                      ),
                      child: Center(
                          child: Text(
                        "Disease Guide Management",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      )),
                    ), //disease guide banner
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 125,
                            height: 100,
                            child: ElevatedButton(
                              //sign in button
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NewDiseaseGuide()));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: cherry,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                shadowColor: Colors.grey.withOpacity(0.9),
                              ),
                              child: Center(
                                child: const Text(
                                  "Add New Disease",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ), //add new disease button
                          SizedBox(
                            width: 30,
                          ), //spacing
                          SizedBox(
                            width: 125,
                            height: 100,
                            child: ElevatedButton(
                              //sign in button
                              onPressed: () {
                                context
                                    .read<AdminNavProvider>()
                                    .toDiseaseGuideList();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: cherry,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                shadowColor: Colors.grey.withOpacity(0.9),
                              ),
                              child: Center(
                                child: const Text(
                                  "Manage Existing Diseases",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ), //manage existing disease button
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
                            pink,
                            pastelPink,
                          ],
                        ),
                      ),
                      child: Center(
                          child: Text(
                        "General Guide Management",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      )),
                    ), //general guide banner
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 125,
                            height: 100,
                            child: ElevatedButton(
                              //sign in button
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NewGeneralGuide()));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: cherry,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                shadowColor: Colors.grey.withOpacity(0.9),
                              ),
                              child: Center(
                                child: const Text(
                                  "Add New Guide",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ), //add new guide button
                          SizedBox(
                            width: 30,
                          ), //spacing
                          SizedBox(
                            width: 125,
                            height: 100,
                            child: ElevatedButton(
                              //sign in button
                              onPressed: () {
                                context
                                    .read<AdminNavProvider>()
                                    .toGeneralGuideList();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: cherry,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                shadowColor: Colors.grey.withOpacity(0.9),
                              ),
                              child: Center(
                                child: const Text(
                                  "Manage Existing Guides",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ), //manage existing guide button
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
                            pink,
                            pastelPink,
                          ],
                        ),
                      ),
                      child: Center(
                          child: Text(
                        "Admin Accounts Management",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      )),
                    ), //admin list banner
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 125,
                            height: 100,
                            child: ElevatedButton(
                              //sign in button
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NewAdmin()));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: cherry,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                shadowColor: Colors.grey.withOpacity(0.9),
                              ),
                              child: Center(
                                child: const Text(
                                  "Add New Admin",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ), //add new admin button
                          SizedBox(
                            width: 30,
                          ), //spacing
                          SizedBox(
                            width: 125,
                            height: 100,
                            child: ElevatedButton(
                              //sign in button
                              onPressed: () {
                                context.read<AdminNavProvider>().toAdminList();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: cherry,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                shadowColor: Colors.grey.withOpacity(0.9),
                              ),
                              child: Center(
                                child: const Text(
                                  "Manage Existing Admins",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ), //manage existing admins button
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ), //spacing
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
