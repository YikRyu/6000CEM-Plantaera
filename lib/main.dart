//splash screen reference: https://www.scaler.com/topics/splash-screen-in-flutter/
//splash screen presist login reference: https://stackoverflow.com/questions/54469191/persist-user-auth-flutter-firebase
//splash screen presist login reference 2: https://medium.com/@ankith159/flutter-firebase-auth-an-easy-guide-to-persist-user-state-c90c2e53f9df
//provider reference for page changes: https://www.youtube.com/watch?v=L_QMsE2v6dw

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:plantaera/admin/widget/admin_bottom_nav.dart';
import 'package:plantaera/res/colors.dart';
import 'package:plantaera/user/view_model/notification_viewmodel.dart';
import 'package:plantaera/user/widget/user_bottom_nav.dart';
import 'package:plantaera/user/widget/user_nav_provider.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:plantaera/user/model/reminder_model.dart';
import 'helper/object_box.dart';

import 'general/view/login.dart';
import 'package:plantaera/general/view_model/login_viewmodel.dart';
import 'package:plantaera/admin/widget/admin_nav_provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();



late ObjectBox objectBox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationVM.init(initScheduled: true);

  //initialize objectBox
  objectBox = await ObjectBox.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AdminNavProvider()),
        ChangeNotifierProvider(create: (_) => UserNavProvider()),
      ],
      child: Plantaera(),
    ),
  );
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
      home: StreamBuilder<User?>(
        //currently not working?
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return UserBottomNav();
          } else {
            return const Login();
          }
        },
      ),
      initialRoute: '/init',
      routes: {
        '/init': (context) => SplashScreen(),
        '/adminBottomNav': (context) => AdminBottomNav(),},
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

    //initialize timezone when launching the app
    NotificationVM.init(initScheduled : true);
  }

  Future initializeUser() async {
    await Firebase.initializeApp();
    final User? firebaseUser = await FirebaseAuth.instance.currentUser;
    await firebaseUser?.reload();
    user = await _auth.currentUser;
    // get User authentication status here
  }

  navigateUser() async {
    if (_auth.currentUser != null) {
      // if logged in
      Map<String, dynamic> userRole = await loginVM
          .getUserInformation(FirebaseAuth.instance.currentUser!.uid);

      if (userRole["role"] == 'user') {
        Timer(
            Duration(seconds: 3),
            () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => UserBottomNav())));
      } else {
        Timer(
            Duration(seconds: 3),
            () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => AdminBottomNav(),
                )));
      }
    } else {
      Timer(
          Duration(seconds: 3),
          () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) => Login())));
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
