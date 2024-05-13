
import 'package:english_learning_app/pages/learn_typing/typing_totals.dart';
import 'package:english_learning_app/pages/menu_topic/action_topics.dart';
import 'package:english_learning_app/pages/setup_root/all_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class TypingTest extends StatefulWidget {
  const TypingTest({super.key});

  @override
  State<TypingTest> createState() => _TypingTestState();
}

class _TypingTestState extends State<TypingTest> {

  double _point = 0.5;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


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
        
        child: Column(children: [
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
            margin: EdgeInsets.fromLTRB(25, 60, 25, 10),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
                  child: Text("Định nghĩa:", style: TextStyle(fontSize: 18),),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(25, 5, 25, 40),
                  child: Text("Con gà", style: TextStyle(fontStyle: FontStyle.italic, fontSize: 25),),
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                          decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Enter your answer',
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_circle_up_rounded)
                ],
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
                      Text("Kết thúc kiểm tra", textAlign:  TextAlign.center,style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold, ),)

                  )
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TypingTotalTest(point: _point)));
                },
            ),

              ],
            ),
          )
        ],),
      ),
    );
  }
}