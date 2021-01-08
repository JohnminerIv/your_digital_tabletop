import 'dart:collection';
import 'dart:convert' show jsonDecode;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

import 'race.dart';

Future<String> loadTextFromFile(path) async {
  return await rootBundle.loadString(path);
}

class PlayerCharacter {
  var raceInfo = {};
  var raceInfoOptions = {};
  var classInfo = {};
  var classInfoOptions = {};
  var stats = {};
}

class PlayerCharacters extends StatefulWidget {
  final String title = "Characters";

  @override
  _PlayerCharacters createState() => _PlayerCharacters();
}

class _PlayerCharacters extends State<PlayerCharacters> {
  List characters = ["John", "Zo"];

  _addCharacter() {
    loadTextFromFile('assets/src/5e-SRD-Races.json').then(
        (data) => Navigator.push(context, MaterialPageRoute(builder: (context) {
              return PlayerCharacterRace(racesJson: jsonDecode(data));
            })));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView.separated(
        padding: const EdgeInsets.all(20.0),
        itemCount: characters.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 50,
            color: Colors.amber,
            child: Center(child: Text(characters[index])),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
      floatingActionButton: FloatingActionButton(
          tooltip: 'Increment',
          child: Icon(Icons.add),
          onPressed: () {
            _addCharacter();
          }),
    );
  }
}



