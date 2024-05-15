import 'package:flutter/material.dart';

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
                  : Expanded(
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
                              onDelete: () => removeWordDefinition(index),
                            );
                          }
                        },
                      ),
                    ),
                    if (_wordDefinitions.length > 0)
              ElevatedButton.icon(
                onPressed: _createTopic,
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

  TextField _buildTextField({required TextEditingController controller, required String labelText}) {
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

  void _createTopic() {
    // Simulate a loading state
    setState(() {
      _isLoading = true;
    });

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
        Navigator.pop(context);
        _showSnackbar('Topic created successfully!');
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

class WordDefinitionRow extends StatelessWidget {
  final String word;
  final String definition;
  final VoidCallback onDelete;

  const WordDefinitionRow({
    Key? key,
    required this.word,
    required this.definition,
    required this.onDelete,
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
                  children: [
                    TextField(
                      controller: TextEditingController(text: word),
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(fontSize: 12),
                        labelText: 'ENGLISH',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: TextField(
                        controller: TextEditingController(text: definition),
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
                  onPressed: onDelete,
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

void main() {
  runApp(MaterialApp(home: CreateTopicPage()));
}
