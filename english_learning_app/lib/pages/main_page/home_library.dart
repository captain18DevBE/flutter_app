
import 'package:english_learning_app/pages/learn_flash_card/flashcard.dart';
import 'package:english_learning_app/pages/learn_flash_card/reusable_card.dart';
import 'package:english_learning_app/pages/main_page/library.dart';
import 'package:english_learning_app/pages/menu_topic/learning.dart';
import 'package:english_learning_app/pages/setup_root/all_constants.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

class HomeLibrary extends StatefulWidget {
  const HomeLibrary({super.key});

  @override
  State<HomeLibrary> createState() => _HomeLibraryState();
}

class _HomeLibraryState extends State<HomeLibrary> {
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
                      Image.asset("assets/logo.png", height: 40,),
        
                      Container(
                        child: Text("Thư viện của bạn", style: TextStyle(color: Colors.black, fontSize: 15)),
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(10), 
                          border: Border.all(
                            color: Colors.white, // Màu viền
                            width: 1, // Độ dày viền
                          ),
                      ),),
                      Icon(Icons.notifications, color: Colors.white,)
                    ],
                  ),
                ),
              ),
        
              
              Container(
                margin: EdgeInsets.fromLTRB(25, 25, 25, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
        
                    Text("List favourite cards yourself!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
                    GestureDetector(
                      child: Text("Xem tất cả", style: TextStyle(fontWeight: FontWeight.bold, color: mainColor),),
                      onTap: loadTopicPage,
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
                    child: Stack(
                            children: [
                              FlipCard(
                                direction: FlipDirection.VERTICAL,
                                front: ReusableCard(
                                    text: 'Chicken'
                                    ),
                                back: ReusableCard(
                                    text: 'Con ga'),
                                ),

                                Positioned(
                                  bottom: 50,
                                  right: 50,
                                  child: GestureDetector(
                                    child: Container(
                                      child: Icon(Icons.pages_rounded, color: mainColor,)
                                    ),
                                    onTap: () {
                                        // Navigator.push(context, 
                                        //   MaterialPageRoute(builder: (context) => FlashCardPage(topicId: 1,))
                                        // );
                                    },
                                  ),
                                ),

                              ])
                  );
                  },
                  
                ),
              ),

              Container(
                margin: EdgeInsets.fromLTRB(25, 25, 25, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
        
                    Text("List folders yourself!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
                    GestureDetector(
                      child: Text("Xem tất cả", style: TextStyle(fontWeight: FontWeight.bold, color: mainColor),),
                      onTap: loadLibraryPage,
                    )
                  ],
                ),
              ),
        
              Container(
                width: double.infinity,
                height: 200,
                child: PageView.builder(
                  itemCount: 4,
                  itemBuilder: (BuildContext context, int index) { 
                    
                    return Container(
                    // width: 200,
                    // height: 200,
                    margin: EdgeInsets.fromLTRB(25, 20, 25, 0),
                    decoration: BoxDecoration(
                      // color: Colors.yellow,
                      borderRadius: BorderRadius.circular(10), 
                      border: Border.all(
                        color: Colors.black, // Màu viền
                        width: 1, // Độ dày viền
                      ),
                    ),
                  
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Learning(statusLearningId: 2, topicId: 2,)));
                      },
                      child: Container(
                        // padding: const EdgeInsets.all(8.0),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(15, 5, 15, 0),
                              width: double.infinity,
                              child: Text("Từ vựng đồ ăn")),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(15, 5, 15, 0),
                              alignment: Alignment.bottomLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: AssetImage("assets/demo.jpg"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text("emailuser@gmail.com"),
                                  ),
                                  Container(
                                    width: 40,
                                  ),
                                  ],),
                            ),
                          ),
                        ],),
                      )
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
        
                    Text("List topics yourself!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
                    GestureDetector(
                      child: Text("Xem tất cả", style: TextStyle(fontWeight: FontWeight.bold, color: mainColor),),
                      onTap: loadTopicPage,
                    )
                  ],
                ),
              ),
        
              Container(
                width: double.infinity,
                height: 200,
                child: PageView.builder(
                  itemCount: 4,
                  itemBuilder: (BuildContext context, int index) { 
                    
                    return Container(
                    margin: EdgeInsets.fromLTRB(25, 20, 25, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), 
                      border: Border.all(
                        color: Colors.black, // Màu viền
                        width: 1, // Độ dày viền
                      ),
                    ),
                  
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Learning(statusLearningId: 2, topicId: 2,)));
                      },
                      child: Container(
                        // padding: const EdgeInsets.all(8.0),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(15, 5, 15, 0),
                              width: double.infinity,
                              child: Text("Từ vựng đồ ăn")),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(15, 5, 15, 0),
                              alignment: Alignment.bottomLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: AssetImage("assets/demo.jpg"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text("emailuser@gmail.com"),
                                  ),
                                  Container(
                                    width: 40,
                                  ),
                                  ],),
                            ),
                          ),
                        ],),
                      )
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

  void loadLibraryPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => LibraryPage()));
  }

  void loadTopicPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => LibraryPage()));
  }
}