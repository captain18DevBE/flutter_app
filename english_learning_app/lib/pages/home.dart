import 'package:english_learning_app/pages/create_folder.dart';
import 'package:english_learning_app/pages/create_topic.dart';
import 'package:english_learning_app/pages/library.dart';
import 'package:english_learning_app/pages/learn_multiple_choise/multiple_test.dart';
import 'package:english_learning_app/pages/main_page/explored_library.dart';
import 'package:english_learning_app/pages/menu_topic/learning.dart';
import 'package:english_learning_app/pages/profile.dart';
import 'package:english_learning_app/pages/learn_flash_card/flashcard.dart';
import 'package:english_learning_app/pages/signup.dart';
import 'package:english_learning_app/pages/type.dart';
import 'package:english_learning_app/pages/edit_topic.dart';
import 'package:english_learning_app/pages/library.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      Learning(),
      ExploredPage(),
      HomePage(),
      LibraryPage(),
      CreateFolderPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        }),
        title: Text(
          "English Learning App",
          style: TextStyle(color: Colors.white),
        ),
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
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
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
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 2) {
            _showCreateDialog(context);
          } else {
            setState(() => _selectedIndex = index);
          }
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded), label: 'Explored'),
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
            label: 'Create'
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

  void _showCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Create Topic'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreateTopicPage()));
                },
              ),
              ListTile(
                title: const Text('Create Folder'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreateFolderPage()));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
