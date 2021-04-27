import 'dart:convert';
import 'dart:io';

import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:flutter/cupertino.dart';
import 'package:gravador_mg/model/config.dart';
import 'package:gravador_mg/repository/DirectoryRepository.dart';
import 'package:gravador_mg/utils/variables.dart';

class NewConfigViewModel extends ChangeNotifier {
  TextEditingController _lenghtSlots = TextEditingController(text: '0');
  TextEditingController _reference = TextEditingController();
  TextEditingController _hexFile = TextEditingController();
  String _program = programSiliconLab;

  Map<String, dynamic> _slots = {'config': {}};

  bool valueCheckBox = true;
  bool _isVerifyPorts = false;

  get slots => _slots;
  get lenghtSlots => _lenghtSlots;
  get reference => _reference;
  get hexFile => _hexFile;
  get program => this._program;
  get isVerifyPorts => _isVerifyPorts;

  set program(String text) {
    _program = text;
    notifyListeners();
  }

  set isVerifyPorts(bool value) {
    _isVerifyPorts = value;
    notifyListeners();
  }

  set slots(Map slots) {
    _slots = slots;
    notifyListeners();
  }

  set lenghtSlots(String value) {
    _lenghtSlots.text = value;
  }

  setNewConfig() {
    Config newConfig = Config(slots, hexFile.text, reference.text, _program);
    File file = File(DirectoryRepository.filesDirectory.path +
        '\\' +
        '${reference.text}.json');

    file.writeAsStringSync(jsonEncode(newConfig));
  }

  onClickCheckBox() {
    valueCheckBox = !valueCheckBox;
    slots.clear();
    slots['config'] = {};
    notifyListeners();
  }

  submitSlots(String value) {
    if (value.isNotEmpty &&
        int.tryParse(value) > 0 &&
        int.tryParse(value) < 30) {
      int _length = int.parse(value);
      slots.clear();
      slots['config'] = {};
      for (int index = 1; index <= _length; index++) {
        slots['config']['SLOT $index'] = {
          'port': _program == programST ? '${index - 1}' : 'PORT$index',
          'active': true,
        };
        notifyListeners();
      }
    }
  }

  openFile() {
    final result = OpenFilePicker()
      ..filterSpecification = program == programST
          ? {'Program (*.s19)': '*.s19', 'Program (*.efm8)': '*.efm8'}
          : {'Program (*.efm8)': '*.efm8', 'Program (*.s19)': '*.s19'}
      ..title = 'Selecione o arquivo';
    final file = result.getFile();
    if (file != null) {
      if (file.path.isNotEmpty) {
        hexFile.text = file.path /* .split("\\").last */;
        reference.text =
            hexFile.text.split("\\").last.split(".").first.toUpperCase();
      }
    }
  }

  hasValueInAllFields() => hexFile.text.isNotEmpty &&
          reference.text.isNotEmpty &&
          lenghtSlots.text.isNotEmpty
      ? true
      : false;
}
