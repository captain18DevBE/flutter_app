import 'package:flutter/material.dart';
import 'package:english_learning_app/models/Topic.dart';
import 'package:english_learning_app/controllers/TopicController.dart';

class TopicSettingPage extends StatefulWidget {
  final int topicId;

  const TopicSettingPage({required this.topicId});

  @override
  _TopicSettingPageState createState() => _TopicSettingPageState();
}

class _TopicSettingPageState extends State<TopicSettingPage> {
  late bool _isPublic = false;
  late Topic _topic;
  final TopicController _topicController = TopicController();

  @override
  void initState() {
    super.initState();
    _fetchTopic();
  }

  Future<void> _fetchTopic() async {
    try {
      _topic = await _topicController.getTopicById(widget.topicId);
      setState(() {
        _isPublic = _topic.isPublic;
      });
    } catch (error) {
      print('Error fetching topic: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'TOPIC SETTINGS',
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
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Publicity',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 10),
            DropdownButton<bool>(
              value: _isPublic,
              items: [
                DropdownMenuItem(
                  value: true,
                  child: Text('Public'),
                ),
                DropdownMenuItem(
                  value: false,
                  child: Text('Private'),
                ),
              ],
              onChanged: (bool? value) {
                setState(() {
                  _isPublic = value!;
                  _updateTopicIsPublic(value);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _updateTopicIsPublic(bool isPublic) async {
    try {
      _topic.isPublic = isPublic;
      await _topicController.updateTopic(_topic);
      _showSnackBar(isPublic);
    } catch (error) {
      print('Error updating topic: $error');
    }
  }

  void _showSnackBar(bool isPublic) {
    final snackBar = SnackBar(
      content: Text(isPublic ? 'Topic set to Public' : 'Topic set to Private'),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
