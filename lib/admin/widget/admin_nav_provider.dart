import 'package:flutter/material.dart';

class AdminNavProvider with ChangeNotifier{
  int _navIndex = 0;

  int get navIndex => _navIndex;

  void toPlantGuideList(){
    _navIndex = 1;
    notifyListeners();
  }

  void toDiseaseGuideList(){
    _navIndex = 2;
    notifyListeners();
  }

  void toGeneralGuideList(){
    _navIndex = 3;
    notifyListeners();
  }

  void toAdminList(){
    _navIndex = 4;
    notifyListeners();
  }

  void changeOnNav(int passedNavIndex){
    _navIndex = passedNavIndex;
    notifyListeners();
  }
}