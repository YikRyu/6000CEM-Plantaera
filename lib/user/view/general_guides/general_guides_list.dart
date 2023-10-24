import 'package:flutter/material.dart';
import 'package:plantaera/res/colors.dart';

class UserGeneralGuidesList extends StatefulWidget {
  const UserGeneralGuidesList({Key? key}) : super(key: key);

  @override
  State<UserGeneralGuidesList> createState() => _UserGeneralGuidesListState();
}

class _UserGeneralGuidesListState extends State<UserGeneralGuidesList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10,),
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
                color: grass,
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
    );
  }
}
