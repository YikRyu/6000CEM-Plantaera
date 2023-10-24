import 'package:flutter/material.dart';
import 'package:plantaera/res/colors.dart';

class AdminDiseaseGuideList extends StatefulWidget {
  const AdminDiseaseGuideList({Key? key}) : super(key: key);

  @override
  State<AdminDiseaseGuideList> createState() => _AdminDiseaseGuideListState();
}

class _AdminDiseaseGuideListState extends State<AdminDiseaseGuideList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: SafeArea(
          child: Column(
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
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: darkgrey,
                      size: 35,
                    ),
                    hintText: "Search for a plant disease...",
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
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
