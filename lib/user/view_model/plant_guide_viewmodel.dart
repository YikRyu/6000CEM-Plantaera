//array update and remove ref: https://firebase.google.com/docs/firestore/manage-data/add-data#dart_12
//array query ref: https://firebase.blog/posts/2018/08/better-arrays-in-cloud-firestore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:rxdart/rxdart.dart';

class UserPlantVM{
  //firestore collection path reference
  CollectionReference plants = FirebaseFirestore.instance.collection('plants');

  //fetch all existing plants
  Stream fetchAllPlants() {
    Stream<QuerySnapshot> querySnapshot = plants.orderBy('name', descending: false).snapshots();
    return querySnapshot;
  }

  //fetch plant details
  Future fetchPlantDetails(String currentPlantId) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection("plants").doc(currentPlantId).get();
      if (documentSnapshot.exists) {
        return documentSnapshot.data();
      }
    } catch (e) {
      throw Exception('Error occurred while fetching plant details: ${e.toString()}');
    }
  }

  //fetch plant cover
  Future<String> fetchPlantCover(String plantId, String cover) async {
    String coverURL = '';
    try {
      final ref = FirebaseStorage.instance.ref().child('plantGuide').child(plantId).child('plantCover').child(cover);
      coverURL = await ref.getDownloadURL();
    } catch (e) {
      print('Error occurred when fetching cover from database: ${e.toString()}');
    }
    return coverURL;
  }

  //fetch plant gallery
  Future<List<String>> fetchPlantGallery(String plantId) async {
    List<String> galleryImageURL = [];
    try {
      firebase_storage.ListResult result =
      await firebase_storage.FirebaseStorage.instance.ref().child('plantGuide').child(plantId).child('plantGallery').listAll();

      for (firebase_storage.Reference ref in result.items) {
        String url = await firebase_storage.FirebaseStorage.instance.ref(ref.fullPath).getDownloadURL();
        galleryImageURL.add(url);
      }
    } catch (e) {
      print('Error occurred when fetching cover from database: ${e.toString()}');
    }
    return galleryImageURL;
  }

  //return full search documents
  Stream returnSearchResult(String searchKeyword) {
    Stream nameQuerySnapshot = fetchNameSearchResult(searchKeyword);
    Stream scientificQuerySnapshot = fetchScientificSearchResult(searchKeyword);

    //merging 2 stream results with rxdart package
    return MergeStream([nameQuerySnapshot, scientificQuerySnapshot]);
  }

  //fetch search result (for name)
  Stream fetchNameSearchResult(String searchKeyword) {
    Stream<QuerySnapshot> querySnapshot = plants
        .where('nameLowerCase', isGreaterThanOrEqualTo: searchKeyword.toLowerCase())
        .where('nameLowerCase', isLessThan: searchKeyword.toLowerCase() + 'z')
        .snapshots();
    return querySnapshot;
  }

  //fetch search result (for name)
  Stream fetchScientificSearchResult(String searchKeyword) {
    Stream<QuerySnapshot> querySnapshot = plants
        .where('scientificLowerCase', isGreaterThanOrEqualTo: searchKeyword.toLowerCase())
        .where('scientificLowerCase', isLessThan: searchKeyword.toLowerCase() + 'z')
        .snapshots();
    return querySnapshot;
  }

  //add user into fav list
  Future addFavorite (String plantId, String userId) async{
    await plants.doc(plantId).update({
      'favorite' : FieldValue.arrayUnion([userId]),
    })
        .catchError((error) {print("Failed to add new user into fav: $error") ;});
  }

  //remove user from fav list
  Future removeFavorite (String plantId, String userId) async{
    await plants.doc(plantId).update({
      'favorite' : FieldValue.arrayRemove([userId]),
    })
        .catchError((error) {print("Failed to remove new user from fav: $error") ;});
  }

  //fetch favorited plants
  Stream fetchFavoritePlants (String userId){
    Stream<QuerySnapshot> querySnapshot = plants.where('favorite', arrayContains: userId).snapshots();
    return querySnapshot;
  }
}