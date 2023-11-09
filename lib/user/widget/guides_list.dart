//tab bar reference: https://stackoverflow.com/questions/63314082/flutter-how-to-make-a-custom-tabbar

import 'package:flutter/material.dart';
import 'package:plantaera/res/colors.dart';


import 'package:plantaera/user/view/disease_guides/disease_guides_list.dart';
import 'package:plantaera/user/view/general_guides/general_guides_list.dart';
import 'package:plantaera/user/view/plant_guides/plant_guides_list.dart';

class GuidesList extends StatefulWidget {
  const GuidesList({Key? key}) : super(key: key);

  @override
  State<GuidesList> createState() => _GuidesListState();
}

class _GuidesListState extends State<GuidesList> with SingleTickerProviderStateMixin{
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.all(7.0),
                  margin: EdgeInsets.only(top: 20,),
                  width: 300,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      width: 1.0,
                      color: darkGreen,
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: grass,
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    tabs: [
                      Tab(
                        text: "Plant",
                      ),
                      Tab(
                        text: "Disease",
                      ),
                      Tab(
                        text: "General",
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    UserPlantGuidesList(),
                    UserDiseaseGuideList(),
                    UserGeneralGuidesList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
