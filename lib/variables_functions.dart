import 'dart:async';

import 'package:file/file.dart' as file;
import 'package:file/local.dart';
import 'package:crypto/crypto.dart';
import 'dart:io';

final List<String> ports = List.generate(29, (index) => 'COM${index + 1}');
Map<dynamic, dynamic> config = {};

verifyPassword(String pass) {
  try {
    Directory dir = confPath;
    File _file = File(dir.path + '\\conf.txt');

    if (sha1.convert(pass.codeUnits).toString() == _file.readAsStringSync()) {
      return true;
    }
    return false;
  } catch (e) {
    return false;
  }
}

_getReferenceLocalFileSystem() {
  file.FileSystem fs = LocalFileSystem();
  return fs;
}

Future<Directory> verifyDirectory() async {
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

Directory get filesPath {
  var fs = _getReferenceLocalFileSystem();
  Directory dir =
      fs.currentDirectory.childDirectory(fs.currentDirectory.path + '\\files');
  return dir;
}

Directory get confPath {
  var fs = _getReferenceLocalFileSystem();
  Directory dir =
      fs.currentDirectory.childDirectory(fs.currentDirectory.path + '\\conf');
  return dir;
}
