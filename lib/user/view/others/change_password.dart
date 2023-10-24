import 'package:flutter/material.dart';
import 'package:plantaera/res/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../view_model/profile_viewmodel.dart';

class ChangeUserPassword extends StatefulWidget {
  const ChangeUserPassword({Key? key}) : super(key: key);

  @override
  State<ChangeUserPassword> createState() => _ChangeUserPasswordState();
}

class _ChangeUserPasswordState extends State<ChangeUserPassword> {
  final changeUserPasswordFormKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _loading = false;
  String currentUserID = FirebaseAuth.instance.currentUser!.uid;
  String? currentUserEmail = FirebaseAuth.instance.currentUser!.email;
  ProfileVM profileVM = ProfileVM();
  String changePasswordStatusText = '';
  RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  changeUsername() async{
    if (changeUserPasswordFormKey.currentState!.validate() && (_confirmPasswordController.text == _newPasswordController.text)) { //check if anything is empty
      final oldPassword = _oldPasswordController.value.text;
      final newPassword = _newPasswordController.value.text;
      setState(() {
        _loading = true; //for the loading progress bar
      });

      changePasswordStatusText = await ProfileVM().changeUserPassword(currentUserEmail!, oldPassword, newPassword);

      if (changePasswordStatusText == "ok") {
        setState(() {
          changePasswordStatusText = 'Password changed successfully!';
          _oldPasswordController.clear();
          _newPasswordController.clear();
          _confirmPasswordController.clear();
        });
        _loading = false;
      }
      else{
        setState(() {
          changePasswordStatusText;
          _loading = false;
        });
      }
    }
    else if(_confirmPasswordController.text != _newPasswordController.text){
      setState(() {
        changePasswordStatusText = "Confirm password and password are not the same!";
        _loading = false;
      });
    }
    else{
      setState(() {
        changePasswordStatusText = "Please enter password with at least 8 characters, 1 upper and lower case, 1 number, and 1 special character(!@#\$&*~).";
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
                  key: changeUserPasswordFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "Change Password",
                          style: TextStyle(
                            fontSize: 30,
                            color: darkGreen,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          controller: _oldPasswordController,
                          enableSuggestions: false,
                          autocorrect: false,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter old password';
                            }
                            return null;
                          },
                          style: TextStyle(
                            fontSize: 17,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Enter old password",
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
                      ), // old password textfield
                      SizedBox(height: 10,),
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          controller: _newPasswordController,
                          enableSuggestions: false,
                          autocorrect: false,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter new password';
                            }
                            else if(!regex.hasMatch(value)){
                              return 'Password is too weak!';
                            }
                            return null;
                          },
                          style: TextStyle(
                            fontSize: 17,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Enter new password",
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
                      ), //new password textfield
                      SizedBox(height: 10,),
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          controller: _confirmPasswordController,
                          enableSuggestions: false,
                          autocorrect: false,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter confirm password';
                            }
                            return null;
                          },
                          style: TextStyle(
                            fontSize: 17,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Enter confirm password",
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
                      ), //confirm password textfield
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(changePasswordStatusText,style: TextStyle(fontSize: 18, ),textAlign: TextAlign.center,),
                      ),
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
                              "Change Password",
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
