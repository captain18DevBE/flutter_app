import 'package:english_learning_app/models/CardImage.dart';
import 'package:intl/intl.dart';


class Cards {
  String term;
  String describe;
  String createByUserEmail;
  String createAt = DateFormat("dd-MM-yyyy").format(DateTime.now());
  CardImage? image;

  Cards(this.term, this.createByUserEmail, this.describe, {this.image});

}