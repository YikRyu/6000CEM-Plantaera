import 'package:flutter/material.dart';
import 'package:plantaera/res/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../view_model/profile_viewmodel.dart';

class ChangeUsername extends StatefulWidget {
  const ChangeUsername({Key? key}) : super(key: key);

  @override
  State<ChangeUsername> createState() => _ChangeUsernameState();
}

class _ChangeUsernameState extends State<ChangeUsername> {
  final changeUsernameFormKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();

  bool _loading = false;
  String currentUserID = FirebaseAuth.instance.currentUser!.uid;
  ProfileVM profileVM = ProfileVM();
  String changeUsernameStatusText = '';

  changeUsername() async{
    if (changeUsernameFormKey.currentState!.validate()) { //check if anything is empty
      final username = _usernameController.value.text;
      setState(() {
        _loading = true; //for the loading progress bar
      });

      changeUsernameStatusText = await ProfileVM().changeUsername(username, currentUserID);

      if (changeUsernameStatusText == "ok") {
        setState(() {
          changeUsernameStatusText = 'Username changed successfully!';
          _usernameController.clear();
        });
        _loading = false;
      }
      else{
        setState(() {
          changeUsernameStatusText;
          _loading = false;
        });
      }
    }
    else{
      setState(() {
        changeUsernameStatusText = "Please enter new username";
        _loading = false;
      });
    }
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
            child: Stack(
              children: [
                Form(
                  key: changeUsernameFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "Change Username",
                          style: TextStyle(
                            fontSize: 30,
                            color: darkGreen,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
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
                            //if able to fetch data, display
                            return SizedBox(
                              width: 300,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Username:   ",
                                        style: TextStyle(
                                          fontSize: 22,
                                        ),
                                      ),
                                      Text(
                                        '$username',
                                        style: TextStyle(
                                          fontSize: 22,
                                          color: grass,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          controller: _usernameController,
                          enableSuggestions: false,
                          autocorrect: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter new username';
                            }
                            return null;
                          },
                          style: TextStyle(
                            fontSize: 17,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Enter new username",
                            hintStyle: const TextStyle(
                              fontSize: 17,
                              color: lightgrey,
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: darkGreen,
                                width: 1.0,
                                style: BorderStyle.none,
                              ),
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                          ),
                        ),
                      ), //username textfield
                      SizedBox(
                        height: 30,
                      ),
                      Text(changeUsernameStatusText,style: TextStyle(fontSize: 18, ),),
                      SizedBox(height: 10,),
                      SizedBox(
                        width: 250,
                        height: 50,
                        child: ElevatedButton(
                          //sign in button
                          onPressed: () => changeUsername(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: grass,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                            shadowColor: Colors.grey.withOpacity(0.9),
                          ),
                          child: Center(
                            child: _loading
                                ? const SizedBox(
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(
                                color: pastelGreen,
                                strokeWidth: 2,
                              ),
                            )
                                : const Text(
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
                      ), //logout button
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
