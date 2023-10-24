import 'package:flutter/material.dart';
import 'package:plantaera/res/colors.dart';
import 'package:plantaera/user/view/plant_guides/plant_guides_list.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key}) : super(key: key);

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
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
                    ),
                    SizedBox(height: 50,), //spacing


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
                          )),
                    ), //plants banner
                    Container(
                    ),
                    SizedBox(height: 50,), //spacing


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
                    ),
                    SizedBox(height: 50,), //spacing


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
                            "Gardening Tips That May Help You",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          )),
                    ), //general tips banner
                    Container(
                    ),
                    SizedBox(height: 50,), //spacing
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
