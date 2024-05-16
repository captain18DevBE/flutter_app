import 'package:english_learning_app/models/dto/TopicDTO.dart';
import 'package:intl/intl.dart';

class Library {
  int id;
  String createBy;
  String tile;
  String? description;
  String createAt = DateFormat("dd-MM-yyyy").format(DateTime.now());
  List<int> topics = [];

  Library({required this.id, required this.tile, required this.createBy, this.description});
}