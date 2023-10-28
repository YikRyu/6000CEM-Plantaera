//reference: https://blog.logrocket.com/how-to-build-a-bottom-navigation-bar-in-flutter/
//bottom nav switch page reference: https://stackoverflow.com/questions/71908809/screen-switching-using-bottom-navigation-bar
//bottom nav for image icon: https://stackoverflow.com/questions/49029966/how-to-change-bottomnavigationbaritem-icon-when-selected-flutter
//bottom nav change screen: https://www.youtube.com/watch?v=xoKqQjSDZ60
//change theme for admin sided: https://www.educative.io/answers/how-to-create-different-themes-for-your-flutter-app
//prevent back button from screwing the screens: https://stackoverflow.com/questions/45916658/how-to-deactivate-or-override-the-android-back-button-in-flutter
//provider reference for page changes: https://www.youtube.com/watch?v=L_QMsE2v6dw

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plantaera/res/colors.dart';
import 'package:provider/provider.dart';

import 'package:plantaera/admin/view/admin_management/admin_list.dart';
import 'package:plantaera/admin/view/disease_guides/disease_guides_list.dart';
import 'package:plantaera/admin/view/general_guides/general_guides_lists.dart';
import 'package:plantaera/admin/view/plant_guides/plant_guides_list.dart';
import 'package:plantaera/admin/view/home/homepage.dart';
import 'package:plantaera/admin/widget/admin_nav_provider.dart';

class AdminBottomNav extends StatefulWidget {
  const AdminBottomNav({Key? key}) : super(key: key);

  @override
  State<AdminBottomNav> createState() => _AdminBottomNavState();


}

class _AdminBottomNavState extends State<AdminBottomNav> {
  final screens = [
    AdminHomePage(),
    AdminPlantGuidesList(),
    AdminDiseaseGuideList(),
    AdminGeneralGuidesList(),
    AdminList(),
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
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: deepPink,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: deepPink,
              ),
            ),
          ),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: cherry,
          ),
        ),
        home: Scaffold(
          body: IndexedStack(
            index: context.watch<AdminNavProvider>().navIndex,
            children: screens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            iconSize: 30,
            backgroundColor: Colors.white,
            selectedItemColor: deepPink,
            unselectedItemColor: pink,
            showUnselectedLabels: true,
            unselectedLabelStyle: const TextStyle(color: pink, fontSize: 11),
            currentIndex: context.watch<AdminNavProvider>().navIndex,
            onTap: (value) {
              setState(() {context.read<AdminNavProvider>().changeOnNav(value);});
            },
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                activeIcon: Image.asset(
                  'assets/admin-plant-icon-darken.png',
                  height: 32,
                  width: 25,
                ),
                icon: Image.asset(
                  'assets/admin-plant-icon.png',
                  height: 32,
                  width: 25,
                ),
                label: 'Plants',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.bug_report,
                ),
                label: 'Diseases',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.book,
                ),
                label: 'Guides',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.people,
                ),
                label: 'Admin Acc',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
