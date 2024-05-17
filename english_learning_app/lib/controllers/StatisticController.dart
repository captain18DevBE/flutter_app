
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
}