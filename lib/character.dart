import 'dart:collection';
import 'dart:convert' show jsonDecode;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'utils.dart';
import 'race.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

class PlayerCharacters extends StatefulWidget {
  final String title = "Characters";

  @override
  _PlayerCharacters createState() => _PlayerCharacters();
}

class _PlayerCharacters extends State<PlayerCharacters> {
  List characters = ["John", "Zo"];
  Directory dir;
  List<FileSystemEntity> files;




  @override
  void initState() {
    super.initState();
    /*to store files temporary we use getTemporaryDirectory() but we need
    permanent storage so we use getApplicationDocumentsDirectory() */
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = new Directory('${directory.path}/playerAssets/characters');
      files = dir.listSync();
      files.forEach((sE) {
        print(sE);
        setState(() {
          characters.add(sE.path);
        });
      });
    });
  }

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
