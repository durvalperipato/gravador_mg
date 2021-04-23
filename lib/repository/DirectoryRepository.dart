import 'dart:io';
import 'package:file/file.dart' as file;
import 'package:file/local.dart';

_getReferenceLocalFileSystem() {
  file.FileSystem fs = LocalFileSystem();
  return fs;
}

class DirectoryRepository {
  static Future<Directory> verifyDirectory() async {
    var fs = _getReferenceLocalFileSystem();
    Directory dir =
        fs.currentDirectory.childDirectory(fs.currentDirectory.path + '\\conf');
    if (!dir.existsSync()) {
      dir.create().then((directory) {
        File _file = File(directory.path + '\\conf.txt');
        _file.create().then((file) =>
            file.writeAsString('880108901999429b9f6fd573ccac0281d839a1e0'));
      });
    }

    fs.currentDirectory.childDirectory(fs.currentDirectory.path + '\\files');
    return dir.create();
  }

  static Directory get confDirectory {
    var fs = _getReferenceLocalFileSystem();
    Directory dir =
        fs.currentDirectory.childDirectory(fs.currentDirectory.path + '\\conf');
    return dir;
  }

  static Directory get filesDirectory {
    var fs = _getReferenceLocalFileSystem();
    Directory dir = fs.currentDirectory
        .childDirectory(fs.currentDirectory.path + '\\files');
    return dir;
  }
}
