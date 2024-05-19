
import 'package:english_learning_app/pages/learn_flash_card/flashcard.dart';
import 'package:english_learning_app/pages/menu_topic/learning.dart';
import 'package:english_learning_app/pages/setup_root/all_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ExploredPage extends StatefulWidget {
  const ExploredPage({super.key});

  @override
  State<ExploredPage> createState() => _ExploredPageState();
}

class _ExploredPageState extends State<ExploredPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
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
                      child: Text("Thư viện cộng đồng", style: TextStyle(color: Colors.black, fontSize: 15)),
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
              margin: EdgeInsets.fromLTRB(25, 20, 25, 0),
              decoration: BoxDecoration(
                // color: Colors.yellow,
                borderRadius: BorderRadius.circular(30), 
                border: Border.all(
                  color: Colors.black, // Màu viền
                  width: 1, // Độ dày viền
                ),
              ),
              child: TextField(
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
                    child: Text("Xem tất cả", style: TextStyle(fontWeight: FontWeight.bold, color: mainColor),)
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Learning(statusLearningId: 1, topicId: 2,)));
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
            )
          ],
        ),
      ),
    );
  }
}