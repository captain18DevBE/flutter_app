import 'package:flutter/material.dart';

class TypePage extends StatefulWidget {

  const TypePage({Key? key}) : super(key: key);

  @override
  State<TypePage> createState() => _TypePageState();
}

class _TypePageState extends State<TypePage> {
  final TextEditingController _controller = TextEditingController();
  String answer = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Type'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('VIETNAMESE WORD'),
            SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter the English word',
              ),
              onSubmitted: (text) {
                if (text.toLowerCase() == answer.toLowerCase()) {
                  //show applause
                } else {
                  //notify incorrect and show correct answer
                }
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {

              },
              child: Text('Check Answer'),
            ),
          ],
        ),
      ),
    );
  }
}

//decorate
//complete function and create test list