import 'package:flutter/material.dart';
import 'package:plantaera/res/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:plantaera/general/view_model/login_viewmodel.dart';
import 'package:plantaera/user/view/others/change_password.dart';
import 'package:plantaera/user/view/others/change_username.dart';
import '../../../general/view/login.dart';
import '../../view_model/profile_viewmodel.dart';

class UserProfile extends StatefulWidget {
  UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final _auth = FirebaseAuth.instance;

  String currentUserID = FirebaseAuth.instance.currentUser!.uid;

  ProfileVM profileVM = ProfileVM();

  Future logout(context) async {
    await _auth.signOut().then((value) => Navigator.of(context)
        .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Login()),
            (route) => false));
  }

  @override
  Widget build(BuildContext context) {
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
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "Account Information",
                        style: TextStyle(
                          fontSize: 30,
                          color: darkGreen,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    FutureBuilder(
                        future: ProfileVM().getProfile(currentUserID),
                        builder: (context, AsyncSnapshot documentSnapshot) {
                          if (documentSnapshot.data == null) {
                            return SizedBox(
                              width: 300,
                              child: Center(
                                child: Text(
                                  "Something went wrong while fetching for user data...",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: darkGreen,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }

                          //assign fetch data to map
                          Map<String, dynamic> userInfoModel =
                              documentSnapshot.data;
                          String username = userInfoModel['username'];
                          String email = userInfoModel['email'];
                          //if able to fetch data, display
                          return SizedBox(
                            width: 300,
                            child: Center(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Email:   ",
                                        style: TextStyle(
                                          fontSize: 22,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 200,
                                        child: Text(
                                          '$email',
                                          style: TextStyle(
                                            fontSize: 22,
                                            color: grass,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Username:   ",
                                        style: TextStyle(
                                          fontSize: 22,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 180,
                                        child: Text(
                                          '$username',
                                          style: TextStyle(
                                            fontSize: 22,
                                            color: grass,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),

                    SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangeUsername())).then((_) => setState((){})); //way to push nav and can setstate when go back
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
                            "Change Username",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ), //change username button
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangeUserPassword()));
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
                            "Change Password",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ), //change password button
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => logout(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: grass,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          shadowColor: Colors.grey.withOpacity(0.9),
                        ),
                        child: Center(
                          child: const Text(
                            "Logout",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ), //logout button
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
