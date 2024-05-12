import 'package:intl/intl.dart';

class Users {
  String email;
  String userName;
  String? phoneNumber;
  bool? isTeacher;

  String createAt = DateFormat("dd-MM-yyyy").format(DateTime.now());

  Users(this.email, this.userName, {this.phoneNumber, this.isTeacher});

}