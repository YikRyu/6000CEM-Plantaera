//referenced: https://www.youtube.com/watch?v=X1nQwpSS0H8

import 'package:plantaera/res/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:email_validator/email_validator.dart';

import 'package:flutter/material.dart';
import 'package:plantaera/general/view_model/login_viewmodel.dart';
import 'package:plantaera/general/view/register.dart';
import 'package:plantaera/user/widget/user_bottom_nav.dart';
import 'package:plantaera/admin/widget/admin_bottom_nav.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _loading = false;
  final loginFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String loginStatusText = " ";
  String accountRole = " ";

  handleSubmit() async {
    //function for login credential handling before going to firebase auth
    if (!loginFormKey.currentState!.validate()) return;

    final email = _emailController.value.text;
    final password = _passwordController.value.text;

    setState(() {
      _loading = true; //for the loading progress bar
    });

    loginStatusText = await LoginVM().login(context, email, password);

    if (loginStatusText == "user") {
      //redirect to user home page...
      Navigator
          .of(context)
          .pushReplacement(
          MaterialPageRoute(
              builder: (BuildContext context) => UserBottomNav()
          ));
    }else if (loginStatusText == "admin"){
      //redirect to admin home page...
      Navigator
          .of(context)
          .pushReplacement(
          MaterialPageRoute(
              builder: (BuildContext context) => AdminBottomNav()
          ));
    }
    else{
      setState(() {
        _loading = false;
      });
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
              key: loginFormKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Column(
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
                          height: 80,
                        ),
                        const Text(
                          "Login as Member",
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
                            controller: _emailController,
                            enableSuggestions: false,
                            autocorrect: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter email';
                              } else if (EmailValidator.validate(value) ==
                                  false) {
                                return 'Please enter a valid email';
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
                                  color: darkGreen,
                                  width: 1.0,
                                  style: BorderStyle.none,
                                ),
                                borderRadius: BorderRadius.circular(7.0),
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
                            textAlign: TextAlign.center,
                            //text field for password
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            controller: _passwordController,
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
                              hintText: "Enter your password",
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
                            onChanged: (value) {
                              setState(() {});
                            },
                          ),
                        ), //password textfield
                        const SizedBox(
                          height: 40,
                        ),
                        Text(
                          loginStatusText,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.red,
                          ),
                        ),//text for warning if has error during login
                        SizedBox(
                          width: 130,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () => handleSubmit(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: grass,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
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
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ), //sign in button
                        const SizedBox(
                          //spacing
                          height: 50,
                        ),
                        Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Want to be a member but don't have an account?",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const Register()));
                                  },
                                  child: Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius:
                                        BorderRadius.circular(10)),
                                    child: const Center(
                                      child: Text(
                                        //redirect to sign up page
                                        "Register Now",
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
                        ), //need help and sign up
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
