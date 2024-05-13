
import 'package:english_learning_app/pages/menu_topic/action_topics.dart';
import 'package:english_learning_app/pages/setup_root/all_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class MultipleTest extends StatefulWidget {
  const MultipleTest({super.key});

  @override
  State<MultipleTest> createState() => _MultipleTestState();
}

class _MultipleTestState extends State<MultipleTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Multiple Choise", style: TextStyle(color: Colors.white),),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 5,
        backgroundColor: Colors.blue[700],
        centerTitle: true,
        shadowColor: Colors.black,
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.close),
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

      ),

      body: Container(
        // color: Color.fromARGB(255, 226, 226, 226),
        child: Column(
          children: [
            Container(
            margin: EdgeInsets.fromLTRB(0, 8, 0, 0),

            // width: double.infinity,
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
              margin: EdgeInsets.fromLTRB(20, 8, 20, 0),
              alignment: Alignment.centerLeft,
              height: 200,
              width: double.infinity,
              child: Text("2. Con gà tiếng anh là gì?", style: TextStyle(fontSize: 20),),
            ),

            GestureDetector(
              child: Container(
                margin: EdgeInsets.fromLTRB(60, 20, 60, 0),
                height: 80,
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
                    Text("Ôn luyện bằng chế độ học", textAlign:  TextAlign.center,style: TextStyle(color:Colors.black, fontSize: 18.0, fontWeight: FontWeight.normal, ),)

                )
              ),
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => FlashCardPage()));
              },
            ),
                      
            GestureDetector(
              child: Container(
                margin: EdgeInsets.fromLTRB(60, 20, 60, 0),
                height: 80,
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
                    Text("Ôn luyện bằng chế độ học", textAlign:  TextAlign.center,style: TextStyle(color:Colors.black, fontSize: 18.0, fontWeight: FontWeight.normal, ),)

                )
              ),
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) {}));
              },
            ),
            GestureDetector(
              child: Container(
                margin: EdgeInsets.fromLTRB(60, 20, 60, 0),
                height: 80,
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
                    Text("Ôn luyện bằng chế độ học", textAlign:  TextAlign.center,style: TextStyle(color:Colors.black, fontSize: 18.0, fontWeight: FontWeight.normal, ),)

                )
              ),
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) {}));
              },
            ),
            GestureDetector(
              child: Container(
                margin: EdgeInsets.fromLTRB(60, 20, 60, 0),
                height: 80,
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
                    Text("Ôn luyện bằng chế độ học", textAlign:  TextAlign.center,style: TextStyle(color:Colors.black, fontSize: 18.0, fontWeight: FontWeight.normal, ),)

                )
              ),
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) {}));
                showAlertDialog(context);
              },
            ),
          ],
        ),
      ),

      
    );
  }
  showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {

        final alertWrong = AlertDialog(
          title: Text('Thông báo'),
          content: Text('Đây là thông báo kiểm tra trắc nghiệm.'),
        );
        
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pop();
        });
        return alertWrong;
      },
    );
  }
}