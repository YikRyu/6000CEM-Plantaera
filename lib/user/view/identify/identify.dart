import 'package:flutter/material.dart';
import 'package:plantaera/res/colors.dart';
import 'package:plantaera/user/view/identify/disease_identify.dart';
import 'package:plantaera/user/view/identify/plant_identify.dart';

class Identify extends StatelessWidget {
  const Identify({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => IdentifyPlant()));
                },
                child: Container(
                  width: double.infinity,
                  height: 331.5,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/identification-plant-bg.jpg"),
                      fit: BoxFit.cover,
                      opacity: 0.65,
                    ),
                    border: Border(
                      bottom: BorderSide(width: 2, color: darkGreen),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Plant Identification",
                      style: TextStyle(
                        fontSize: 50,
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
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => IdentifyDisease()));
                },
                child: Container(
                  width: double.infinity,
                  height: 331.5,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/identification-disease-bg.jpg"),
                      fit: BoxFit.cover,
                      opacity: 0.65,
                    ),
                    border: Border(
                      top: BorderSide(width: 2, color: darkGreen),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Disease Identification",
                      style: TextStyle(
                        fontSize: 50,
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
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
