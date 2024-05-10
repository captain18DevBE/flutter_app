import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_learning_app/models/Users.dart';


class UserController {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> addUser(Users data) async {
    final user = <String, dynamic> {
      "email" : data.email,
      "userName" : data.userName,
      "phoneNumber" : data.phoneNumber,
      "isTeacher" : data.isTeacher,
      "createAt" : data.createAt
    };

    db.collection("Users").add(user).then((value) => print("Added Data with ID: ${value.id}"));
  }

  
}