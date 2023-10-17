import 'package:flutter/material.dart';
import 'package:plantaera/res/colors.dart';

class PlantGuides extends StatefulWidget {
  const PlantGuides({Key? key}) : super(key: key);

  @override
  State<PlantGuides> createState() => _PlantGuidesState();
}

class _PlantGuidesState extends State<PlantGuides> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                Text("Plant Guides"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
