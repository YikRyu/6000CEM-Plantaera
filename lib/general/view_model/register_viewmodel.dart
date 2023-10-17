import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plantaera/general/model/user_model.dart';
import 'package:flutter/material.dart';

class RegisterVM {
  Future register(BuildContext context, String username, String email,
      String password) async {
    String createUsername = username;
    String createEmail = email;
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      createNewUser(createUsername, createEmail); //create user document in db
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
  Future createNewUser(String createUsername, String createEmail) async {
    final docPost = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    Users postJson = Users(
      id: FirebaseAuth.instance.currentUser!.uid,
      email: createEmail,
      username: createUsername,
      role: 'user',
    );

    await docPost.set(postJson.toJson());
  }
}
