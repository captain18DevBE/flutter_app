
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_learning_app/models/StatusLearning.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StatusLearningController {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final CollectionReference _statusLearningRef = FirebaseFirestore.instance.collection("Status_Learning"); 


  Future<int> amountStatusLearning() async {
    final QuerySnapshot result = await _statusLearningRef.get();
    final List<DocumentSnapshot> documents = result.docs;

    return documents.length;
  }

  Future<bool> checkExist(String email, int topicId) async {
    final QuerySnapshot result = await _statusLearningRef
      .where('create_by', isEqualTo: email)
      .where('topic_id', isEqualTo: topicId)
      .get();
    final List<DocumentSnapshot> documents = result.docs;
    return (documents.length>0);
  }

  Future<void> addStatusLearning(StatusLearning data) async {
    int statusLearningId = await amountStatusLearning() + 1 ;
    final statusLearning = <String, dynamic> {
      'id' : statusLearningId,
      'topic_id' : data.topicId,
      'create_by' : data.createBy,
      'create_at' : data.createAt,
      'cards_yet_to_be_memorized' : data.cardMomorized,
      'learned' : data.learned,
      'memorized' : data.memorized
    };

    await _statusLearningRef.doc(statusLearningId.toString())
      .set(statusLearning)
      .then((value) {
        print("Status learning Added");
        return Future.value();
      })
      .catchError((error) {
        print("Failed to add status learning: $error");
        return Future.error(error);
      });
  }

  Future<void> updateStatusLearning(StatusLearning data) async {
    final statusLearning = <String, dynamic> {
      'cards_yet_to_be_memorized' : data.cardMomorized,
      'memorized' : data.memorized
    };

    await _statusLearningRef
      .doc(data.id.toString())
      .update(statusLearning)
      .then((value) {
        print("Status learning updated");
        return Future.value();
      })
      .catchError((error) {
        print("Failed to update status learning: $error");
        return Future.error(error);
      });
  }

  Future<StatusLearning> readStatusLearningById(int statusId) async {
    try {
      final docSnapshot = await _statusLearningRef.doc(statusId.toString()).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;

        return StatusLearning(
              id: data['id'], 
              topicId: data['topic_id'], 
              createBy: data['create_by'], 
              cardMomorized: List<int>.from(data['cards_yet_to_be_memorized']),
              learned: List.from(data['learned']), 
              memorized: List.from(data['memorized'])
              );
      } 
      else {
        throw Exception('Topic not found');
      }

    } on FirebaseException catch (error) {
      print('Failed to fetch topic: $error');
      throw Exception('Failed to fetch topic');
    }
  } 

  Future<List<StatusLearning>> readStatusLearningByEmailAndTopicId(String email, int topicId) async {
    try {
      final querySnapshot = await _statusLearningRef
        .where('create_by', isEqualTo: email)
        .where('topic_id', isEqualTo: topicId)
        .get();

        return querySnapshot.docs.map( (doc) {
            final data = doc.data() as Map<String, dynamic>;
            return StatusLearning(
              id: data['id'], 
              topicId: data['topic_id'], 
              createBy: data['create_by'], 
              cardMomorized: List<int>.from(data['cards_yet_to_be_memorized']),
              learned: List.from(data['learned']), 
              memorized: List.from(data['memorized'])
              );
          }
        ).toList();
    } on FirebaseException catch (error) {
      print('Error status learning topics: $error');
      return Future.error(error);
    }
  }

  Future<void> deleteStatusLearning(statusId) async {

    return await _statusLearningRef
      .doc(statusId.toString())
      .delete()
      .then((value) {
        print("Status learning deleted");
        return Future.value();
        }) 
      .catchError((error) {
        print("Failed to delete status learning: $error");
        return Future.error(error);
      }); 
  }
}