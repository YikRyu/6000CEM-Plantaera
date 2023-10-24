import 'package:flutter/material.dart';
import 'package:plantaera/res/colors.dart';


import 'package:plantaera/user/view/others/fav_diseases.dart';
import 'package:plantaera/user/view/others/fav_plants.dart';
import 'package:plantaera/user/view/others/fav_generals.dart';

class FavoriteGuidesList extends StatefulWidget {
  const FavoriteGuidesList({Key? key}) : super(key: key);

  @override
  State<FavoriteGuidesList> createState() => _FavoriteGuidesListState();
}

class _FavoriteGuidesListState extends State<FavoriteGuidesList>
    with SingleTickerProviderStateMixin {
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
        appBar: AppBar(
          title: null,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: darkGreen,
              size: 35,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Center(
                child: Text(
                  "Favorites",
                  style: TextStyle(
                    fontSize: 25,
                    color: darkGreen,
                  ),
                ),
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.all(7.0),
                  margin: EdgeInsets.only(
                    top: 20,
                  ),
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
                    labelColor: Colors.black,
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
                    FavoritePlantList(),
                    FavoriteDiseaseList(),
                    FavoriteGeneralList(),
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
