
  import 'package:english_learning_app/models/Topic.dart';
import 'package:english_learning_app/pages/main_page/library.dart';
  import 'package:english_learning_app/pages/setup_root/all_constants.dart';
  import 'package:english_learning_app/pages/topics/edit_topic.dart';
  import 'package:english_learning_app/controllers/TopicController.dart';
import 'package:firebase_auth/firebase_auth.dart';
  import 'package:flutter/material.dart';

  class ActionTopic extends StatefulWidget {
    final int topicId;
    final String viewerEmail;

    const ActionTopic({required this.topicId, required this.viewerEmail});

    

  @override
  State<ActionTopic> createState() => _ActionTopicState();
}

class _ActionTopicState extends State<ActionTopic> {
    TopicController _topicController = TopicController();
    Topic? topic;
    String _userEmail = "";

    @override
  void initState() {
    super.initState();
    _getData(widget.topicId);
  }

    void _showSnackbar(String message) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.hideCurrentSnackBar();
    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

    Future<void> _getData(int topicId) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        _showSnackbar('Error: No logged in user');
        return;
      }
      _userEmail = currentUser.email!;
      _showSnackbar(_userEmail);
      
      topic = await _topicController.getTopicById(widget.topicId);
    } catch (error) {
      // Handle error
      print('Error loading topic data: $error');
    }
  }

  

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: mainColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Divider(
                color: Colors.white,
                thickness: 0.8,
              ),
              Container(
                height: 10,
              ),
              GestureDetector(
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                      ),
                      Icon(Icons.edit, color: Colors.white),
                      Container(
                        width: 10,
                      ),
                      Text("Sửa học phần", style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold, ),)
                    ],
                  )
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditTopicPage(topicId: this.widget.topicId)));
                },
              ),
              Container(
                height: 10,
              ),
              Divider(
                color: Colors.white,
                thickness: 0.8,
              ),
              Container(
                height: 10,
              )
              ,
              GestureDetector(
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                      ),
                      Icon(Icons.folder, color: Colors.white),
                      Container(
                        width: 10,
                      ),
                      Text("Thêm vào thư mục", style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold, ),)
                    ],
                  )
                ),
                onTap: () {
                  
                },
              ),
              Container(
                height: 10,
              ),
              Divider(
                color: Colors.white,
                thickness: 0.8,
              ),
              Container(
                height: 10,
              ),
              GestureDetector(
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                      ),
                      Icon(Icons.people, color: Colors.white),
                      Container(
                        width: 10,
                      ),
                      Text("Thêm vào lớp học", style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold, ),)
                    ],
                  )
                ),
                onTap: () {
                  
                },
              ),
              Container(
                height: 10,
              ),
              Divider(
                color: Colors.white,
                thickness: 0.8,
              ),
              Container(
                height: 10,
              ),
              GestureDetector(
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                      ),
                      Icon(Icons.save, color: Colors.white),
                      Container(
                        width: 10,
                      ),
                      Text("Lưu và chỉnh sửa", style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold, ),)
                    ],
                  )
                ),
                onTap: () {
                  
                },
              ),
              Container(
                height: 10,
              ),
              Divider(
                color: Colors.white,
                thickness: 0.8,
              ),
              Container(
                height: 10,
              ),
              GestureDetector(
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                      ),
                      Icon(Icons.ios_share, color: Colors.white),
                      Container(
                        width: 10,
                      ),
                      Text("Chia sẻ", style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold, ),)
                    ],
                  )
                ),
                onTap: () {
                  
                },
              ),
              Container(
                height: 10,
              ),
              Divider(
                color: Colors.white,
                thickness: 0.8,
              ),
              Container(
                height: 10,
              ),
              GestureDetector(
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                      ),
                      Icon(Icons.info_outline_rounded, color: Colors.white),
                      Container(
                        width: 10,
                      ),
                      Text("Thông tin học phần", style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold, ),)
                    ],
                  )
                ),
                onTap: () {
                  
                },
              ),
              Container(
                height: 10,
              ),
              Divider(
                color: Colors.white,
                thickness: 0.8,
              ),
              Container(
                height: 10,
              ),
              GestureDetector(
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                      ),
                      Icon(Icons.delete, color: Colors.white),
                      Container(
                        width: 10,
                      ),
                      Text("Xóa học phần", style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold, ),)
                    ],
                  )
                ),
                onTap: () {
                  
                },
              ),
              Container(
                height: 10,
              ),
              Divider(
                color: Colors.white,
                thickness: 0.8,
              ),
              Container(
                height: 30,
              ),
              GestureDetector(
                child: Container(
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Hủy", style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold, ),)
                    ],
                  )
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              Container(
                height: 50,
              ),
            ],
            ),
        ),
      );
    }
}