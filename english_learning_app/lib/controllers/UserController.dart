import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_learning_app/models/Users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';


class UserController {

  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final _storageRef = FirebaseStorage.instance.ref();

  Future<void> addUser(Users data) async {
    final user = <String, dynamic> {
      "email" : data.email,
      "userName" : data.userName,
      "phoneNumber" : data.phoneNumber,
      "isTeacher" : data.isTeacher,
      "createAt" : data.createAt
    };

    db.collection("Users").add(user).then((value) => print("Added Data with ID: ${value.id}"));
  }

  Future<String> upUserAvatar(String fileName, String filePath) async {
    File file = File(filePath);

    Reference referenceAvatar = _storageRef.child("avatar_user");
    Reference referenceToUpLoad = referenceAvatar.child(fileName); 

    String urlDownLoad = "";
    try {
      await referenceToUpLoad.putFile(file);
      
      urlDownLoad =  await referenceToUpLoad.getDownloadURL();
      User? user = _auth.currentUser;
      user?.updatePhotoURL(urlDownLoad);
    } on FirebaseException catch(e) {
      print("Have an problem upload file image user'avatar");
    } 

    return urlDownLoad;
  }
}