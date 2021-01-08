import 'dart:collection';
import 'dart:convert' show jsonDecode;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

class PlayerCharacter {
  var raceInfo = {};
  var raceInfoOptions = {};
  var classInfo = {};
  var classInfoOptions = {};
  var stats = {};
}
Future<String> loadTextFromFile(path) async {
  return await rootBundle.loadString(path);
}