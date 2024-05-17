
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

  Future<void> addStatusLearning(StatusLearning data) async {
    int statusLearningId = await amountStatusLearning();
    final statusLearning = <String, dynamic> {
      'id' : statusLearningId,
      'topic_id' : data.topicId,
      'create_by' : data.createBy,
      'create_at' : data.createAt,
      'cards_yet_to_be_memorized' : data.cardMomorized
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
      'create_at' : data.createAt,
      'cards_yet_to_be_memorized' : data.cardMomorized
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

  Future<QuerySnapshot<Object?>> readStatusLearningByEmailAndTopicId(String email, int topicId) async {
    try {
      final querySnapshot = await _statusLearningRef
        .where('create_by', isEqualTo: email)
        .where('topic_id', isEqualTo: topicId)
        .get();

        return Future.value(querySnapshot);
    } on FirebaseException catch (error) {
      print('Error status learning topics: $error');
      return Future.error(error);
    }

  } 
}