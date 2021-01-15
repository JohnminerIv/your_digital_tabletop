import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

import 'campaign.dart';
import 'character.dart';

void main() {
  runApp(DigitalTableTopApp());
}

class DigitalTableTopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Override the Build method to create the player assets path which will
    // contain any files that they create.
    getApplicationDocumentsDirectory().then((Directory path) {
      final charDir = new Directory('${path.path}/playerAssets/characters');
      final notesDir = new Directory('${path.path}/playerAssets/campaigns');
      charDir.exists().then((isThere) {
        if (isThere) {
          print("The playerAssets path exists");
        } else {
          print("The playerAssets path dose not exist");
          charDir.create(recursive: true);
          notesDir.create(recursive: true);
          print("playerAssets path created");
        }
      });
    });
    return MaterialApp(
        title: "Digital Tabletop",
        theme: ThemeData(
            primarySwatch: Colors.amber,
            primaryColor: Color(0xffF5A300),
            accentColor: Color(0xffC77E63),
            scaffoldBackgroundColor: Color(0xff9859C5),
            visualDensity: VisualDensity.adaptivePlatformDensity),
        home: DigitalTableTopHome(title: "Digital TableTop"));
  }
}

class DigitalTableTopHome extends StatefulWidget {
  final String title;

  DigitalTableTopHome({Key key, this.title}) : super(key: key);

  @override
  _DigitalTableTopHome createState() => _DigitalTableTopHome();
}

class _DigitalTableTopHome extends State<DigitalTableTopHome> {
  FlatButton routeButton(BuildContext context, String buttonText, Widget page) {
    return FlatButton(
      color: Theme.of(context).accentColor,
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return page;
        }));
      },
      child: SizedBox(
        height: 40,
        width: 200,
        child: Center(
          child: Text(buttonText),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
        ),
      ),
    );
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
