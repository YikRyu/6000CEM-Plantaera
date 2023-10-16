import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plantaera/user/model/user_model.dart';
import 'package:flutter/material.dart';

/*class RegisterVM {

  Future register(BuildContext context, String username, String email, String birthdate, String gender, String password) async {
    String createUsername = username;
    String createEmail = email;
    String createBirthdate = birthdate;
    String createGender = gender;
    try {
      final credential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      createNewUser(createUsername, createEmail, createGender, createBirthdate); //create user document in db
      createRatingInfo(createUsername); //create user rating document info
      createInitialRating(); //insert first rating as collection cannot be empty
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
  Future createNewUser(String createUsername, String createEmail, createGender,
      String createBirthdate) async {
    final docPost = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    Users postJson = Users(
      id: FirebaseAuth.instance.currentUser!.uid,
      email: createEmail,
      username: createUsername,
      gender: createGender,
      birthdate: createBirthdate,
      rating: '0.0',
    );

    await docPost.set(postJson.toJson());
  }

  //create initial rating info
  Future createRatingInfo(String createUsername) async {
    final docPost = FirebaseFirestore.instance
        .collection('ratings')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    RatingRegis postJson = RatingRegis(
      id: FirebaseAuth.instance.currentUser!.uid,
      username: createUsername,
      accumulateRating: '0.0',
      totalRater: 0,
    );

    await docPost.set(postJson.toJson());
  }

  //create initial rating document for the user as well in ratings collection (as firestore cannot create empty collection...)
  Future createInitialRating() async {
    String ratingCollection = 'ratings/' + FirebaseAuth.instance.currentUser!.uid + '/all_ratings';
    final docPost = FirebaseFirestore.instance
        .collection(ratingCollection.replaceAll(' ', ''))
        .doc(FirebaseAuth.instance.currentUser!.uid);
    Rating postJson = Rating(
        id: FirebaseAuth.instance.currentUser!.uid,
        ratedBy: "none",
        rating: "0.0"
    );

    await docPost.set(postJson.toJson());
  }
}*/


