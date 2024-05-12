import 'package:flutter/material.dart';

class CreateFolderPage extends StatefulWidget {
  @override
  _CreateFolderPageState createState() => _CreateFolderPageState();
}

class _CreateFolderPageState extends State<CreateFolderPage> {
  final _folderNameController = TextEditingController();
  List<Topic> _existingTopics = [];
  List<Topic> _selectedTopics = []; 

  @override
  void initState() {
    super.initState();
    _existingTopics = [
      Topic(name: 'Topic 1'),
      Topic(name: 'Topic 2'),
      Topic(name: 'Topic 3'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Folder'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _folderNameController,
              decoration: const InputDecoration(
                labelText: 'FOLDER NAME',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showTopicSelectionDialog(context),
              child: const Text('Add Topics'),
            ),
            const SizedBox(height: 16),
            Text('Selected Topics:'),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: _selectedTopics.length,
                itemBuilder: (context, index) {
                  final topic = _selectedTopics[index];
                  return Row(
                    children: [
                      Text(topic.name),
                      Spacer(),
                      IconButton(
                        icon: const Icon(Icons.remove_circle),
                        onPressed: () => removeTopic(topic),
                      ),
                    ],
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () => submitFolder(),
              child: const Text('Create Folder'),
            ),
          ],
        ),
      ),
    );
  }

 void _showTopicSelectionDialog(BuildContext context) async {
  final existingTopics = await _fetchExistingTopics();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Select Topics'),
        content: existingTopics != null
            ? _buildTopicSelectionList()
            : const CircularProgressIndicator(),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => addSelectedTopics(),
            child: const Text('Done'),
          ),
        ],
      );
    },
  );
}

Future<List<Topic>> _fetchExistingTopics() async {
  await Future.delayed(const Duration(milliseconds: 1));

  return [
    Topic(name: 'Math'),
    Topic(name: 'Science'),
    Topic(name: 'History'),
    Topic(name: 'Literature'),
    Topic(name: 'Geography'),
    Topic(name: 'Art'),
    Topic(name: 'Music'),
    Topic(name: 'Technology'),
    Topic(name: 'Sports'),
    Topic(name: 'Cooking'),
  ];
}


  Widget _buildTopicSelectionList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _existingTopics.length,
      itemBuilder: (context, index) {
        final topic = _existingTopics[index];
        return CheckboxListTile(
          title: Text(topic.name),
          value: _selectedTopics.contains(topic),
          onChanged: (value) => toggleTopicSelection(topic),
        );
      },
    );
  }

  void toggleTopicSelection(Topic topic) {
    setState(() {
      if (_selectedTopics.contains(topic)) {
        _selectedTopics.remove(topic);
      } else {
        _selectedTopics.add(topic);
      }
    });
  }

  void addSelectedTopics() {
    Navigator.pop(context);
  }

  void removeTopic(Topic topic) {
    setState(() {
      _selectedTopics.remove(topic);
    });
  }

  void submitFolder() {
    
  }
}

class Topic {
  final String name;

  const Topic({required this.name});
}
