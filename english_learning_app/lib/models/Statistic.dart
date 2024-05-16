
import 'package:intl/intl.dart';

class Statistic {
  int id;
  int topicId;
  String createBy;
  double percenRate;
  int numOfStudy;
  String createAt = DateFormat("dd-MM-yyyy").format(DateTime.now());

  Statistic({required this.id, required this.topicId, required this.createBy, required this.percenRate, required this.numOfStudy});
}