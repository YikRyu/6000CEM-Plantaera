//reference: https://blog.logrocket.com/how-to-build-a-bottom-navigation-bar-in-flutter/
//bottom nav switch page reference: https://stackoverflow.com/questions/71908809/screen-switching-using-bottom-navigation-bar
//bottom nav change screen: https://www.youtube.com/watch?v=xoKqQjSDZ60
//prevent back button from screwing the screens: https://stackoverflow.com/questions/45916658/how-to-deactivate-or-override-the-android-back-button-in-flutter

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plantaera/res/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plantaera/user/widget/user_nav_provider.dart';
import 'package:provider/provider.dart';

import 'package:plantaera/user/view/home/homepage.dart';
import 'package:plantaera/user/view/others/others.dart';
import 'package:plantaera/user/view/identify/identify.dart';
import 'package:plantaera/user/view/reminders/reminder_list.dart';
import 'package:plantaera/user/widget/guides_list.dart';

class UserBottomNav extends StatefulWidget {
  const UserBottomNav({Key? key}) : super(key: key);

  @override
  State<UserBottomNav> createState() => _UserBottomNavState();
}

class _UserBottomNavState extends State<UserBottomNav> {
  int navIndex = 0;

  final screens = [
    UserHomePage(),
    GuidesList(),
    Identify(),
    ReminderList(),
    Others(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, //prevent back button from screwing the app screen lol
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Plantaera',
        theme: ThemeData(
          scaffoldBackgroundColor: background,
          textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
          primaryColor: darkGreen,
          inputDecorationTheme: InputDecorationTheme(
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
        ),
        home: Scaffold(
          body: IndexedStack(
            index: context.watch<UserNavProvider>().navIndex,
            children: screens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            iconSize: 30,
            backgroundColor: Colors.white,
            selectedItemColor: darkGreen,
            unselectedItemColor: grass,
            showUnselectedLabels: true,
            unselectedLabelStyle: const TextStyle(color: grass, fontSize: 11),
            currentIndex: context.watch<UserNavProvider>().navIndex,
            onTap: (value) {
              setState(() {context.read<UserNavProvider>().changeOnNav(value);});
            },
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.book,
                ),
                label: 'Guides',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.camera,
                ),
                label: 'Identify',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.notifications,
                ),
                label: 'Reminder',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.grid_view_rounded,
                ),
                label: 'Others',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
