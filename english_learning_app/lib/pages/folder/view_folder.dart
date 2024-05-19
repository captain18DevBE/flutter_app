import 'package:english_learning_app/controllers/StatusLearningController.dart';
import 'package:english_learning_app/controllers/UserAuthController.dart';
import 'package:english_learning_app/models/StatusLearning.dart';
import 'package:english_learning_app/pages/folder/edit_folder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:english_learning_app/controllers/LibraryController.dart';
import 'package:english_learning_app/controllers/TopicController.dart';
import 'package:english_learning_app/models/Library.dart';
import 'package:english_learning_app/models/Topic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_learning_app/pages/menu_topic/learning.dart';

class ViewFolderPage extends StatefulWidget {
  final int folderId;

  const ViewFolderPage({required this.folderId});

  @override
  _ViewFolderPageState createState() => _ViewFolderPageState();
}

class _ViewFolderPageState extends State<ViewFolderPage> {
  final _libraryController = LibraryController();
  final _topicController = TopicController();
  final StatusLearningController _statusLearningController = StatusLearningController();
  late Future<Library> _folderFuture;
  List<Topic> _topics = [];
  bool _isLoading = false;
  late List<StatusLearning> _statusLearning;
  final UserAuthController _userAuthController = new UserAuthController();
   late User _user;

  @override
  void initState() {
    super.initState();
    _folderFuture = _loadFolder();
  }

  Future<void> fetchCurrentUser() async {
    try {
      User? current = await _userAuthController.getCurrentUser();
      setState(() {
        if (current != null) {
          _user = current;
        }
      });
    } catch (error) {
      print("Have problem loading user ${error}");
    }
  }

  Future<List<StatusLearning>> fetchStatusLearning(int id) async {
    List<StatusLearning> tmp = await _statusLearningController.readStatusLearningByEmailAndTopicId(_user.email!, id);

    setState(() {
      _statusLearning = tmp;
    });
    return tmp;
  }

  Future<Library> _loadFolder() async {
    setState(() {
      _isLoading = true;
    });

    try {
      DocumentSnapshot folderSnapshot = await _libraryController.readLibraryById(widget.folderId);
      if (!folderSnapshot.exists) {
        throw Exception('Folder not found');
      }

      Map<String, dynamic> folderData = folderSnapshot.data() as Map<String, dynamic>;
      Library folder = Library(
        id: folderData['id'],
        title: folderData['title'],
        description: folderData['description'],
        createBy: folderData['create_by'],
        
      );

      folder.topics = List<int>.from(folderData['topics']);

      List<Topic> topics = [];
      for (int topicId in folder.topics) {
        Topic topic = await _topicController.getTopicById(topicId);
        topics.add(topic);
      }

      setState(() {
        _topics = topics;
        _isLoading = false;
      });

      return folder;
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'VIEW FOLDER',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditFolderPage(folderId: widget.folderId)
                ),
              );
            },
          ),
        ],
        elevation: 5,
        backgroundColor: Colors.blue[700],
        centerTitle: true,
        shadowColor: Colors.black,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: <Color>[
            Color(0xFF1976D2),
            Color(0xFF42A5F5),
            Color(0xFF90CAF9),
            Colors.white
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: FutureBuilder<Library>(
          future: _folderFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting || _isLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('Folder not found'));
            } else {
              Library folder = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextView(
                      text: 'FOLDER NAME',
                      content: folder.title,
                    ),
                    const SizedBox(height: 16),
                    _buildTextView(
                      text: 'DESCRIPTION',
                      content: folder.description ?? 'No DESCRIPTION provided',
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Topics: ${_topics.length}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const Divider(color: Colors.white),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _topics.length,
                        itemBuilder: (context, index) {
                          final topic = _topics[index];
                          return _buildTopicCard(topic);
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildTextView({required String text, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content.isNotEmpty ? content : 'No $text provided',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ],
    );
  }


Widget _buildTopicCard(Topic topic) {
  return GestureDetector(
    onTap: () {
      StatusLearning temp = fetchStatusLearning(topic.id);
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Learning(statusLearningId: , topicId: topic.id),
        ),
      );
    },
    child: Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(topic.title, style: TextStyle(fontWeight: FontWeight.bold)),
          Text('Words: ${topic.cards.length}'),
        ],
      ),
    ),
  );
}

}
