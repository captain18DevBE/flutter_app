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
    super.initState(); // Assuming we want users to type the English word
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
            Text('VIETNAMESE WORD'), // Display Vietnamese meaning
            SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter the English word',
              ),
              onSubmitted: (text) {
                // Implement logic to check answer and update UI
                if (text.toLowerCase() == answer.toLowerCase()) {
                  // Show correct message
                } else {
                  // Show incorrect message and optionally display the correct answer
                }
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implement logic to handle check answer button click (similar to onSubmitted)
              },
              child: Text('Check Answer'),
            ),
          ],
        ),
      ),
    );
  }
}
