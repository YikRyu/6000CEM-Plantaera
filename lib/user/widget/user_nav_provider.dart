import 'package:flutter/material.dart';

class UserNavProvider with ChangeNotifier{
  int _navIndex = 0;

  int get navIndex => _navIndex;

  void toIdentify(){
    _navIndex = 2;
    notifyListeners();
  }

  void toReminderList(){
    _navIndex = 3;
    notifyListeners();
  }

  void changeOnNav(int passedNavIndex){
    _navIndex = passedNavIndex;
    notifyListeners();
  }
}