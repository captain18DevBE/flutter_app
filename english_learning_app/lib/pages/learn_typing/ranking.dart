
import 'package:english_learning_app/controllers/StatisticController.dart';
import 'package:english_learning_app/models/Statistic.dart';
import 'package:english_learning_app/pages/setup_root/all_constants.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class Ranking extends StatefulWidget {
  int topicId;
  int statisticId;
  double point;
  int statusLearningId;
  int amountUnMemoriedCard;
  int amountMemoricard;

  Ranking({
    required this.topicId, 
    required this.statusLearningId, 
    required this.amountMemoricard, 
    required this.amountUnMemoriedCard, 
    required this.statisticId, 
    required this.point, 
    super.key
  });

  @override
  State<Ranking> createState() => _RankingState();
}

class _RankingState extends State<Ranking> {

  final StatisticController _statisticController = new StatisticController();

  bool _showWidget = false;
  late List<Statistic> _statistic;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchListStatics();

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showWidget = true;
      });
    });
  }

  Future<void> fetchListStatics() async {
    List<Statistic> results = await _statisticController.readStatisticByTopicId(widget.topicId);

    setState(() {
      _statistic = results;
    });

    print(_statistic.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Ranking", style: TextStyle(color: Colors.white),),
        centerTitle: true,
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.close, size: 30, color: Colors.white,),
            onPressed: () {
              Navigator.pop(context);              
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        );
        }),
      ),

      body: Container(
        margin: EdgeInsets.fromLTRB(20, 8, 0, 20),
        alignment: Alignment.centerLeft,
        child: 
        Column(
          children: [
            Container(
                  height: 25,
                ),
            Text("Your Ranking", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
            Container(
              height: 10,
            ),
            Text("Congratulation: 13th", style: TextStyle(fontSize: 19, fontStyle: FontStyle.italic, color: Colors.green),),
            Container(
              height: 25,
              // margin: EdgeInsets.fromLTRB(50, 0, 0, 0),
            ),
                Row(
                  children: [
                    CircularPercentIndicator(
                      animation: true,
                      animationDuration: 100,
        
                      radius: 35,
                      lineWidth: 6,
                      percent: widget.point,
                      progressColor: mainColor,
                      circularStrokeCap: CircularStrokeCap.round,
                      center: Text((widget.point * 100).toString() + "%", style: TextStyle(color: mainColor),),

                    ),

                    Column(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 60, 10),
                                child: Text("True   : ", style: TextStyle(color: Colors.blue, fontSize: 17),),
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
                                  child: Text(_showWidget ? widget.amountMemoricard.toString() : "0", style: TextStyle(color: Colors.blue, fontSize: 18),),
                              ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 60, 10),
                                child: Text( "Failed: ", style: TextStyle(color: Colors.red, fontSize: 17),),
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
                                  child: Text(_showWidget ? (widget.amountUnMemoriedCard - widget.amountMemoricard).toString() : "0", style: TextStyle(color: Colors.red, fontSize: 18),),
                              ),
                              ),
                            ],
                          ),
                        ),



                      ],
                    )
                  ]
                ),

              Container(
                margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
                child: Text("Ranking all user:", style: TextStyle(fontSize: 20),),

              ),
              Container(
                height: 400,
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: ((context, index) {
                    
                  return detailCards(index);
                  
                  })
                ),
              )
          ],
        ),
      ),
    );
  }
  
  Widget detailCards(int index) {
    return Container(
      margin: EdgeInsets.fromLTRB(25, 10, 25, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), // Maintain rounded corners
        border: Border.all(
          color: Colors.green, // Set border color to black
          width: 1, // Set border width to 2 pixels (optional)
        ),
      ),
      width: double.infinity,

      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(25, 5, 25, 5),
                  child: Text(
                    _showWidget ? "Point: " + _statistic[index].percenRate.toString() : "Point: 0.0",
                    style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.fromLTRB(25, 0, 25, 5),
            alignment: Alignment.centerLeft,
            child: Text(
              _showWidget ? 'Username: '+ _statistic[index].createBy : 'username',
              style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
          )
        ],
      ),

    );
  }

}

