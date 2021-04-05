// Needed for reading and writing to the file system
import 'dart:io';

// Needed to make things look pretty
import 'package:flutter/material.dart';

// Needed to make things look pretty
import 'package:flutter/rendering.dart';

// Finding the file paths to things
import 'package:path_provider/path_provider.dart';

// My lovely code for campaigns
import 'campaign.dart';

// My lovely code for characters
import 'character.dart';

void main() {
  runApp(DigitalTableTopApp());
}

class DigitalTableTopApp extends StatelessWidget {
  void createDirectories() {
    getApplicationDocumentsDirectory().then((Directory path) {
      final Directory charDir = new Directory(
          '${path.path}/playerAssets/characters'); // Path to created characters
      final Directory notesDir = new Directory(
          '${path.path}/playerAssets/campaigns'); // path to created campaigns
      return Future.wait(
          [charDir.exists(), Future.value(charDir), Future.value(notesDir)]);
    }).then((futures) {
      if (futures[0]) {
        print("The playerAssets path exists");
      } else {
        final Directory charDir = futures[1];
        final Directory notesDir = futures[2];
        print("The playerAssets path dose not exist");
        charDir.create(recursive: true);
        notesDir.create(recursive: true);
        print("playerAssets path created");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Create our directories for storing character and campaign data
    createDirectories();
    // Return our Material App
    return MaterialApp(
        title: "Digital Tabletop",
        theme: ThemeData(
            // Setting some theme data
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
  FlatButton pageButton(BuildContext context, String buttonText, Widget page) {
    return FlatButton(
      color: Theme.of(context).primaryColor,
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
        child: Container(
          height: 250,
          color: Theme.of(context).accentColor,
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              pageButton(context, "Characters", PlayerCharacters()),
              pageButton(context, "Campaign", Campaign()),
              pageButton(context, "Local Play", LocalPlay()),
              pageButton(context, "Homebrew", Homebrew())
            ],
          ),
        ),
      ),
    );
  }
}

class LocalPlay extends StatefulWidget {
  final String title = 'Local Play';

  @override
  _LocalPlay createState() => _LocalPlay();
}

class _LocalPlay extends State<LocalPlay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Text('Nothing to see here...'),
    );
  }
}

class Homebrew extends StatefulWidget {
  final String title = 'Home Brew';

  @override
  _HomeBrew createState() => _HomeBrew();
}

class _HomeBrew extends State<Homebrew> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Text('Nothing to see here...'),
    );
  }
}
