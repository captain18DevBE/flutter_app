
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_learning_app/models/Statistic.dart';

class StatisticController {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final CollectionReference _statisticRef = FirebaseFirestore.instance.collection("Statistics");

  Future<int> amountStatistic() async {
    final QuerySnapshot result = await _statisticRef.get();
    final List<DocumentSnapshot> documents = result.docs;

    return documents.length;
  }

  Future<void> addStatistic(Statistic data) async {
    int staticId = await amountStatistic() + 1;

    final statistic = <String, dynamic> {
      'id' : staticId,
      'topic' : data.topicId,
      'create_by' : data.createBy,
      'create_at' : data.createAt,
      'number_of_study' : data.numOfStudy,
      'percen_rate' : data.percenRate
    };

    await _statisticRef
      .doc(staticId.toString())
      .set(statistic)
      .then((value) {
        print("Statistic added");
        return Future.value();
      })
      .catchError((error) {
        print("Failed to add statistic");
        return Future.error(error);
      });
  }

  Future<bool> checkExist(String email, int topicId) async {
    final QuerySnapshot result = await _statisticRef
      .where('create_by', isEqualTo: email)
      .where('topic_id', isEqualTo: topicId)
      .get();
    final List<DocumentSnapshot> documents = result.docs;
    return (documents.isNotEmpty);
  }



  Future<void> updateStatistic(Statistic data) async {
    final statistic = <String, dynamic> {
      'create_at' : data.createAt,
      'number_of_study' : data.numOfStudy,
      'percen_rate' : data.percenRate
    };

    return await _statisticRef.doc(data.id.toString())
      .update(statistic)
      .then((value) {
        print("Statistic updated");
        return Future.value();
      })
      .catchError((error) {
        print("Failed to update statistic: $error");
        return Future.error(error);
      });
  }

  Future<void> deleteStatistic(int statisticId) async {
    
    return await _statisticRef
      .doc(statisticId.toString())
      .delete()
      .then((value) {
        print("Statistic deleted");
        return Future.value();
      })
      .catchError((error) {
        print("Failed to delete statistic: $error");
        return Future.error(error);
      });
  }

  Future<List<Statistic>> readStatisticByTopicId(int topicId) async {
    try {
      final querySnapshot = await _statisticRef
        .where('topic_id', isEqualTo: topicId)
        .get();

        return querySnapshot.docs.map( (doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Statistic(
              id: data['id'], 
              topicId: data['topic_id'], 
              createBy: data['create_by'], 
              percenRate: 0.0, 
              numOfStudy: data['number_of_study'], 
              );
          }
        ).toList();
    } on FirebaseException catch (error) {
      print('Error statistic topics: $error');
      return Future.error(error);
    }
  }

  Future<List<Statistic>> readStatisticByEmailAndTopicId(String email, int topicId) async {
    try {
      final querySnapshot = await _statisticRef
        .where('create_by', isEqualTo: email)
        .where('topic_id', isEqualTo: topicId)
        .get();

        return querySnapshot.docs.map( (doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Statistic(
              id: data['id'], 
              topicId: data['topic_id'], 
              createBy: data['create_by'], 
              percenRate: data['percen_rate'], 
              numOfStudy: data['number_of_study'],
              );
          }
        ).toList();
    } on FirebaseException catch (error) {
      print('Error statistic topics: $error');
      return Future.error(error);
    }
  }

  Future<Statistic> readStatisticById(int statusId) async {
    try {
      final docSnapshot = await _statisticRef.doc(statusId.toString()).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;

        return Statistic(
              id: data['id'], 
              topicId: data['topic_id'], 
              createBy: data['create_by'], 
              percenRate: 0.0, 
              numOfStudy: data['number_of_study'], 
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
}