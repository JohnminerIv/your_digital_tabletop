import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

enum FileOptions { rename, delete }

class Campaign extends StatefulWidget {
  final title = "Campaigns";
  final directory;

  const Campaign({Key key, this.directory}) : super(key: key);

  @override
  _CampaignState createState() => _CampaignState(directory);
}

class _CampaignState extends State<Campaign> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool drawerIsOpen = false;
  var filesList = [];
  Directory dir;
  List<FileSystemEntity> fileAndFolders = [];


  FileOptions fileOption = FileOptions.rename;
  int renamingAtIndex;

  _CampaignState(this.dir);

  @override
  void initState() {
    super.initState();
    if (dir == null) {
      getApplicationDocumentsDirectory().then((Directory directory) {
        dir = new Directory('${directory.path}/playerAssets/campaigns');
        var lister = dir.list();
        lister.listen(
              (systemEntity) {
            setState(() {
              fileAndFolders.add(systemEntity);
            });
          },
        );
      });
    } else {
      updateFiles();
    }
  }

  updateFiles() {
    var lister = dir.list();
    lister.listen(
          (systemEntity) {
        setState(() {
          fileAndFolders.add(systemEntity);
        });
      },
    );
  }

  openButton(path) {
    return FlatButton(
      color: Theme
          .of(context)
          .primaryColor,
      onPressed: () {
        Directory thisDir = new Directory(path);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Campaign(
            directory: thisDir,
          );
        }));
      },
      child: SizedBox(
        height: 20,
        width: 40,
        child: Center(
          child: Text("Open"),
        ),
      ),
    );
  }

  editButton(path) {
    return FlatButton(
      color: Theme
          .of(context)
          .primaryColor,
      onPressed: () {
        Directory thisDir = new Directory(path);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return TextEditClass(
            thisDir,
          );
        }));
      },
      child: SizedBox(
        height: 20,
        width: 30,
        child: Center(
          child: Text("Edit"),
        ),
      ),
    );
  }

  addFile() {
    final notesFile = new File('${dir.path}/${fileAndFolders.length}.txt');
    notesFile.createSync(recursive: true);
    setState(() {
      fileAndFolders = dir.listSync();
    });
  }

  addDirectory() {
    final notesDir = new Directory('${dir.path}/${fileAndFolders.length}');
    notesDir.createSync(recursive: true);
    setState(() {
      fileAndFolders = dir.listSync();
    });
  }

  void _openEndDrawer() {
    setState(() {
      drawerIsOpen = true;
    });
    _scaffoldKey.currentState.openEndDrawer();
  }

  void _closeEndDrawer() {
    setState(() {
      drawerIsOpen = false;
    });
    Navigator.of(context).pop();
  }

  chooseProperButton(fileEntity) {
    if (fileEntity is File) {
      return editButton(fileEntity.path);
    } else {
      return openButton(fileEntity.path);
    }
  }

  filePopUpMenu(index) {
    PopupMenuButton<FileOptions>(
      onSelected: (FileOptions result) {
        fileOption = result;
        if (fileOption == FileOptions.delete) {
          fileAndFolders[index].delete(recursive: true);
          fileOption = FileOptions.delete;
          updateFiles();
        } else if (fileOption == FileOptions.rename) {
          fileAndFolders[index].delete(recursive: true);
          fileOption = FileOptions.delete;
          updateFiles();
        }
      },
      itemBuilder: (BuildContext context) =>
      <PopupMenuEntry<FileOptions>>[
        const PopupMenuItem<FileOptions>(
          value: FileOptions.rename,
          child: Text('Rename'),
        ),
        const PopupMenuItem<FileOptions>(
          value: FileOptions.delete,
          child: Text('Delete'),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (fileAndFolders == null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: new CircularProgressIndicator(
          backgroundColor: Theme
              .of(context)
              .accentColor,
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Builder(builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                drawerIsOpen ? _closeEndDrawer() : _openEndDrawer();
              },
              child: drawerIsOpen ? Icon(Icons.close) : Icon(Icons.menu),
            );
          })
        ],
      ),
      body: Scaffold(
        key: _scaffoldKey,
        body: ListView.separated(
          padding: const EdgeInsets.all(30),
          itemCount: fileAndFolders.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                padding: EdgeInsets.only(left: 30, right: 30),
                height: 50,
                color: Theme
                    .of(context)
                    .accentColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    renamingAtIndex == index ? TextField(
                      controller:,
                    )
                    Text(fileAndFolders[index].path
                        .split("/")
                        .last),
                    chooseProperButton(fileAndFolders[index])
                  ],
                ));
          },
          separatorBuilder: (BuildContext context, int index) =>
          const Divider(),
        ),
        endDrawer: Drawer(
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    addFile();
                  },
                  child: SizedBox(
                    height: 20,
                    width: 200,
                    child: Center(
                      child: const Text('Add a File'),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    addDirectory();
                  },
                  child: SizedBox(
                    height: 20,
                    width: 200,
                    child: Center(
                      child: const Text('Add a Folder'),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(),
                )
              ],
            ),
          ),
        ),
        endDrawerEnableOpenDragGesture: false,
      ),
    );
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

  saveText() {
    print(_textController.text);
    var file = File(dir.path);
    file.writeAsStringSync(_textController.text);
    print(file.readAsStringSync());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var appBar = AppBar(title: Text("${dir.path
        .split('/')
        .last}"));
    return Scaffold(
      appBar: appBar,
      body: TextField(
          controller: _textController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          style: TextStyle(fontSize: 12.0)),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          saveText();
        },
      ),
    );
  }
}
