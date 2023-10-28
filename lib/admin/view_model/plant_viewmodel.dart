import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PlantVM {
  CollectionReference plants = FirebaseFirestore.instance.collection('plants');

  //add new plant
  Future<String> addPlantToDB(String name, String nameLowerCase, String scientificName, String scientificLowerCase, String description, String plantType, String lifespan,
      String bloomTime, String habitat, String difficulty, String sunlight, String soil, String water, String fertilize, String plantingTime, String harvestTime, String disease) async{
    await plants.add({
      'name': name,
      'nameLowerCase' : nameLowerCase,
      'scientificName' : scientificName,
      'scientificLowerCase' : scientificLowerCase,
      'description' : description,
      'plantType' : plantType,
      'lifespan' : lifespan,
      'bloomTime' : bloomTime,
      'habitat' : habitat,
      'difficulty' : difficulty,
      'sunlight' : sunlight,
      'soil' : soil,
      'water' : water,
      'fertilize' : fertilize,
      'platingTime' : plantingTime,
      'harvestTime' : harvestTime,
      'disease' : disease,
      'favorite' : [],
    })
        .then((value) => {
      plants.doc(value.id).update({
        "id": value.id
      })
    })
        .catchError((error) {return "Failed to add new plant: $error";});

    return "ok";

  }

  //add plant cover to storage
  Future uploadPlantCover(File plantCover, String nameLowerCase) async {
    final PlantCover = basename(plantCover.path);
    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref().child(nameLowerCase).child('plantCover').child(PlantCover);
      await ref.putFile(plantCover);
    } catch (e) {
      print('Error occurred when uploading cover to database: ${e.toString()}');
    }
  }

  //add plant gallery to storage
  Future uploadPlantGallery(File plantGallery, String nameLowerCase) async {
    final BookCondition = basename(plantGallery.path);
    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref().child(nameLowerCase).child('PlantGallery').child(BookCondition);
      await ref.putFile(plantGallery);
    } catch (e) {
      print('Error occurred when uploading gallery to database: ${e.toString()}');
    }
  }
}