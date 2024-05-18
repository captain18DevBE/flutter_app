import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_learning_app/models/Cards.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CardsController {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final _storageRef = FirebaseStorage.instance.ref();
  final CollectionReference _cardsRef = FirebaseFirestore.instance.collection("Cards");

  //Get id card
  Future<int> amountCards() async {
    final QuerySnapshot result = await _cardsRef.get();
    final List<DocumentSnapshot> documents = result.docs;

    return documents.length;
  }

  //Add new Card
  Future<void> addCard(Cards card) async {
    int cardId = await amountCards() + 1; 
    Map<String, dynamic> data = {
      "id" : cardId,
      "topic_id" : card.topicId,
      "create_by" : card.createByUserEmail,
      "create_at" : card.createAt,
      "term" : card.term,
      "mean" : card.mean,
      "urlPhoto" : card.urlPhoto
    };
    return _cardsRef.doc(cardId.toString())
      .set(data)
      
      .then((value) => print("Card added"))
      .catchError((error) => print("Failed to add card: $error"));
  }

  //Update card by id
  Future<void> updateCardById(Cards data) async {
    return _cardsRef
      .doc(data.id.toString())
      .update({
        'term' : data.term,
        'mean' : data.mean,
        'urlPhoto' : data.urlPhoto
      })
      .then((value) {
        print("Card updated");
        return Future.value();
      })
      .catchError((error) {
        print("Failed to update card: $error");
        return Future.error(error);
      });
  }


  //Delete Card by Topic Id
  Future<void> deleteCard(int cardId) async {

    return _cardsRef
      .doc(cardId.toString())
      .delete()
      .then((value) {
        print("Card deleted");
        return Future.value();
      })
      .catchError((error) {
        print("Failed to delete card: $error");
        return Future.error(error);
      });
  }

  //Read Card by Id
  Future<Cards> readCardById(int cardId) async {
    try {
      final docSnapshot = await _cardsRef.doc(cardId.toString()).get();
      // return Future.value(docSnapshot);
      final data = docSnapshot.data() as Map<String, dynamic>;
      return Cards(
        id: data['id'], 
        topicId: data['topic_id'], 
        term: data['term'], 
        createByUserEmail: data['create_by'], 
        mean: data['mean']);
    } on FirebaseException catch (error) {
      print('Failed to read card: $error');
      return Future.error(error);
    }
  }

  //Read Card By TopicId
  Future<List<Cards>> readCardsByTopicId(int topicId) async {
    try {
      final querySnapshot = await _cardsRef
        .where('topic_id', isEqualTo: topicId)
        .get();

      return querySnapshot.docs.map((data) {
        return Cards(
        id: data['id'], 
        topicId: data['topic_id'], 
        term: data['term'], 
        createByUserEmail: data['create_by'], 
        mean: data['mean']);
      }).toList();

    } on FirebaseException catch (error) {
      print('Failed to read card: $error');
      return Future.error(error);
    }

  }

}