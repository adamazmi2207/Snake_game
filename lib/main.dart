//import 'package:destini_challenge_starting/story_brain.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './screens/snake_game.dart';

void main() => runApp(Destini());

class Destini extends StatefulWidget {
  @override
  _DestiniState createState() => _DestiniState();
}

class _DestiniState extends State<Destini> {
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          buttonBarTheme: ButtonBarThemeData(
            alignment: MainAxisAlignment.spaceAround,
          ),
          textTheme:
              GoogleFonts.pressStart2pTextTheme(Theme.of(context).textTheme)),
      debugShowCheckedModeBanner: false,
      home: SnakeGame(),
    );
  }
}
