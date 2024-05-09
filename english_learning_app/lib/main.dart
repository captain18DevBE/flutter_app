import 'package:english_learning_app/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyAxHI5zRTGrS3s2FeyWJ0vM9H08hX7whe4',
      appId: 'flutterenglishapp',
      messagingSenderId: 'sendid',
      projectId: 'flutterenglishapp',
      storageBucket: 'flutterenglishapp.appspot.com',
    )

  );
  
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage()
    );
  }
}

