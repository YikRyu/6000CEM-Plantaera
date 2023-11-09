import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AdminGeneralGuideVM {
  //assign collection
  CollectionReference generals = FirebaseFirestore.instance.collection('generals');
  String guideId = '';

  //add new general guide
  Future<String> addGuideToDB(String title, String content, XFile generalBanner) async {
    final generalBannerImageName = generalBanner.path.split("/").last;
    await generals.add({
      'title': title,
      'titleLowerCase': title.toLowerCase(),
      'content': content,
      'banner': generalBannerImageName,
      'favorite': [],
    }).then((value) {
      guideId = value.id;
      generals.doc(value.id).update({"id": value.id});
    }).catchError((error) {
      return "Failed to add new plant: $error";
    });

    //upload banner to storage
    await uploadGeneralBanner(generalBanner, guideId);

    return "ok";
  }

  //add banner into storage
  Future uploadGeneralBanner(XFile generalBanner, String guideId) async {
    final generalBannerImageName = generalBanner.path.split("/").last;
    try {
      final ref = FirebaseStorage.instance.ref().child('generalGuide').child(guideId).child('articleBanner').child(generalBannerImageName);
      await ref.putFile(File(generalBanner.path));
    } catch (e) {
      print('Error occurred when uploading banner to database: ${e.toString()}');
    }
  }

  //get all guides
  Stream fetchAllGeneralGuides() {
    Stream<QuerySnapshot> querySnapshot = generals.orderBy('title', descending: false).snapshots();
    return querySnapshot;
  }

  //fetch plant details
  Future fetchGuideDetails(String currentGuideId) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection("generals").doc(currentGuideId).get();
      if (documentSnapshot.exists) {
        return documentSnapshot.data();
      }
    } catch (e) {
      throw Exception('Error occurred while fetching guide details: ${e.toString()}');
    }
  }

  //fetch guide banner
  Future<String> fetchGuideBanner(String guideId, String banner) async {
    String bannerURL = '';
    try {
      final ref = FirebaseStorage.instance.ref().child('generalGuide').child(guideId).child('articleBanner').child(banner);
      bannerURL = await ref.getDownloadURL();
    } catch (e) {
      print('Error occurred when fetching cover from database: ${e.toString()}');
    }
    return bannerURL;
  }

  //delete guide banner
  Future deleteGuideBanner(String imageURL) async {
    try {
      await FirebaseStorage.instance.refFromURL(imageURL).delete();
    } catch (e) {
      print('Error occurred when deleting image from storage: ${e.toString()}');
    }
  }


  //delete guide article
  Future<String> deleteGeneralGuide (String currentGuideId, String bannerURL) async{
    await generals.doc(currentGuideId).delete(); //remove document from cloud firestore
    await deleteGuideBanner(bannerURL); //remove banner

    return 'ok';
  }

  //edit guide article
  Future<String> editGeneralGuide(
      String guideId,
      String title,
      String content,
      XFile? guideBanner,
      String bannerURL) async {
    if (guideBanner == null) {
      //update the details without updating plant cover image name if cover is not changed
      await generals.doc(guideId).update({
        'title': title,
        'titleLowerCase': title.toLowerCase(),
        'content': content,
      }).catchError((error) {
        return "Failed to update guide: ${error.toString()}";
      });
    } else {
      //get image name from path
      final guideBannerImageName = guideBanner.path.split("/").last;
      //update details while also updating plant cover image name
      await generals.doc(guideId).update({
        'title': title,
        'titleLowerCase': title.toLowerCase(),
        'content': content,
        'banner': guideBannerImageName,
      }).catchError((error) {
        return "Failed to update guide: ${error.toString()}";
      });

      //upload new banner
      await uploadGeneralBanner(guideBanner, guideId);
      //remove older banner
      await deleteGuideBanner(bannerURL);
    }

    return 'ok';
  }
}
