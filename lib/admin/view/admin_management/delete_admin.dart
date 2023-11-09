import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plantaera/res/colors.dart';

import '../../../general/view/login.dart';
import '../../view_model/admin_viewmodel.dart';

class DeleteAdmin extends StatefulWidget {
  const DeleteAdmin({Key? key}) : super(key: key);

  @override
  State<DeleteAdmin> createState() => _DeleteAdminState();
}

class _DeleteAdminState extends State<DeleteAdmin> {
  final deleteAdminFormKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmTextController = TextEditingController();

  final _auth = FirebaseAuth.instance;


  bool _loading = false;
  String adminEmail = '';
  AdminVM adminVM = AdminVM();
  String deleteAdminStatusText = '';
  String currentAdminId = FirebaseAuth.instance.currentUser!.uid;

  //logging out
  Future logout(context) async {
    await _auth.signOut().then((value) => Navigator.of(context)
        .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Login()),
            (route) => false));
  }

  deleteAdmin() async{
    if (deleteAdminFormKey.currentState!.validate() && (_confirmTextController.text == "CONFIRM")) { //check if anything is empty
      final password = _passwordController.value.text;
      setState(() {
        _loading = true; //for the loading progress bar
      });

      deleteAdminStatusText = await AdminVM().deleteAdmin(adminEmail, password, currentAdminId);

      if (deleteAdminStatusText == "ok") {
        Fluttertoast.showToast(
          msg: "Admin removed successfully! Redirecting back to login page....",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        logout(context);
        _loading = false;
      }
      else{
        setState(() {
          deleteAdminStatusText;
          _loading = false;
        });
      }
    }
    else if(_confirmTextController.text != "CONFIRM"){
      setState(() {
        deleteAdminStatusText = "Please enter \'CONFIRM\' to continue this operation!";
        _loading = false;
      });
    }
    else{
      setState(() {
        deleteAdminStatusText = "Please fill up all fields!";
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    //fetch arguments passed from previous page
    adminEmail = arguments['email']!;

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
                  key: deleteAdminFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Text(
                              "Delete Admin Account",
                              style: TextStyle(
                                fontSize: 30,
                                color: deepPink,
                              ),
                            ),
                            SizedBox(height: 10,),
                            Text(
                              "Please enter admin account password and CONFIRM for this action to execute.",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: Container(
                          width: 300,
                          child: Row(
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
                                  '$adminEmail',
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: cherry,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
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
                              return 'Please enter password';
                            }
                            return null;
                          },
                          style: TextStyle(
                            fontSize: 17,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Enter admin password",
                            hintStyle: const TextStyle(
                              fontSize: 17,
                              color: lightgrey,
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: deepPink,
                                width: 1.0,
                                style: BorderStyle.none,
                              ),
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                          ),
                        ),
                      ), // password textfield
                      SizedBox(height: 10,),
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          controller: _confirmTextController,
                          enableSuggestions: false,
                          autocorrect: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please the word CONFIRM';
                            }
                            return null;
                          },
                          style: TextStyle(
                            fontSize: 17,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Enter CONFIRM",
                            hintStyle: const TextStyle(
                              fontSize: 17,
                              color: lightgrey,
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: deepPink,
                                width: 1.0,
                                style: BorderStyle.none,
                              ),
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                          ),
                        ),
                      ), //new password textfield
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(deleteAdminStatusText,style: TextStyle(fontSize: 18, color: Colors.red),textAlign: TextAlign.center,),
                      ),
                      SizedBox(height: 10,),
                      SizedBox(
                        width: 250,
                        height: 50,
                        child: ElevatedButton(
                          //change password button
                          onPressed: () => deleteAdmin(),
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
                              height:44,
                              child: CircularProgressIndicator(
                                color: pastelPink,
                                strokeWidth: 2,
                              ),
                            )
                                : const Text(
                              "Delete Admin",
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
