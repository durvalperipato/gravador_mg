import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gravador_mg/repository/DirectoryRepository.dart';

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
          int length = 0;
          slots['config'].values.forEach((element) async {
            if (element['active']) {
              element['color'] = Colors.yellow[200];

              try {
                await Process.run(
                  /* 'efm8load.exe' */ 'stvp/STVP_CmdLine.exe',
                  [
                    /* '-p', '${element['port']}', config['hex'] */ '-BoardName=ST-LINK',
                    '-Port=USB',
                    '-ProgMode=SWIM',
                    '-Device=STM8S001J3',
                    '-Tool_ID=0',
                    '-no_loop',
                    '-FileProg=N:\\3_DESENVOLVIMENTO\\Detec_Projeto\\Durval\\Gravador\\files_svtp\\CJ017940.s19'
                  ],
                ).then((process) {
                  if (process.exitCode != 0) {
                    recordingSlots[index] = true;
                    index++;
                    element['color'] = Colors.red[200];
                    //setState(() {});
                  } else {
                    if (process.stdout.contains('?')) {
                      recordingSlots[index] = true;
                      index++;
                      element['color'] = Colors.red[200];
                      // setState(() {});
                    } else if (process.stdout.contains('@@@@@@')) {
                      recordingSlots[index] = true;
                      index++;
                      element['color'] = Colors.green[200];
                      //  setState(() {});
                    }
                  }
                }, onError: (error) {
                  element['color'] = Colors.red[200];
                  recordingSlots[index] = true;
                  index++;
                  //setState(() {});
                }).whenComplete(() {
                  recordingSlots.forEach((element) {
                    if (element) {
                      length += 1;
                      if (length == recordingSlots.length) {
                        /* setState(() {
                          _isRecording = false;
                        }); */
                        isRecording = false;
                      }
                    }
                  });
                });
              } catch (e) {
                /* setState(() {
                  _isRecording = false;
                }); */
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
        /* setState(() {
          _isRecording = false;
        }); */
        isRecording = true;
      }
    }
  }

  dispose() {
    controllerCP.dispose();
    controllerPassword.dispose();
    super.dispose();
  }
}
