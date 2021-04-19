// Finding the file paths to things
import 'package:path_provider/path_provider.dart';
// Needed for reading and writing to the file system
import 'dart:io';
void createDirectory(String directory){
  getApplicationDocumentsDirectory().then((Directory path){
    final Directory dir = new Directory('${path.path}$directory');
    return Future.wait([dir.exists(), Future.value(dir)]);
  }).then((data) {
    if (data[0] == false){
      final Directory dir = data[1];
      print('Creating directory $dir');
      dir.create(recursive: true);
    }
  });
}