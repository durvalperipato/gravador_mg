import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gravador_mg/repository/DirectoryRepository.dart';
import 'package:gravador_mg/utils/variables.dart';
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

  addTextControllerCP(String value) {
    controllerCP.text = value;
  }

  //######### Methods #########

  void activeOrDisableSlot(String slot) {
    slots['config'][slot]['active'] = !slots['config'][slot]['active'];

    notifyListeners();
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
        addTextControllerCP(slots['ref']);
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

          int length = 0;
          slots['config'].values.forEach((element) async {
            if (element['active']) {
              element['color'] = Colors.yellow[200];
              try {
                Future<ProcessResult> process;
                if (slots['program'] == programST) {
                  File file = File(DirectoryRepository.confDirectory.path +
                      '\\' +
                      'param_st.json');
                  Map params = jsonDecode(file.readAsStringSync())['params'];
                  List<String> paramsST = [];

                  params.entries.forEach((elementST) {
                    if (elementST.value == "") {
                      paramsST.add(elementST.key);
                    } else if (elementST.value == "\$hex") {
                      paramsST.add(elementST.key + '=' + slots['hex']);
                    } else if (elementST.value == "\$id") {
                      paramsST.add(elementST.key + '=' + element['port']);
                    } else {
                      paramsST.add(elementST.key + '=' + elementST.value);
                    }
                  });
                  process = ShellModelView.recordST(paramsST);
                } else {
                  File file = File(DirectoryRepository.confDirectory.path +
                      '\\' +
                      'param_silicon_lab.json');
                  Map params = jsonDecode(file.readAsStringSync())['params'];
                  List<String> paramsSiliconLabs = [];
                  params.entries.forEach((elementParams) {
                    if (elementParams.key == "\$hex") {
                      paramsSiliconLabs.add(slots['hex']);
                    } else if (elementParams.value == "\$port") {
                      paramsSiliconLabs
                          .add(elementParams.key + ' ' + element['port']);
                    } else if (elementParams.value == "") {
                      paramsSiliconLabs.add(elementParams.key);
                    } else {
                      paramsSiliconLabs
                          .add(elementParams.key + ' ' + elementParams.value);
                    }
                  });

                  process = ShellModelView.recordSiliconLabs(paramsSiliconLabs);
                }

                process.then((process) {
                  if (process.exitCode != 0) {
                    recordingSlots[index] = true;
                    index++;
                    element['color'] = Colors.red[200];
                  } else {
                    if (slots['program'] == programST) {
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
