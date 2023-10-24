import 'package:flutter/material.dart';
import 'package:plantaera/res/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../general/view/login.dart';

class AdminList extends StatelessWidget {
  AdminList({Key? key}) : super(key: key);

  final _auth = FirebaseAuth.instance;

  Future logout(context) async {
    await _auth.signOut().then((value) => Navigator.of(context)
        .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Login()),
            (route) => false));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 100,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    //background image
                    image: AssetImage("assets/admin-banner.jpg"),
                    fit: BoxFit.cover, opacity: 0.8,
                  ),
                ),
                child: Center(
                  child: Text(
                    "Admin List",
                    style: TextStyle(
                      fontSize: 28,
                      color: cherry,
                      shadows: [
                        //outline
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
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => logout(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cherry,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadowColor: Colors.grey.withOpacity(0.9),
                  ),
                  child: Center(
                    child: const Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
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
