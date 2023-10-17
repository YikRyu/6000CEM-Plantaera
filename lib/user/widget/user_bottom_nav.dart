//reference: https://blog.logrocket.com/how-to-build-a-bottom-navigation-bar-in-flutter/
//bottom nav switch page reference: https://stackoverflow.com/questions/71908809/screen-switching-using-bottom-navigation-bar

import 'package:flutter/material.dart';
import 'package:plantaera/res/colors.dart';
import 'package:plantaera/user/view/plant_guides/plant_guides.dart';
import 'package:plantaera/user/view/home/homepage.dart';

class UserBottomNav extends StatefulWidget {
  const UserBottomNav({Key? key}) : super(key: key);

  @override
  State<UserBottomNav> createState() => _UserBottomNavState();
}

class _UserBottomNavState extends State<UserBottomNav> {
  int navIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: SafeArea(
          child: IndexedStack(
            children: [
                UserHomePage(),
                PlantGuides(),
              ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          iconSize: 30,
          onTap: (value) {
            setState(() {navIndex = value;});
          },
          currentIndex: navIndex,
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
    );
  }
}
