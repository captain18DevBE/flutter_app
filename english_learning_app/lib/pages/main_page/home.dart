import 'package:english_learning_app/controllers/UserAuthController.dart';
import 'package:english_learning_app/pages/folder/create_folder.dart';
import 'package:english_learning_app/pages/main_page/library.dart';
import 'package:english_learning_app/pages/learn_multiple_choise/multiple_test.dart';
import 'package:english_learning_app/pages/main_page/login.dart';
import 'package:english_learning_app/pages/main_page/explored_library.dart';
import 'package:english_learning_app/pages/menu_topic/learning.dart';
import 'package:english_learning_app/pages/main_page/profile.dart';
import 'package:english_learning_app/pages/learn_flash_card/flashcard.dart';
import 'package:english_learning_app/pages/main_page/signup.dart';
import 'package:english_learning_app/pages/topics/create_topic.dart';
import 'package:english_learning_app/pages/type.dart';
import 'package:english_learning_app/pages/topics/edit_topic.dart';
import 'package:english_learning_app/pages/main_page/library.dart';
import 'package:english_learning_app/pages/view_settings/main_setting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserAuthController _userAuthController = new UserAuthController();
  User? _currentUser;
  String? _username;
  String? _useremail;
  String? _urlPhotoAvatar;

  int _selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _currentUser = _userAuthController.getCurrentUser()!;

    _username = _currentUser?.displayName;
    _useremail = _currentUser?.email;
    _urlPhotoAvatar = _currentUser?.photoURL;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      Learning(),
      ExploredPage(),
      HomePage(),
      LibraryPage(),
      SettingPage(),
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
          // "English Learning App",
          headingPage(),
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
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.transparent),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // User Avatar
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                          _urlPhotoAvatar ?? "https://drive.google.com/file/d/1S_t4qHw4dgLMmJHEfcFcPkXDX2fpwYMF/view?usp=sharing"),
                        ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _username ?? 'TLDuyk2',
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          // Email
                          Text(
                            _useremail ?? 'tlduy@gmail.com',
                            style: const TextStyle(
                            color: Colors.white, fontSize: 15
                            ),
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
                    title: Text('Your Library'),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfilePage())),
                  ),
                  ListTile(
                    title: Text('Log out'),
                    onTap: logOut 
                      
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

  void logOut() {
    _userAuthController.signOut();
    Navigator.push(context, MaterialPageRoute( builder: (context) => const LoginPage()));
  }

  String headingPage() {
    String heading = "English App";

    if(_selectedIndex == 0) {
      heading = "Home";
    } else if (_selectedIndex == 1) {
      heading = "Explored";
    } else if (_selectedIndex == 3) {
      heading = "Library";
    } else {
      heading = "Settings";
    }
    return heading;
  }
}


