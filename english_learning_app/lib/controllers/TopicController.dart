//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_learning_app/models/Topic.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TopicController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  final CollectionReference _topicRef = FirebaseFirestore.instance.collection("Topics");

  Future<int> amountTopics() async {
    final QuerySnapshot result = await _topicRef.get();
    final List<DocumentSnapshot> documents = result.docs;

    return documents.length;
  }

  //Add Topic
  Future<void> addTopic(Topic data) async {
    int topicId = await amountTopics() + 1;
    final topic = <String, dynamic> {
      'id' : topicId,
      'title' : data.createBy,
      'description' : data.description,
      'create_by' : data.createBy,
      'create_at' : data.createAt,
      'is_public' : data.isPublic,
      'cards' : data.cards
    };

    await db.collection("Topics")
      .doc(topicId.toString())
      .set(topic)
      .then((value) => print("Topic added"))
      .catchError((error) => print("Failed to add topic: $error"));
  }

  //Update topic
  Future<void> updateTopicById(Topic data) async {
    final topic = <String, dynamic> {
      'title' : data.createBy,
      'description' : data.description,
      'create_by' : data.createBy,
      'create_at' : data.createAt,
      'is_public' : data.isPublic,
      'cards' : data.cards
    };
    return _topicRef
      .doc(data.id.toString())
      .update(topic)
      .then((value) {
        print("Topic updated");
        return Future.value();
        }) 
      .catchError((error) {
        print("Failed to update topic: $error");
        return Future.error(error);
      }); 
  }

  Future<void> updateTopic(Topic topic) async {
  Map<String, dynamic> data = {
    "id": topic.id,
    "title": topic.title,
    "description": topic.description,
    "create_by": topic.createBy,
    "create_at": topic.createAt,
    "is_public": topic.isPublic,
    "cards": topic.cards,
  };
  return _topicRef.doc(topic.id.toString())
    .update(data)
      .then((value) {
        print("Topic updated");
        return Future.value();
        }) 
      .catchError((error) {
        print("Failed to update topic: $error");
        return Future.error(error);
      }); 
}


  //Delete topic
  Future<void> deleteTopic(int topicId) async {

    return _topicRef
      .doc(topicId.toString())
      .delete()
      .then((value) {
        print("Topic deleted");
        return Future.value();
        }) 
      .catchError((error) {
        print("Failed to delete topic: $error");
        return Future.error(error);
      }); 
  }

  //Read topic by id
  Future<DocumentSnapshot<Object?>> readTopicById(int topicId) async {
    try {
      final docSnapshot = await _topicRef.doc(topicId.toString())
        .get();
        return Future.value(docSnapshot);
        //return docSnapshot;
    } on FirebaseException catch (error) {
      print('Failed to read topic: $error');
      return Future.error(error);
    }
  }

  //Read topic by email
  Future<QuerySnapshot<Object?>> readTopicByEmailUserOwner(String email) async {
    try {
      final querySnapshot = await _topicRef
        .where('create_by', isEqualTo: email)
        .get();
      return Future.value(querySnapshot);
      // return querySnapshot;
    } on FirebaseException catch (error) {
      print('Error reading topics: $error');
      return Future.error(error);
    } 
  }

}