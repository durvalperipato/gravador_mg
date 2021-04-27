import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gravador_mg/repository/DirectoryRepository.dart';
import 'package:gravador_mg/viewmodel/shell_modelview.dart';

class HomePageViewModel extends ChangeNotifier {
  // ######### Variables #########
  Directory _files;
  Directory _configuration;
  TextEditingController _controllerCP = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  Map<dynamic, dynamic> _slots = {};
  List<bool> _recording = [];
  bool _isRecording = false;

  //######### Getters #########
  Directory get filesPath => this._files;
  Directory get configurationPath => this._configuration;
  TextEditingController get controllerCP => _controllerCP;
  TextEditingController get controllerPassword => _controllerPassword;
  Map get slots => this._slots;
  List get recordingSlots => this._recording;
  bool get isRecording => this._isRecording;

  //######### Setters #########
  set slots(Map newConfig) {
    _slots = newConfig;
    notifyListeners();
  }

  set isRecording(bool value) {
    _isRecording = value;
    notifyListeners();
  }

  set addRecording(bool value) {
    _recording.add(value);
  }

  //######### Methods #########

  void activeOrDisableSlot(String slot) {
    slots['config'][slot]['active'] = !slots['config'][slot]['active'];

    notifyListeners();
  }

  Color colorSlot(String slot) => slots['config'][slot]['active']
      ? slots['config'][slot]['color']
      : Colors.grey[200];

  double textFontSize({bool title = false}) {
    double min = 10;
    double med = 15;
    double max = 30;
    if (!title) {
      min = 7;
      med = 10;
      max = 20;
    }
    return slots['config'].length > 7 && slots['config'].length < 11
        ? med
        : slots['config'].length >= 11
            ? min
            : max;
  }

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

  openFile(BuildContext context) async {
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
        File _file = File(path);
        slots = jsonDecode(_file.readAsStringSync());
        //String _hex = config['hex'];
        //String _ref = slots['ref'];
        slots['config'].values.forEach((element) {
          element['color'] = Colors.grey[400];
          element['port'] = element['port'];
        });

        slots = slots;
      }
    }
  }

  recordDevice() async {
    if (!slots['config']
        .values
        .every((element) => element['active'] == false)) {
      isRecording = true;

      try {
        if (slots.isNotEmpty) {
          int index = 0;
          int id = 0;
          int length = 0;
          slots['config'].values.forEach((element) async {
            if (element['active']) {
              element['color'] = Colors.yellow[200];
              try {
                var process = slots['program'] == 'ST'
                    ? ShellModelView.recordST(id.toString(), slots['hex'])
                    : ShellModelView.recordSiliconLabs(
                        element['port'], slots['hex']);

                process.then((process) {
                  if (process.exitCode != 0) {
                    recordingSlots[index] = true;
                    index++;
                    element['color'] = Colors.red[200];
                  } else {
                    if (slots['program'] == 'ST') {
                      if (process.stdout
                          .contains('Programming PROGRAM MEMORY succeeds')) {
                        recordingSlots[index] = true;
                        index++;
                        element['color'] = Colors.green[200];
                      } else {
                        recordingSlots[index] = true;
                        index++;
                        element['color'] = Colors.red[200];
                      }
                    } else {
                      if (process.stdout.contains('?')) {
                        recordingSlots[index] = true;
                        index++;
                        element['color'] = Colors.red[200];
                      } else if (process.stdout.contains('@@@@@@')) {
                        recordingSlots[index] = true;
                        index++;
                        element['color'] = Colors.green[200];
                      }
                    }
                  }
                }, onError: (error) {
                  element['color'] = Colors.red[200];
                  recordingSlots[index] = true;
                  index++;
                }).whenComplete(() {
                  recordingSlots.forEach((element) {
                    if (element) {
                      length += 1;
                      if (length == recordingSlots.length) {
                        isRecording = false;
                      }
                    }
                  });
                });
                id++;
              } catch (e) {
                isRecording = false;
              }
            } else {
              recordingSlots[index] = true;
              index++;
              length++;
            }
          });
        }
      } catch (e) {
        isRecording = false;
      }
    }
  }

  dispose() {
    controllerCP.dispose();
    controllerPassword.dispose();
    super.dispose();
  }
}
