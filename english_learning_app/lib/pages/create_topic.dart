import 'package:flutter/material.dart';

class CreateTopicPage extends StatefulWidget {
  @override
  _CreateTopicPageState createState() => _CreateTopicPageState();
}

class _CreateTopicPageState extends State<CreateTopicPage> {
  final _topicNameController = TextEditingController();
  List<Map<String, String>> _wordDefinitions =
      [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    //  appBar: AppBar(
    //    title: const Text('Create Topic'),
    //  ),
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
                controller: _topicNameController,
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white
                    )
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white
                    )
                  ),
                  labelText: 'TOPIC NAME',
                  labelStyle: TextStyle(color: Colors.white)
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _wordDefinitions.length +
                      1,
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
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.check),
                label: const Text('Done'),
              ),
            ],
          ),
        ),
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
          child:
        Row(
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
        ),),
      ),
    );
  }
}



class AddWordDefinitionRow extends StatelessWidget {
  final VoidCallback onAdd;

  const AddWordDefinitionRow({Key? key, required this.onAdd}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onAdd,
      icon: const Icon(Icons.add, color: Colors.blue,),
      label: const Text('Add Word & Definition', style: TextStyle(color: Colors.blue)),
    );
  }
}
