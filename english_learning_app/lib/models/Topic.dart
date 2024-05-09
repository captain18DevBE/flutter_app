import 'package:english_learning_app/models/Cards.dart';
import 'package:intl/intl.dart';


class Topic {
  String createByUserEmail;
  String createAt = DateFormat("dd-MM-yyyy").format(DateTime.now());
  String topicName;
  List<Cards> lstCard;
  String? description;


  Topic(this.createByUserEmail, this.topicName, this.lstCard, {this.description});

  set setTopicName(String data) {
    this.topicName = data;
  }

  String get getTopicName {
    return this.topicName;
  }

  set setDescription(String des) {
    this.description = des;
  }

  String? get getDescription {
    return this.description;
  }

  List<Cards> get getLstCards {
    return this.lstCard;
  }
}