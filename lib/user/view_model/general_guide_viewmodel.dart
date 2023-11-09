//array update and remove ref: https://firebase.google.com/docs/firestore/manage-data/add-data#dart_12
//array query ref: https://firebase.blog/posts/2018/08/better-arrays-in-cloud-firestore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:rxdart/rxdart.dart';

class UserGeneralsVM{
  //firestore collection path reference
  CollectionReference generals = FirebaseFirestore.instance.collection('generals');

  //fetch all existing general guides
  Stream fetchAllGeneralGuides() {
    Stream<QuerySnapshot> querySnapshot = generals.orderBy('title', descending: false).snapshots();
    return querySnapshot;
  }

  //fetch general guides details
  Future fetchGeneralGuideDetails(String currentGeneralGuideId) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection("generals").doc(currentGeneralGuideId).get();
      if (documentSnapshot.exists) {
        return documentSnapshot.data();
      }
    } catch (e) {
      throw Exception('Error occurred while fetching guide details: ${e.toString()}');
    }
  }

  //fetch guide banner
  Future<String> fetchGuideBanner(String guideId, String cover) async {
    String coverURL = '';
    try {
      final ref = FirebaseStorage.instance.ref().child('generalGuide').child(guideId).child('articleBanner').child(cover);
      coverURL = await ref.getDownloadURL();
    } catch (e) {
      print('Error occurred when fetching banner from database: ${e.toString()}');
    }
    return coverURL;
  }


  //add user into fav list
  Future addFavorite (String guideId, String userId) async{
    await generals.doc(guideId).update({
      'favorite' : FieldValue.arrayUnion([userId]),
    })
        .catchError((error) {print("Failed to add new user into fav: $error") ;});
  }

  //remove user from fav list
  Future removeFavorite (String guideId, String userId) async{
    await generals.doc(guideId).update({
      'favorite' : FieldValue.arrayRemove([userId]),
    })
        .catchError((error) {print("Failed to remove new user from fav: $error") ;});
  }

  //fetch favorited guides
  Stream fetchFavoriteGuides (String userId){
    Stream<QuerySnapshot> querySnapshot = generals.where('favorite', arrayContains: userId).snapshots();
    return querySnapshot;
  }
}