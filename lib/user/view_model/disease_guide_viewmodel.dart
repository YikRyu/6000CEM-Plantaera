//array update and remove ref: https://firebase.google.com/docs/firestore/manage-data/add-data#dart_12
//array query ref: https://firebase.blog/posts/2018/08/better-arrays-in-cloud-firestore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:rxdart/rxdart.dart';

class UserDiseaseVM{
  //firestore collection path reference
  CollectionReference diseases = FirebaseFirestore.instance.collection('diseases');

  //fetch all existing diseases
  Stream fetchAllDiseases() {
    Stream<QuerySnapshot> querySnapshot = diseases.orderBy('name', descending: false).snapshots();
    return querySnapshot;
  }

  //fetch disease details
  Future fetchDiseaseDetails(String currentDiseaseId) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection("diseases").doc(currentDiseaseId).get();
      if (documentSnapshot.exists) {
        return documentSnapshot.data();
      }
    } catch (e) {
      throw Exception('Error occurred while fetching disease details: ${e.toString()}');
    }
  }

  //fetch disease cover
  Future<String> fetchDiseaseCover(String diseaseId, String cover) async {
    String coverURL = '';
    try {
      final ref = FirebaseStorage.instance.ref().child('diseaseGuide').child(diseaseId).child('diseaseCover').child(cover);
      coverURL = await ref.getDownloadURL();
    } catch (e) {
      print('Error occurred when fetching cover from database: ${e.toString()}');
    }
    return coverURL;
  }

  //fetch disease gallery
  Future<List<String>> fetchDiseaseGallery(String diseaseId) async {
    List<String> galleryImageURL = [];
    try {
      firebase_storage.ListResult result =
      await firebase_storage.FirebaseStorage.instance.ref().child('diseaseGuide').child(diseaseId).child('diseaseGallery').listAll();

      for (firebase_storage.Reference ref in result.items) {
        String url = await firebase_storage.FirebaseStorage.instance.ref(ref.fullPath).getDownloadURL();
        galleryImageURL.add(url);
      }
    } catch (e) {
      print('Error occurred when fetching cover from database: ${e.toString()}');
    }
    return galleryImageURL;
  }

  //fetch search result
  Stream fetchSearchResult(String searchKeyword) {
    Stream<QuerySnapshot> querySnapshot = diseases
        .where('nameLowerCase', isGreaterThanOrEqualTo: searchKeyword.toLowerCase())
        .where('nameLowerCase', isLessThan: searchKeyword.toLowerCase() + 'z')
        .snapshots();
    return querySnapshot;
  }

  //add user into fav list
  Future addFavorite (String diseaseId, String userId) async{
    await diseases.doc(diseaseId).update({
      'favorite' : FieldValue.arrayUnion([userId]),
    })
        .catchError((error) {print("Failed to add new user into fav: $error") ;});
  }

  //remove user from fav list
  Future removeFavorite (String diseaseId, String userId) async{
    await diseases.doc(diseaseId).update({
      'favorite' : FieldValue.arrayRemove([userId]),
    })
        .catchError((error) {print("Failed to remove new user from fav: $error") ;});
  }

  //fetch favorited diseases
  Stream fetchFavoriteDiseases (String userId){
    Stream<QuerySnapshot> querySnapshot = diseases.where('favorite', arrayContains: userId).snapshots();
    return querySnapshot;
  }
}