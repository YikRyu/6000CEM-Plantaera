//splash screen reference: https://www.scaler.com/topics/splash-screen-in-flutter/

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:plantaera/res/colors.dart';
import 'package:plantaera/user/view/home/homepage.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'general/view/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const Plantaera());
}

class Plantaera extends StatelessWidget {
  const Plantaera({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plantaera',
      theme: ThemeData(
        scaffoldBackgroundColor: background,
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
        textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        //currently not working?
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return UserHomePage();
          } else {
            return const Login();
          }
        },
      ),
      initialRoute: '/init',
      routes: {'/init': (context) => SplashScreen()},
    );
  }
}

//app startup splash screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Login())));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: background,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Image.asset(
                  "assets/plantaera-logo-removebg.png",
                  height: 200,
                  width: 200,
                ),
                const Text(
                  "Plantaera",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: darkGreen,
                    fontSize: 35,
                  ),
                ),
                const Text(
                  "Your Plant Growing Helper",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: grass,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
