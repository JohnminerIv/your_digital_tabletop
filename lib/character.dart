import 'dart:collection';
import 'dart:convert' show jsonDecode;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

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

class PlayerCharacterRace extends StatefulWidget {
  final String title = "Races";
  final List<dynamic> racesJson;

  const PlayerCharacterRace({Key key, this.racesJson}) : super(key: key);

  @override
  _PlayerCharacterRace createState() => _PlayerCharacterRace();
}

class _PlayerCharacterRace extends State<PlayerCharacterRace> {
  PlayerCharacter playerCharacter = PlayerCharacter();

  _submitButton() {
    loadTextFromFile('assets/src/5e-SRD-Classes.json').then(
        (data) => Navigator.push(context, MaterialPageRoute(builder: (context) {
              return PlayerCharacterClass(
                  classesJson: jsonDecode(data),
                  playerCharacter: playerCharacter);
            })));
  }

  void setRaceInfo(index) {
    setState(() {
      if (playerCharacter.raceInfo == null) {
        playerCharacter.raceInfo = widget.racesJson[index];
      } else if (playerCharacter.raceInfo["index"] ==
          widget.racesJson[index]["index"]) {
        playerCharacter.raceInfo = {};
      } else {
        playerCharacter.raceInfo = widget.racesJson[index];
      }
    });
  }

  Column generateRaceLayout(index) {
    Column raceColumn = Column(
      children: [],
    );
    bool resetButtons = true;
    if (playerCharacter.raceInfoOptions.length == 0) {
      playerCharacter.raceInfoOptions = {
        "race": playerCharacter.raceInfo["index"]
      };
    } else if (playerCharacter.raceInfoOptions["race"] !=
        playerCharacter.raceInfo["index"]) {
      playerCharacter.raceInfoOptions = {
        "race": playerCharacter.raceInfo["index"]
      };
    } else {
      resetButtons = false;
    }
    print(playerCharacter.raceInfoOptions);
    print(resetButtons);
    playerCharacter.raceInfo.forEach((k, v) {
      if (k.contains("options")) {
        raceColumn.children.add(Row(
          children: [Text(k)],
        ));
        if (playerCharacter.raceInfoOptions[k] == null) {
          playerCharacter.raceInfoOptions[k] = {};
        }
        int choiceAmount = playerCharacter.raceInfo[k]["choose"];
        playerCharacter.raceInfoOptions[k]["choiceAmount"] = choiceAmount;
        raceColumn.children.add(Row(
          children: [Text("Choose $choiceAmount from: ")],
        ));

        for (var i = 0; i < playerCharacter.raceInfo[k]["from"].length; i++) {
          if (resetButtons == true) {
            playerCharacter.raceInfoOptions[k]
                [playerCharacter.raceInfo[k]["from"][i]["name"]] = false;
          }
          print(playerCharacter.raceInfoOptions[k]);
          raceColumn.children.add(Row(
            children: [
              Text(playerCharacter.raceInfo[k]["from"][i]["name"]),
              Checkbox(
                  value: playerCharacter.raceInfoOptions[k]
                      [playerCharacter.raceInfo[k]["from"][i]["name"]],
                  onChanged: (bool newValue) {
                    setState(() {
                      playerCharacter.raceInfoOptions[k]
                              [playerCharacter.raceInfo[k]["from"][i]["name"]] =
                          newValue;
                    });
                  })
            ],
          ));
        }
      }
    });
    raceColumn.children.add(Row(
      children: [Text("Subraces")],
    ));
    if (playerCharacter.raceInfo["subraces"].length == 0) {
      raceColumn.children.add(Row(
        children: [Text("No subclasses")],
      ));
    } else {
      if (playerCharacter.raceInfoOptions["subraces"] == null) {
        playerCharacter.raceInfoOptions["subraces"] = {};
      }
      playerCharacter.raceInfo["subraces"].forEach((m) {
        if (resetButtons == true) {
          playerCharacter.raceInfoOptions["subraces"][m["index"]] = false;
        }
        raceColumn.children.add(Row(
          children: [
            Text(m["index"]),
            Checkbox(
                value: playerCharacter.raceInfoOptions["subraces"][m["index"]],
                onChanged: (bool newValue) {
                  setState(() {
                    playerCharacter.raceInfoOptions["subraces"][m["index"]] =
                        newValue;
                  });
                })
          ],
        ));
      });
    }
    bool valid = true;
    playerCharacter.raceInfoOptions.forEach((key, value) {
      print(value.runtimeType);
      if (value is HashMap<dynamic, dynamic>) {
        int checkMarkCount = 0;
        value.forEach((secondkey, secondvalue) {
          if (secondvalue is bool) {
            if (secondvalue == true) {
              checkMarkCount++;
            }
          }
        });
        if (key == "subraces") {
          if (checkMarkCount != 1) {
            valid = false;
            if (value.length == 0) {
              valid = true;
            }
          } else {
            if (value["choiceAmount"] != checkMarkCount) {
              print(value["choiceAmount"]);
              print(checkMarkCount);
              valid = false;
            }
          }
        }
      }
    });
    raceColumn.children.add(Row(
      children: [
        FlatButton(
            onPressed: valid ? _submitButton() : null, child: Text("Submit"))
      ],
    ));
    return raceColumn;
  }

  @override
  Widget build(BuildContext context) {
    print(playerCharacter);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return Container(
                color: Colors.amber,
                child: (playerCharacter.raceInfo.length == 0 ||
                        playerCharacter.raceInfo != widget.racesJson[index])
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

class PlayerCharacterClass extends StatefulWidget {
  final title = "Classes";
  final List<dynamic> classesJson;
  final playerCharacter;

  const PlayerCharacterClass({Key key, this.classesJson, this.playerCharacter})
      : super(key: key);

  @override
  _PlayerCharacterClass createState() => _PlayerCharacterClass(
      classesJson: classesJson, playerCharacter: playerCharacter);
}

class _PlayerCharacterClass extends State<PlayerCharacterClass> {
  List<dynamic> classesJson;
  PlayerCharacter playerCharacter;

  void setClassInfo(index) {
    setState(() {
      if (playerCharacter.classInfo == null) {
        playerCharacter.classInfo = widget.classesJson[index];
      } else if (playerCharacter.raceInfo["index"] ==
          widget.classesJson[index]["index"]) {
        playerCharacter.classInfo = {};
      } else {
        playerCharacter.classInfo = widget.classesJson[index];
      }
    });
  }

  _submitButton() {
    loadTextFromFile('assets/src/5e-SRD-Classes.json').then(
        (data) => Navigator.push(context, MaterialPageRoute(builder: (context) {
              return PlayerCharacterClass(
                  classesJson: jsonDecode(data),
                  playerCharacter: playerCharacter);
            })));
  }

  Column generateClassLayout(index) {
    Column classColumn = Column(
      children: [],
    );
    bool resetButtons = true;
    if (playerCharacter.classInfoOptions.length == 0) {
      playerCharacter.classInfoOptions = {
        "class": playerCharacter.classInfo["index"]
      };
    } else if (playerCharacter.classInfoOptions["class"] !=
        playerCharacter.classInfo["index"]) {
      playerCharacter.classInfoOptions = {
        "class": playerCharacter.classInfo["index"]
      };
    } else {
      resetButtons = false;
    }
    playerCharacter.classInfo.forEach((k, v) {
      if (k.contains("options")) {
        classColumn.children.add(Row(
          children: [Text(k)],
        ));
        playerCharacter.classInfoOptions[k] = {};
        int choiceAmount = playerCharacter.classInfo[k]["choose"];
        playerCharacter.classInfoOptions[k]["choiceAmount"] = choiceAmount;
        classColumn.children.add(Row(
          children: [Text("Choose $choiceAmount from: ")],
        ));

        for (var i = 0; i < playerCharacter.classInfo[k]["from"].length; i++) {
          if (resetButtons == true) {
            playerCharacter.classInfoOptions[k]
                [playerCharacter.classInfo[k]["from"][i]["name"]] = false;
          }
          classColumn.children.add(Row(
            children: [
              Text(playerCharacter.classInfo[k]["from"][i]["name"]),
              Checkbox(
                  value: playerCharacter.classInfoOptions[k]
                      [playerCharacter.classInfo[k]["from"][i]["name"]],
                  onChanged: (bool newValue) {
                    setState(() {
                      playerCharacter.classInfoOptions[k][playerCharacter
                          .classInfo[k]["from"][i]["name"]] = newValue;
                    });
                  })
            ],
          ));
        }
      }
    });
    if (playerCharacter.classInfo["subclasss"].length == 0) {
      classColumn.children.add(Row(
        children: [Text("No subclasses")],
      ));
    } else {
      playerCharacter.classInfoOptions["subclasss"] = {};
      playerCharacter.classInfo["subclasss"].forEach((m) {
        if (resetButtons == true) {
          playerCharacter.classInfoOptions["subclasss"][m["index"]] = false;
        }
        classColumn.children.add(Row(
          children: [
            Text(m["index"]),
            Checkbox(
                value: playerCharacter.classInfoOptions["subclasss"]
                    [m["index"]],
                onChanged: (bool newValue) {
                  setState(() {
                    playerCharacter.classInfoOptions["subclasss"][m["index"]] =
                        newValue;
                  });
                })
          ],
        ));
      });
    }
    bool valid = true;
    playerCharacter.classInfoOptions.forEach((key, value) {
      if (value is Map) {
        int checkMarkCount;
        value.forEach((secondkey, secondvalue) {
          if (secondvalue is bool) {
            if (secondvalue == true) {
              checkMarkCount++;
            }
          }
        });
        if (key == "subclasses") {
          if (checkMarkCount != 1) {
            valid = false;
          } else {
            if (value["choiceAmount"] != checkMarkCount) valid = false;
          }
        }
      }
    });
    classColumn.children.add(Row(
      children: [
        FlatButton(
            onPressed: valid ? (){_submitButton();} : null, child: Text("Submit"))
      ],
    ));
    return classColumn;
  }

  _PlayerCharacterClass(
      {List<dynamic> classesJson, PlayerCharacter playerCharacter});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return Container(
                color: Colors.amber,
                child: (playerCharacter.classInfo.length == 0 ||
                        playerCharacter.classInfo != classesJson[index])
                    ? Row(children: [
                        Text(widget.classesJson[index]['index']),
                        FlatButton(
                            onPressed: () {
                              setClassInfo(index);
                            },
                            child: Icon(Icons.add))
                      ])
                    : Column(
                        children: [
                          Row(
                            children: [
                              Text(widget.classesJson[index]['index']),
                              FlatButton(
                                  onPressed: () {
                                    setClassInfo(index);
                                  },
                                  child: Icon(Icons.add))
                            ],
                          ),
                          Row(
                            children: [generateClassLayout(index)],
                          )
                        ],
                      ));
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
          itemCount: widget.classesJson.length),
    );
  }
}
