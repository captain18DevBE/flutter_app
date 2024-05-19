import 'package:english_learning_app/controllers/LibraryController.dart';
import 'package:english_learning_app/controllers/StatusLearningController.dart';
import 'package:english_learning_app/controllers/TopicController.dart';
import 'package:english_learning_app/controllers/UserAuthController.dart';
import 'package:english_learning_app/controllers/UserController.dart';
import 'package:english_learning_app/models/Library.dart';
import 'package:english_learning_app/models/StatusLearning.dart';
import 'package:english_learning_app/models/Topic.dart';
import 'package:english_learning_app/pages/folder/view_folder.dart';
import 'package:english_learning_app/pages/learn_flash_card/flashcard.dart';
import 'package:english_learning_app/pages/learn_flash_card/reusable_card.dart';
import 'package:english_learning_app/pages/main_page/library.dart';
import 'package:english_learning_app/pages/menu_topic/learning.dart';
import 'package:english_learning_app/pages/setup_root/all_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

class HomeLibrary extends StatefulWidget {
  const HomeLibrary({super.key});

  @override
  State<HomeLibrary> createState() => _HomeLibraryState();
}

class _HomeLibraryState extends State<HomeLibrary> {
  List<Topic> _topics = [];
  List<Library> _folders = [];
  StatusLearning statusLearning = new StatusLearning(
      id: 0,
      topicId: 0,
      createBy: 'createBy',
      cardMomorized: <int>[],
      learned: <int>[],
      memorized: <int>[]);

  final TopicController _topicController = TopicController();
  final UserController _userController = UserController();
  final LibraryController _folderController = LibraryController();
  final StatusLearningController _statusLearningController =
      StatusLearningController();
  final UserAuthController _userAuthController = new UserAuthController();

  late User _user;
  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
    _loadTopics();
    _loadFolders();
  }

  Future<void> _fetchCurrentUser() async {
    User? tmp = await _userAuthController.getCurrentUser();
    if (tmp != null) {
      setState(() {
        _user = tmp;
      });
    }
  }

  Future<void> _loadFolders() async {
    final folders = await _folderController.readLibraryByEmailUserOwner();
    setState(() {
      _folders = folders;
      print(_folders);
    });
  }

  Future<void> _loadTopics() async {
    final topics = await _topicController.readTopicByEmailUserOwner();
    setState(() {
      _topics = topics;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
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
                      Image.asset(
                        "assets/logo.png",
                        height: 40,
                      ),
                      Container(
                        child: Text("Thư viện của bạn",
                            style:
                                TextStyle(color: Colors.black, fontSize: 15)),
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.white, // Màu viền
                            width: 1, // Độ dày viền
                          ),
                        ),
                      ),
                      Icon(
                        Icons.notifications,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(25, 25, 25, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("List favourite cards yourself!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.blue)),
                    GestureDetector(
                      child: Text(
                        "Xem tất cả",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: mainColor),
                      ),
                      onTap: () {}
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 300,
                child: PageView.builder(
                  itemCount: 4,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        child: Stack(children: [
                      FlipCard(
                        direction: FlipDirection.VERTICAL,
                        front: ReusableCard(text: 'Chicken'),
                        back: ReusableCard(text: 'Con ga'),
                      ),
                      Positioned(
                        bottom: 50,
                        right: 50,
                        child: GestureDetector(
                          child: Container(
                              child: Icon(
                            Icons.pages_rounded,
                            color: mainColor,
                          )),
                          onTap: () {
                            // Navigator.push(context,
                            //   MaterialPageRoute(builder: (context) => FlashCardPage(topicId: 1,))
                            // );
                          },
                        ),
                      ),
                    ]));
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(25, 25, 25, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("List folders yourself!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.blue)),
                    GestureDetector(
                      child: Text(
                        "Xem tất cả",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: mainColor),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LibraryPage()));
                      },
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 200,
                child: PageView.builder(
                  itemCount: _folders.length,
                  itemBuilder: (BuildContext context, int index) {
                    final folder = _folders[index];
                    return Container(
                      margin: EdgeInsets.fromLTRB(25, 20, 25, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          loadLibraryPage(folder.id);
                        },
                        child: Container(
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(15, 5, 15, 0),
                                  width: double.infinity,
                                  child: Text(folder.title),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(15, 5, 15, 0),
                                  alignment: Alignment.bottomLeft,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        backgroundImage:
                                            AssetImage("assets/demo.jpg"),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(_user.email ??
                                            "emailuser@gmail.com"),
                                      ),
                                      Container(
                                        width: 40,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(25, 25, 25, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("List topics yourself!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.blue)),
                    GestureDetector(
                      child: Text(
                        "Xem tất cả",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: mainColor),
                      ),
                      onTap: () {},
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 200,
                child: PageView.builder(
                  itemCount: _topics.length,
                  itemBuilder: (BuildContext context, int index) {
                    final topic = _topics[index];
                    return Container(
                      margin: EdgeInsets.fromLTRB(25, 20, 25, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          loadTopicPage(topic.id);
                        },
                        child: Container(
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(15, 5, 15, 0),
                                  width: double.infinity,
                                  child: Text(topic.title),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(15, 5, 15, 0),
                                  alignment: Alignment.bottomLeft,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        backgroundImage:
                                            AssetImage("assets/demo.jpg"),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(_user.email ??
                                            "emailuser@gmail.com"),
                                      ),
                                      Container(
                                        width: 40,
                                      ),
                                    ],
                                  ),
                                ),
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
        ),
      ),
    );
  }

  void loadLibraryPage(int folderId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ViewFolderPage(folderId: folderId)));
  }

  void loadTopicPage(int topicId) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Learning(statusLearningId: statusLearning.id , topicId: topicId)));
  }
}
