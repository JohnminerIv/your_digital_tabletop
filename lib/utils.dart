import 'dart:collection';
import 'dart:convert' show jsonDecode, jsonEncode;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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
    "gender": "",
    "class": "",
    "subclass": "",
    "speed": 0,
    "hitDie": 0,
    "curentHp": 0,
    "maxHp": 0,
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
    "featuresTraits": {
      "name": <dynamic>[],
    },
    "spells": [
      {
        "name": ["description"],
      },
    ]
  };

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    new File('$path/playerAssets/characters/${characterSheet["name"]}.json')
            .createSync(recursive: true);
    return File('$path/playerAssets/characters/${characterSheet["name"]}.json');
  }

  saveCharacterJson() async {
    File characterFile = await _localFile;
    characterFile.writeAsStringSync(jsonEncode(characterSheet));
  }

  setNullsToTrue() {
    characterSheet["proficiencies"]["skills"].forEach((key, value) {
      value.forEach((k, v) {
        if (v == null) {
          characterSheet["proficiencies"]["skills"][key][k] = true;
        }
      });
    });
  }

  profSwitch(profs) {
    switch (profs[0]["type"]) {
      case "Armor":
        {
          characterSheet["proficiencies"]["equipment"]["armor"]
              .add(profs[0]["name"]);
        }
        break;
      case "Weapons":
        {
          characterSheet["proficiencies"]["equipment"]["weapons"]
              .add(profs[0]["name"]);
        }
        break;
      case "Artisan's Tools":
        {
          characterSheet["proficiencies"]["equipment"]["tools"]
              .add(profs[0]["name"]);
        }
        break;
      case "Gaming Sets":
        {
          characterSheet["proficiencies"]["equipment"]["tools"]
              .add(profs[0]["name"]);
        }
        break;
      case "Musical Instruments":
        {
          characterSheet["proficiencies"]["equipment"]["tools"]
              .add(profs[0]["name"]);
        }
        break;
      case "Other":
        {
          characterSheet["proficiencies"]["equipment"]["tools"]
              .add(profs[0]["name"]);
        }
        break;
      case "Vehicles":
        {
          characterSheet["proficiencies"]["equipment"]["tools"]
              .add(profs[0]["name"]);
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
          print("Skills switch");
          characterSheet["proficiencies"]["skills"].forEach((k, v) {
            if (v.containsKey(profs[0]["references"][0]["name"])) {
              print("Set profs");
              characterSheet["proficiencies"]["skills"][k]
                  [profs[0]["references"][0]["name"]] = null;
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
          m["ability_score"]["index"], (int val) => (val + m["bonus"]) as int);
    });
    characterSheet["size"] = raceInfo["size"];
    raceInfo["starting_proficiencies"].forEach((item) {
      var profs =
          proficiencies.where((m) => m["index"] == item["index"]).toList();
      profSwitch(profs);
    });

    raceInfoOptions.forEach((key, value) {
      if (key.contains("options")) {
        value.forEach((k, v) {
          if (v == true) {
            var choice =
                raceInfo[key]["from"].where((m) => m["name"] == k).toList();
            switch (raceInfo[key]) {
              case "proficiencies":
                {
                  var profs = proficiencies
                      .where((m) => m["index"] == choice["index"])
                      .toList();
                  profSwitch(profs);
                }
                break;
              case "languages":
                {
                  characterSheet["proficiencies"]["language"]
                      .add(choice["name"]);
                }
                break;
              case "trait":
                {
                  var trait = traits
                      .where((m) => m["index"] == choice["index"])
                      .toList();
                  characterSheet["featuresTraits"][trait[0]["name"]] =
                      trait[0]["desc"];
                  trait["proficiencies"].forEach((prof) {
                    var profs = proficiencies
                        .where((m) => m["index"] == prof["index"])
                        .toList();
                    profSwitch(profs);
                  });
                }
                break;
              case "ability_bonuses":
                {
                  characterSheet["stats"].update(
                      choice["ability_score"]["index"],
                      (dynamic val) => val + choice["bonus"]);
                }
                break;
                defualt:
                {
                  print("You suck at coding!");
                }
            }
          }
        });
      }
    });
    raceInfo["languages"].forEach((m) {
      characterSheet["proficiencies"]["language"].add(m["name"]);
    });
    raceInfo["traits"].forEach((m) {
      var trait = traits.where((tm) => tm["index"] == m["index"]).toList();
      characterSheet["featuresTraits"][trait[0]["name"]] = trait[0]["desc"];
      trait[0]["proficiencies"].forEach((prof) {
        var profs =
            proficiencies.where((m) => m["index"] == prof["index"]).toList();
        profSwitch(profs);
      });
    });
    if (raceInfoOptions.containsKey("subraces")) {
      raceInfoOptions["subraces"].forEach((key, value) {
        if (value == true) {
          var subrace =
              raceInfo["subraces"].where((m) => m["index"] == key).toList();
          var subraceInfo = subraces
              .where((race) => race["name"] == subrace[0]["name"])
              .toList();
          subraceInfo[0]["ability_bonuses"].forEach((m) {
            characterSheet["stats"].update(m["ability_score"]["index"],
                (int val) => (val + m["bonus"]) as int);
          });
          subraceInfo[0]["starting_proficiencies"].forEach((choice) {
            var profs = proficiencies
                .where((m) => m["index"] == choice["index"])
                .toList();
            profSwitch(profs);
          });
          subraceInfo[0]["languages"].forEach((choice) {
            characterSheet["proficiencies"]["language"].add(choice["name"]);
          });
          subraceInfo[0]["racial_traits"].forEach((choice) {
            var trait =
                traits.where((m) => m["index"] == choice["index"]).toList();
            characterSheet["featuresTraits"][trait[0]["name"]] =
                trait[0]["desc"];
            trait[0]["proficiencies"].forEach((prof) {
              var profs = proficiencies
                  .where((m) => m["index"] == prof["index"])
                  .toList();
              profSwitch(profs);
            });
          });
        }
      });
    }
  }

  setClassInfo() async {
    var proficiencies = jsonDecode(
        await loadTextFromFile("assets/src/5e-SRD-Proficiencies.json"));
    var startingEquipment = jsonDecode(
        await loadTextFromFile("assets/src/5e-SRD-StartingEquipment.json"));
    characterSheet["hitDie"] = classInfo["hit_die"];
    classInfoOptions.forEach((key, value) {
      print(key.substring(key.length - 1));
      if (key.contains("choices")) {
        value.forEach((k, v) {
          if (v == true) {
            print("found true choice");
            print(key.substring(key.length - 1));
            print(key);
            var choice = classInfo[key.substring(0, key.length - 1)]
                    [int.parse(key.substring(key.length - 1))]["from"]
                .where((m) => m["name"] == k)
                .toList();
            var profs = proficiencies
                .where((m) => m["index"] == choice[0]["index"])
                .toList();
            print(profs);
            profSwitch(profs);
          }
        });
      }
    });
    classInfo["proficiencies"].forEach((item) {
      var profs =
          proficiencies.where((m) => m["index"] == item["index"]).toList();
      profSwitch(profs);
    });
    classInfo["saving_throws"].forEach((m) {
      characterSheet["proficiencies"]["savingThrows"][m["index"]] = true;
    });
    if (classInfo.containsKey("spellcasting")) {
      if (classInfo["spellcasting"]["level"] == 1) {
        classInfo["spellcasting"]["info"].forEach((m) {
          characterSheet["featuresTraits"][m["name"]] = m["desc"];
        });
      }
    }
  }
}

Future<String> loadTextFromFile(path) async {
  return await rootBundle.loadString(path);
}
