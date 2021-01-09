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
  var backgroundInfo = {};
  var backgroundInfoOptions = {};
  var stats = {};
  Map<String, dynamic> characterSheet = {
    "name": "",
    "race": "",
    "subrace": "",
    "class": "",
    "subclass": "",
    "speed": 0,
    "size": "",
    "level": 1,
    "experience": 0,
    "alignment": "",
    "stats": {"str": 0, "dex": 0, "con": 0, "int": 0, "wis": 0, "cha": 0},
    "equipment": {
      "tools": [],
      "weapons": [],
      "armor": [],
      "money": {"cp": 0, "sp": 0, "ep": 0, "gp": 0, "pp": 0}
    },
    "proficiencies": {
      "savingThrows": {
        "str": 0,
        "dex": 0,
        "con": 0,
        "int": 0,
        "wis": 0,
        "cha": 0
      },
      "skills": {
        "str": {"Athletics": false},
        "dex": {
          "Dexterity": false,
          "Acrobatics": false,
          "Sleight of Hand": false,
          "Stealth": false
        },
        "int": {
          "Arcana": false,
          "History": false,
          "Investigation": false,
          "Nature": false,
          "Religion": false
        },
        "wis": {
          "Animal Handling": false,
          "Insight": false,
          "Medicine": false,
          "Perception": false,
          "Survival": false,
        },
        "cha": {
          "Deception": false,
          "Intimidation": false,
          "Performance": false,
          "Persuasion": false
        },
        "con": {}
      },
      "language": {},
      "equipment": {"tools": [], "weapons": [], "armor": []}
    },
    "background": {
      "name": "",
      "personalityTrait": "",
      "ideal": "",
      "bond": "",
      "flaw": "",
    },
    "featuresTraits": [
      {
        "name": "description",
      },
    ],
    "spells": [
      {
        "name": "description",
      },
    ]
  };

  setRaceInfo() async {
    var proficiencies = jsonDecode(await loadTextFromFile("assets/src/5e-SRD-Proficiencies.json"));
    var traits = jsonDecode(await loadTextFromFile("assets/src/5e-SRD-Traits.json"));
    var subraces = jsonDecode(await loadTextFromFile("assets/src/5e-SRD-Subraces.json"));
    var spells = jsonDecode(await loadTextFromFile("assets/src/5e-SRD-Subraces.json"));
    characterSheet["race"] = raceInfo["name"];
    characterSheet["speed"] = raceInfo["speed"];
    raceInfo["ability_bonuses"].forEach((m) {
      characterSheet["stats"].update(
          m["ability_score"]["index"], (dynamic val) => val + m["bonus"]);
    });
    characterSheet["size"] = raceInfo["size"];
    raceInfo["starting_proficiencies"].forEach((item) {
      proficiencies.where((m) => m["index"] == item["index"])[0]["type"];
    });
  }
}

Future<String> loadTextFromFile(path) async {
  return await rootBundle.loadString(path);
}
