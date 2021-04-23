import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gravador_mg/model/config.dart';
import 'package:gravador_mg/repository/DirectoryRepository.dart';

class HomePageViewModel extends ChangeNotifier {
  Directory _files;
  Directory _configuration;
  TextEditingController _controllerCP = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  Map<dynamic, dynamic> _config = {};

  
  Directory get filesPath => this._files;
  Directory get configurationPath => this._configuration;
  
  TextEditingController get controllerCP => _controllerCP;
  TextEditingController get controllerPassword => _controllerPassword;


  +

  Future<Directory> verifyDirectory() async {
    return DirectoryRepository.verifyDirectory();
  }

  verifyPassword(String pass) {
    try {
      File _file = File(DirectoryRepository.confDirectory.path + '\\conf.txt');

      if (sha1.convert(pass.codeUnits).toString() == _file.readAsStringSync()) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  openFile(BuildContext context, Map config) async {
    String path = await FilesystemPicker.open(
      title: 'Carregar Programa',
      context: context,
      rootDirectory: DirectoryRepository.filesDirectory,
      fsType: FilesystemType.file,
      folderIconColor: Colors.teal,
      allowedExtensions: ['.json'],
      fileTileSelectMode: FileTileSelectMode.wholeTile,
    );
    if (path != null) {
      if (path.isNotEmpty) {
        config.clear();
        File _file = File(path);
        config = jsonDecode(_file.readAsStringSync());
        //String _hex = config['hex'];
        String _ref = config['ref'];
        config['config'].values.forEach((element) {
          print('ENTREI');
          element['color'] = Colors.grey[400];
          element['port'] = element['port'];
        });

        notifyListeners();
      }
    }
  }
}
