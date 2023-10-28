import 'package:flutter/material.dart';
import 'package:plantaera/admin/view/general_guides/new_general_guide.dart';
import 'package:plantaera/res/colors.dart';

class AdminGeneralGuidesList extends StatefulWidget {
  const AdminGeneralGuidesList({Key? key}) : super(key: key);

  @override
  State<AdminGeneralGuidesList> createState() => _AdminGeneralGuidesListState();
}

class _AdminGeneralGuidesListState extends State<AdminGeneralGuidesList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 100,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          //background image
                          image: AssetImage("assets/gardening-guide-banner.jpg"),
                          fit: BoxFit.cover,
                          opacity: 0.8,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Gardening Guides",
                          style: TextStyle(
                            fontSize: 28,
                            color: cherry,
                            shadows: [
                              Shadow(
                                // bottomLeft
                                  offset: Offset(-1.5, -1.5),
                                  color: Colors.white),
                              Shadow(
                                // bottomRight
                                  offset: Offset(1.5, -1.5),
                                  color: Colors.white),
                              Shadow(
                                // topRight
                                  offset: Offset(1.5, 1.5),
                                  color: Colors.white),
                              Shadow(
                                // topLeft
                                  offset: Offset(-1.5, 1.5),
                                  color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: "newGeneral",
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewGeneralGuide())).then((_) => setState((){}));
          },
          foregroundColor: cherry,
          backgroundColor: cherry,
          child: const Icon(Icons.add, color: Colors.white, size: 45,),
        ),
      ),
    );
  }
}
