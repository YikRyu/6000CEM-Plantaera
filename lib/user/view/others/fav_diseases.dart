import 'package:flutter/material.dart';
import 'package:plantaera/res/colors.dart';

class FavoriteDiseaseList extends StatefulWidget {
  const FavoriteDiseaseList({Key? key}) : super(key: key);

  @override
  State<FavoriteDiseaseList> createState() => _FavoriteDiseaseListState();
}

class _FavoriteDiseaseListState extends State<FavoriteDiseaseList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
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
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }
}