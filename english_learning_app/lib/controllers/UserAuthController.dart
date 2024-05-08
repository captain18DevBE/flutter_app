import 'package:firebase_auth/firebase_auth.dart';



class UserAuthController {
  
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      return credential.user;
    } catch (e) {
      print("Some error SingUp user");
    }

    return null;
  }

  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      
      return credential.user;
    } catch (e) {
      print("Some error SingUp user");
    }

    return null;
  }

}

