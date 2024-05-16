
import 'package:intl/intl.dart';

class StatusLearning {
  int id;
  int topicId;

  String createBy;
  String createAt = DateFormat("dd-MM-yyyy").format(DateTime.now());

  List<int> cardMomorized;

  StatusLearning({required this.id, required this.topicId, required this.createBy, required this.cardMomorized});
}