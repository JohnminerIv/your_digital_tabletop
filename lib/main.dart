import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'character.dart';
import 'utils.dart';

void main() async {
  runApp(DigitalTableTopApp());
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

class DigitalTableTopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    getApplicationDocumentsDirectory().then((Directory path) {
      final charDir = new Directory('${path.path}/playerAssets/characters');
      final notesDir = new Directory('${path.path}/playerAssets/campaigns');
      charDir.exists().then((isThere) {
        isThere ? print('exists') : charDir.create(recursive: true);
        notesDir.create(recursive: true);
      });
    });
    return MaterialApp(
        title: "Digital Tabletop",
        theme: ThemeData(
            primarySwatch: Colors.lightBlue,
            primaryColorLight: Colors.lightBlueAccent,
            primaryColorDark: Colors.blueGrey,
            visualDensity: VisualDensity.adaptivePlatformDensity),
        home: DigitalTableTopHome(title: "Digital TableTop"));
  }
}

class DigitalTableTopHome extends StatefulWidget {
  final String title;

  DigitalTableTopHome({Key key, this.title}) : super(key: key);

  @override
  _DigitalTableTopHome createState() => _DigitalTableTopHome();
}

class _DigitalTableTopHome extends State<DigitalTableTopHome> {
  Directory campaignDir;

  @override
  void initState() {
    super.initState();
    /*to store files temporary we use getTemporaryDirectory() but we need
    permanent storage so we use getApplicationDocumentsDirectory() */
    getApplicationDocumentsDirectory().then((Directory directory) {
      setState(() {
        campaignDir = new Directory('${directory.path}/playerAssets/campaigns');
      });
    });
  }

  FlatButton routeButton(BuildContext context, String buttonText, Widget page) {
    return FlatButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return page;
          }));
        },
        child: Text(buttonText));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            routeButton(context, "Characters", PlayerCharacters()),
            routeButton(
                context,
                "Campaign",
                Campaign(
                  directory: campaignDir,
                )),
            routeButton(context, "Local Play", LocalPlay()),
            routeButton(context, "Homebrew", Homebrew())
          ],
        )));
  }
}

class Campaign extends StatefulWidget {
  final title = "Campaigns";
  final directory;

  const Campaign({Key key, this.directory}) : super(key: key);

  @override
  _CampaignState createState() => _CampaignState(directory);
}

class _CampaignState extends State<Campaign> {
  var filesList = [];
  Directory dir;
  List<FileSystemEntity> files;

  _CampaignState(this.dir);

  @override
  void initState() {
    super.initState();
    /*to store files temporary we use getTemporaryDirectory() but we need
    permanent storage so we use getApplicationDocumentsDirectory() */
    files = dir.listSync();
  }

  addDirectory() {
    final notesDir = new Directory('${dir.path}/${files.length}');
    notesDir.createSync(recursive: true);
    setState(() {
      files = dir.listSync();
    });
  }

  openButton(path) {
    return FlatButton(
        onPressed: () {
          Directory thisDir = new Directory(path);
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Campaign(
              directory: thisDir,
            );
          }));
        },
        child: Text("Open"));
  }

  editButton(path) {
    return FlatButton(
        onPressed: () {
          Directory thisDir = new Directory(path);
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return TextEditClass(
              thisDir,
            );
          }));
        },
        child: Text("Edit"));
  }

  addFile() {
    final notesFile = new File('${dir.path}/${files.length}.txt');
    notesFile.createSync(recursive: true);
    setState(() {
      files = dir.listSync();
    });
  }

  chooseProperButton(fileEntity) {
    return fileEntity is File
        ? editButton(fileEntity.path)
        : openButton(fileEntity.path);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            GestureDetector(
              onTap: () {
                addFile();
              },
              child: Icon(Icons.file_copy),
            )
          ],
        ),
        body: ListView.separated(
          padding: const EdgeInsets.all(20.0),
          itemCount: files.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                height: 50,
                color: Colors.lightBlueAccent,
                child: Row(
                  children: [
                    Text(files[index].path.split("/").last),
                    chooseProperButton(files[index])
                  ],
                ));
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Increment',
          child: Icon(Icons.add),
          onPressed: () {
            addDirectory();
          },
        ));
  }
}

class TextEditClass extends StatefulWidget {
  final Directory dir;

  TextEditClass(this.dir);

  @override
  _TextEditClass createState() => _TextEditClass(dir);
}

class _TextEditClass extends State<TextEditClass> {
  Directory dir;
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = new TextEditingController();
    var file = File(dir.path);
    _textController.text = file.readAsStringSync();

  }

  _TextEditClass(this.dir);
  saveText(){
    print(_textController.text);
    var file = File(dir.path);
    file.writeAsStringSync(_textController.text);
    print(file.readAsStringSync());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var appBar = AppBar(title: Text("${dir.path.split('/').last}"));
    return Scaffold(
      appBar: appBar,
      body: TextField(
          controller: _textController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          style: TextStyle(fontSize: 12.0, color: Colors.black)),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {saveText();},
      ),
    );
  }
}

class LocalPlay extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class Homebrew extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
