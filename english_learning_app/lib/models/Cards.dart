import 'package:intl/intl.dart';

class Cards {
  int id;
  int topicId;
  String term;
  String mean;
  String createByUserEmail;
  String createAt = DateFormat("dd-MM-yyyy").format(DateTime.now());
  String? urlPhoto;

  Cards({required this.id,required this.topicId, required this.term, required this.createByUserEmail, required this.mean, this.urlPhoto});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'topicId': topicId,
      'term': term,
      'mean': mean,
      'createByUserEmail': createByUserEmail,
      'createAt': createAt,
      'urlPhoto': urlPhoto,
    };
  }

}