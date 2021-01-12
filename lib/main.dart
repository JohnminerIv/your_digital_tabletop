import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'character.dart';

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
            primarySwatch: Colors.amber,
            primaryColorLight: Colors.amberAccent,
            primaryColorDark: Colors.deepOrangeAccent,
            visualDensity: VisualDensity.adaptivePlatformDensity),
        home: DigitalTableTopHome(title: "Digital TableTop"));
  }
}

class DigitalTableTopHome extends StatelessWidget {
  final String title;

  const DigitalTableTopHome({Key key, this.title}) : super(key: key);

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
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            routeButton(context, "Characters", PlayerCharacters()),
            routeButton(context, "Campaign", Campaign()),
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
  _CampaignState createState() => _CampaignState();
}

class _CampaignState extends State<Campaign> {
  var filesList = [];
  Directory dir;
  List<FileSystemEntity> files;
  @override
  void initState() {
    super.initState();
    /*to store files temporary we use getTemporaryDirectory() but we need
    permanent storage so we use getApplicationDocumentsDirectory() */
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = new Directory('${directory.path}/playerAssets/campaigns');
      files = dir.listSync();
      files.forEach((sE){
        print(sE);
        setState(() {
          filesList.add(sE.path);
        });
      });
    });
  }
  addDirectory(){
      final notesDir = new Directory('${widget.directory.path}/${filesList.length}');
      notesDir.createSync(recursive: true);

}
editButton(){

}
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text(widget.title),
      actions: [GestureDetector(onTap:(){addFile()},child: Icon(Icons.file_copy),)],),
      body: ListView.separated(
        padding: const EdgeInsets.all(20.0),
        itemCount: filesList.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 50,
            color: Colors.amber,
            child: Row(children: [Text(filesList[index]), (files[index] is File) ? editButton() : null],)
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
      floatingActionButton: FloatingActionButton(
          tooltip: 'Increment',
          child: Icon(Icons.add),
          onPressed: (){
            addDirectory();
          },
      ));
}}

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
