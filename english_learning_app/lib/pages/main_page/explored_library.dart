import 'package:english_learning_app/models/Topic.dart';
import 'package:english_learning_app/pages/menu_topic/learning.dart';
import 'package:english_learning_app/pages/setup_root/all_constants.dart';
import 'package:english_learning_app/controllers/TopicController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ExploredPage extends StatefulWidget {
  const ExploredPage({super.key});

  @override
  State<ExploredPage> createState() => _ExploredPageState();
}

class _ExploredPageState extends State<ExploredPage> {
  final TopicController _topicController = TopicController();
  late List<Topic> _allTopics;
  late List<Topic> _filteredTopics;

  @override
  void initState() {
    super.initState();
    _filteredTopics = [];
    _allTopics = [];
    fetchTopics();
  }

  Future<void> fetchTopics() async {
    try {
      List<Topic> topics = await _topicController.readTopicPublic();
      setState(() {
        _allTopics = topics;
        _filteredTopics = topics;
      });
    } catch (error) {
      print('Error fetching topics: $error');
    }
  }

  void _filterTopics(String query) {
  setState(() {
    _filteredTopics = _allTopics.where((topic) {
      final words = topic.title.split(' ');

      return words.any((word) =>
          word.toLowerCase().startsWith(query.toLowerCase()));
    }).toList();
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 70,
            color: mainColor,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset("assets/logo.png", height: 40,),
                  Container(
                    child: Text("Thư viện cộng đồng", style: TextStyle(color: Colors.black, fontSize: 15)),
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(10), 
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                  ),
                  Icon(Icons.notifications, color: Colors.white,),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(25, 20, 25, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
            ),
            child: TextField(
              onChanged: _filterTopics,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.find_in_page_outlined),
                hintText: "Tìm kiếm học phần...",
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(25, 25, 25, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Các học phần mới", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                GestureDetector(
                  child: Text("Xem tất cả", style: TextStyle(fontWeight: FontWeight.bold, color: mainColor)),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredTopics.length,
              itemBuilder: (context, index) {
                Topic topic = _filteredTopics[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Learning(
                          statusLearningId: 1, // Update as necessary
                          topicId: topic.id,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(25, 10, 25, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(topic.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(topic.description!),
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage("assets/demo.jpg"),
                              ),
                              SizedBox(width: 10),
                              Text(topic.createBy),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

