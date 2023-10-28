import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../../res/colors.dart';
import 'package:google_fonts/google_fonts.dart';


import '../view_model/register_viewmodel.dart';
import 'package:plantaera/user/widget/user_bottom_nav.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _loading = false;
  final registerFormKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String registerStatusText = " ";
  RegExp regex = RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  handleSubmit() async {
    //function for login credential handling before going to firebase auth
    if (registerFormKey.currentState!.validate() &&
        (_passwordController.text == _confirmPasswordController.text)) { //check if anything is empty
      final username = _usernameController.value.text;
      final email = _emailController.value.text;
      final password = _passwordController.value.text;
      setState(() {
        _loading = true; //for the loading progress bar
      });

      registerStatusText = await RegisterVM().register(context, username, email, password);

      if (registerStatusText == "ok") {
        //redirect to home page... succ method, might change ltr when have time
        Navigator
            .of(context)
            .pushReplacement(
            MaterialPageRoute(
                builder: (BuildContext context) => UserBottomNav()
            ));
        _loading = false;
      }else{
        setState(() {
          _loading = false; //for the loading progress bar
        });
      }
    }
    else if(_confirmPasswordController.text != _passwordController.text){
      setState(() {
        registerStatusText = "Password and Confirm Password are not the same!";
        _loading = false; //for the loading progress bar
      });
      return;
    }
    else if(!registerFormKey.currentState!.validate()){
      setState(() {
        registerStatusText = "Please insert all fields!";
        _loading = false;
      });
    }
    else{
      setState(() {
        registerStatusText = "Please enter password with at least 8 characters, 1 upper and lower case, 1 number, and 1 special character(!@#\$&*~).";
        _loading = false; //for the loading progress bar
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plantaera',
      theme: ThemeData(
        scaffoldBackgroundColor: background,
        textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: darkGreen,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: darkGreen,
            ),
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: grass,
        ),
        useMaterial3: true,
      ),
      home: Container(
        child: Scaffold(
          body: SafeArea(
              child: Form(
                key: registerFormKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            //spacing
                            height: 40,
                          ),
                          const Text(
                            "Welcome To",
                            style: TextStyle(
                              fontSize: 30,
                              color: darkGreen,
                            ),
                          ),
                          const Text(
                            "Plantaera",
                            style: TextStyle(
                              fontSize: 30,
                              color: darkGreen,
                            ),
                          ),
                          const SizedBox(
                            //spacing
                            height: 50,
                          ),
                          const Text(
                            "Register for an account",
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            //spacing
                            height: 15,
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
                                  return 'Please enter your username';
                                }
                                return null;
                              },
                              style: TextStyle(
                                fontSize: 17,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Enter your username",
                                hintStyle: const TextStyle(
                                  fontSize: 17,
                                  color: lightgrey,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 0.0,
                                    style: BorderStyle.none,
                                  ),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                          ), //text field for username
                          const SizedBox(
                            //spacing
                            height: 15,
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
                                  return 'Please enter email';
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
                                hintText: "Enter your email",
                                hintStyle: const TextStyle(
                                  fontSize: 17,
                                  color: lightgrey,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 0.0,
                                    style: BorderStyle.none,
                                  ),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                          ), //text field for email
                          const SizedBox(
                            //spacing
                            height: 15,
                          ),
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                              //text field for password
                              textAlign: TextAlign.center,
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              controller: _passwordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter password';
                                }else if(!regex.hasMatch(value)){
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
                                hintText: "Enter your password",
                                hintStyle: const TextStyle(
                                  fontSize: 17,
                                  color: lightgrey,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 0.0,
                                    style: BorderStyle.none,
                                  ),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {});
                              },
                            ),
                          ),
                          const SizedBox(
                            //spacing
                            height: 15,
                          ),
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                              //text field for password
                              textAlign: TextAlign.center,
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              controller: _confirmPasswordController,
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
                                hintText: "Confirm password",
                                hintStyle: const TextStyle(
                                  fontSize: 17,
                                  color: lightgrey,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 0.0,
                                    style: BorderStyle.none,
                                  ),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {});
                              },
                            ),
                          ), //password textfield
                          const SizedBox(
                            //spacing
                            height: 20,
                          ),
                          Text(//text for warning if fail to register
                            registerStatusText,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(
                            width: 130,
                            height: 50,
                            child: ElevatedButton(
                              //sign in button
                              onPressed: () => handleSubmit(),
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
                                  "Register",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ), //sign up button
                          const SizedBox(
                            //spacing
                            height: 50,
                          ),
                          Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 7,
                                ),
                                const Text(
                                  "Already have an account?  ",
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      width: 100,
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.circular(10)),
                                      child: const Center(
                                        child: Text(
                                          //redirect to sign up page
                                          "Login Now",
                                          style: TextStyle(
                                            color: grass,
                                            fontSize: 14,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ), //need help and sign in if got acc
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
