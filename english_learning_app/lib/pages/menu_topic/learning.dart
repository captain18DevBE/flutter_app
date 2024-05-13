import 'dart:ffi';

import 'package:english_learning_app/pages/learn_multiple_choise/multiple_test.dart';
import 'package:english_learning_app/pages/learn_typing/typing_test.dart';
import 'package:english_learning_app/pages/menu_topic/action_topics.dart';
import 'package:english_learning_app/pages/setup_root/all_constants.dart';
import 'package:english_learning_app/pages/learn_flash_card/flashcard.dart';
import 'package:english_learning_app/pages/learn_flash_card/reusable_card.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Learning extends StatefulWidget {
  const Learning({super.key});

  @override
  State<Learning> createState() => _LearningState();
}

class _LearningState extends State<Learning> {

  final PageController _pageController = new PageController();

  late int _activePage = 2;

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
                Navigator.pop(context);              
              },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        );
        }),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_horiz),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder:(context) => ActionTopic()));
            }
          ), 
        ],
        title: Text("Leaning", style: TextStyle(color: Colors.white),),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 5,
        backgroundColor: Colors.blue[700],
        centerTitle: true,
        shadowColor: Colors.black,
      ),

      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
                SizedBox(
                      width: 450,
                      height: 300,
                      child: 
                      PageView.builder(
                        controller: _pageController,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              FlipCard(
                                direction: FlipDirection.VERTICAL,
                                front: ReusableCard(
                                    text: 'Con ga'
                                    ),
                                back: ReusableCard(
                                    text: 'Chicken'),
                                
                                ),

                                Positioned(
                                  bottom: 50,
                                  right: 50,
                                  child: GestureDetector(
                                    child: Container(
                                      child: Icon(Icons.pages_rounded, color: mainColor,)
                                    ),
                                    onTap: () {
                                        Navigator.push(context, 
                                          MaterialPageRoute(builder: (context) => const FlashCardPage())
                                        );
                                    },
                                  ),
                                ),

                              ]
                          );
                        }
                        )
                  ),
                  
              
              Positioned(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<Widget>.generate(
                        5, 
                        (index) => Padding(
        
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: InkWell(
                            onTap: () {
                              _pageController.animateToPage(index, duration: Duration(microseconds: 300), curve: Curves.ease);
                            },
                            child: CircleAvatar(
                              radius: 3,
                              backgroundColor: index == _activePage ? mainColor : Colors.grey,
                            
                            ),
                          ),
                          
                        )
                      ),
                  ),
                  
                ),
                  
              ),
        
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(20, 10, 0, 10),
                      child: Text("Tile Topic: Test UI", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19, color: mainColor),),
                    ),
                  ),
        
                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                      color: mainColor, // Màu của viền
                      width: 2, // Độ rộng của viền
                    ),
                    ),
                    child: Center(
                      child: Icon(Icons.save,color: mainColor,)),
                    ),
                  
                ],
              ),
        
              Container(
                margin: EdgeInsets.fromLTRB(20, 20, 20, 5),
                child: Row(children: [
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
                  Text("Số lượng thẻ")
                ],),
              ),
        
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(20, 5, 0, 5),
                child: Text("Mô tả học phần"),
              ),

              Container(
                margin: EdgeInsets.fromLTRB(20, 5, 20, 20),
                
                child: Column(
                  children: [
                  GestureDetector(
              child: Container(
                height: 50,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  gradient: LinearGradient(colors: <Color>[
                    Color(0xFF42A5F5),
                    Color.fromARGB(255, 117, 193, 255),
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                    ),
                    Icon(Icons.crop_landscape_rounded, color: Colors.white),
                    Container(
                      width: 10,
                    ),
                    Text("Thẻ ghi nhớ", style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold, ),)
                  ],
                )
              ),
              onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FlashCardPage()));
                
              },
            ),
                      ],),
                  ),
            Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                
                child: Column(
                  children: [
                  GestureDetector(
              child: Container(
                height: 50,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  gradient: LinearGradient(colors: <Color>[
                    Color(0xFF42A5F5),
                    Color.fromARGB(255, 117, 193, 255),
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                    ),
                    Icon(Icons.book_outlined, color: Colors.white),
                    Container(
                      width: 10,
                    ),
                    Text("Học", style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold, ),)
                  ],
                )
              ),
              onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MultipleTest()));
                
              },
            ),
                      ],),
                  ),

            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
              
              child: Column(
                children: [
                GestureDetector(
                child: Container(
                  height: 50,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gradient: LinearGradient(colors: <Color>[
                      Color(0xFF42A5F5),
                      Color.fromARGB(255, 117, 193, 255),
                    ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                      ),
                      Icon(Icons.text_snippet, color: Colors.white),
                      Container(
                        width: 10,
                      ),
                      Text("Kiểm tra", style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold, ),)
                    ],
                  )
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TypingTest()));
                },
            ),
                      ],),
                  ),

            Container(
              margin: EdgeInsets.fromLTRB(25, 5, 20, 0),
              alignment: Alignment.centerLeft,
              child: Text("Thuật ngữ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
            ),

            Container(

              margin: EdgeInsets.fromLTRB(25, 5, 25, 5),  
              
              child: Column(children: [
                Container(
                  width: double.infinity,
                  height: 90,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white
                  ),

                  child: Column(children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(25, 5, 25, 5),  
                            child: Text("Tieng anh", style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),),
                          ),
                        ),

                        GestureDetector(
                          onTap: () {

                          },
                          child: Icon(Icons.volume_up, color: Colors.grey,),
                        ),
                        
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GestureDetector(
                            
                            onTap: () {
                          
                            },
                            child: Icon(Icons.star, color: Colors.grey,),
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(25, 0, 25, 5), 
                      alignment: Alignment.centerLeft,
                      child: Text("Nghia cua the", style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),),
                    )


                  ],),
                ),
                Container(
                  width: double.infinity,
                  height: 80,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white
                  ),

                  child: Column(children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(25, 5, 25, 5),  
                            child: Text("Tieng anh", style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),),
                          ),
                        ),

                        GestureDetector(
                          onTap: () {

                          },
                          child: Icon(Icons.volume_up, color: Colors.grey,),
                        ),
                        
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GestureDetector(
                            
                            onTap: () {
                          
                            },
                            child: Icon(Icons.star, color: Colors.grey,),
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(25, 0, 25, 5), 
                      alignment: Alignment.centerLeft,
                      child: Text("Nghia cua the", style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),),
                    )

                    
                  ],),
                ),
                
              ],),
            ),
            
            
            ],),
          ),
      ),
    );
  }
}