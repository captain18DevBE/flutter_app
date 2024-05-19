import 'package:english_learning_app/pages/topics/settings_topic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:english_learning_app/controllers/TopicController.dart';
import 'package:english_learning_app/controllers/CardsController.dart';
import 'package:english_learning_app/models/Cards.dart';
import 'package:english_learning_app/models/Topic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:english_learning_app/controllers/PersonalStarCardsController.dart';
import 'package:english_learning_app/models/PersonalStarCards.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditTopicPage extends StatefulWidget {
  final int topicId;

  const EditTopicPage({required this.topicId});

  @override
  _EditTopicPageState createState() => _EditTopicPageState();
}

class _EditTopicPageState extends State<EditTopicPage> {
  final _topicNameController = TextEditingController();
  List<Map<String, String>> _wordDefinitions = [];
  FlutterTts flutterTts = FlutterTts();

  final PersonalStarCardsController _personalStarCardsController = PersonalStarCardsController();
  final TopicController _topicController = TopicController();
  bool _isLoading = false;
  final CardsController _cardsController = CardsController();

  String? _userEmail;
  PersonalStarCards? _personalStarCards;

  @override
  void initState() {
    super.initState();
    flutterTts.setLanguage("en-US");
    _loadTopicData(widget.topicId);
  }

  Future<void> _loadTopicData(int topicId) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        _showSnackbar('Error: No logged in user');
        return;
      }
      _userEmail = currentUser.email!;
      
      final topic = await _topicController.getTopicById(topicId);
      final cards = await _cardsController.readCardsByTopicId(topicId);
      final starCardsSnapshot = await _personalStarCardsController.readPersonalStarCardByEmail(_userEmail!);

      /* if (starCardsSnapshot.docs.isNotEmpty) {
        final starCardDoc = starCardsSnapshot.docs.first;
        _personalStarCards = PersonalStarCards(
          id: starCardDoc['id'],
          createBy: starCardDoc['create_by'],
        );
        _personalStarCards?.lstStarCards = Map<int, dynamic>.from(starCardDoc['cards']);
      } else {
        // Create new PersonalStarCards for the user if not exist
        int starCardId = await _personalStarCardsController.amountPersonalStarCard() + 1;
        _personalStarCards = PersonalStarCards(
          id: starCardId,
          createBy: _userEmail!,
        );
        _personalStarCards?.lstStarCards = {};
        await _personalStarCardsController.addPersonalStarCards(_personalStarCards!);
      } */

      setState(() {
        _topicNameController.text = topic.title;
        _wordDefinitions = cards.map((card) {
          return {
            'id': card.id.toString(),
            'word': card.term,
            'definition': card.mean,
            'isStarred': /*_personalStarCards!.lstStarCards.containsKey(card.id) ?*/ 'false',
          };
        }).toList();
      });
    } catch (error) {
      // Handle error
      print('Error loading topic data: $error');
    }
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

  void _showSnackbar(String message) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.hideCurrentSnackBar();
    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<int> cardIds = [];
      for (var cardData in _wordDefinitions) {
        final card = Cards(
          id: int.parse(cardData['id']!),
          topicId: widget.topicId,
          term: cardData['word']!,
          mean: cardData['definition']!,
          createByUserEmail: _userEmail!,
          urlPhoto: '',
        );

        // Update the card and get the card ID
        await _cardsController.updateCardById(card);

        cardIds.add(int.parse(cardData['id']!));
      }

      final topic = Topic(
        id: widget.topicId,
        title: _topicNameController.text,
        description: '', // Add description field if needed
        createBy: _userEmail!, // Add createBy field if needed
        cards: cardIds,
      );

      await _topicController.updateTopicById(topic);

      // Update the star cards
      await _personalStarCardsController.updatePersonalStarCards(_personalStarCards!);

      print('Changes saved successfully');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Changes saved successfully')),
      );
    } catch (error) {
      print('Error saving changes: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving changes: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
    actions: [
      IconButton(
        icon: Icon(Icons.settings),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TopicSettingPage(topicId: widget.topicId),
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
    child: Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _topicNameController.text,
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
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _wordDefinitions.length + 1,
                itemBuilder: (context, index) {
                  if (index == _wordDefinitions.length) {
                    return AddWordDefinitionRow(onAdd: addWordDefinition);
                  } else {
                    final wordDefinition = _wordDefinitions[index];
                    return WordDefinitionRow(
                      word: wordDefinition['word']!,
                      definition: wordDefinition['definition']!,
                      onEdit: () => showWordEditDialog(
                        context,
                        index,
                        int.parse(wordDefinition['id'].toString()),
                      ),
                      onListen: () => _speak(wordDefinition['word']!),
                      isStarred: wordDefinition['isStarred'] == 'true',
                      onMarkStar: () => toggleStarStatus(index),
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
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _saveChanges();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
              icon: const Icon(Icons.check, color: Colors.white),
              label: const Text(
                'Done',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    ),
  ),
);

  }

  void addWordDefinition() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      _showSnackbar('Error: No logged in user');
      setState(() {
        _isLoading = false;
      });
      return;
    }
    String userEmail = currentUser.email!;

    int cardId = await _cardsController.amountCards() + 1;
    Cards card = Cards(
      id: cardId,
      topicId: widget.topicId,
      term: 'English Word',
      mean: 'Vietnamese Word',
      createByUserEmail: userEmail,
      urlPhoto: '',
    );

    await _cardsController.addCard(card);

    Topic topic = await _topicController.getTopicById(widget.topicId);

    List<int> cardList = topic.cards.toList();

    cardList.add(cardId);

    topic.cards = cardList;

    await _topicController.updateTopicById(topic);

    setState(() {
      _wordDefinitions.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
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

  void showWordEditDialog(BuildContext context, int index, int id) {
    final wordController =
        TextEditingController(text: _wordDefinitions[index]['word']!);
    final definitionController =
        TextEditingController(text: _wordDefinitions[index]['definition']!);

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
              User? currentUser = FirebaseAuth.instance.currentUser;
              if (currentUser == null) {
                _showSnackbar('Error: No logged in user');
                setState(() {
                  _isLoading = false;
                });
                return;
              }
              String userEmail = currentUser.email!;

              Cards card = Cards(
                id: id,
                topicId: widget.topicId,
                term: wordController.text,
                mean: definitionController.text,
                createByUserEmail: userEmail,
                urlPhoto: '',
              );
              _cardsController.updateCardById(card);
              setState(() {
                _wordDefinitions[index]['word'] = wordController.text;
                _wordDefinitions[index]['definition'] =
                    definitionController.text;
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () async {
              try {
                Topic topic = await _topicController.getTopicById(widget.topicId);
                List<int> cardList = topic.cards.toList();
                cardList.remove(id);
                topic.cards = cardList;
                await _topicController.updateTopicById(topic);
                await _cardsController.deleteCard(id);
                setState(() {
                  _wordDefinitions.removeAt(index);
                });
                Navigator.pop(context);
                _showSnackbar('Card deleted successfully');
              } catch (error) {
                _showSnackbar('Error deleting card: $error');
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void toggleStarStatus(int index) async {
  int cardId = int.parse(_wordDefinitions[index]['id']!);
  String userEmail = _userEmail!;

  bool isStarred = _wordDefinitions[index]['isStarred'] == 'true';

  setState(() {
    _wordDefinitions[index]['isStarred'] = (!isStarred).toString();
  });

  /* /* try {
    if (isStarred) {
      _personalStarCards!.lstStarCards.remove(cardId);
    } else {
      _personalStarCards!.lstStarCards[cardId] = {
        'word': _wordDefinitions[index]['word']!,
        'definition': _wordDefinitions[index]['definition']!,
      };
    } */

    await _personalStarCardsController.updatePersonalStarCards(_personalStarCards!);
  } catch (error) {
    print('Error toggling star status: $error');
    setState(() {
      _wordDefinitions[index]['isStarred'] = isStarred.toString();
    });
  } */
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
    required this.word,
    required this.definition,
    required this.onEdit,
    required this.onListen,
    required this.isStarred,
    required this.onMarkStar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            IconButton(
              onPressed: onListen,
              icon: const Icon(Icons.volume_up),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ENGLISH: $word'),
                  const SizedBox(height: 8),
                  Text('VIETNAMESE: $definition'),
                ],
              ),
            ),
            IconButton(
              onPressed: onEdit,
              icon: const Icon(Icons.edit),
            ),
            /* IconButton(
              onPressed: onMarkStar,
              icon: Icon(
                isStarred ? Icons.star : Icons.star_border,
                color: isStarred ? Colors.yellow : null,
              ),
            ), */
          ],
        ),
      ),
    );
  }
}

class AddWordDefinitionRow extends StatelessWidget {
  final VoidCallback onAdd;

  const AddWordDefinitionRow({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.8),
      child: ListTile(
        leading: const Icon(Icons.add),
        title: const Text('Add Word and Definition'),
        onTap: onAdd,
      ),
    );
  }
}
