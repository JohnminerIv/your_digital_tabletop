import 'dart:convert' show jsonDecode;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

class PlayerCharacters extends StatefulWidget {
  final String title = "Characters";

  @override
  _PlayerCharacters createState() => _PlayerCharacters();
}

class _PlayerCharacters extends State<PlayerCharacters> {
  List characters = ["John", "Zo"];

  Future<String> loadTextFromFile(path) async {
    return await rootBundle.loadString(path);
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

class PlayerCharacterRace extends StatefulWidget {
  final String title = "Races";
  final List<dynamic> racesJson;

  const PlayerCharacterRace({Key key, this.racesJson}) : super(key: key);

  @override
  _PlayerCharacterRace createState() => _PlayerCharacterRace();
}

class _PlayerCharacterRace extends State<PlayerCharacterRace> {
  var raceInfo;

  void setRaceInfo(index) {
    setState(() {
      if (raceInfo == null) {
        raceInfo = widget.racesJson[index];
      } else if (raceInfo["index"] == widget.racesJson[index]["index"]) {
        raceInfo = null;
      } else {
        raceInfo = widget.racesJson[index];
      }
    });
  }

  Column generateRaceLayout(index) {
    Column raceColumn = Column(
      children: [],
    );
    List<String> optionFields = [];
    raceInfo.forEach((k, v) {
      if (k.contains("options")) {
        optionFields.add(k);
      }
    });
    List<String> subraces = [];
    raceInfo["subraces"].forEach((m) {
      subraces.add(m["index"]);
    });
    for (var i = 0; i < optionFields.length; i++) {
      raceColumn.children.add(Row(children: [
        Text(optionFields[i]),
        FlatButton(onPressed: null, child: Icon(Icons.add))
      ]));
    }
    return raceColumn;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return Container(
                color: Colors.amber,
                child: (raceInfo == null || raceInfo != widget.racesJson[index])
                    ? Row(children: [
                        Text(widget.racesJson[index]['index']),
                        FlatButton(
                            onPressed: () {
                              setRaceInfo(index);
                            },
                            child: Icon(Icons.add))
                      ])
                    : Column(
                        children: [
                          Row(
                            children: [
                              Text(widget.racesJson[index]['index']),
                              FlatButton(
                                  onPressed: () {
                                    setRaceInfo(index);
                                  },
                                  child: Icon(Icons.add))
                            ],
                          ),
                          Row(
                            children: [generateRaceLayout(index)],
                          )
                        ],
                      ));
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
          itemCount: widget.racesJson.length),
    );
  }
}
