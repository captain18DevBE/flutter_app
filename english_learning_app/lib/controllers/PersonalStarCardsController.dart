

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_learning_app/models/PersonalStarCards.dart';

class PersonalStarCardsController {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final CollectionReference _personalStarCardRef = FirebaseFirestore.instance.collection("Personal_Star_Cards");

  Future<int> amountPersonalStarCard() async {
    final QuerySnapshot result = await _personalStarCardRef.get();
    final List<DocumentSnapshot> documents = result.docs;

    return documents.length;
  }

  // Add Personal Star Card Same create new Account
  Future<void> addPersonalStarCards(PersonalStarCards data) async {
    int starCardId = await amountPersonalStarCard() + 1;
    Map<String, dynamic> starCards = {
      "id" : starCardId,
      "create_by" : data.createBy,
      'cards' : data.lstStarCards
    };

    return _personalStarCardRef.doc(starCardId.toString())
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
Future<PersonalStarCards> readPersonalStarCardByEmail(String email) async {
  try {
    final querySnapshot = await _personalStarCardRef
      .where('create_by', isEqualTo: email)
      .get();

    // Check if there are any documents
    if (querySnapshot.docs.isNotEmpty) {
      final docSnapshot = querySnapshot.docs.first;

      // Convert the document data to PersonalStarCards
      final mapData = docSnapshot.data() as Map<String, dynamic>;
    
      return PersonalStarCards(
        id: mapData['id'], 
        createBy: mapData['create_by'], 
        //lstStarCards: mapData['cards']
        );
    } else {
      return PersonalStarCards(id: 0, createBy: email,); // Return empty object if no documents found
    }
  } on FirebaseException catch (error) {
    print('Error reading personal star card: $error');
    return Future.error(error);
  }
}
  // Delete Card
}