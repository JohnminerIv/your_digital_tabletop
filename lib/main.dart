// Needed to make things look pretty
import 'package:flutter/material.dart';

// Needed to make things look pretty
import 'package:flutter/rendering.dart';

import 'index.dart';
import 'utilities.dart';

void main() {
  // Start up our application
  runApp(DigitalTableTopApp());
}

class DigitalTableTopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Create our directories for storing character and campaign data if they don't exist yet
    createDirectory('/playerAssets/characters');
    createDirectory('/playerAssets/campaigns');
    return MaterialApp(
        title: "Digital Tabletop",
        theme: ThemeData(
            primarySwatch: Colors.amber,
            primaryColor: Color(0xffF5A300),
            accentColor: Color(0xffC77E63),
            scaffoldBackgroundColor: Color(0xff9859C5),
            buttonColor: Color(0xffC77E63),
            visualDensity: VisualDensity.adaptivePlatformDensity),
        home: DigitalTableTopHome(title: "Digital TableTop"));
  }
}
