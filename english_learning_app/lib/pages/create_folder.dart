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
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('CREATE FOLDER',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                style: TextStyle(fontSize: 20),
                cursorColor: Colors.white,
                controller: _folderNameController,
                decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    labelText: 'FOLDER NAME:',
                    labelStyle: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 16),
              Container(
                margin: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: CircleBorder(),
                    shadows: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      )
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: IconButton(
                    onPressed: () => _showTopicSelectionDialog(context),
                    iconSize: 24.0,
                    icon: const Icon(Icons.add, color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Selected Topics:',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              const Divider(
                color: Colors.white,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _selectedTopics.length,
                  itemBuilder: (context, index) {
                    final topic = _selectedTopics[index];
                    return Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.only(left: 15),
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
                      child: Row(
                        children: [
                          Text(topic.name,),
                          Spacer(),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red,),
                            onPressed: () => removeTopic(topic),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green)),
                icon: const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                label: const Text(
                  'Create',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTopicSelectionDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: const Text('Select Topics'),
                content: Container(
                  height: 300,
                  width: 300,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _existingTopics.length,
                    itemBuilder: (context, index) {
                      final topic = _existingTopics[index];
                      return CheckboxListTile(
                          title: Text(topic.name),
                          value: _selectedTopics.contains(topic),
                          onChanged: (value) {
                            setState(() {
                              toggleTopicSelection(topic);
                            });
                          });
                    },
                  ),
                ),
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
            }));
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
}

class Topic {
  final String name;

  const Topic({required this.name});
}
