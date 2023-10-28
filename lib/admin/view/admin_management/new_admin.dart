import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plantaera/admin/view_model/admin_viewmodel.dart';
import 'package:plantaera/res/colors.dart';

class NewAdmin extends StatefulWidget {
  const NewAdmin({Key? key}) : super(key: key);

  @override
  State<NewAdmin> createState() => _NewAdminState();
}

class _NewAdminState extends State<NewAdmin> {
  final newAdminFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _loading = false;
  AdminVM adminVM = AdminVM();
  String newAdminStatusText = '';
  RegExp regex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  handleSubmit() async {
    //function for login credential handling before going to firebase auth
    if (newAdminFormKey.currentState!.validate() &&
        (_passwordController.text == _confirmPasswordController.text)) {
      //check if anything is empty
      final username = _emailController.value.text;
      final email = _emailController.value.text;
      final password = _passwordController.value.text;
      setState(() {
        _loading = true; //for the loading progress bar
      });

      newAdminStatusText =
          await adminVM.newAdmin(context, username, email, password);

      if (newAdminStatusText == "ok") {
        //redirect back to admin list with toaster message shown
        Fluttertoast.showToast(
          msg: "Admin added successfully! Redirecting back to Admin list....",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        Navigator.pop(context);
        _loading = false;
      } else {
        setState(() {
          _loading = false; //for the loading progress bar
        });
      }
    } else if (_confirmPasswordController.text != _passwordController.text) {
      setState(() {
        newAdminStatusText = "Password and Confirm Password are not the same!";
        _loading = false; //for the loading progress bar
      });
      return;
    } else if (!newAdminFormKey.currentState!.validate()) {
      setState(() {
        newAdminStatusText = "Please insert all fields!";
        _loading = false;
      });
    } else {
      setState(() {
        newAdminStatusText =
            "Please enter password with at least 8 characters, 1 upper and lower case, 1 number, and 1 special character(!@#\$&*~).";
        _loading = false; //for the loading progress bar
      });
      return;
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
              color: deepPink,
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
                  key: newAdminFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "New Admin",
                          style: TextStyle(
                            fontSize: 30,
                            color: deepPink,
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
                          controller: _emailController,
                          enableSuggestions: false,
                          autocorrect: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email';
                            } else if (EmailValidator.validate(value) ==
                                false) {
                              return 'please enter a valid email';
                            }
                            return null;
                          },
                          style: TextStyle(
                            fontSize: 17,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Enter new admin email",
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
                      ), // admin email textfield
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          controller: _passwordController,
                          enableSuggestions: false,
                          autocorrect: false,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter admin password';
                            } else if (!regex.hasMatch(value)) {
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
                            hintText: "Enter new admin password",
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
                      ), //password textfield
                      SizedBox(
                        height: 10,
                      ),
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
                        child: Text(
                          newAdminStatusText,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 250,
                        height: 50,
                        child: ElevatedButton(
                          //sign in button
                          onPressed: () => handleSubmit(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cherry,
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
                                      color: pastelPink,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    "New Admin",
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
