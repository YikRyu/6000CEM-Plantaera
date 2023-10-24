//change password reference: https://www.youtube.com/watch?v=EqI6IukN29g

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../general/model/user_model.dart';

class ProfileVM {
  //fetch user info
  Future getProfile(String userID) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection("users").doc(userID).get();
      if (documentSnapshot.exists) {
        return documentSnapshot.data();  }
    } catch (e) {
      throw Exception('Error occurred while fetching user information: $e');
    }
  }

  //update new username
  Future<String> changeUsername(String newUsername, String currentUserId) async{
    try {
      await FirebaseFirestore.instance.collection('users').doc(currentUserId)
          .update({
        'username' : newUsername
      });
      return "ok";
    } catch(error){
      return "Failed update username: ${error.toString()}";
    }
  }

  //update password
 Future <String> changeUserPassword(String email, String oldPassword, String newPassword) async{
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