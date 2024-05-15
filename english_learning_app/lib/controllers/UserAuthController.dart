import 'package:firebase_auth/firebase_auth.dart';



class UserAuthController {
  
  FirebaseAuth _auth = FirebaseAuth.instance;

  User? getCurrentUser() {
    User? user = _auth.currentUser;
    return user;
  }

  Future<User?> signUpWithEmailPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      return credential.user;
    } on FirebaseAuthException catch (e) {
      print("Some error SingUp user");
    }

    return null;
  }

  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      
      return credential.user;
    } on FirebaseAuthException catch (e) {
      print("Some error SingIn user");
    }

    return null;
  }


  Future<void> signOut() async {
    await _auth.signOut();
  }


  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseException catch(e) {
      print("Some error SingUp user");
    }

  }

  Future<User?> updateUserProfile(String displayName, String urlPhoto) async {
    User? user = _auth.currentUser;

    if (user != null) {
      if (displayName != null) {
        await user?.updateDisplayName(displayName);
      }
      if (urlPhoto != null) {
        await user?.updatePhotoURL(urlPhoto);
      }
      return user;
    }
    print('Have a problem on event user profile date changed');
    return null;
  }

  Future<User?> updateEmailAddress(String email) async {
    User? user = _auth.currentUser;

    if(user != null) {
      await user?.sendEmailVerification();
      await user?.updateEmail(email);

      return user;
    }

    return null;
  }

  Future<User?> changedPassword(String newPassword) async {
    User? user = _auth.currentUser;

    if(user != null) {
      await user?.updatePassword(newPassword);

      return user;
    }

    return null;
  }

}

