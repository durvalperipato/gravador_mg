import 'package:file/file.dart' as file;
import 'package:file/local.dart';
import 'package:crypto/crypto.dart';
import 'dart:io';

final List<String> ports = List.generate(29, (index) => 'COM${index + 1}');
final Map<String, dynamic> slots = {};

verifyPassword(String pass) {
  final file.FileSystem fs = LocalFileSystem();

  Directory dir =
      fs.currentDirectory.childDirectory(fs.currentDirectory.path + '\\conf');
  File _file = File(dir.path + '\\conf.txt');

  if (sha1.convert(pass.codeUnits).toString() == _file.readAsStringSync()) {
    return true;
  }
  return false;
}
