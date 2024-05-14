import 'package:flutter/material.dart';

class EditFolderPage extends StatefulWidget {
  @override
  _EditFolderPageState createState() => _EditFolderPageState();
}

class _EditFolderPageState extends State<EditFolderPage> {
  final _folderNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  List<Topic> _existingTopics = [];
  List<Topic> _selectedTopics = [];
  bool _isAddingDescription = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _existingTopics = [
      Topic(name: 'Topic 1', wordCount: 10),
      Topic(name: 'Topic 2', wordCount: 20),
      Topic(name: 'Topic 3', wordCount: 30),
    ];
    _selectedTopics.add(_existingTopics[1]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'EDIT FOLDER',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
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
              _buildTextField(
                controller: _folderNameController,
                labelText: 'FOLDER NAME',
              ),
              const SizedBox(height: 16),
              if (_isAddingDescription)
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _descriptionController,
                        labelText: 'DESCRIPTION',
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _isAddingDescription = false;
                          _descriptionController.clear();
                        });
                      },
                    )
                  ],
                )
              else
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isAddingDescription = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Add Description'),
                ),
              const SizedBox(height: 16),
              _buildAddTopicButton(),
              const SizedBox(height: 16),
              Text(
                'Selected Topics: ${_selectedTopics.length}',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const Divider(color: Colors.white),
              _isLoading
                  ? CircularProgressIndicator()
                  : _selectedTopics.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: _selectedTopics.length,
                            itemBuilder: (context, index) {
                              final topic = _selectedTopics[index];
                              return _buildTopicCard(topic);
                            },
                          ),
                        )
                      : SizedBox(),
              if (_selectedTopics.length > 0)
                ElevatedButton.icon(
                  onPressed: _createFolder,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                  ),
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

  TextField _buildTextField(
      {required TextEditingController controller, required String labelText}) {
    return TextField(
      style: TextStyle(fontSize: 20),
      cursorColor: Colors.white,
      controller: controller,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildAddTopicButton() {
    return Container(
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
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: IconButton(
          onPressed: () => _showTopicSelectionDialog(context),
          iconSize: 24.0,
          icon: const Icon(Icons.add, color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildTopicCard(Topic topic) {
    return Container(
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
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(topic.name, style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Words: ${topic.wordCount}'),
            ],
          ),
          Spacer(),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () => removeTopic(topic),
          ),
        ],
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
                  subtitle: Text('Words: ${topic.wordCount}'),
                  value: _selectedTopics.contains(topic),
                  onChanged: (value) {
                    setState(() {
                      toggleTopicSelection(topic);
                    });
                  },
                );
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
      }),
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
    _showSnackbar('Removed ${topic.name}');
  }

  void _createFolder() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
        Navigator.pop(context);
        _showSnackbar('Folder created successfully!');
      });
    });
  }

  void _showSnackbar(String message) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.hideCurrentSnackBar();
    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class Topic {
  final String name;
  final int wordCount;

  const Topic({required this.name, required this.wordCount});
}
