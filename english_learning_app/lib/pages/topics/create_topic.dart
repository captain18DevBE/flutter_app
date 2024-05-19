import 'package:english_learning_app/pages/topics/settings_topic.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:english_learning_app/controllers/TopicController.dart';
import 'package:english_learning_app/controllers/CardsController.dart';
import 'package:english_learning_app/controllers/UserController.dart';
import 'package:english_learning_app/models/Topic.dart';
import 'package:english_learning_app/models/Cards.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class CreateTopicPage extends StatefulWidget {
  @override
  _CreateTopicPageState createState() => _CreateTopicPageState();
}

class _CreateTopicPageState extends State<CreateTopicPage> {
  final _topicNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  List<Map<String, String>> _wordDefinitions = [];
  bool _isAddingDescription = false;
  bool _isLoading = false;
  final TopicController _topicController = TopicController();
  final CardsController _cardsController = CardsController();
  final UserController _userController = UserController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: AppBar(
    iconTheme: const IconThemeData(color: Colors.white),
    title: const Text(
      'CREATE TOPIC',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevation: 5,
    backgroundColor: Colors.blue[700],
    centerTitle: true,
    shadowColor: Colors.black,
    actions: [
      IconButton(
        icon: Icon(Icons.upload_file),
        onPressed: _importCSV,
      ),
    ],
  ),
  body: Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: <Color>[
          Color(0xFF1976D2),
          Color(0xFF42A5F5),
          Color(0xFF90CAF9),
          Colors.white
        ], 
        begin: Alignment.topCenter, 
        end: Alignment.bottomCenter,
      ),
    ),
    child: Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildTextField(
                controller: _topicNameController,
                labelText: 'TOPIC NAME',
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
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Add Description',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                'Words: ${_wordDefinitions.length}',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              _isLoading
                  ? CircularProgressIndicator()
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _wordDefinitions.length + 1,
                      itemBuilder: (context, index) {
                        if (index == _wordDefinitions.length) {
                          return AddWordDefinitionRow(onAdd: addWordDefinition);
                        } else {
                          final wordDefinition = _wordDefinitions[index];
                          return WordDefinitionRow(
                            wordDefinition: wordDefinition,
                            onDelete: () => removeWordDefinition(index),
                            onUpdate: (word, definition) {
                              setState(() {
                                _wordDefinitions[index] = {
                                  'word': word,
                                  'definition': definition
                                };
                              });
                            },
                          );
                        }
                      },
                    ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _wordDefinitions.length > 0
                ? ElevatedButton.icon(
                    onPressed: _createTopic,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                    ),
                    icon: const Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Create',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : Container(),
          ),
        ),
      ],
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

  void addWordDefinition() {
    setState(() {
      _wordDefinitions.add({'word': '', 'definition': ''});
    });
  }

  void removeWordDefinition(int index) {
    setState(() {
      _wordDefinitions.removeAt(index);
    });
    _showSnackbar('Removed word definition');
  }

  void _createTopic() async {
    setState(() {
      _isLoading = true;
    });

    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      _showSnackbar('Error: No logged in user');
      setState(() {
        _isLoading = false;
      });
      return;
    }
    String userEmail = currentUser.email!;

    int topicId = await _topicController.amountTopics() + 1;
    Topic newTopic = Topic(
      id: topicId,
      title: _topicNameController.text,
      description: _descriptionController.text,
      createBy: userEmail,
      cards: [],
    );

    await _topicController.addTopic(newTopic);

    List<int> cardIds = [];
    for (var wordDefinition in _wordDefinitions) {
      int cardId = await _cardsController.amountCards() + 1;
      Cards newCard = Cards(
        id: cardId,
        topicId: newTopic.id,
        createByUserEmail: userEmail,
        term: wordDefinition['word']!,
        mean: wordDefinition['definition']!,
        urlPhoto:
            '', //picture url
      );
      await _cardsController.addCard(newCard);
      cardIds.add(cardId);
    }

    //update topic
    newTopic.cards = cardIds;
    await _topicController.updateTopicById(newTopic);

    setState(() {
      _isLoading = false;
      Navigator.pop(context);
      _showSnackbar('Topic and cards created successfully!');
    });
  }

  void _showSnackbar(String message) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.hideCurrentSnackBar();
    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _importCSV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      List<String> lines = await file.readAsLines();
      List<Map<String, String>> importedWords = [];

      for (String line in lines) {
        List<String> values = line.split(',');
        if (values.length == 2) {
          importedWords
              .add({'word': values[0].trim(), 'definition': values[1].trim()});
        }
      }

      setState(() {
        _wordDefinitions.addAll(importedWords);
      });

      _showSnackbar('Imported ${importedWords.length} words successfully!');
    } else {
      _showSnackbar('File import cancelled');
    }
  }
}

class WordDefinitionRow extends StatefulWidget {
  final Map<String, String> wordDefinition;
  final VoidCallback onDelete;
  final Function(String, String) onUpdate;

  const WordDefinitionRow({
    Key? key,
    required this.wordDefinition,
    required this.onDelete,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _WordDefinitionRowState createState() => _WordDefinitionRowState();
}

class _WordDefinitionRowState extends State<WordDefinitionRow> {
  late TextEditingController _wordController;
  late TextEditingController _definitionController;

  @override
  void initState() {
    super.initState();
    _wordController =
        TextEditingController(text: widget.wordDefinition['word']);
    _definitionController =
        TextEditingController(text: widget.wordDefinition['definition']);
  }

  @override
  void dispose() {
    _wordController.dispose();
    _definitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
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
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    TextField(
                      controller: _wordController,
                      onChanged: (value) =>
                          widget.onUpdate(value, _definitionController.text),
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(fontSize: 12),
                        labelText: 'ENGLISH',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: TextField(
                        controller: _definitionController,
                        onChanged: (value) =>
                            widget.onUpdate(_wordController.text, value),
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(fontSize: 12),
                          labelText: 'VIETNAMESE',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              VerticalDivider(
                indent: 10,
                endIndent: 10,
                color: Colors.grey,
                thickness: 1,
              ),
              const SizedBox(width: 5),
              Align(
                alignment: Alignment.center,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: widget.onDelete,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddWordDefinitionRow extends StatelessWidget {
  final VoidCallback onAdd;

  const AddWordDefinitionRow({Key? key, required this.onAdd}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          onPressed: onAdd,
          iconSize: 24.0,
          icon: const Icon(Icons.add, color: Colors.blue),
        ),
      ),
    );
  }
}
