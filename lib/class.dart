import 'dart:convert' show jsonDecode;

import 'package:flutter/material.dart';

import 'background.dart' show PlayerCharacterBackground;
import 'utils.dart' show PlayerCharacter, loadTextFromFile;

class PlayerCharacterClass extends StatefulWidget {
  final title = "Classes";
  final List<dynamic> classesJson;
  final playerCharacter;

  const PlayerCharacterClass({Key key, this.classesJson, this.playerCharacter})
      : super(key: key);

  @override
  _PlayerCharacterClass createState() =>
      _PlayerCharacterClass(classesJson, playerCharacter);
}

class _PlayerCharacterClass extends State<PlayerCharacterClass> {
  _PlayerCharacterClass(this.classesJson, this.playerCharacter);

  List<dynamic> classesJson;
  PlayerCharacter playerCharacter;

  void setClassInfo(index) {
    setState(() {
      if (playerCharacter.classInfo == null) {
        playerCharacter.classInfo = widget.classesJson[index];
      } else if (playerCharacter.classInfo["index"] ==
          widget.classesJson[index]["index"]) {
        playerCharacter.classInfo = {};
      } else {
        playerCharacter.classInfo = widget.classesJson[index];
      }
    });
  }

  _submitButton() {
    print(playerCharacter.classInfoOptions);
    playerCharacter.setClassInfo().then((nonData) =>
        loadTextFromFile('assets/src/backgrounds.json').then((data) =>
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return PlayerCharacterBackground(
                  backgroundJson: jsonDecode(data),
                  playerCharacter: playerCharacter);
            }))));
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
      if (k.contains("choices")) {
        classColumn.children.add(Row(
          children: [Text(k)],
        ));
        for (var t = 0; t < playerCharacter.classInfo[k].length; t++) {
          if (playerCharacter.classInfoOptions["$k$t"] == null) {
            playerCharacter.classInfoOptions["$k$t"] = {};
          }
          int choiceAmount = playerCharacter.classInfo[k][t]["choose"];
          playerCharacter.classInfoOptions["$k$t"]["choiceAmount"] =
              choiceAmount;
          classColumn.children.add(Row(
            children: [Text("Choose $choiceAmount from: ")],
          ));

          for (var i = 0;
              i < playerCharacter.classInfo[k][t]["from"].length;
              i++) {
            if (resetButtons == true) {
              playerCharacter.classInfoOptions["$k$t"]
                  [playerCharacter.classInfo[k][t]["from"][i]["name"]] = false;
            }
            classColumn.children.add(Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(playerCharacter.classInfo[k][t]["from"][i]["name"]),
                Checkbox(
                    value: playerCharacter.classInfoOptions["$k$t"]
                        [playerCharacter.classInfo[k][t]["from"][i]["name"]],
                    onChanged: (bool newValue) {
                      setState(() {
                        playerCharacter.classInfoOptions["$k$t"][playerCharacter
                            .classInfo[k][t]["from"][i]["name"]] = newValue;
                      });
                    })
              ],
            ));
          }
        }
      }
    });
    bool valid = true;
    playerCharacter.classInfoOptions.forEach((key, value) {
      if (value is Map) {
        int checkMarkCount = 0;
        value.forEach((secondkey, secondvalue) {
          if (secondvalue is bool) {
            if (secondvalue == true) {
              checkMarkCount++;
            }
          }
        });
        if (value["choiceAmount"] != checkMarkCount) {
          valid = false;
        }
      }
    });
    classColumn.children.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FlatButton(
            color: Theme.of(context).accentColor,
            onPressed: valid
                ? () {
                    _submitButton();
                  }
                : null,
            child: Text("Submit"))
      ],
    ));
    return classColumn;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView.separated(
          padding: const EdgeInsets.all(30),
          itemBuilder: (BuildContext context, int index) {
            return Container(
                padding: EdgeInsets.only(left: 30, right: 30),
                color: Theme.of(context).primaryColor,
                child: (playerCharacter.classInfo.length == 0 ||
                        playerCharacter.classInfo != classesJson[index])
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Text(widget.classesJson[index]['index']),
                            FlatButton(
                                color: Theme.of(context).accentColor,
                                onPressed: () {
                                  setClassInfo(index);
                                },
                                child: Icon(Icons.add))
                          ])
                    : Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.classesJson[index]['index']),
                              FlatButton(
                                  color: Theme.of(context).accentColor,
                                  onPressed: () {
                                    setClassInfo(index);
                                  },
                                  child: Icon(Icons.add))
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: generateClassLayout(index))
                            ],
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
