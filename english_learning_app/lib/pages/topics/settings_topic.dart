import 'package:flutter/material.dart';


class TopicSettingPage extends StatefulWidget {
  final bool isPublic;
  final ValueChanged<bool> onSettingChanged;

  const TopicSettingPage({Key? key, required this.isPublic, required this.onSettingChanged}) : super(key: key);

  @override
  _TopicSettingPageState createState() => _TopicSettingPageState();
}

class _TopicSettingPageState extends State<TopicSettingPage> {
  late bool _isPublic;

  @override
  void initState() {
    super.initState();
    _isPublic = widget.isPublic;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'TOPIC SETTINGS',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 5,
        backgroundColor: Colors.blue[700],
        centerTitle: true,
        shadowColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Publicity',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 10,),
            DropdownButton<bool>(
              value: _isPublic,
              items: [
                DropdownMenuItem(
                  value: true,
                  child: Text('Public'),
                ),
                DropdownMenuItem(
                  value: false,
                  child: Text('Private'),
                ),
              ],
              onChanged: (bool? value) {
                setState(() {
                  _isPublic = value!;
                  widget.onSettingChanged(_isPublic);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
