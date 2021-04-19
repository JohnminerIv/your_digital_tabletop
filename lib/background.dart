import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'utils.dart' show PlayerCharacter, loadTextFromFile;

class PlayerCharacterBackground extends StatefulWidget {
  final title = "Backgrounds";
  final playerCharacter;
  final backgroundJson;

  const PlayerCharacterBackground(
      {Key key, this.playerCharacter, this.backgroundJson})
      : super(key: key);

  @override
  _PlayerCharacterBackground createState() =>
      _PlayerCharacterBackground(playerCharacter);
}

enum CharacterAlignment {
  lawfulGood,
  neutralGood,
  chaoticGood,
  lawfulNeutral,
  neutral,
  chaoticNeutral,
  lawfulEvil,
  neutralEvil,
  chaoticEvil
}

class _PlayerCharacterBackground extends State<PlayerCharacterBackground> {
  _PlayerCharacterBackground(this.playerCharacter);

  CharacterAlignment alignment = CharacterAlignment.neutral;

  PlayerCharacter playerCharacter;
  var language = "";
  var equipment = "";
  var feature = "";
  var description = "";
  var bgExpanded = "";

  setbgExpandedButton(name) {
    return FlatButton(
        color: Theme.of(context).accentColor,
        child: Icon(Icons.add),
        onPressed: () {
          setState(() {
            if (bgExpanded == name) {
              bgExpanded = "";
            } else {
              bgExpanded = name;
            }
          });
        });
  }

  ListView generateBackgroundLayout() {
    var bgList = [];
    List<dynamic> bgJ = widget.backgroundJson["background"];
    for (var i = 0; i < bgJ.length; i++) {
      bgList.add(Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(bgJ[i]["name"].split('(')[0]),
              setbgExpandedButton(bgJ[i]["name"]),
            ],
          )
        ],
      ));
      if (bgJ[i]["name"] == bgExpanded) {
        for (var j = 0; j < bgJ[i]["trait"].length; j++) {
          bgList[i].children.add(Text(bgJ[i]["trait"][j]["name"]));

          bgJ[i]["trait"][j]["text"].forEach((item) {
            if (item.runtimeType == String) {
              bgList[i].children.add(Text(item));
            } else {
              bgList[i]
                  .children
                  .add(Text("${item["thead"][0]} ${item["thead"][1]}"));
              item["tbody"].forEach((l) {
                bgList[i].children.add(Text("${l[0]}: ${l[1]}"));
              });
            }
          });
        }
      }
    }
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return Container(
              padding: EdgeInsets.only(left: 30, right: 30),
              color: Theme.of(context).primaryColor,
              child: bgList[index]);
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemCount: bgList.length);
  }

  backgroundForm() {
    print(playerCharacter.characterSheet);
    var bgForm = [];
    bgForm.add(Column(
      children: [
        Text("Name"),
        TextField(
            decoration:
                InputDecoration(border: InputBorder.none, hintText: 'Name'),
            onChanged: (text) {
              playerCharacter.characterSheet["name"] = text;
            }),
      ],
    ));
    bgForm.add(Column(
      children: [
        Text("Gender"),
        TextField(
            decoration:
                InputDecoration(border: InputBorder.none, hintText: 'gender'),
            onChanged: (text) {
              playerCharacter.characterSheet["gender"] = text;
            }),
      ],
    ));
    bgForm.add(Column(
      children: [
        Text("Alignment"),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.only(right: 30),
              child: Text("Lawful - Evil"),
            )
          ],
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("Good"),
          Row(children: [
            Radio(
              value: CharacterAlignment.lawfulGood,
              groupValue: alignment,
              onChanged: (CharacterAlignment value) {
                setState(() {
                  alignment = value;
                  playerCharacter.characterSheet["alignment"] =
                      alignment.toString().split('.').last;
                });
              },
            ),
            Radio(
              value: CharacterAlignment.neutralGood,
              groupValue: alignment,
              onChanged: (CharacterAlignment value) {
                setState(() {
                  alignment = value;
                  playerCharacter.characterSheet["alignment"] =
                      alignment.toString().split('.').last;
                });
              },
            ),
            Radio(
              value: CharacterAlignment.chaoticGood,
              groupValue: alignment,
              onChanged: (CharacterAlignment value) {
                setState(() {
                  alignment = value;
                  playerCharacter.characterSheet["alignment"] =
                      alignment.toString().split('.').last;
                });
              },
            )
          ])
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("|"),
          Row(
            children: [
              Radio(
                value: CharacterAlignment.lawfulNeutral,
                groupValue: alignment,
                onChanged: (CharacterAlignment value) {
                  setState(() {
                    alignment = value;
                    playerCharacter.characterSheet["alignment"] =
                        alignment.toString().split('.').last;
                  });
                },
              ),
              Radio(
                value: CharacterAlignment.neutral,
                groupValue: alignment,
                onChanged: (CharacterAlignment value) {
                  setState(() {
                    alignment = value;
                    playerCharacter.characterSheet["alignment"] =
                        alignment.toString().split('.').last;
                  });
                },
              ),
              Radio(
                value: CharacterAlignment.chaoticNeutral,
                groupValue: alignment,
                onChanged: (CharacterAlignment value) {
                  setState(() {
                    alignment = value;
                    playerCharacter.characterSheet["alignment"] =
                        alignment.toString().split('.').last;
                  });
                },
              )
            ],
          )
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("Evil"),
          Row(
            children: [
              Radio(
                value: CharacterAlignment.lawfulEvil,
                groupValue: alignment,
                onChanged: (CharacterAlignment value) {
                  setState(() {
                    alignment = value;
                    playerCharacter.characterSheet["alignment"] =
                        alignment.toString().split('.').last;
                  });
                },
              ),
              Radio(
                value: CharacterAlignment.neutralEvil,
                groupValue: alignment,
                onChanged: (CharacterAlignment value) {
                  setState(() {
                    alignment = value;
                    playerCharacter.characterSheet["alignment"] =
                        alignment.toString().split('.').last;
                  });
                },
              ),
              Radio(
                value: CharacterAlignment.chaoticEvil,
                groupValue: alignment,
                onChanged: (CharacterAlignment value) {
                  setState(() {
                    alignment = value;
                    playerCharacter.characterSheet["alignment"] =
                        alignment.toString().split('.').last;
                  });
                },
              )
            ],
          )
        ])
      ],
    ));
    bgForm.add(Column(
      children: [
        Text("Language"),
        TextField(
            decoration:
                InputDecoration(border: InputBorder.none, hintText: 'language'),
            onChanged: (text) {
              language = text;
            }),
      ],
    ));
    bgForm.add(Column(
      children: [
        Text("Two personality traits"),
        TextField(
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'personality'),
            onChanged: (text) {
              playerCharacter.characterSheet["background"]["personalityTrait"] =
                  text;
            }),
        Text("Ideal"),
        TextField(
            decoration:
                InputDecoration(border: InputBorder.none, hintText: 'Ideal'),
            onChanged: (text) {
              playerCharacter.characterSheet["background"]["ideal"] = text;
            }),
        Text("Bond"),
        TextField(
            decoration:
                InputDecoration(border: InputBorder.none, hintText: 'Bond'),
            onChanged: (text) {
              playerCharacter.characterSheet["background"]["bond"] = text;
            }),
        Text("Flaw"),
        TextField(
            decoration:
                InputDecoration(border: InputBorder.none, hintText: 'Flaw'),
            onChanged: (text) {
              playerCharacter.characterSheet["background"]["flaw"] = text;
            }),
      ],
    ));
    bgForm.add(Column(
      children: [],
    ));
    playerCharacter.characterSheet["proficiencies"]["skills"]
        .forEach((key, value) {
      bgForm[bgForm.length - 1].children.add(Text(key));
      value.forEach((k, v) {
        bgForm[bgForm.length - 1].children.add(Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(k),
                Checkbox(
                    tristate: true,
                    value: v,
                    onChanged: (bool newValue) {
                      if (playerCharacter.characterSheet["proficiencies"]
                                  ["skills"][key][k] ==
                              true ||
                          playerCharacter.characterSheet["proficiencies"]
                                  ["skills"][key][k] ==
                              false) {
                        setState(() {
                          playerCharacter.characterSheet["proficiencies"]
                                  ["skills"][key][k] =
                              playerCharacter.characterSheet["proficiencies"]
                                      ["skills"][key][k]
                                  ? false
                                  : true;
                        });
                      }
                    })
              ],
            ));
      });
    });
    bgForm.add(Column(children: [
      Text("Equipment, comma separated"),
      TextField(
          decoration: null,
          onChanged: (text) {
            equipment = text;
          }),
    ]));
    bgForm.add(Column(children: [
      Text("Feature, name"),
      TextField(
          decoration: null,
          onChanged: (text) {
            feature = text;
          }),
      Text("Feature, description"),
      TextField(
          decoration: null,
          onChanged: (text) {
            description = text;
          })
    ]));
    bgForm.add(FlatButton(
      child: Text("Submit"),
      onPressed: () {
        _submitButton();
      },
    ));

    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return Container(
              padding: EdgeInsets.only(left: 30, right: 30),
              color: Theme.of(context).primaryColor,
              child: bgForm[index]);
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemCount: bgForm.length);
  }

  _submitButton() {
    playerCharacter.characterSheet["proficiencies"]["language"].add(language);
    playerCharacter.characterSheet["equipment"]["tools"].add(equipment);
    playerCharacter.characterSheet["featuresTraits"][feature] = [description];
    playerCharacter.setNullsToTrue();
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PlayerCharacterStats(playerCharacter: playerCharacter);
    }));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var appBar = AppBar(title: Text(widget.title));
    return Scaffold(
        appBar: appBar,
        body: Container(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: SizedBox(
              height: MediaQuery.of(context).size.height -
                  appBar.preferredSize.height,
              child: Column(
                children: [
                  Expanded(child: generateBackgroundLayout()),
                  Expanded(child: backgroundForm()),
                ],
              ),
            )));
  }
}

class PlayerCharacterStats extends StatefulWidget {
  final title = "Stats";
  final playerCharacter;

  const PlayerCharacterStats({Key key, this.playerCharacter}) : super(key: key);

  @override
  _PlayerCharacterStats createState() => _PlayerCharacterStats(playerCharacter);
}

class _PlayerCharacterStats extends State<PlayerCharacterStats> {
  var playerCharacter;

  _PlayerCharacterStats(this.playerCharacter);

  var statsThing = {
    "str": 15,
    "dex": 14,
    "con": 13,
    "int": 12,
    "wis": 10,
    "cha": 8
  };
  var rollOrPointsBool = false;
  var userOrderedStats = {
    "str": 0,
    "dex": 0,
    "con": 0,
    "int": 0,
    "wis": 0,
    "cha": 0
  };

  rollRandomStats() {
    setState(() {
      var rng = new Random();
      statsThing.forEach((key, value) {
        var diceRoll = [
          rng.nextInt(6) + 1,
          rng.nextInt(6) + 1,
          rng.nextInt(6) + 1,
          rng.nextInt(6) + 1
        ];
        statsThing[key] =
            diceRoll.reduce((a, b) => a + b) - diceRoll.reduce(min);
      });
      userOrderedStats.forEach((key, value) {
        userOrderedStats[key] = 0;
      });
    });
  }

  statsForm() {
    var statsCol = Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [],
    );
    print(userOrderedStats);
    playerCharacter.characterSheet["stats"].forEach((key, value) {
      print(statsThing[key]);
      statsCol.children.add(
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            Text("$key: "),
            Text((value + userOrderedStats[key]).toString()),
          ],
        ),
        Row(
          children: [
            DragTarget<int>(
              onWillAccept: (value) {
                return userOrderedStats[key] == 0;
              },
              onAccept: (value) {
                setState(() {
                  userOrderedStats[key] = value;
                });
              },
              builder: (_, candidateData, rejectedData) {
                return Container(
                  width: 50,
                  height: 30,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  alignment: Alignment.center,
                  child: userOrderedStats[key] != 0
                      ? Draggable<int>(
                          data: userOrderedStats[key],
                          child: Container(
                            width: 50,
                            height: 30,
                            alignment: Alignment.center,
                            color: Theme.of(context).accentColor,
                            child: Text(userOrderedStats[key].toString()),
                          ),
                          onDragCompleted: () {
                            setState(() {
                              userOrderedStats[key] = 0;
                            });
                          },
                          // The widget to show under the pointer when a drag is under way
                          feedback: Opacity(
                            opacity: 0.4,
                            child: Container(
                              width: 50,
                              height: 30,
                              alignment: Alignment.center,
                              color: Theme.of(context).accentColor,
                              child: Text(userOrderedStats[key].toString()),
                            ),
                          ),
                        )
                      : Container(),
                );
              },
            ),
            DragTarget<int>(
              onWillAccept: (value) {
                return statsThing[key] == 0;
              },
              onAccept: (value) {
                setState(() {
                  statsThing[key] = value;
                });
              },
              builder: (_, candidateData, rejectedData) {
                return Container(
                  width: 50,
                  height: 30,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  alignment: Alignment.center,
                  child: statsThing[key] != 0
                      ? Draggable<int>(
                          data: statsThing[key],

                          onDragCompleted: () {
                            setState(() {
                              statsThing[key] = 0;
                            });
                          },
                          child: Container(
                            width: 50,
                            height: 30,
                            alignment: Alignment.center,
                            color: Theme.of(context).accentColor,
                            child: Text(statsThing[key].toString()),
                          ),
                          // The widget to show under the pointer when a drag is under way
                          feedback: Opacity(
                            opacity: 0.4,
                            child: Container(
                              width: 50,
                              height: 30,
                              alignment: Alignment.center,
                              color: Theme.of(context).accentColor,
                              child: Text(statsThing[key].toString()),
                            ),
                          ),
                        )
                      : Container(),
                );
              },
            ),
          ],
        )
      ]));
    });
    statsCol.children.add(FlatButton(
      color: Theme.of(context).accentColor,
      child: Text("Pray to R N Jesus"),
      onPressed: () {
        rollRandomStats();
      },
    ));
    var canSubmit = true;
    userOrderedStats.forEach((key, value) {
      if (value == 0) {
        canSubmit = false;
      }
    });
    statsCol.children.add(FlatButton(
        color: Theme.of(context).accentColor,
        onPressed: canSubmit
            ? () {
                _submit();
              }
            : null,
        child: Text("Finalize")));
    return statsCol;
  }

  _submit() {
    userOrderedStats.forEach((key, value) {
      playerCharacter.characterSheet["stats"][key] =
          value + playerCharacter.characterSheet["stats"][key];
      print(playerCharacter.characterSheet["stats"][key]);
    });
    playerCharacter.saveCharacterJson();
    var count = 0;
    Navigator.popUntil(context, (route) {
      return count++ == 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
          child: Container(
        margin: EdgeInsets.all(30.0),
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.all(30.0),
        child: statsForm(),
      )),
    );
  }
}
