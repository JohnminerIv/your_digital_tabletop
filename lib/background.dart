import 'dart:collection';
import 'dart:convert' show jsonDecode;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

class PlayerCharacterBackground extends StatefulWidget{
  final title = "Classes";
  final playerCharacter;

  const PlayerCharacterBackground({Key key, this.playerCharacter}) : super(key: key);

  @override
  _PlayerCharacterBackground createState() => _PlayerCharacterBackground(playerCharacter);

}

class _PlayerCharacterBackground extends State<PlayerCharacterBackground> {
  _PlayerCharacterBackground(this.playerCharacter);
  PlayerCharacter playerCharacter;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}