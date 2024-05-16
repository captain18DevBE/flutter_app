import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_learning_app/models/Cards.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CardsController {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final _storageRef = FirebaseStorage.instance.ref();
  final CollectionReference _cardsRef = FirebaseFirestore.instance.collection("Cards");

  //Add new Card
  Future<void> addCard(Cards card) async {
    Map<String, dynamic> data = {
      "id" : card.id,
      "topic_id" : card.topicId,
      "create_by" : card.createByUserEmail,
      "create_at" : card.createAt,
      "term" : card.term,
      "mean" : card.mean,
      "urlPhoto" : card.urlPhoto
    };
    return _cardsRef.doc(card.id.toString())
      .set(data)
      
      .then((value) => print("Card added"))
      .catchError((error) => print("Failed to add card: $error"));
  }

  //Update card by id
  Future<void> updateCardById(int cardId, String term, String mean, String urlPhoto) async {
    return _cardsRef
      .doc(cardId.toString())
      .update({
        'term' : term,
        'mean' : mean,
        'urlPhoto' : urlPhoto
      })
      .then((value) => print("Card updated"))
      .catchError((error) => print("Failed to update card: $error"));
  }


  //Delete Card by Topic Id
  Future<void> deleteCard(int cardId) async {

    return _cardsRef
      .doc(cardId.toString())
      .delete()
      .then((value) => print("Card deleted"))
      .catchError((error) => print("Failed to delete card: $error"));
  }

  //Read Card by Id
  Future<DocumentSnapshot<Object?>> readCardById(int cardId) async {
    try {
      final docSnapshot = await _cardsRef.doc(cardId.toString()).get();
      return Future.value(docSnapshot);
      // return docSnapshot;
    } on FirebaseException catch (error) {
      print('Failed to read card: $error');
      return Future.error(error);
    }
  }

  //Read Card By email

}