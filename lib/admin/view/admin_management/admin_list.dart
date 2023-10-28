import 'package:flutter/material.dart';
import 'package:plantaera/admin/view/admin_management/change_password_admin.dart';
import 'package:plantaera/admin/view/admin_management/new_admin.dart';
import 'package:plantaera/admin/view_model/admin_viewmodel.dart';
import 'package:plantaera/res/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../general/view/login.dart';

class AdminList extends StatefulWidget {
  AdminList({Key? key}) : super(key: key);

  @override
  State<AdminList> createState() => _AdminListState();
}

class _AdminListState extends State<AdminList> {
  final _auth = FirebaseAuth.instance;
  String currentAdminId =
      FirebaseAuth.instance.currentUser!.uid; //fetch current admin id
  String? currentAdminEmail =
      FirebaseAuth.instance.currentUser!.email; //fetch current admin email

  AdminVM adminVM = AdminVM();

  //logging out
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
                    "Admin Account Management",
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

              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      pink,
                      pastelPink,
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    "Current Admin Account Management",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ), //current admin section banner
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) {
                              return ChangeAdminPassword();
                            },
                            settings: RouteSettings(arguments: {
                              'email': currentAdminEmail!,
                            })));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cherry,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadowColor: Colors.grey.withOpacity(0.9),
                  ),
                  child: Center(
                    child: const Text(
                      "Change Password",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
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
              SizedBox(
                height: 30,
              ), //spacing

              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      pink,
                      pastelPink,
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    "Admin List Management",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ), //other admin section banner
              StreamBuilder(
                  //get book info with the user id logging in now
                  stream: adminVM.fetchAllAdmin(currentAdminId),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                          child: CircularProgressIndicator(
                        color: pink,
                      ));
                    }
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> adminModel =
                              snapshot.data?.docs[index].data();
                          String email = adminModel['email'];

                          //show cards of admins
                          return Center(
                            child: Container(
                              width: 320,
                              height: 80,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 200,
                                        child: Text(
                                          adminModel['email'],
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: (){
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                        return ChangeAdminPassword();
                                                      },
                                                      settings: RouteSettings(arguments: {
                                                        'email': email,
                                                      })));
                                            },
                                            child: Icon(Icons.edit, size: 30, color: deepPink,),
                                          ),
                                          SizedBox(width: 10.0,),
                                          InkWell(
                                            onTap: (){},
                                            child: Icon(Icons.delete, size: 30, color: deepPink,),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: "newAdmin",
          onPressed: () {
            Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NewAdmin()))
                .then((_) => setState(() {}));
          },
          foregroundColor: cherry,
          backgroundColor: cherry,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 45,
          ),
        ),
      ),
    );
  }
}
