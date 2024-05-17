import 'package:english_learning_app/models/Cards.dart';
import 'package:intl/intl.dart';


class Topic {
  int id;
  String createBy;
  String createAt = DateFormat("dd-MM-yyyy").format(DateTime.now());
  String title;
  bool isPublic = false;
  List<int> cards;
  String? description;

  Topic({required this.id, required this.createBy, required this.title, required this.cards, this.description,});
}