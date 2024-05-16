

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_learning_app/models/PersonalStarCards.dart';

class PersonalStarCardsController {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final CollectionReference _personalStarCardRef = FirebaseFirestore.instance.collection("Personal_Star_Cards");

  // Add Personal Star Card Same create new Account
  Future<void> addPersonalStarCards(PersonalStarCards data) async {

    Map<String, dynamic> starCards = {
      "id" : data.id,
      "create_by" : data.createBy,
      'cards' : data.lstStarCards
    };

    return _personalStarCardRef.doc(data.id.toString())
      .set(starCards)
      .then((value) {
        print("Personal Star'Card added");
        return Future.value();
      })
      .catchError((error) {
        print("Failed to add personal star cards");
        return Future.error(error);
      });
  }

  // Update Personal Star Card
  Future<void> updatePersonalStarCards(PersonalStarCards data) async {
    return _personalStarCardRef
      .doc(data.id.toString())
      .update({
        'cards' : data.lstStarCards
      })
      .then((value) {
        print("ersonal Star'Card updated");
        return Future.value();
      })
      .catchError((error) {
        print("Failed to update personal star cards");
        return Future.error(error);
      });
  }

  // Add Field to Map<StarCard>

  // Read Personal Star Card by email User
  Future<QuerySnapshot<Object?>> readPersonalStarCardByEmail(String email) async {

    try {
      final querySnapshot = await _personalStarCardRef
        .where('create_by', isEqualTo: email)
        .get();

      return Future.value(querySnapshot);
    } on FirebaseException catch (error) {
      print('Error reading personal star card: $error');
      return Future.error(error);
    }
  }

}