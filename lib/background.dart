import 'dart:collection';
import 'dart:convert' show jsonDecode;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

import 'utils.dart' show PlayerCharacter, loadTextFromFile;

class PlayerCharacterBackground extends StatefulWidget {
  final title = "Backgroundss";
  final playerCharacter;
  final backgroundJson;

  const PlayerCharacterBackground(
      {Key key, this.playerCharacter, this.backgroundJson})
      : super(key: key);

  @override
  _PlayerCharacterBackground createState() =>
      _PlayerCharacterBackground(playerCharacter);
}

class _PlayerCharacterBackground extends State<PlayerCharacterBackground> {
  _PlayerCharacterBackground(this.playerCharacter);

  PlayerCharacter playerCharacter;
  var bgExpanded = "";

  setbgExpandedButton(name) {
    return FlatButton(
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
        children: [
          Row(
            children: [
              Text(bgJ[i]["name"]),
              setbgExpandedButton(bgJ[i]["name"]),
            ],
          )
        ],
      ));
      if (bgJ[i]["name"] == bgExpanded) {
        for (var j = 0; j < bgJ[i]["trait"].length; j++){
          bgList[i].children.add(Text(bgJ[i]["trait"][j]["name"]));

            bgJ[i]["trait"][j]["text"].forEach((item){
              if (item.runtimeType == String){
                bgList[i].children.add(Text(item));
              } else {
                bgList[i].children.add(Text("${item["thead"][0]} ${item["thead"][1]}"));
                item["tbody"].forEach((l){
                  bgList[i].children.add(Text("${l[0]}: ${l[1]}"));
                });
              }
            });
        }
      }
    }
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return Container(color: Colors.amber, child: bgList[index]);
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemCount: bgList.length);
  }

  backgroundForm() {
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return Container(color: Colors.amber, child: bgList[index]);
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemCount: bgList.length);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Column(
          children: <Widget>[SizedBox(
            height: 200, // constrain height
            child: generateBackgroundLayout(),
          )],
        ));
  }
}
