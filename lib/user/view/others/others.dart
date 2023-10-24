import 'package:flutter/material.dart';
import 'package:plantaera/res/colors.dart';
import 'package:plantaera/user/widget/fav_guide_list.dart';
import 'user_profile.dart';

class Others extends StatelessWidget {
  const Others({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50,),
              Material(
                elevation: 5.0,
                shadowColor: darkgrey,
                child: ListTile(
                  contentPadding: EdgeInsets.all(10),
                  tileColor: green,
                  leading: const Icon(Icons.person, size: 35,),
                  iconColor: Color(0xFF562400),
                  title: const Text('User Account',
                      style: TextStyle(fontSize: 25, color: darkGreen)),
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => UserProfile()));
                  },
                ),
              ),
              SizedBox(height: 30,),
              Material(
                elevation: 5.0,
                shadowColor: darkgrey,
                child: ListTile(
                  contentPadding: EdgeInsets.all(10),
                  tileColor: green,
                  leading: const Icon(Icons.favorite, size: 35,),
                  iconColor: favorite,
                  title: const Text('Favorites',
                      style: TextStyle(fontSize: 25, color: darkGreen)),
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => FavoriteGuidesList()));
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
