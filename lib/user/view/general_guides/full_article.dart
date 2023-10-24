import 'package:flutter/material.dart';
import 'package:plantaera/res/colors.dart';

class FullArticle extends StatefulWidget {
  const FullArticle({Key? key}) : super(key: key);

  @override
  State<FullArticle> createState() => _FullArticleState();
}

class _FullArticleState extends State<FullArticle> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: null,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: darkGreen,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                  },
                  child: RawMaterialButton(
                    elevation: 2.0,
                    onPressed: () {},
                    child: new Icon(
                      Icons.favorite,
                      color: darkgrey,
                      size: 25,
                    ),
                    shape: CircleBorder(),
                    fillColor: Colors.white,
                  ),
                )
            ),
          ],
      ),
      body: SafeArea(
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }
}
