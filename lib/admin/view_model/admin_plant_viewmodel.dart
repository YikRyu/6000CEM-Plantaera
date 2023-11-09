//multi image upload ref: https://www.youtube.com/watch?v=S5qitqOTZu8
//multi image fetching ref: https://stackoverflow.com/questions/62817715/flutter-how-to-list-all-images-from-firebase-storage
//stream doc merging ref: https://pub.dev/documentation/rxdart/latest/rx/MergeStream-class.html
//delete image from firebase storage with URL: https://stackoverflow.com/questions/54170250/how-to-delete-a-firebase-storage-file-with-flutter

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class AdminPlantVM {
  //firestore collection path reference
  CollectionReference plants = FirebaseFirestore.instance.collection('plants');

  //add new plant
  Future<String> addPlantToDB(
      String name,
      String nameLowerCase,
      String scientificName,
      String scientificLowerCase,
      String description,
      String plantType,
      String lifespan,
      String bloomTime,
      String habitat,
      String difficulty,
      String sunlight,
      String soil,
      String water,
      String fertilize,
      String plantingTime,
      String harvestTime,
      String disease,
      XFile plantCover,
      List<XFile> plantGallery) async {
    //get image name from path
    final plantCoverImageName = plantCover.path.split("/").last;

    String plantId = '';

    await plants.add({
      'name': name,
      'nameLowerCase': nameLowerCase,
      'scientificName': scientificName,
      'scientificLowerCase': scientificLowerCase,
      'description': description,
      'plantType': plantType,
      'lifespan': lifespan,
      'bloomTime': bloomTime,
      'habitat': habitat,
      'difficulty': difficulty,
      'sunlight': sunlight,
      'soil': soil,
      'water': water,
      'fertilize': fertilize,
      'plantingTime': plantingTime,
      'harvestTime': harvestTime,
      'disease': disease,
      'cover': plantCoverImageName,
      'favorite': [],
    }).then((value) {
      plantId = value.id;
      plants.doc(value.id).update({"id": value.id});
    }).catchError((error) {
      return "Failed to add new plant: $error";
    });

    //call function to upload cover
    await uploadPlantCover(plantCover, plantId);
    //call function to upload gallery
    for (XFile _plantGalleryList in plantGallery) {
      await uploadPlantGallery(_plantGalleryList, plantId); //upload them one by one
    }

    return "ok";
  }

  //add plant cover to storage
  Future uploadPlantCover(XFile plantCover, String plantId) async {
    final plantCoverImageName = plantCover.path.split("/").last;
    try {
      final ref = FirebaseStorage.instance.ref().child('plantGuide').child(plantId).child('plantCover').child(plantCoverImageName);
      await ref.putFile(File(plantCover.path));
    } catch (e) {
      print('Error occurred when uploading cover to database: ${e.toString()}');
    }
  }

  //add plant gallery to storage one by one
  Future uploadPlantGallery(XFile plantGallery, String plantId) async {
    final plantGalleryImageName = plantGallery.path.split("/").last;
    try {
      final ref = FirebaseStorage.instance.ref().child('plantGuide').child(plantId).child('plantGallery').child(plantGalleryImageName);
      await ref.putFile(File(plantGallery.path));
    } catch (e) {
      print('Error occurred when uploading gallery to database: ${e.toString()}');
    }
  }

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

  //edit plant details
  Future<String> editPlantGuide(
      String plantId,
      String name,
      String nameLowerCase,
      String scientificName,
      String scientificLowerCase,
      String description,
      String plantType,
      String lifespan,
      String bloomTime,
      String habitat,
      String difficulty,
      String sunlight,
      String soil,
      String water,
      String fertilize,
      String plantingTime,
      String harvestTime,
      String disease,
      XFile? plantCover,
      List<XFile> plantGallery,
      String plantCoverURL) async {
    if (plantCover == null) {
      //update the details without updating plant cover image name if plant cover is not changed
      await plants.doc(plantId).update({
        'name': name,
        'nameLowerCase': nameLowerCase,
        'scientificName': scientificName,
        'scientificLowerCase': scientificLowerCase,
        'description': description,
        'plantType': plantType,
        'lifespan': lifespan,
        'bloomTime': bloomTime,
        'habitat': habitat,
        'difficulty': difficulty,
        'sunlight': sunlight,
        'soil': soil,
        'water': water,
        'fertilize': fertilize,
        'plantingTime': plantingTime,
        'harvestTime': harvestTime,
        'disease': disease,
      }).catchError((error) {
        return "Failed to update plant result: ${error.toString()}";
      });
    } else {
      //get image name from path
      final plantCoverImageName = plantCover.path.split("/").last;
      //update details while also updating plant cover image name
      await plants.doc(plantId).update({
        'name': name,
        'nameLowerCase': nameLowerCase,
        'scientificName': scientificName,
        'scientificLowerCase': scientificLowerCase,
        'description': description,
        'plantType': plantType,
        'lifespan': lifespan,
        'bloomTime': bloomTime,
        'habitat': habitat,
        'difficulty': difficulty,
        'sunlight': sunlight,
        'soil': soil,
        'water': water,
        'fertilize': fertilize,
        'plantingTime': plantingTime,
        'harvestTime': harvestTime,
        'disease': disease,
        'cover': plantCoverImageName,
      }).catchError((error) {
        return "Failed to update plant result: ${error.toString()}";
      });

      //upload new plant cover
      await uploadPlantCover(plantCover, plantId);
      //remove older plant cover
      await deletePlantCover(plantCoverURL);
    }

    //check if plant gallery has newly added image or not, if yes then trigger upload function
    if (plantGallery.length != 0) {
      //call function to upload gallery
      for (XFile _plantGalleryList in plantGallery) {
        await uploadPlantGallery(_plantGalleryList, plantId); //upload them one by one
      }
    }

    return 'ok';
  }

  //delete plant gallery pictures
  Future deletePlantGallery(String imageURL) async {
    try {
      await FirebaseStorage.instance.refFromURL(imageURL).delete();
    } catch (e) {
      print('Error occurred when deleting image from storage: ${e.toString()}');
    }
  }

  //delete plant cover
  Future deletePlantCover(String imageURL) async {
    try {
      await FirebaseStorage.instance.refFromURL(imageURL).delete();
    } catch (e) {
      print('Error occurred when deleting image from storage: ${e.toString()}');
    }
  }

  //delete plant guide from database
  Future<String> deletePlantGuide(String currentPlantId, String coverURL, List<String> galleryList) async {
    await plants.doc(currentPlantId).delete(); //remove document from cloud firestore
    await deletePlantGallery(coverURL); //remove cover
    //remove pictures from gallery
    for (String _galleryURL in galleryList) {
      await deletePlantGallery(_galleryURL);
    }

    return 'ok';
  }
}
