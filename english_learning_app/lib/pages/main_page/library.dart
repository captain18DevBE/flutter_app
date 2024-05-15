import 'package:english_learning_app/pages/folder/edit_folder.dart';
import 'package:english_learning_app/pages/topics/edit_topic.dart';
import 'package:flutter/material.dart';

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final _topics = [
    Topic(name: 'Math', wordCount: 50),
    Topic(name: 'Science', wordCount: 40),
    Topic(name: 'History', wordCount: 30),
  ];
  final _folders = [
    Folder(name: 'Work Documents', topicCount: 2),
    Folder(name: 'Personal Notes', topicCount: 1),
  ];

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
            title: Text(topic.name),
            subtitle: Text('Words: ${topic.wordCount}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditTopicPage()),
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
            title: Text(folder.name),
            subtitle: Text('Topics: ${folder.topicCount}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditFolderPage(),)
              );
            },
          ),
        );
      },
    );
  }
}

class Topic {
  final String name;
  final int wordCount;

  const Topic({required this.name, required this.wordCount});
}

class Folder {
  final String name;
  final int topicCount;

  const Folder({required this.name, required this.topicCount});
}


