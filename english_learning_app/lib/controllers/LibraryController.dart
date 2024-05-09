import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_learning_app/models/Library.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LibraryController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  //Add Library same create new Account
  Future<void> addLibrary(Library data) async {
    final library = <String, dynamic> {
      "userEmailOwner" : data.userEmailOwner,
      "createAt" : data.createAt,
      "lstTopics" : data.lstTopics
    };

    await db.collection("Libraries").add(library).then((DocumentReference doc) =>
    print('Libraries added with ID: ${doc.id}'));
  }

  //Read Library By Email
  

  //Update Library
  Future<void> updateLibrary(Library data) async {

  }


}