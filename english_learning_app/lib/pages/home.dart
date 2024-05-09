import 'package:english_learning_app/pages/profile.dart';
import 'package:english_learning_app/pages/flashcard.dart';
import 'package:english_learning_app/pages/quiz.dart';
import 'package:english_learning_app/pages/type.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 5,
        backgroundColor: Colors.blue[700],
        centerTitle: true,
        shadowColor: Colors.black,
      ),
      drawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: <Color>[
              Color(0xFF1976D2),
              Color(0xFF42A5F5),
              Color(0xFF90CAF9),
              Colors.white
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const DrawerHeader(
                decoration: BoxDecoration(color: Colors.transparent),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // User Avatar
                      const CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                            "https://placeimg.com/640/480/people"), // Replace with user's avatar URL
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'John Doe',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          // Email
                          Text(
                            'johndoe@example.com',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15),
                          )
                        ],
                      )
                      // Username
                    ])),
            Expanded(
                child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    title: Text('Profile'),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfilePage())),
                  ),
                  ListTile(
                    title: Text('Create Subject'),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfilePage())),
                  ),
                  ListTile(
                    title: Text('View Subjects Created'),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfilePage())),
                  ),
                ],
              ),
            )),
          ]),
        ),
      ),
      body: TypePage(),
      bottomNavigationBar: BottomNavigationBar(
        // <-- this will hide the label text for the unselected items
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, color: Colors.blue),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded), label: 'Subjects'),
          BottomNavigationBarItem(
            icon: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.blue, shape: BoxShape.circle),
                padding: const EdgeInsets.all(14),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
            label: '', // <-- set the label to an empty string
          ),
          const BottomNavigationBarItem(
              icon: Icon(Icons.my_library_books_outlined), label: 'Library'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.blue,
        unselectedLabelStyle: const TextStyle(color: Colors.grey),
      ),
    );
  }
}