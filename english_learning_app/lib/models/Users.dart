import 'package:intl/intl.dart';

class Users {
  int id;
  String email;
  String userName;
  String? phoneNumber;
  bool? isTeacher;

  String createAt = DateFormat("dd-MM-yyyy").format(DateTime.now());

  Users(this.id, this.email, this.userName, {this.phoneNumber, this.isTeacher});

}