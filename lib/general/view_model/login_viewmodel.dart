import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class LoginVM{
  Future login(BuildContext context,String email, String password) async{
    try{
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "ok";
    }on FirebaseAuthException catch(e){
      print(e);
      if(e.code == 'user-not-found'){
        return "User not found, check your email or register an account...";
      }
      else if(e.code == 'wrong-password'){
        return "Incorrect password...";
      }
      else{
        return "Unknown error occurred...";
      }
    }
  }

  getCurrentUserId() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future getUserInformation(String userId) async {
    QuerySnapshot querySnapshot= await FirebaseFirestore.instance.collection("users").where("id", isEqualTo: userId).get();
    return querySnapshot.docs[0].data();
  }
}




