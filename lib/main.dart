import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'character.dart';

void main() {
  runApp(DigitalTableTopApp());
}

class DigitalTableTopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Digital Tabletop",
        theme: ThemeData(
            primarySwatch: Colors.amber,
            primaryColorLight: Colors.amberAccent,
            primaryColorDark: Colors.deepOrangeAccent,
            visualDensity: VisualDensity.adaptivePlatformDensity),
        home: DigitalTableTopHome(title: "Digital TableTop"));
  }
}

class DigitalTableTopHome extends StatelessWidget {
  final String title;

  const DigitalTableTopHome({Key key, this.title}) : super(key: key);

  FlatButton routeButton(BuildContext context, String buttonText, Widget page) {
    return FlatButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return page;
          }));
        },
        child: Text(buttonText));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            routeButton(context, "Characters", PlayerCharacters()),
            routeButton(context, "Campaign", Campaign()),
            routeButton(context, "Local Play", LocalPlay()),
            routeButton(context, "Homebrew", Homebrew())
          ],
        )));
  }
}

class Campaign extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class LocalPlay extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class Homebrew extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
