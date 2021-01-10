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
        "str": false,
        "dex": false,
        "con": false,
        "int": false,
        "wis": false,
        "cha": false
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
      "language": [],
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

  profSwitch(profs) {
    switch (profs[0]["type"]) {
      case "Armor":
        {
          characterSheet["proficiencies"]["equipment"]["armor"] =
          profs[0]["name"];
        }
        break;
      case "Weapons":
        {
          characterSheet["proficiencies"]["equipment"]["weapons"] =
          profs[0]["name"];
        }
        break;
      case "Artisan's Tools":
        {
          characterSheet["proficiencies"]["equipment"]["tools"] =
          profs[0]["name"];
        }
        break;
      case "Gaming Sets":
        {
          characterSheet["proficiencies"]["equipment"]["tools"] =
          profs[0]["name"];
        }
        break;
      case "Musical Instruments":
        {
          characterSheet["proficiencies"]["equipment"]["tools"] =
          profs[0]["name"];
        }
        break;
      case "Other":
        {
          characterSheet["proficiencies"]["equipment"]["tools"] =
          profs[0]["name"];
        }
        break;
      case "Vehicles":
        {
          characterSheet["proficiencies"]["equipment"]["tools"] =
          profs[0]["name"];
        }
        break;
      case "Saving Throws":
        {
          characterSheet["proficiencies"]["savingThrows"]
          [profs[0]["references"][0]["index"]] = true;
        }
        break;
      case "Skills":
        {
          characterSheet["proficiencies"]["skills"].forEach((k, v) {
            if (v.containsKey(profs[0]["references"][0]["Name"])) {
              v[profs[0]["references"][0]["Name"]] = true;
            }
          });
          break;
        }
        defualt:
        {
          print("Wow you suck at coding");
        }
    }
  }

  setRaceInfo() async {
    var proficiencies = jsonDecode(
        await loadTextFromFile("assets/src/5e-SRD-Proficiencies.json"));
    var traits =
    jsonDecode(await loadTextFromFile("assets/src/5e-SRD-Traits.json"));
    var subraces =
    jsonDecode(await loadTextFromFile("assets/src/5e-SRD-Subraces.json"));
    var spells =
    jsonDecode(await loadTextFromFile("assets/src/5e-SRD-Subraces.json"));
    characterSheet["race"] = raceInfo["name"];
    characterSheet["speed"] = raceInfo["speed"];
    raceInfo["ability_bonuses"].forEach((m) {
      characterSheet["stats"].update(
          m["ability_score"]["index"], (dynamic val) => val + m["bonus"]);
    });
    characterSheet["size"] = raceInfo["size"];
    raceInfo["starting_proficiencies"].forEach((item) {
      var profs = proficiencies.where((m) => m["index"] == item["index"]);
      profSwitch(profs);
    });

    raceInfoOptions.forEach((key, value) {
      if (key.contains("options")) {
        value.forEach((k, v) {
          if (value == true) {
            var choice = raceInfo[key]["from"].where((m) => m["name"] == k);
            switch (raceInfo[key]) {
              case "proficiencies":
                {
                  var profs = proficiencies.where((m) =>
                  m["index"] == choice["index"]);
                  profSwitch(profs);
                }
                break;
              case "languages":
                {
                  characterSheet["proficiencies"]["language"].add(
                      choice["name"]);
                }
                break;
              case "trait":
                {
                  var trait = traits.where((m) =>
                  m["index"] == choice["index"]);
                  characterSheet["featuresTraits"][trait[0]["name"]] =
                  trait[0]["desc"];
                  trait["proficiencies"].forEach((prof) {
                    var profs = proficiencies.where((m) =>
                    m["index"] == prof["index"]);
                    profSwitch(profs);
                  });
                }
                break;
              case "ability_bonuses":
                {
                  characterSheet["stats"].update(
                      choice["ability_score"]["index"], (dynamic val) => val + choice["bonus"]);
                }
                break;
                defualt:
                {
                  print("You suck at coding!")
                }
            }
          }
        });
      }
    });
    raceInfo["languages"].forEach((m){
      characterSheet["proficiencies"]["language"].add(m["name"]);
    });
    raceInfo["traits"].forEach((m){
      var trait = traits.where((tm) =>
      tm["index"] == m["index"]);
      characterSheet["featuresTraits"][trait[0]["name"]] =
      trait[0]["desc"];
      trait["proficiencies"].forEach((prof) {
        var profs = proficiencies.where((m) =>
        m["index"] == prof["index"]);
        profSwitch(profs);
      });
    });
    if (raceInfoOptions.containsKey("subraces")){
      raceInfoOptions["subraces"].forEach((key, value){
        if (value == true){
          var subrace = raceInfo["subraces"].where((m) => m["name"] == key);
          var subraceInfo = subraces.where((race) => race["name"] == subrace[0]["name"]);
          subraceInfo["ability_bonuses"].forEach((m){
            characterSheet["stats"].update(
                m["ability_score"]["index"], (dynamic val) => val + m["bonus"]);
          });
          subraceInfo["starting_proficiencies"].forEach((choice){
            var profs = proficiencies.where((m) =>
            m["index"] == choice["index"]);
            profSwitch(profs);
          });
          subraceInfo["languages"].forEach((choice){
            characterSheet["proficiencies"]["language"].add(
                choice["name"]);
          });
          subraceInfo["racial_traits"].forEach((choice){
            var trait = traits.where((m) =>
            m["index"] == choice["index"]);
            characterSheet["featuresTraits"][trait[0]["name"]] =
            trait[0]["desc"];
            trait["proficiencies"].forEach((prof) {
              var profs = proficiencies.where((m) =>
              m["index"] == prof["index"]);
              profSwitch(profs);
            });
          });
        }
      });
    }
  }
}

Future<String> loadTextFromFile(path) async {
  return await rootBundle.loadString(path);
}
