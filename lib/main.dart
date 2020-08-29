//import 'package:destini_challenge_starting/story_brain.dart';
import 'package:flutter/material.dart';
import './screens/story_page.dart';
import './screens/settings_page.dart';
import './screens/home_page.dart';
import './screens/login_page.dart';
import './screens/snake_game.dart';

void main() => runApp(Destini());

class Destini extends StatefulWidget {
  @override
  _DestiniState createState() => _DestiniState();
}

class _DestiniState extends State<Destini> {
  int _bottomNavIndex = 0;
  final List<Widget> _screenOptions = [
    HomePage(),
    LoginPage(),
    StoryPage(),
    SettingsPage(),
  ];

  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: SnakeGame(),
      // home: Scaffold(
      //   body: _screenOptions[_bottomNavIndex],
      //   bottomNavigationBar: BottomNavigationBar(
      //       currentIndex: _bottomNavIndex,
      //       onTap: (int currentIndex) {
      //         setState(() {
      //           _bottomNavIndex = currentIndex;
      //         });
      //       },
      //       items: [
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.home),
      //           title: Text("Home"),
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.person),
      //           title: Text("Login"),
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.library_books),
      //           title: Text("Story"),
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.settings),
      //           title: Text("Setting"),
      //         ),
      //       ]),
      // ),
    );
  }
}

//TODO: Step 24 - Run the app and try to figure out what code you need to add to this file to make the story change when you press on the choice buttons.

//TODO: Step 29 - Run the app and test it against the Story Outline to make sure you've completed all the steps. The code for the completed app can be found here: https://github.com/londonappbrewery/destini-challenge-completed/
