import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_learning_app/models/Topic.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TopicController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;


  //Add Topic
  Future<void> addTopic(Topic data) async {
    final topic = <String, dynamic> {
      "createByUserEmail" : data.createByUserEmail,
      "createAt" : data.createAt,
      "topicName" : data.topicName,
      "lstCard" : data.lstCard,
      "description" : data.description
    };

    await db.collection("Topics").add(topic).then(
      (value) => print('Topics added with ID: ${value.id}')
    );
  }

  //Read Topic
  Future<Topic?> readTopic(String email, String topicName) async {
    Topic? result;

    await db.collection("Topics").get().then((value) => null);

  }

}