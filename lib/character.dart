import 'dart:collection';
import 'dart:convert' show jsonDecode;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'utils.dart';
import 'dart:math';
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
  Directory dir;
  List<FileSystemEntity> files;

  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((Directory directory) {
      setState(() {
        dir = new Directory('${directory.path}/playerAssets/characters');
        files = dir.listSync();
      });
    });
  }

  _addCharacter() {
    loadTextFromFile('assets/src/5e-SRD-Races.json').then(
        (data) => Navigator.push(context, MaterialPageRoute(builder: (context) {
              return PlayerCharacterRace(racesJson: jsonDecode(data));
            })));
  }

  showCharacter(File file) {
    var jsonData = jsonDecode(file.readAsStringSync());
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PCSheet(json: jsonData);
    }));
  }

  @override
  Widget build(BuildContext context) {
    files = dir.listSync();
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView.separated(
        padding: const EdgeInsets.all(20.0),
        itemCount: files.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 50,
            color: Colors.lightBlueAccent,
            child: Center(
                child: Row(
              children: [
                Text(files[index].path.split("/").last),
                FlatButton(
                    onPressed: () {
                      showCharacter(files[index]);
                    },
                    child: Icon(Icons.folder_open))
              ],
            )),
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

class PCSheet extends StatefulWidget {
  final json;

  const PCSheet({Key key, this.json}) : super(key: key);

  @override
  _PCSheet createState() => _PCSheet(json);
}

class _PCSheet extends State<PCSheet> {
  var json;

  _PCSheet(this.json);

  var statsMods = {};

  buildBody() {
    statsMods = {};
    json["stats"].forEach((key, value) {
      statsMods[key] = ((value - 10) / 2).floor();
    });
    Column column = new Column(
      children: [],
    );
    column.children.add(Row(
      children: [
        Column(
          children: [Text("${json["currentHp"]}/${json["maxHp"]}"), Text("HP")],
        ),
        Column(
          children: [Text("${10 + statsMods["dex"]}"), Text("AC")],
        ),
        Column(
          children: [Text("${statsMods["dex"]}"), Text("Initiative")],
        ),
        Column(
          children: [Text("${json["hitDie"]}"), Text("Hit Die")],
        )
      ],
    ));
    column.children.add(Row(
      children: [
        Column(
          children: [Text("2"), Text("Prof Bonus")],
        ),
        Column(
          children: [Text("${json["speed"]}"), Text("Speed")],
        ),
        Column(
          children: [Text("${10 + statsMods["wis"]}"), Text("Pass Wis")],
        )
      ],
    ));
    column.children.add(Row(
      children: [
        Column(
          children: [Text("${statsMods["str"]}"), Text("Str")],
        ),
        Column(
          children: [Text("${statsMods["dex"]}"), Text("Dex")],
        ),
        Column(
          children: [Text("${statsMods["con"]}"), Text("Con")],
        )
      ],
    ));
    column.children.add(Row(
      children: [
        Column(
          children: [Text("${statsMods["int"]}"), Text("Int")],
        ),
        Column(
          children: [Text("${statsMods["wis"]}"), Text("Wis")],
        ),
        Column(
          children: [Text("${statsMods["cha"]}"), Text("Cha")],
        )
      ],
    ));
    return column;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("${json['name']}, ${json['race']} ${json['class']}"),
        ),
        body: buildBody());
  }
}
