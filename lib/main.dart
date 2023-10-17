//splash screen reference: https://www.scaler.com/topics/splash-screen-in-flutter/
//splash screen presist login reference: https://stackoverflow.com/questions/54469191/persist-user-auth-flutter-firebase
//splash screen presist login reference 2: https://medium.com/@ankith159/flutter-firebase-auth-an-easy-guide-to-persist-user-state-c90c2e53f9df

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:plantaera/res/colors.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'general/view/login.dart';
import 'package:plantaera/user/view/home/homepage.dart';
import 'package:plantaera/admin/view/home/homepage.dart';
import 'package:plantaera/general/view_model/login_viewmodel.dart';

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
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: darkGreen,
          unselectedItemColor: grass,
          showUnselectedLabels: true,
          unselectedLabelStyle: const TextStyle(color: grass, fontSize: 11),
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  LoginVM loginVM = LoginVM();

  @override
  void initState() {
    super.initState();
    initializeUser(); //check for user instance
    navigateUser(); //navigate to page accordingly
  }

  Future initializeUser() async {
    await Firebase.initializeApp();
    final User? firebaseUser = await FirebaseAuth.instance.currentUser;
    await firebaseUser?.reload();
    user = await _auth.currentUser;
    // get User authentication status here
  }

  navigateUser() async {
    if (_auth.currentUser != null) { // if logged in
      Map<String, dynamic> userRole = await loginVM.getUserInformation(FirebaseAuth.instance.currentUser!.uid);

      if(userRole["role"] == 'user'){
        Timer(Duration(seconds: 3),
                () => Navigator
                .of(context)
                .pushReplacement(
                MaterialPageRoute(
                    builder: (BuildContext context) => UserHomePage()
                )));
      }else{
        Timer(Duration(seconds: 3),
                () => Navigator
                .of(context)
                .pushReplacement(
                MaterialPageRoute(
                    builder: (BuildContext context) => AdminHomePage()
                )));
      }

    } else {
      Timer(Duration(seconds: 3),
              () => Navigator
                  .of(context)
                  .pushReplacement(
                  MaterialPageRoute(
                      builder: (BuildContext context) => Login()
                  )));
    }
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
