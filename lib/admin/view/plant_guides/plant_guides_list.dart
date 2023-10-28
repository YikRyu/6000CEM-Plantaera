import 'package:flutter/material.dart';
import 'package:plantaera/admin/view/plant_guides/new_plant_guide.dart';
import 'package:plantaera/res/colors.dart';

class AdminPlantGuidesList extends StatefulWidget {
  const AdminPlantGuidesList({Key? key}) : super(key: key);

  @override
  State<AdminPlantGuidesList> createState() => _AdminPlantGuidesListState();
}

class _AdminPlantGuidesListState extends State<AdminPlantGuidesList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 55,
                      width: double.infinity,
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: TextField(
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: darkgrey,
                            size: 35,
                          ),
                          hintText: "Search for a plant...",
                          hintStyle: TextStyle(
                            color: darkgrey,
                            fontSize: 18,
                            decoration: TextDecoration.underline,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              style: BorderStyle.none,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: "newPlant",
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewPlantGuide())).then((_) => setState((){}));
          },
          foregroundColor: cherry,
          backgroundColor: cherry,
          child: const Icon(Icons.add, color: Colors.white, size: 45,),
        ),
      ),
    );
  }
}
