
import 'package:english_learning_app/models/Cards.dart';

class PersonalStarCards {
  int id;
  String createBy;
  List<Cards> lstStarCards = [];

  PersonalStarCards({required this.id, required this.createBy});
}