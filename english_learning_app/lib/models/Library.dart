import 'package:english_learning_app/models/dto/TopicDTO.dart';
import 'package:intl/intl.dart';

class Library {
  String userEmailOwner;
  String createAt = DateFormat("dd-MM-yyyy").format(DateTime.now());
  List<TopicDTO> lstTopics = [];

  Library(this.userEmailOwner);
}