
import 'package:english_learning_app/pages/learn_flash_card/flashcard.dart';
import 'package:english_learning_app/pages/learn_typing/typing_test.dart';
import 'package:english_learning_app/pages/menu_topic/action_topics.dart';
import 'package:english_learning_app/pages/menu_topic/learning.dart';
import 'package:english_learning_app/pages/setup_root/all_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TypingTotalTest extends StatefulWidget {

  final double point;

  const TypingTotalTest({required this.point,super.key});

  @override
  State<TypingTotalTest> createState() => _TypingTotalTestState();
}

class _TypingTotalTestState extends State<TypingTotalTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.close, size: 30,),
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
        title: Text("1/10", style: TextStyle(color: Colors.white),),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 5,
        backgroundColor: Colors.blue[700],
        centerTitle: true,
        shadowColor: Colors.black,
      ),

      body: Container(
        margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
        color: Color.fromARGB(255, 226, 226, 226),
        child: Column(
          children: [
            Container(
            child: 
            LinearPercentIndicator(

              animation: true,
              animationDuration: 1000,
              lineHeight: 8,
              percent: 0.5,

              progressColor: mainColor,
              backgroundColor: Colors.grey,
              
            ),
          ),

          Container(
            margin: EdgeInsets.fromLTRB(20, 8, 0, 20),
            alignment: Alignment.centerLeft,

            child: Column(
              children: [
                Container(
                  height: 25,
                ),
                Text("Bạn đang tiến bộ!", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                Container(
                  height: 10,
                ),
                Text("Kết quả của bạn:", style: TextStyle(fontSize: 19, fontStyle: FontStyle.italic),),
                Container(
                  height: 25,
                ),
                Row(
                  children: [
                    CircularPercentIndicator(
                      animation: true,
                      animationDuration: 100,
        
                      radius: 45,
                      lineWidth: 10,
                      percent: widget.point,
                      progressColor: mainColor,
                      circularStrokeCap: CircularStrokeCap.round,
                      center: Text("40%", style: TextStyle(color: mainColor),),

                    ),

                    Column(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(40, 0, 60, 10),
                                child: Text("Đúng : ", style: TextStyle(color: Colors.blue, fontSize: 20),),
                              ),

                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                                ),
                                child: Center(
                                  child: Text("0", style: TextStyle(color: Colors.blue, fontSize: 18),),
                              ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(40, 0, 60, 10),
                                child: Text("Sai    : ", style: TextStyle(color: Colors.red, fontSize: 20),),
                              ),

                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                  color: Colors.red, // Màu của viền
                                  width: 2, // Độ rộng của viền
                                ),
                                ),
                                child: Center(
                                  child: Text("0", style: TextStyle(color: Colors.red, fontSize: 18),),
                              ),
                              ),
                            ],
                          ),
                        ),

                        

                      ],
                    )
                  ]
                ),

                GestureDetector(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(60, 80, 60, 0),
                            height: 50,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: Colors.green
                              
                            ),
                            child: Center(
                              child: 
                                Text("Làm bài kiểm tra mới", textAlign:  TextAlign.center,style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold, ),)

                            )
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => TypingTest()));
                          },
                        ),

                GestureDetector(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(60, 20, 60, 0),
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: Colors.white,
                              border: Border.all(
                                width: 2,
                                color: Colors.grey
                              )
                            ),
                            child: Center(
                              child: 
                                Text("Ôn luyện bằng chế độ học", textAlign:  TextAlign.center,style: TextStyle(color:mainColor, fontSize: 18.0, fontWeight: FontWeight.bold, ),)

                            )
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => FlashCardPage()));
                          },
                        ),
              ],
            ),
          ),
          
          Container(
            margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
            alignment: Alignment.centerLeft,
            child: Column(

              children: [
                Container(
                  height: 60,
                  alignment: Alignment.centerLeft,
                  child: Text("Đáp án của bạn"),
                ),

                Container(
                  height: 120,
                  width: double.infinity,
                  
                  color: Colors.white,
                ),
                Container(
                  width: double.infinity,
                  height: 30,
                  color: Colors.blue,

                  child: Row(
                    children: [
                      Icon(Icons.close, color: Colors.white,),
                      Text("Đúng", style: TextStyle(color: Colors.white),)
                    ],
                  ),
                )
              ],
            ),
          )

        ],),
      ),
    );
  }
}