import 'package:english_learning_app/models/dto/TopicDTO.dart';
import 'package:intl/intl.dart';

class Library {
  int id;
  String createBy;
  String title;
  String? description;
  String createAt = DateFormat("dd-MM-yyyy").format(DateTime.now());
  List<int> topics = [];

  Library({required this.id, required this.title, required this.createBy, this.description});
}