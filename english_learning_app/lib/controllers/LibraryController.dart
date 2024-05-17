import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_learning_app/models/Library.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LibraryController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  final CollectionReference _libraryRef = FirebaseFirestore.instance.collection("Libraries");

  Future<int> amountLibrary() async {
    final QuerySnapshot result = await _libraryRef.get();
    final List<DocumentSnapshot> documents = result.docs;

    return documents.length; 
  }

  Future<void> addLibrary(Library data) async {
    int libraryId = await amountLibrary() + 1;
    final library = <String, dynamic> {
      'id' : libraryId,
      'title' : data.title,
      'description' : data.description,
      "create_by" : data.createBy,
      "createAt" : data.createAt,
      "topics" : data.topics
    };
    
    return _libraryRef.doc(libraryId.toString())
      .set(library)
      .then((value) {
        print("Library added");
        return Future.value();
      })
      .catchError((error) {
        print("Failed to add library");
        return Future.error(error);
      });
  }

  //Read library by id
  Future<DocumentSnapshot<Object?>> readLibraryById(int libraryId) async {
    try {
      final docSnapshot = await _libraryRef.doc(libraryId.toString())
        .get();

      return Future.value(docSnapshot);
    } on FirebaseException catch (error) {
      print('Failed to read library: $error');
      return Future.error(error);
    }
  }


  //Read Library By Email
  Future<List<Library>> readLibraryByEmailUserOwner() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      return [];
    }
    try {
      final querySnapshot = await _libraryRef
        .where("create_by", isEqualTo: currentUser.email)
        .get();

      return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      Library library = Library(
        id: data['id'],
        createBy: data['create_by'],
        title: data['title'],
        description: data['description'],
      );
      library.topics = List<int>.from(data['topics'] as List);
      return library;

    }).toList();
    } on FirebaseException catch (error) {
      print('Error reading library: $error');
      return Future.error(error);
    }

  }

  //Update Library
  Future<void> updateLibraryById(Library data) async {
    final library = <String, dynamic> {
      'title' : data.title,
      'description' : data.description,
      "create_by" : data.createBy,
      "createAt" : data.createAt,
      "topics" : data.topics
    };

    return _libraryRef
      .doc(data.id.toString())
      .update(library)
      .then((value) => print("Library updated"))
      .catchError((error) => print("Failed to update library: $error"));
  }

}