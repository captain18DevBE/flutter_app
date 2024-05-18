
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_learning_app/models/Topic.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TopicController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  final CollectionReference _topicRef = FirebaseFirestore.instance.collection("Topics");

  Future<int> amountTopics() async {
    final QuerySnapshot result = await _topicRef.get();
    final List<DocumentSnapshot> documents = result.docs;

    return documents.length;
  }

  //Add Topic
  Future<void> addTopic(Topic data) async {
    int topicId = await amountTopics() + 1;
    final topic = <String, dynamic> {
      'id' : topicId,
      'title' : data.createBy,
      'description' : data.description,
      'create_by' : data.createBy,
      'create_at' : data.createAt,
      'is_public' : data.isPublic,
      'cards' : data.cards
    };

    await db.collection("Topics")
      .doc(topicId.toString())
      .set(topic)
      .then((value) => print("Topic added"))
      .catchError((error) => print("Failed to add topic: $error"));
  }

  // Update Topic
  Future<void> updateTopicById(Topic data) async {
    final topic = {
      'title': data.title,
      'description': data.description,
      'create_by': data.createBy,
      'create_at': data.createAt,
      'is_public': data.isPublic,
      'cards': data.cards
    };
    return _topicRef
      .doc(data.id.toString())
      .update(topic)
      .then((value) => print("Topic updated"))
      .catchError((error) => print("Failed to update topic: $error"));
  }

  Future<void> updateTopic(Topic topic) async {
    Map<String, dynamic> data = {
      "title": topic.title,
      "description": topic.description,
      "create_by": topic.createBy,
      "create_at": topic.createAt,
      "is_public": topic.isPublic,
      "cards": topic.cards,
    };
    return _topicRef.doc(topic.id.toString())
      .update(data)
      .then((value) {
        print("Topic updated");
        return Future.value();
        }) 
      .catchError((error) {
        print("Failed to update topic: $error");
        return Future.error(error);
    }); 
  }


  //Delete topic
  Future<void> deleteTopic(int topicId) async {

    return await _topicRef
      .doc(topicId.toString())
      .delete()
      .then((value) {
        print("Topic deleted");
        return Future.value();
        }) 
      .catchError((error) {
        print("Failed to delete topic: $error");
        return Future.error(error);
      }); 
  }

  //Read topic by id
  // Future<DocumentSnapshot<Object?>> readTopicById(int topicId) async {
  //   try {
  //     final docSnapshot = await _topicRef.doc(topicId.toString())
  //       .get();
  //       return Future.value(docSnapshot);
  //       //return docSnapshot;
  //   } on FirebaseException catch (error) {
  //     print('Failed to read topic: $error');
  //     return Future.error(error);
  //   }
  // }

   // Fetch a topic by its ID
  Future<Topic> getTopicById(int topicId) async {
    try {
      final docSnapshot = await _topicRef.doc(topicId.toString()).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        return Topic(
          id: data['id'],
          createBy: data['create_by'],
          title: data['title'],
          cards: List<int>.from(data['cards']),
          description: data['description'],
        );
      } else {
        throw Exception('Topic not found');
      }
    } on FirebaseException catch (error) {
      print('Failed to fetch topic: $error');
      throw Exception('Failed to fetch topic');
    }
  }


  //Read topic by email
  Future<List<Topic>> readTopicByEmailUserOwner() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      return [];
    }
    try {
      final querySnapshot = await _topicRef
        .where('create_by', isEqualTo: currentUser.email)
        .get();
      return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Topic(
        id: data['id'],
        createBy: data['create_by'],
        title: data['title'],
        cards: List<int>.from(data['cards']),
        description: data['description'],
      );
      }).toList();
      // return querySnapshot;
    } on FirebaseException catch (error) {
      print('Error reading topics: $error');
      return Future.error(error);
    } 
  }

  //Read topic is public
  Future<List<Topic>> readTopicPublic() async {
    try {
      final querySnapshot = await _topicRef
        .where('is_public', isEqualTo: true)
        .get();
      
        return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Topic(
          id: data['id'],
          createBy: data['create_by'],
          title: data['title'],
          cards: List<int>.from(data['cards']),
          description: data['description'],
        );
        }).toList();
    } on FirebaseException catch (error) {
      print('Error reading topics: $error');
      return Future.error(error);
    }
  }

}