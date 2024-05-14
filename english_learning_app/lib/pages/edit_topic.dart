import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class EditTopicPage extends StatefulWidget {

  const EditTopicPage({Key? key}) : super(key: key);

  @override
  _EditTopicPageState createState() => _EditTopicPageState();
}

class _EditTopicPageState extends State<EditTopicPage> {
  final _topicNameController = TextEditingController();
  List<Map<String, String>> _wordDefinitions = [];
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    flutterTts.setLanguage("en-US");
    _topicNameController.text = 'TOPIC NAME';
    _wordDefinitions = [
      {'word': 'Apple', 'definition': 'A fruit', 'isStarred': 'false'},
      {'word': 'Banana', 'definition': 'Another fruit', 'isStarred': 'true'},
      {'word': 'Carrot', 'definition': 'A vegetable', 'isStarred': 'false'},
    ];
    // Load word definitions if available
  }

  @override
  void dispose() {
    _topicNameController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'EDIT TOPIC',
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'TOPIC NAME',
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () => showTopicNameEditDialog(context),
                    icon: const Icon(Icons.edit),
                    color: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _wordDefinitions.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _wordDefinitions.length) {
                      return AddWordDefinitionRow(onAdd: addWordDefinition);
                    } else {
                      final wordDefinition = _wordDefinitions[index];
                      return WordDefinitionRow(
                        word: wordDefinition['word']!,
                        definition: wordDefinition['definition']!,
                        onEdit: () => showWordEditDialog(context, index),
                        onListen: () => _speak(wordDefinition['word']!),
                        isStarred: wordDefinition['isStarred'] == 'true',
                        onMarkStar: () {
                          setState(() {
                            _wordDefinitions[index]['isStarred'] =
                                (wordDefinition['isStarred'] == 'true')
                                    ? 'false'
                                    : 'true';
                          });
                        },
                      );
                    }
                  },
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                ),
                icon: const Icon(Icons.check, color: Colors.white),
                label: const Text('Save', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addWordDefinition() {
    setState(() {
      _wordDefinitions.add({
        'word': 'English Word',
        'definition': 'Vietnamese Word',
        'isStarred': 'false',
      });
    });
  }

  void showTopicNameEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Topic Name'),
        content: TextField(
          controller: _topicNameController,
          decoration: const InputDecoration(labelText: 'Topic Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void showWordEditDialog(BuildContext context, int index) {
    final wordController = TextEditingController(text: _wordDefinitions[index]['word']!);
    final definitionController = TextEditingController(text: _wordDefinitions[index]['definition']!);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Word & Definition'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: wordController,
              decoration: const InputDecoration(labelText: 'ENGLISH'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: definitionController,
              decoration: const InputDecoration(labelText: 'VIETNAMESE'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _wordDefinitions[index]['word'] = wordController.text;
                _wordDefinitions[index]['definition'] = definitionController.text;
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _wordDefinitions.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class WordDefinitionRow extends StatelessWidget {
  final String word;
  final String definition;
  final VoidCallback onEdit;
  final VoidCallback onListen;
  final bool isStarred;
  final VoidCallback onMarkStar;

  const WordDefinitionRow({
    Key? key,
    required this.word,
    required this.definition,
    required this.onEdit,
    required this.onListen,
    required this.isStarred,
    required this.onMarkStar,
  }) : super(key: key);

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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      word,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '($definition)',
                      style: const TextStyle(fontSize: 16),
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
              Column(
                children: [
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: onListen,
                    icon: const Icon(Icons.volume_up_outlined),
                  ),
                  IconButton(
                    icon: Icon(
                      isStarred ? Icons.star : Icons.star_outline,
                      color: isStarred ? Colors.yellow : null,
                    ),
                    onPressed: onMarkStar,
                  ),
                ],
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
          ),
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

class Topic {
  final String name;

  const Topic({required this.name});
}
