import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AdminDiseaseVM {
  CollectionReference diseases = FirebaseFirestore.instance.collection('diseases');

  //add new plant
  Future<String> addDiseaseToDB(String name, String nameLowerCase, String symptoms, String causes, String solutions, String preventions, XFile diseaseCover, List<XFile> diseaseGallery) async{
    //get image name from path
    final diseaseCoverImageName = diseaseCover.path.split("/").last;

    String diseaseId = '';

    await diseases.add({
      'name': name,
      'nameLowerCase': nameLowerCase,
      'symptoms' : symptoms,
      'causes' : causes,
      'solutions' : solutions,
      'preventions' : preventions,
      'cover': diseaseCoverImageName,
      'favorite': [],
    }).then((value) {
      diseaseId = value.id;
      diseases.doc(value.id).update({"id": value.id});
    }).catchError((error) {
      return "Failed to add new disease: $error";
    });

    //call function to upload cover
    await uploadDiseaseCover(diseaseCover, diseaseId);
    //call function to upload gallery
    for (XFile _diseaseGalleryList in diseaseGallery) {
      await uploadDiseaseGallery(_diseaseGalleryList, diseaseId); //upload them one by one
    }

    return "ok";

  }

  //add plant cover to storage
  Future uploadDiseaseCover(XFile diseaseCover, String diseaseId) async {
    final diseaseCoverImageName = diseaseCover.path.split("/").last;
    try {
      final ref = FirebaseStorage.instance.ref().child('diseaseGuide').child(diseaseId).child('diseaseCover').child(diseaseCoverImageName);
      await ref.putFile(File(diseaseCover.path));
    } catch (e) {
      print('Error occurred when uploading cover to database: ${e.toString()}');
    }
  }

  //add disease gallery to storage one by one
  Future uploadDiseaseGallery(XFile diseaseGallery, String diseaseId) async {
    final diseaseGalleryImageName = diseaseGallery.path.split("/").last;
    try {
      final ref = FirebaseStorage.instance.ref().child('diseaseGuide').child(diseaseId).child('diseaseGallery').child(diseaseGalleryImageName);
      await ref.putFile(File(diseaseGallery.path));
    } catch (e) {
      print('Error occurred when uploading gallery to database: ${e.toString()}');
    }
  }

  //fetch all existing diseases
  Stream fetchAllDiseases() {
    Stream<QuerySnapshot> querySnapshot = diseases.orderBy('name', descending: false).snapshots();
    return querySnapshot;
  }

  //fetch plant details
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

  //fetch plant cover
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

  //fetch plant gallery
  Future<List<String>> fetchDiseaseGallery(String currentDiseaseId) async {
    List<String> galleryImageURL = [];
    try {
      firebase_storage.ListResult result =
      await firebase_storage.FirebaseStorage.instance.ref().child('diseaseGuide').child(currentDiseaseId).child('diseaseGallery').listAll();

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

  //edit disease guide
  Future<String> editDiseaseGuide(
      String diseaseId,
      String name,
      String nameLowerCase,
      String symptoms,
      String causes,
      String solutions,
      String preventions,
      XFile? diseaseCover,
      List<XFile> diseaseGallery,
      String diseaseCoverURL) async{

    if(diseaseCover == null){
      //update the details without updating cover image name if cover is not changed
      await diseases.doc(diseaseId).update({
        'name': name,
        'nameLowerCase': nameLowerCase,
        'symptoms' : symptoms,
        'causes' : causes,
        'solutions' : solutions,
        'preventions' : preventions,
      }).catchError((error) {
        return "Failed to update disease: ${error.toString()}";
      });
    }else{
      //get image name from path
      final diseaseCoverImagePath = diseaseCover.path.split("/").last;
      //update the details while also update cover image path
      await diseases.doc(diseaseId).update({
        'name': name,
        'nameLowerCase': nameLowerCase,
        'symptoms' : symptoms,
        'causes' : causes,
        'solutions' : solutions,
        'preventions' : preventions,
        'cover': diseaseCoverImagePath,
      }).catchError((error) {
        return "Failed to update disease: ${error.toString()}";
      });


      //upload new cover
      await uploadDiseaseCover(diseaseCover, diseaseId);
      //remove older cover
      await deleteDiseaseCover(diseaseCoverURL);
    }

    //check if disease gallery has newly added image or not, if yes then trigger upload function
    if (diseaseGallery.length != 0) {
      //call function to upload gallery
      for (XFile _diseaseGalleryList in diseaseGallery) {
        await uploadDiseaseGallery(_diseaseGalleryList, diseaseId); //upload them one by one
      }
    }

    return 'ok';
}

  //delete plant gallery pictures
  Future deleteDiseaseGallery(String imageURL) async {
    try {
      await FirebaseStorage.instance.refFromURL(imageURL).delete();
    } catch (e) {
      print('Error occurred when deleting image from storage: ${e.toString()}');
    }
  }

  //delete plant cover
  Future deleteDiseaseCover(String imageURL) async {
    try {
      await FirebaseStorage.instance.refFromURL(imageURL).delete();
    } catch (e) {
      print('Error occurred when deleting image from storage: ${e.toString()}');
    }
  }

  //delete plant guide from database
  Future<String> deleteDiseaseGuide(String currentDiseaseId, String coverURL, List<String> galleryList) async {
    await diseases.doc(currentDiseaseId).delete(); //remove document from cloud firestore
    await deleteDiseaseCover(coverURL); //remove cover
    //remove pictures from gallery
    for (String _galleryURL in galleryList) {
      await deleteDiseaseGallery(_galleryURL);
    }

    return 'ok';
  }

}