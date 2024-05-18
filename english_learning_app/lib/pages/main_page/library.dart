import 'package:english_learning_app/pages/folder/edit_folder.dart';
import 'package:english_learning_app/pages/menu_topic/learning.dart';
import 'package:english_learning_app/pages/topics/edit_topic.dart';
import 'package:flutter/material.dart';
import 'package:english_learning_app/controllers/TopicController.dart';
import 'package:english_learning_app/controllers/UserController.dart';
import 'package:english_learning_app/controllers/LibraryController.dart';
import 'package:english_learning_app/models/Topic.dart';
import 'package:english_learning_app/models/Library.dart';
import 'package:intl/intl.dart';

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  List<Topic> _topics = [];
  List<Library> _folders = [];
  
  final TopicController _topicController = TopicController();
  final UserController _userController = UserController();
  final LibraryController _folderController = LibraryController();

  @override
  void initState() {
    super.initState();
    _loadTopics();
    _loadFolders();
  }

  Future<void> _loadFolders() async {
    final folders = await _folderController.readLibraryByEmailUserOwner();
    setState(() {
      _folders = folders;
      print(_folders);
    });
  }

  Future<void> _loadTopics() async {
    final topics = await _topicController.readTopicByEmailUserOwner();
    setState(() {
      _topics = topics;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Your Library',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.blue[700],
          bottom: TabBar(
            labelColor: Colors.white,
            indicatorColor: Colors.blue,
            tabs: [
              Tab(
                icon: Icon(Icons.topic),
                text: 'Topics',
              ),
              Tab(
                icon: Icon(Icons.folder),
                text: 'Folders',
              ),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                Color(0xFF1976D2),
                Color(0xFF42A5F5),
                Color(0xFF90CAF9),
                Colors.white,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: TabBarView(
            children: [
              _buildTopicsList(),
              _buildFoldersList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopicsList() {
    return ListView.builder(
      itemCount: _topics.length,
      itemBuilder: (context, index) {
        final topic = _topics[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            title: Text(topic.title),
            subtitle: Text('Words: ${topic.cards.length}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Learning(topicId: topic.id,)),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFoldersList() {
    return ListView.builder(
      itemCount: _folders.length,
      itemBuilder: (context, index) {
        final folder = _folders[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            title: Text(folder.title),
            subtitle: Text('Topics: ${folder.topics.length}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditFolderPage()),
              );
            },
          ),
        );
      },
    );
  }
}
