import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:plantaera/general/model/user_model.dart';
import 'package:flutter/material.dart';

class AdminVM {
  Future newAdmin(BuildContext context, String username, String email,
      String password) async {
    String createUsername = username;
    String createEmail = email;
    try {
      final credential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      createNewAdmin(createUsername, createEmail); //create user document in db
      return "ok";
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == 'weak-password') {
        return "Password too weak! Please change your password!";
      } else if (e.code == 'email-already-in-use') {
        return "Email already registered, please login or register with another email!";
      } else {
        return "Unknown error occurred...";
      }
    }
  }

  //function to create new user in firestore db
  Future createNewAdmin(String createUsername, String createEmail) async {
    final docPost = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    Users postJson = Users(
      id: FirebaseAuth.instance.currentUser!.uid,
      email: createEmail,
      username: createUsername,
      role: 'admin',
    );

    await docPost.set(postJson.toJson());
  }

  Future getAdminProfile(String userID) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection("users").doc(userID).get();
      if (documentSnapshot.exists) {
        return documentSnapshot.data();  }
    } catch (e) {
      throw Exception('Error occurred while fetching admin information: $e');
    }
  }

  //get all admins
  Stream fetchAllAdmin(String currentAdminId){
    Stream<QuerySnapshot> querySnapshot = FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'admin').orderBy('email', descending: false).snapshots();
    return querySnapshot;
  }

  //update password
  Future <String> changeAdminPassword(String email, String oldPassword, String newPassword) async{
    var user = await FirebaseAuth.instance.currentUser!;
    var credentials = EmailAuthProvider.credential(email: email, password: oldPassword);
    bool flag = false;
    String errorMessage = '';

    await user.reauthenticateWithCredential(credentials).then((value) {
      user.updatePassword(newPassword);
      flag = true;
    }).catchError((error){
      flag = false;
      errorMessage = error.toString();
    });

    if (flag == true){
      return "ok";
    }
    else{
      return "Failed to update password: $errorMessage";
    }
  }
}
