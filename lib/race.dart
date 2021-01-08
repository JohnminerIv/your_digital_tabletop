import 'dart:collection';
import 'dart:convert' show jsonDecode;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

import 'class.dart';
import 'utils.dart' show PlayerCharacter, loadTextFromFile;

class PlayerCharacterRace extends StatefulWidget{
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
      if (!(value is String)) {
        print("hi");
        int checkMarkCount = 0;
        value.forEach((secondkey, secondvalue) {
          if (secondvalue is bool) {
            if (secondvalue == true) {
              checkMarkCount++;
            }
          }
        });
        if (key == "subraces") {
          print("subraces");
          if (value.length == 0) {
          } else if (checkMarkCount != 1) {
            valid = false;
          }
        } else {
          if (value["choiceAmount"] != checkMarkCount) {
            print(value);
            print(value["choiceAmount"]);
            print(checkMarkCount);
            valid = false;
          }
        }
      }
    });
    raceColumn.children.add(Row(
      children: [
        FlatButton(
            onPressed: valid
                ? () {
              _submitButton();
            }
                : null,
            child: Text("Submit"))
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